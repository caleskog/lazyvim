return {
  {
    "jmbuhr/otter.nvim",
    dev = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    ---@module "otter.config"
    ---@type OtterConfig | table[]
    opts = {},
  },
}
