-- Minimal TOML reader: enough for flat key/value pairs under [section] headers.
-- Not a full TOML spec implementation.

local M = {}

function M.parse_file(path)
  local f = io.open(vim.fn.expand(path), "r")
  if not f then
    return nil
  end

  local result = {}
  local current_section = result

  for line in f:lines() do
    local trimmed = line:match("^%s*(.-)%s*$")

    if trimmed == "" or trimmed:sub(1, 1) == "#" then
      -- skip blank lines / comments
    else
      local section = trimmed:match("^%[([%w_.]+)%]$")
      if section then
        result[section] = result[section] or {}
        current_section = result[section]
      else
        local key, value = trimmed:match("^([%w_]+)%s*=%s*(.-)%s*$")
        if key then
          if value == "true" then
            current_section[key] = true
          elseif value == "false" then
            current_section[key] = false
          elseif tonumber(value) then
            current_section[key] = tonumber(value)
          else
            current_section[key] = value:match('^"(.*)"$') or value
          end
        end
      end
    end
  end

  f:close()
  return result
end

return M
