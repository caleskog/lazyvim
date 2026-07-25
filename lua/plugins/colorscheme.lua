return {
  {
    url = "https://codeberg.org/caleskog/dytheme.nvim.git",
    name = "dytheme",
    lazy = false,
    priority = 1000, -- load before everything else
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "dytheme" },
  },
}
