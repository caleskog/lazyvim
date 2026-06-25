return {
  {
    -- point lazy at the folder containing colors/ and lua/
    dir = vim.fn.stdpath("config") .. "/lua/plugins/dytheme",
    name = "dytheme",
    lazy = false,
    priority = 1000, -- load before everything else
  },

  -- tell LazyVim to actually apply it
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "dytheme" },
  },
}
