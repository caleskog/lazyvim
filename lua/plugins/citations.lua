if vim.fn.executable("quarto") == 0 then
  vim.notify("`citations.lua` require `quarto-cli` to be installed", vim.log.levels.WARN)
  return {}
end

local bib_paths = function(ctx)
  local defaults = require("blink-cmp-bibtex.config").defaults()
  local scan = require("blink-cmp-bibtex.scan")
  local sources = scan.resolve_bib_sources(ctx.bufnr, ctx.opts or defaults)
  return scan.paths_from_sources(sources)
end

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

  return entries
end

--- Finds and formats citation entries from bibliography files for Snacks picker.
---
--- Returns a list of formatted items containing citation metadata (id, author, title, year, file path, and full entry)
--- that can be searched and selected in the Snacks picker interface.
---
--- @return snacks.picker.finder.Item[] List of citation items with searchable text and metadata
local function citation_finder(_, _)
  local opts = require("blink-cmp-bibtex").opts

  local paths = bib_paths({
    bufnr = vim.api.nvim_get_current_buf(),
    opts = opts,
  })

  ---@type snacks.picker.finder.Item[]
  local items = {}

  for _, path in ipairs(paths) do
    for _, entry in ipairs(parse_bib(path)) do
      local authors = {}

      for _, author in ipairs(entry.author or {}) do
        local name = author.family

        if author.given then
          name = (name or "") .. ", " .. author.given
        end

        if name then
          table.insert(authors, name)
        end
      end

      local author_text = table.concat(authors, "; ")

      local year = ""
      if entry.issued and entry.issued["date-parts"] then
        year = tostring(entry.issued["date-parts"][1][1] or "")
      end

      ---@type snacks.picker.finder.Item
      local item = {
        -- Everything here is searchable by Snacks.
        text = table.concat({
          entry.id or "",
          author_text,
          entry.title or "",
          year,
        }, " "),

        -- Data used for displaying/inserting.
        id = entry.id,
        author = author_text,
        title = entry.title or "",
        year = year,
        file = path,

        entry = entry,
      }

      table.insert(items, item)
    end
  end

  return items
end

--- Wraps text into multiple lines with a given width and optional prefix.
--- Each line (except the first) starts with the prefix.
--- Lines are broken at word boundaries when possible.
---
---@param text string The text to wrap
---@param width number The maximum width of each line
---@param prefix string? (optional) The prefix to prepend to each line
---@param cond_prefix string? (optional) The prefix to prepend to each line after the first line
---@return table A list of wrapped lines
local function wrap_text(text, width, prefix, cond_prefix)
  prefix = prefix or ""
  cond_prefix = cond_prefix or prefix
  if not text or text == "" then
    return { prefix }
  end

  local lines = {}
  local remaining = text
  local current_line = prefix

  while #remaining > 0 do
    local space_left = width - #current_line

    -- Find the last space wwithin the available width
    local split_at = space_left
    if #remaining > space_left then
      -- Look for the last space before the width limit
      local last_space = remaining:sub(1, space_left):match(".*() %S*$") or space_left
      split_at = math.min(last_space, space_left)

      -- If no space found, split at width
      if split_at == 0 then
        split_at = space_left
      end
    else
      split_at = #remaining
    end

    -- Add the segment to current line
    current_line = current_line .. remaining:sub(1, split_at)
    table.insert(lines, current_line)

    -- Move to next segment
    remaining = remaining:sub(split_at + 1)
    current_line = cond_prefix
  end

  return lines
end

---@param ctx snacks.picker.preview.ctx
local function citation_preview(ctx)
  local item = ctx.item

  if not item then
    return
  end

  local preview_win = ctx.picker.layout.wins.preview
  local width = vim.o.columns - 20
  if preview_win and preview_win.win then
    local preview_width = vim.api.nvim_win_get_width(preview_win.win)
    width = preview_width - 4
  end

  local entry = item.entry
  local lines = {}

  -- Title
  if entry.title then
    local prefix = "**Title:** "
    local title_lines = wrap_text(entry.title, width, prefix, string.rep(" ", #prefix - 4))
    vim.list_extend(lines, title_lines)
  end

  -- ID
  table.insert(lines, "**ID:** `" .. (entry.id or "") .. "`")

  -- Authors
  if entry.author and #entry.author > 0 then
    local authors = {}
    for _, author in ipairs(entry.author) do
      local name = author.given and author.given .. " " .. (author.family or "") or (author.family or "")
      table.insert(authors, name)
    end
    local authors_str = table.concat(authors, ", ")
    local prefix = "**Authors:** "
    local authors_lines = wrap_text(authors_str, width, prefix, string.rep(" ", #prefix - 4))
    table.insert(lines, "")
    vim.list_extend(lines, authors_lines)
  end

  -- Year
  if entry.issued and entry.issued["date-parts"] then
    local year = tostring(entry.issued["date-parts"][1][1] or "")
    table.insert(lines, "**Year:** " .. year)
  end

  -- Abstract (if available)
  if entry.abstract then
    table.insert(lines, "")
    table.insert(lines, "## Abstract")
    table.insert(lines, "")
    local abstract_lines = wrap_text(entry.abstract, width)
    vim.list_extend(lines, abstract_lines)
  end

  ctx.preview:reset()
  ctx.preview:set_lines(lines)
  ctx.preview:highlight({ ft = "markdown" })
end

local function citation_confirm(picker, item)
  item = item or picker:selected()
  if not item then
    return
  end
  picker:close()

  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local cursor_pos = col + 1 -- convert 0-indexed byte col to 1-indexed Lua string pos

  local pattern = "%[@[^%]]*%]"
  local match_start, match_end

  local init = 1
  while true do
    local s, e = line:find(pattern, init)
    if not s then
      break
    end
    if cursor_pos >= s and cursor_pos <= e then
      match_start, match_end = s, e
      break
    end
    init = e + 1
  end

  if match_start then
    -- cursor is in/on an existing [@...] block: append the new id before the closing ]
    local insert_pos = match_end -- index of the closing ']'
    local insertion = "; @" .. item.id
    local new_line = line:sub(1, insert_pos - 1) .. insertion .. line:sub(insert_pos)
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, insert_pos - 1 + #insertion })
  else
    vim.api.nvim_put({
      "[@" .. item.id .. "]",
    }, "c", true, true)
  end
end

return {
  {
    "krissen/blink-cmp-bibtex",
    opts = {
      filetypes = { "tex", "plaintex", "markdown", "quarto", "rmd", "typst" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "krissen/blink-cmp-bibtex",
    },
    ---@module "blink.cmp.config"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = function()
          return { "bibtex", "lsp", "path", "snippets", "buffer" }
        end,
        providers = {
          bibtex = {
            module = "blink-cmp-bibtex",
            name = "BibTeX",
            min_keyword_length = 2,
            score_offset = 10,
            async = true,
            opts = {
              -- provider-level overrides (optional)
            },
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      picker = {
        sources = {
          quarto_citations = {
            title = "Quarto Citations",
            finder = citation_finder,
            format = function(item)
              return {
                { "(" .. item.year .. ") ", "SnacksPickerComment" },
                { item.title, "SnacksPickerFile" },
              }
            end,
            preview = citation_preview,
            confirm = citation_confirm,
          },
        },
      },
    },
    keys = {
      {
        "<C-q>",
        function()
          Snacks.picker.pick("quarto_citations")
        end,
        desc = "Quarto Citations",
      },
    },
  },
}
