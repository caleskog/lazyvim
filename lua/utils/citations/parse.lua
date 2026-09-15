local M = {}

--- Parses a bibliography file using Quarto and Pandoc.
--- @param path string: The path to the bibliography file to parse.
--- @return table: A table of parsed bibliography entries, or an empty table on error.
local function parse_bib(path)
  local result = vim
    .system({
      "quarto",
      "pandoc",
      "--from=biblatex",
      "--to=csljson",
      path,
    }, {
      text = true,
    })
    :wait()

  if result.code ~= 0 then
    vim.notify("Failed to parse bibliography: " .. path .. "\n" .. result.stderr, vim.log.levels.ERROR)
    return {}
  end

  local ok, entries = pcall(vim.json.decode, result.stdout)

  if not ok then
    vim.notify("Failed to decode CSL JSON: " .. path, vim.log.levels.ERROR)
    return {}
  end

  if type(entries) ~= "table" then
    vim.notify("Invalid CSL JSON bibliography: " .. path, vim.log.levels.ERROR)
    return {}
  end

  return entries
end

--- Parses a CSL JSON bibliography file.
--- @param path string: The path to the bibliography file to parse.
--- @return table: A table of parsed bibliography entries, or an empty table on error.
local function parse_csl_json(path)
  local file = io.open(path, "r")
  if not file then
    vim.notify("Failed to open bibliography: " .. path, vim.log.levels.ERROR)
    return {}
  end

  local contents = file:read("*a")
  file:close()

  local ok, entries = pcall(vim.json.decode, contents)

  if not ok then
    vim.notify("Failed to decode CSL JSON: " .. path, vim.log.levels.ERROR)
    return {}
  end

  if type(entries) ~= "table" then
    vim.notify("Invalid CSL JSON bibliography: " .. path, vim.log.levels.ERROR)
    return {}
  end

  return entries
end

function M.parse_bibliography(path)
  if path:lower():match("%.json$") then
    return parse_csl_json(path)
  end
  return parse_bib(path)
end

return M
