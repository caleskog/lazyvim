local M = {}

--- Returns citation ids from the Pandoc-style citation block under the cursor.
--- Scans the current line for a `[@...]` block containing the cursor and
--- extracts all citation ids referenced inside that block.
---
--- @return table<string, boolean> Set-like table of citation ids under the cursor
function M.citation_ids_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local cursor_pos = col + 1

  local pattern = "%[@[^%]]*%]"
  local init = 1

  while true do
    local s, e = line:find(pattern, init)
    if not s then
      break
    end

    if cursor_pos >= s and cursor_pos <= e then
      local block = line:sub(s, e)
      local ids = {}

      for id in block:gmatch("@([%w:_%-%.]+)") do
        ids[id] = true
      end

      return ids
    end

    init = e + 1
  end

  return {}
end

return M
