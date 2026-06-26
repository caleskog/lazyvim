-- Sets Neovim's 16 built-in terminal colors (vim.g.terminal_color_0..15)
-- so that :terminal buffers and any plugin that opens a terminal window
-- match the theme palette.
--
-- The 16 slots follow the standard ANSI order, which base16/base24 also
-- uses for its ANSI column. The mapping below is taken directly from the
-- base24 styling spec ANSI column:
--
--   0  Black           → base00  (bg / normal black)
--   1  Red             → base08
--   2  Green           → base0B
--   3  Yellow / Brown  → base0A
--   4  Blue            → base0D
--   5  Magenta         → base0E
--   6  Cyan            → base0C
--   7  White           → base05  (normal white / foreground)
--   8  Bright Black    → base03  (comments / gray)
--   9  Bright Red      → base12  (bright_red,  falls back to base08)
--  10  Bright Green    → base14  (bright_green, falls back to base0B)
--  11  Bright Yellow   → base13  (bright_yellow,falls back to base0A)
--  12  Bright Blue     → base16  (bright_blue,  falls back to base0D)
--  13  Bright Magenta  → base17  (bright_magenta,falls back to base0E)
--  14  Bright Cyan     → base15  (bright_cyan,  falls back to base0C)
--  15  Bright White    → base07  (fg_bright / lightest fg)
--
-- Note: slots 16–21 (base01, base04, base06, base10, base11) are the
-- "extra" shades from base16/base24 that have no canonical ANSI slot.
-- They are intentionally omitted here; Neovim only exposes 0–15.

local M = {}

--- Apply terminal colors from the theme palette.
--- Called automatically by dytheme.load(), but can also be called
--- standalone if you want to update terminal colors without touching
--- highlight groups:
---
---   require("dytheme.terminal").apply(require("dytheme").palette)
---
--- @param c table  The resolved palette table from mytheme.init
function M.apply(c)
  -- Normal (dim) ANSI colors
  vim.g.terminal_color_0 = c.bg -- black      (base00)
  vim.g.terminal_color_1 = c.red -- red        (base08)
  vim.g.terminal_color_2 = c.green -- green      (base0B)
  vim.g.terminal_color_3 = c.yellow -- yellow     (base0A)
  vim.g.terminal_color_4 = c.blue -- blue       (base0D)
  vim.g.terminal_color_5 = c.magenta -- magenta    (base0E)
  vim.g.terminal_color_6 = c.cyan -- cyan       (base0C)
  vim.g.terminal_color_7 = c.fg -- white      (base05)

  -- Bright ANSI colors — use base24 bright slots when available,
  -- falling back to the normal variant (which init.lua already handled
  -- when it built the palette from a base16-only scheme).
  vim.g.terminal_color_8 = c.comment -- bright black  (base03 / gray)
  vim.g.terminal_color_9 = c.bright_red -- bright red    (base12 → base08)
  vim.g.terminal_color_10 = c.bright_green -- bright green  (base14 → base0B)
  vim.g.terminal_color_11 = c.bright_yellow -- bright yellow (base13 → base0A)
  vim.g.terminal_color_12 = c.bright_blue -- bright blue   (base16 → base0D)
  vim.g.terminal_color_13 = c.bright_magenta -- bright magenta (base17 → base0E)
  vim.g.terminal_color_14 = c.bright_cyan -- bright cyan   (base15 → base0C)
  vim.g.terminal_color_15 = c.fg_bright -- bright white  (base07)
end

return M
