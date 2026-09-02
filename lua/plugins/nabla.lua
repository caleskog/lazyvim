return {
  { -- preview equations
    "jbyuki/nabla.nvim",
    ft = { "mardkown", "quarto", "latex" },
    keys = {
      { "<leader>mp", ':lua require("nabla").popup()<cr>', desc = "popup [m]ath equations" },
      { "<leader>mm", ':lua require("nabla").toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },
}
