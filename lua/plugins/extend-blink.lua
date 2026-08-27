return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "krissen/blink-cmp-bibtex",
    },
    ---@module "blink.cmp.config"
    ---@type blink.cmp.Config
    opts = {
      completion = {
        documentation = {
          -- only show docs when manually triggered
          auto_show = false,
        },
      },
    },
  },
}
