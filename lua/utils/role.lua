-- Reads ~/role.toml and exposes helpers for gating plugins/features on it.
-- Parses once and caches the result for the session; call M.reload() to force
-- a re-read (e.g. from a user command after editing role.toml).

local toml = require("utils.toml")

local M = {}

M.paths = { "~/role.toml", "~/.dotfiles/role.toml", "~/dotfiles/role.toml" }

---@type table|nil
local cache = nil
local loaded = false

--- Force re-parsing role.toml on next access. Useful after editing the file.
function M.reload()
  cache = nil
  loaded = false
end

--- Returns the parsed .toml as a table, or nil if the file is missing or fails to parse.
--- Cached after first successful read.
---@return table|nil
function M.data()
  if not loaded then
    for _, path in ipairs(M.paths) do
      cache = toml.parse_file(path)
      if cache then
        loaded = true
        break
      end
    end

    if not loaded then
      vim.notify_once("Could not find `role.toml` in " .. table.concat(M.paths, ", "), vim.log.levels.INFO)
    end
  end
  return cache
end

--- Get a value at role.toml[section][key].
--- Returns `default` (nil if omitted) when the file, section, or key is missing.
---@param section string
---@param key string
---@param default any
---@return any
function M.get(section, key, default)
  local data = M.data()
  if not data or not data[section] then
    return default
  end
  local value = data[section][key]
  if value == nil then
    return default
  end
  return value
end

--- Convenience boolean check: role.toml[section][key] == true.
---@param section string
---@param key string
---@return boolean
function M.enabled(section, key)
  return M.get(section, key, false) == true
end

return M
