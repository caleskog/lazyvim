-- Lualine picks this file up automatically because it lives at
-- lua/lualine/themes/<name>.lua inside the plugin's runtimepath.
-- Users set it with:
--
--   require("lualine").setup({ options = { theme = "dytheme" } })
--
-- Or in LazyVim's plugin spec:
--
--   { "nvim-lualine/lualine.nvim", opts = { options = { theme = "dytheme" } } }
--
-- lualine theme structure:
--   Each mode key (normal, insert, …) holds section keys (a, b, c).
--   x/y/z on the right side mirror c/b/a automatically when unset.
--   Each section: { fg = "#hex", bg = "#hex", gui = "bold|italic|…" }
--
-- Mode → accent color convention (matches all major themes):
--   normal   → blue    calm default
--   insert   → green   writing / adding
--   visual   → magenta selecting
--   replace  → red     overwriting (destructive)
--   command  → yellow  ex-mode prompt
--   terminal → cyan    shell buffer

-- palette is populated by dytheme.setup() before colors/dytheme.lua returns,
-- so by the time lualine reads this file the table is always ready.
---@type DyPalette
local c = require("dytheme").palette

-- b and c are shared across all active modes — only the `a` pill changes.
local b = { fg = c.on_surface, bg = c.bg_surface }
local co = { fg = c.muted_on_surface, bg = c.bg_surface }

return {
  normal = {
    a = { fg = c.on_ansi_blue, bg = c.ansi_blue, gui = "bold" },
    b = b,
    c = co,
  },
  insert = {
    a = { fg = c.on_ansi_green, bg = c.ansi_green, gui = "bold" },
    b = b,
    c = co,
  },
  visual = {
    a = { fg = c.on_ansi_magenta, bg = c.ansi_magenta, gui = "bold" },
    b = b,
    c = co,
  },
  replace = {
    a = { fg = c.on_ansi_red, bg = c.ansi_red, gui = "bold" },
    b = b,
    c = co,
  },
  command = {
    a = { fg = c.on_ansi_yellow, bg = c.ansi_yellow, gui = "bold" },
    b = b,
    c = co,
  },
  terminal = {
    a = { fg = c.on_ansi_cyan, bg = c.ansi_cyan, gui = "bold" },
    b = b,
    c = co,
  },
  inactive = {
    a = { fg = c.muted_on_surface, bg = c.bg_surface, gui = "bold" },
    b = { fg = c.muted_on_surface, bg = c.bg_surface },
    c = { fg = c.muted_on_surface, bg = c.bg_surface },
  },
}
