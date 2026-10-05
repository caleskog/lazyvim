return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            exportPdf = "never",
          },
        },
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {
      open_cmd = "qutebrowser --desktop-file-name typst-preview --target window -s tabs.show never -s statusbar.show never %s",
    },
  },
}
