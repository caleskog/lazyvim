return {
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        app = {
          "qutebrowser",
          "--desktop-file-name",
          "markdown-preview",
          "--target",
          "window",
          "-s",
          "tabs.show",
          "never",
          "-s",
          "statusbar.show",
          "never",
          "%s",
        },
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
