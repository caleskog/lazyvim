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

-- Build a palette from a base16 or base24 scheme table.
--
-- base16 spec (dark theme):
--   base00  darkest bg          → bg
--   base01  slightly lighter bg → bg_alt   (status bars, lighter backgrounds)
--   base02  selection bg        → sel
--   base03  comments/invisible  → comment  (also line highlighting)
--   base04  dark fg (statusbar) → fg_dim
--   base05  default fg          → fg
--   base06  light fg (rare)     → (unused — absorbed into fg)
--   base07  lightest fg (rare)  → (unused)
--   base08  red                 → red      (variables, diff deleted, errors)
--   base09  orange              → orange   (integers, booleans, constants)
--   base0A  yellow              → yellow   (classes, search bg, markup bold)
--   base0B  green               → green    (strings, diff inserted)
--   base0C  cyan                → cyan     (support, regex, escape chars)
--   base0D  blue                → blue     (functions, headings, attr IDs)
--   base0E  magenta             → magenta  (keywords, storage, diff changed)
--   base0F  brown/dark-red      → (rare — embedded lang tags, deprecated)
--
-- base24 extras (dark theme):
--   base10  darker bg           → (falls back to base00 / bg)
--   base11  darkest bg          → (falls back to base00 / bg)
--   base12  bright red          → (falls back to base08 / red)
--   base13  bright yellow       → (falls back to base0A / yellow)
--   base14  bright green        → (falls back to base0B / green)
--   base15  bright cyan         → (falls back to base0C / cyan)
--   base16  bright blue         → (falls back to base0D / blue)
--   base17  bright magenta      → (falls back to base0E / magenta)
--
-- Note: base0F and the base24 "bright" slots (base12–base17) are stored
-- on the palette but not used heavily in Neovim syntax — they exist so that
-- terminal and other downstream consumers can use them correctly.
local function palette_from_scheme(s)
  local b = {}
  for k, v in pairs(s) do
    b[k] = norm(v)
  end

  -- base24 fallbacks: if a slot is missing, fall back to its base16 equivalent
  local function get(key, fallback)
    return b[key] or b[fallback] or error("dytheme: missing required slot " .. (fallback or key))
  end

  return {
    -- ── UI shades ──────────────────────────────────────────────────────────
    bg = get("base00"),
    bg_alt = get("base01"),
    sel = get("base02"),
    comment = get("base03"),
    fg_dim = get("base04"),
    fg = get("base05"),
    -- base06/07 kept for completeness but not mapped to named slots
    fg_light = get("base06"),
    fg_bright = get("base07"),

    -- ── Accent colors ─────────────────────────────────────────────────────
    red = get("base08"),
    orange = get("base09"),
    yellow = get("base0A"),
    green = get("base0B"),
    cyan = get("base0C"),
    blue = get("base0D"),
    magenta = get("base0E"),
    brown = get("base0F"), -- embedded tags, deprecated items

    -- ── Border: midpoint between bg and sel (cosmetic convenience) ─────────
    -- We synthesise this because base16 has no explicit border slot.
    -- It is overridable: opts.palette_override = { border = "#..." }
    border = get("base02"), -- same as sel; fine as a subtle separator

    -- ── base24 extras (bright variants) ───────────────────────────────────
    -- Falls back to the base16 equivalent when base24 slots are absent.
    bg_darker = get("base10", "base00"), -- darker than bg
    bg_darkest = get("base11", "base00"), -- darkest bg
    bright_red = get("base12", "base08"),
    bright_yellow = get("base13", "base0A"),
    bright_green = get("base14", "base0B"),
    bright_cyan = get("base15", "base0C"),
    bright_blue = get("base16", "base0D"),
    bright_magenta = get("base17", "base0E"),
  }
end

-- ── Built-in default palette (tokyonight-ish dark) ───────────────────────────
-- Expressed as a base16 scheme.
local DEFAULT_SCHEME = {
  -- bg shades (dark → light)
  base00 = "#1a1b26", -- bg            darkest
  base01 = "#13141f", -- bg_alt        status bars
  base02 = "#283457", -- sel           selection
  base03 = "#444b6a", -- comment       comments / invisibles
  base04 = "#565f89", -- fg_dim        dim foreground
  base05 = "#c0caf5", -- fg            default foreground
  base06 = "#d0d7ff", -- fg_light      (rarely used)
  base07 = "#e8eaf6", -- fg_bright     (rarely used)
  -- accent colors
  base08 = "#f7768e", -- red
  base09 = "#ff9e64", -- orange
  base0A = "#e0af68", -- yellow
  base0B = "#9ece6a", -- green
  base0C = "#7dcfff", -- cyan
  base0D = "#7aa2f7", -- blue
  base0E = "#bb9af7", -- magenta
  base0F = "#c53b53", -- brown/dark-red
  -- base24 extras (brighter variants)
  base10 = "#0f101a", -- bg_darker
  base11 = "#0a0b10", -- bg_darkest
  base12 = "#ff9aa1", -- bright_red
  base13 = "#ffc777", -- bright_yellow
  base14 = "#b6e67e", -- bright_green
  base15 = "#a8e8ff", -- bright_cyan
  base16 = "#9dbeff", -- bright_blue
  base17 = "#d0b3ff", -- bright_magenta
}

-- ── Public API ────────────────────────────────────────────────────────────────

M.palette = {}

--- @param opts? { scheme?: table, palette_override?: table }
function M.load(opts)
  opts = opts or {}

  local palette = M.read_cache()
  if not vim.fn.empty(palette) and opts.scheme then
    local scheme = opts.scheme or DEFAULT_SCHEME
    palette = palette_from_scheme(scheme)
  end

  -- Synthesise border from midpoint of bg and sel when not explicitly set.
  local blend = require("dytheme.util").blend
  if not opts.palette_override or not opts.palette_override.border then
    palette.border = blend(palette.bg, palette.sel, 0.6)
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

  require("dytheme.groups").apply(palette)
end

-- Read a JSON colorscheme file from tinty
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
  for k, v in pairs(json_scheme["palette"]) do
    if vim.startswith(k, "base") then
      scheme[k] = v["hex_str"]
    end
  end

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
    vim.notify("dytheme: Cache retrived.", vim.log.levels.DEBUG)
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
