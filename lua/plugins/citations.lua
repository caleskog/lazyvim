if vim.fn.executable("quarto") == 0 then
  vim.notify("`citations.lua` require `quarto-cli` to be installed", vim.log.levels.WARN)
  return {}
end

local bibliography = require("utils.citations.bibliography")
local citation_cursor = require("utils.citations.cursor")
local citation_parse = require("utils.citations.parse")
local citation_text = require("utils.citations.text")

local bib_paths = function(ctx)
  local sources = bibliography.resolve_bib_sources(ctx.bufnr, ctx.opts or {})
  return bibliography.paths_from_sources(sources)
end

--- Finds and formats citation entries from bibliography files for Snacks picker.
---
--- Returns a list of formatted items containing citation metadata (id, author, title, year, file path, and full entry)
--- that can be searched and selected in the Snacks picker interface.
---
--- @return snacks.picker.finder.Item[] List of citation items with searchable text and metadata
local function citation_finder(_, _)
  local opts = {
    files = {
      -- "/absolute/path/to/references.json",
    },
    global_files = {},
    search_paths = {
      -- "~/docs/**/*.bib",
      -- "~/docs/**/*.json",
    },
  }
  local excluded_ids = citation_cursor.citation_ids_under_cursor()

  local paths = bib_paths({
    bufnr = vim.api.nvim_get_current_buf(),
    opts = opts,
  })

  ---@type snacks.picker.finder.Item[]
  local items = {}

  for _, path in ipairs(paths) do
    for _, entry in ipairs(citation_parse.parse_bibliography(path)) do
      if not excluded_ids[entry.id] then
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
  end

  return items
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
    local title_lines = citation_text.wrap_text(entry.title, width, prefix, string.rep(" ", #prefix - 4))
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
    local authors_lines = citation_text.wrap_text(authors_str, width, prefix, string.rep(" ", #prefix - 4))
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
    local abstract_lines = citation_text.wrap_text(entry.abstract, width)
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
        "<C-c>",
        function()
          Snacks.picker.pick("quarto_citations")
        end,
        mode = { "n", "v", "i" },
        desc = "Quarto Citations",
      },
      {
        "<leader>mc",
        function()
          Snacks.picker.pick("quarto_citations")
        end,
        mode = { "n", "v" },
        desc = "Quarto Citations",
      },
    },
  },
}
