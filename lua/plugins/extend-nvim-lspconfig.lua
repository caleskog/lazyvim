return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.handlers["$/progress"] = function() end
    end,
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
