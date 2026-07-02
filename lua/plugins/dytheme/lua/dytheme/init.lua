--- Supports three usage modes:
---
---   1. Built-in palette (default, no args)
---        require("dytheme").setup()
---
---   2. base16 scheme table
---        require("dytheme").setup({ scheme = base16_table })
---
---   3. base24 scheme table (superset of base16)
---        require("dytheme").setup({ scheme = base24_table })
---
--- A scheme table uses the canonical base16/base24 key names:
---   base00 .. base0F          (base16, required)
---   base10 .. base17          (base24, optional — falls back to base16 keys)
--- Values are hex strings with or without a leading "#".

local M = {}

-- Accept "rrggbb" or "#rrggbb", always return "#rrggbb"
local function norm(hex)
  if not hex then
    return nil
  end
  hex = hex:gsub("^#", "")
  return "#" .. hex:lower()
end

---Builds a DyPalette from a decoded UIColors JSON table.
---@param ui DyUIColors
---@return DyPalette
local function palette_from_ui_colors(ui)
  local function hex(key)
    ---@type DyHex
    local v = ui[key]
    if not v then
      error("dytheme: missing required UIColors slot: " .. key)
    end
    return string.format("#%02x%02x%02x", v.r, v.g, v.b)
  end

  local ansi = {
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
  }

  local palette = {}
  for k, _ in pairs(ui) do
    if not k.match(k, "^ansi_*$") then
      palette[k] = hex(k)
    end
  end

  for i, color in ipairs(ansi) do
    palette["terminal_color_" .. (i - 1)] = hex("ansi_" .. color)
  end

  return palette
end

--- Fallback palette based on tinty's base16-classic-dark scheme.
--- Used when no theme JSON has been loaded yet, ensuring the plugin
--- is always in a valid state without requiring a mandatory setup call.
---@type DyPalette
local DEFAULT_PALETTE = {
  ansi_cyan = "#75b5aa",
  ansi_magenta = "#aa759f",
  ansi_blue = "#6a9fb5",
  secondary = "#aa759f",
  ansi_green = "#90a959",
  syntax_type = "#f4bf75",
  border = "#303030",
  info = "#75b5aa",
  on_info = "#ffffff",
  on_warning = "#ffffff",
  url = "#75b5aa",
  on_cursor = "#ffffff",
  on_visual = "#d0d0d0",
  on_selection = "#d0d0d0",
  on_floating = "#d0d0d0",
  on_surface = "#d0d0d0",
  on_bg = "#d0d0d0",
  border_active = "#6a9fb5",
  indicator = "#6978b5",
  nontext_on_bg = "#4a4a4a",
  muted_on_statusline = "#636363",
  on_statusline = "#d0d0d0",
  fg_match = "#f4bf75",
  bg_highlight = "#303030",
  hint = "#668d86",
  on_highlight = "#d0d0d0",
  diff_delete = "#331e1e",
  muted_on_surface = "#6b6b6b",
  terminal_color_1 = "#ac4142",
  bg_surface = "#202020",
  diff_change = "#3b2b1f",
  terminal_color_6 = "#75b5aa",
  syntax_variable = "#c46465",
  bg_selection = "#3c464b",
  ansi_bright_red = "#ac4142",
  bg_search = "#486875",
  disabled_on_bg = "#636363",
  bg_shadow = "#202020",
  terminal_color_3 = "#f4bf75",
  muted_on_floating = "#6e6e6e",
  prompt = "#6a9fb5",
  bg_visual = "#374c55",
  error = "#c46465",
  disabled_on_floating = "#6e6e6e",
  fg = "#d0d0d0",
  on_primary = "#ffffff",
  muted_on_bg = "#636363",
  on_success = "#ffffff",
  terminal_color_12 = "#6a9fb5",
  ansi_red = "#ac4142",
  terminal_color_13 = "#aa759f",
  bg_match = "#2f3e45",
  syntax_string = "#90a959",
  syntax_escape = "#75b5aa",
  terminal_color_15 = "#f5f5f5",
  terminal_color_8 = "#505050",
  syntax_function = "#6a9fb5",
  cursor = "#6a9fb5",
  syntax_keyword = "#aa759f",
  terminal_color_4 = "#6a9fb5",
  terminal_color_5 = "#aa759f",
  syntax_comment = "#636363",
  terminal_color_11 = "#f4bf75",
  bg = "#151515",
  syntax_punctuation = "#b0b0b0",
  terminal_color_10 = "#90a959",
  terminal_color_14 = "#75b5aa",
  terminal_color_0 = "#151515",
  terminal_color_9 = "#ac4142",
  bg_floating = "#252525",
  terminal_color_7 = "#d0d0d0",
  terminal_color_2 = "#90a959",
  bg_panel = "#272d2f",
  on_secondary = "#ffffff",
  bg_inactive = "#1c1c1c",
  mark = "#aa759f",
  ansi_white = "#d0d0d0",
  bg_statusline = "#151515",
  diff_text = "#744c2d",
  ansi_black = "#151515",
  bg_cursorline = "#222222",
  ansi_bright_yellow = "#f4bf75",
  ansi_yellow = "#f4bf75",
  syntax_deprecated = "#b56c45",
  primary = "#6a9fb5",
  warning = "#d28445",
  on_error = "#ffffff",
  ansi_bright_white = "#f5f5f5",
  ansi_bright_cyan = "#75b5aa",
  ansi_bright_magenta = "#aa759f",
  ansi_bright_blue = "#6a9fb5",
  diff_add = "#2e3323",
  success = "#90a959",
  ansi_bright_green = "#90a959",
  disabled_on_surface = "#6b6b6b",
  syntax_constant = "#d28445",
  ansi_bright_black = "#505050",
}

-- ── Public API ────────────────────────────────────────────────────────────────

---@type DyPalette
M.palette = {}

---Load the colorscheme from a DyPalette talbe
---@param opts? { scheme?: DyPalette, palette_override?: table }
function M.load(opts)
  opts = opts or {}

  local palette = M.read_cache()
  if opts.scheme or not vim.fn.empty(palette) then
    if opts.scheme then
      palette = palette_from_ui_colors(opts.scheme)
    else
      palette = opts.scheme or DEFAULT_PALETTE
    end
  end

  -- Allow the caller to pin individual slots without overriding the whole palette.
  if opts.palette_override then
    for k, v in pairs(opts.palette_override) do
      palette[k] = norm(v) or palette[k]
    end
  end

  M.palette = palette

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "dytheme"

  -- Hightlight groups
  require("dytheme.groups").apply(M.palette)
  -- Terminal colors
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = M.palette["terminal_color_" .. i]
  end

  -- Fire the ColorScheme autocmd so that plugins which listen for colorscheme
  -- changes (lualine, bufferline, etc.) refresh themselves. This is the same
  -- event Neovim fires after :colorscheme, so all plugins handle it correctly
  -- without needing plugin-specific reload calls.
  vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
end

---Read a JSON colorscheme file
---See `switch-theme.py` from `codeberg.org/caleskog/tumbleweed-dotfiles`
---for JSON colorscheme file details.
---@param opts table
function M.load_scheme_from_file(opts)
  -- opts.fargs contains the arguments split into an array by whitespace
  local path = opts.fargs[1]

  if not path or path == "" then
    print("Error: Please provide a file path.")
    return
  end

  local file, err = io.open(path, "r")
  if not file then
    print("Error opening file: " .. tostring(err))
    return
  end

  local content = file:read("*a")
  file:close()
  local scheme = {}
  local json_scheme = vim.json.decode(content)
  scheme = json_scheme["ui"]

  M.load({ scheme = scheme })
end

local cache_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "dytheme")
local cache_file = vim.fs.joinpath(cache_dir, "palette.lua")

function M.compile_and_save_cache()
  vim.fn.mkdir(cache_dir, "p")

  local lines = { "return {" }
  for key, hex_value in pairs(M.palette) do
    table.insert(lines, string.format('  ["%s"] = "%s",', key, hex_value))
  end
  table.insert(lines, "}")
  local compiled_lua_string = table.concat(lines, "\n")

  local file = io.open(cache_file, "w")
  if file then
    file:write(compiled_lua_string)
    file:close()
  end

  vim.notify("dytheme: Compiled and saved cache successfully!", vim.log.levels.INFO)
end

function M.read_cache()
  local cache_chunk = loadfile(cache_file)

  if cache_chunk then
    return cache_chunk()
  end

  if vim.fn.empty(M.palette) then
    M.compile_and_save_cache()
  end
  return M.palette
end

function M.clear_cache()
  os.remove(cache_file)
  vim.notify("dytheme: Cache cleared! It will regenerate on next load.", vim.log.levels.INFO)
end

return M
