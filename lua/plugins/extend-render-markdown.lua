return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
      file_types = { "markdown", "codecompanion" },
      completions = { lsp = { enabled = true } },
      heading = {
        width = "block",
      },
      on = {
        attach = function()
          if vim.bo.filetype == "codecompanion" then
            vim.cmd("RenderMarkdown enable")
          end
        end,
      },
    },
  },
}
