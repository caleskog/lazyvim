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
local c = require("dytheme").palette

-- b and c are shared across all active modes — only the `a` pill changes.
local b = { fg = c.fg, bg = c.bg_alt }
local co = { fg = c.fg_dim, bg = c.bg_alt }

return {
  normal = {
    a = { fg = c.bg, bg = c.blue, gui = "bold" },
    b = b,
    c = co,
  },
  insert = {
    a = { fg = c.bg, bg = c.green, gui = "bold" },
    b = b,
    c = co,
  },
  visual = {
    a = { fg = c.bg, bg = c.magenta, gui = "bold" },
    b = b,
    c = co,
  },
  replace = {
    a = { fg = c.bg, bg = c.red, gui = "bold" },
    b = b,
    c = co,
  },
  command = {
    a = { fg = c.bg, bg = c.yellow, gui = "bold" },
    b = b,
    c = co,
  },
  terminal = {
    a = { fg = c.bg, bg = c.cyan, gui = "bold" },
    b = b,
    c = co,
  },
  inactive = {
    a = { fg = c.fg_dim, bg = c.bg_alt, gui = "bold" },
    b = { fg = c.fg_dim, bg = c.bg_alt },
    c = { fg = c.comment, bg = c.bg_alt },
  },
}
