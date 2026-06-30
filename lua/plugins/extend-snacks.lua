return {
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      picker = {
        -- This forces the global setting, but sources can override it
        hidden = true,
        sources = {
          -- This specifically targets the <space><space> "Smart" finder
          smart = {
            hidden = true,
          },
          -- This targets the <leader>fF / <leader>ff "Find Files" finder
          files = {
            hidden = true,
          },
        },
      },
    },
  },
}
