return {
  { "akinsho/bufferline.nvim", enabled = false },
  -- I don't use the default explorer
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
    },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
  { "iamcco/markdown-preview.nvim", enabled = false }, -- using `peek.nvim` instead
}
