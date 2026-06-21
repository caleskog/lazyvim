---@module 'yazi'
---@type YaziConfig | {}
local yazi_opts = {
  open_for_directories = true,
  keymaps = {
    show_help = "~",
  },
}

return {
  ---@module 'lazy'
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>e",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi (directory of current file)",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi (cwd)",
      },
      {
        "<leader>fm",
        function()
          require("yazi").yazi(yazi_opts, LazyVim.root(), {})
        end,
        desc = "Open yazi (root)",
      },
      {
        "<leader>fy",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@module 'yazi'
    ---@type YaziConfig | {}
    opts = yazi_opts,
    init = function()
      -- mark netrw as loaded so it's not loaded at all.
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
