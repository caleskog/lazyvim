return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/dytheme",
    name = "dytheme",
    lazy = false,
    priority = 1000, -- load before everything else
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "dytheme" },
  },
}
