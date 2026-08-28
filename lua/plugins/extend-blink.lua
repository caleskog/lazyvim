return {
  {
    "saghen/blink.cmp",
    branch = "v1",
    ---@module "blink.cmp.config"
    ---@type blink.cmp.Config
    opts = {
      completion = {
        documentation = {
          -- only show docs when manually triggered
          auto_show = false,
        },
        ghost_text = { enabled = false },
        list = {
          selection = { auto_insert = false },
        },
      },
    },
  },
}
