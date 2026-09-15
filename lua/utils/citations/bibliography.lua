local M = {}

local path_utils = require("utils.path")
local text_utils = require("utils.text")
local file_utils = require("utils.file")

local function split_csv(value)
  local items = {}
  for part in value:gmatch("[^,]+") do
    local cleaned = text_utils.trim(part)
    if cleaned ~= "" then
      items[#items + 1] = cleaned
    end
  end
  return items
end

local function ensure_bibliography_extension(path)
  if not path or path == "" then
    return path
  end
  if path:find("[%*%?%[]") then
    return path
  end
  if path:match("%.bib$") or path:match("%.json$") or path:match("%.ya?ml$") then
    return path
  end
  local filename = path:match("([^/\\]+)$") or path
  if filename:find("%.") then
    return path
  end
  return path .. ".bib"
end

local bibliography_commands = {
  addbibresource = true,
  ["addbibresource*"] = true,
  addglobalbib = true,
  addsectionbib = true,
  bibliography = true,
  nobibliography = true,
}

local function skip_whitespace(str, idx)
  while idx <= #str and str:sub(idx, idx):match("%s") do
    idx = idx + 1
  end
  return idx
end

local function read_balanced_block(str, idx)
  if str:sub(idx, idx) ~= "{" then
    return nil, idx
  end
  local depth = 1
  local cursor = idx + 1
  while cursor <= #str and depth > 0 do
    local ch = str:sub(cursor, cursor)
    if ch == "{" then
      depth = depth + 1
    elseif ch == "}" then
      depth = depth - 1
      if depth == 0 then
        return str:sub(idx + 1, cursor - 1), cursor + 1
      end
    elseif ch == "\\" and cursor < #str then
      cursor = cursor + 1
    end
    cursor = cursor + 1
  end
  return nil, idx
end

local function skip_optional_arguments(str, idx)
  local cursor = skip_whitespace(str, idx)
  while str:sub(cursor, cursor) == "[" do
    local depth = 1
    cursor = cursor + 1
    while cursor <= #str and depth > 0 do
      local ch = str:sub(cursor, cursor)
      if ch == "[" then
        depth = depth + 1
      elseif ch == "]" then
        depth = depth - 1
      end
      cursor = cursor + 1
    end
    cursor = skip_whitespace(str, cursor)
  end
  return cursor
end

local function find_latex(lines)
  local results = {}
  for idx, line in ipairs(lines) do
    local i = 1
    while i <= #line do
      local _, end_pos, command = line:find("\\([%a%@]+%*?)", i)
      if not end_pos then
        break
      end
      i = end_pos + 1
      if bibliography_commands[command] then
        local cursor = skip_optional_arguments(line, i)
        cursor = skip_whitespace(line, cursor)
        local value
        value, i = read_balanced_block(line, cursor)
        if value and #value > 0 then
          for _, resource in ipairs(split_csv(value)) do
            results[#results + 1] = { name = ensure_bibliography_extension(resource), line = idx }
          end
        end
      end
    end
  end
  return results
end

local function parse_metadata_value(value)
  value = text_utils.trim(value)
  if value == "" then
    return {}
  end

  local bracketed = value:match("^%[(.*)%]$")
  if bracketed then
    return split_csv(bracketed)
  end

  local quoted = value:match('^"(.*)"$') or value:match("^'(.*)'$")
  if quoted then
    return { text_utils.trim(quoted) }
  end

  return split_csv(value)
end

local function find_yaml(lines)
  local results = {}
  local in_front_matter = false
  local collecting_list = false

  for idx, line in ipairs(lines) do
    if idx == 1 and line:match("^%-%-%-%s*$") then
      in_front_matter = true
    elseif in_front_matter and line:match("^%-%-%-%s*$") then
      break
    elseif in_front_matter then
      local inline = line:match("^bibliography:%s*(.+)$")
      if inline then
        for _, item in ipairs(parse_metadata_value(inline)) do
          results[#results + 1] = { name = ensure_bibliography_extension(item), line = idx }
        end
        collecting_list = false
      elseif line:match("^bibliography:%s*$") then
        collecting_list = true
      elseif line:match("^%S") and not line:match("^%s") then
        collecting_list = false
      end

      if collecting_list then
        local item = line:match("^%s*%-%s*(.+)%s*$")
        if item then
          results[#results + 1] = { name = ensure_bibliography_extension(text_utils.trim(item)), line = idx }
        end
      end
    end
  end

  return results
end

local function find_typst_imports(lines)
  local imports = {}
  for _, line in ipairs(lines) do
    for path in line:gmatch('#import%s+"([^"]+)"') do
      if path:match("%.typ$") then
        imports[#imports + 1] = text_utils.trim(path)
      end
    end
    for path in line:gmatch("#import%s+'([^']+)'") do
      if path:match("%.typ$") then
        imports[#imports + 1] = text_utils.trim(path)
      end
    end
  end
  return imports
end

local function find_typst(lines, base_dir, visited)
  visited = visited or {}
  local results = {}

  for idx, line in ipairs(lines) do
    for _, pattern in ipairs({
      '#bibliography%s*%(%s*"([^"]+)"%s*%)',
      "#bibliography%s*%(%s*'([^']+)'%s*%)",
    }) do
      for path in line:gmatch(pattern) do
        path = ensure_bibliography_extension(text_utils.trim(path))
        if not path_utils.is_absolute(path) and base_dir then
          path = path_utils.joinpath(base_dir, path)
        end
        results[#results + 1] = { name = path, line = idx }
      end
    end
  end

  if base_dir then
    for _, import_path in ipairs(find_typst_imports(lines)) do
      local full_path = path_utils.is_absolute(import_path) and path_utils.normalize(import_path)
        or path_utils.normalize(path_utils.joinpath(base_dir, import_path))
      if full_path and not visited[full_path] then
        visited[full_path] = true
        local import_lines = file_utils.read_file_lines(full_path)
        if import_lines then
          local import_dir = vim.fs.dirname(full_path)
          local imported = find_typst(import_lines, import_dir, visited)
          for _, item in ipairs(imported) do
            if not path_utils.is_absolute(item.name) then
              item.name = path_utils.joinpath(import_dir, item.name)
            end
            item.file = item.file or full_path
            results[#results + 1] = item
          end
        end
      end
    end
  end

  return results
end

local function find_quarto_metadata(lines)
  local results = {}

  if not (lines[1] and lines[1]:match("^%-%-%-%s*$")) then
    return results
  end

  local collecting_list = false

  for idx = 2, #lines do
    local line = lines[idx]

    if line:match("^%-%-%-%s*$") or line:match("^%.%.%.%s*$") then
      break
    end

    local inline = line:match("^bibliography:%s*(.+)$")
    if inline then
      for _, item in ipairs(parse_metadata_value(inline)) do
        results[#results + 1] = { name = ensure_bibliography_extension(item), line = idx }
      end
      collecting_list = false
    elseif line:match("^bibliography:%s*$") then
      collecting_list = true
    elseif collecting_list then
      local item = line:match("^%s*%-%s*(.+)%s*$")
      if item then
        results[#results + 1] = { name = ensure_bibliography_extension(text_utils.trim(item)), line = idx }
      else
        collecting_list = false
      end
    end
  end

  return results
end

local function discover(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return {}
  end

  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, -1, false)
  if not ok or not lines then
    return {}
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local dir = (bufname and bufname ~= "") and vim.fs.dirname(bufname) or nil

  local results = {}
  for _, item in ipairs(find_latex(lines)) do
    results[#results + 1] = item
  end
  for _, item in ipairs(find_yaml(lines)) do
    results[#results + 1] = item
  end
  for _, item in ipairs(find_quarto_metadata(lines)) do
    results[#results + 1] = item
  end
  for _, item in ipairs(find_typst(lines, dir)) do
    results[#results + 1] = item
  end

  return results
end

local function normalize_to_list(value)
  if value == nil then
    return {}
  end
  if type(value) == "table" then
    return value
  end
  return { value }
end

local function resolve_option(value, ...)
  if type(value) == "function" then
    local ok, result = pcall(value, ...)
    if ok then
      return result
    end
    return {}
  end
  return value
end

local function expand_search_path(path, root)
  local resolved = {}
  local base = root or (vim.uv or vim.loop).cwd() or ""
  if not path_utils.is_absolute(path) then
    path = vim.fs.normalize(path_utils.joinpath(base, path))
  end
  if path:find("[%*%?%[]") then
    for _, match in ipairs(vim.fn.glob(path, false, true)) do
      resolved[#resolved + 1] = vim.fs.normalize(match)
    end
  else
    resolved[#resolved + 1] = vim.fs.normalize(path)
  end
  return resolved
end

function M.resolve_bib_sources(bufnr, opts)
  opts = opts or {}

  local bufname = ""
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    bufname = vim.api.nvim_buf_get_name(bufnr)
  end

  local uv = vim.uv or vim.loop
  local cwd = uv.cwd() or ""
  local buffer_dir = (bufname ~= "" and bufname ~= ".") and vim.fs.dirname(bufname) or cwd
  local root = buffer_dir

  local files = normalize_to_list(resolve_option(opts.files, bufnr))
  local global_files = normalize_to_list(resolve_option(opts.global_files, bufnr))
  local search_paths = normalize_to_list(resolve_option(opts.search_paths, bufnr))
  local discovered = discover(bufnr)

  local index = {}
  local sources = {}

  local function add_path(path, base_dir, origin)
    if not path or path == "" then
      return
    end

    local expanded
    if path_utils.is_absolute(path) then
      expanded = path_utils.normalize(path)
    else
      expanded = path_utils.normalize(path_utils.joinpath(base_dir or root or buffer_dir, path))
    end

    expanded = path_utils.canonical(expanded)
    if not expanded then
      return
    end

    local source = index[expanded]
    if not source then
      local info = path_utils.stat(expanded)
      source = {
        path = expanded,
        exists = info ~= nil,
        is_dir = info ~= nil and info.type == "directory",
        origins = {},
      }
      index[expanded] = source
      sources[#sources + 1] = source
    end

    source.origins[#source.origins + 1] = origin
  end

  for _, entry in ipairs(discovered) do
    add_path(entry.name, buffer_dir, {
      kind = "buffer",
      detail = entry.name,
      file = entry.file,
      line = entry.line,
    })
  end

  for _, path in ipairs(files) do
    add_path(path, nil, { kind = "files", detail = path })
  end

  for _, path in ipairs(global_files) do
    add_path(path, nil, { kind = "global_files", detail = path })
  end

  for _, path in ipairs(search_paths) do
    for _, expanded in ipairs(expand_search_path(path, root)) do
      add_path(expanded, nil, { kind = "search_paths", detail = path })
    end
  end

  return sources
end

function M.paths_from_sources(sources)
  local paths = {}
  for _, source in ipairs(sources or {}) do
    if source.exists and not source.is_dir then
      paths[#paths + 1] = source.path
    end
  end
  return paths
end

function M.resolve_bib_paths(bufnr, opts)
  return M.paths_from_sources(M.resolve_bib_sources(bufnr, opts))
end

return M
