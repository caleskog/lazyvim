return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        http = {
          azure_openai = function()
            return require("codecompanion.adapters").extend("azure_openai", {
              env = {
                api_key = "file:~/.dotfiles/.azure_openai_api_key",
                endpoint = "https://dida-foundry.openai.azure.com",
              },
              schema = {
                model = {
                  default = "gpt-5.4",
                },
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = {
            name = "azure_openai",
            model = "gpt-5.4",
          },
        },
        inline = {
          adapter = {
            name = "azure_openai",
            model = "gpt-5.4",
          },
        },
        cmd = {
          adapter = {
            name = "azure_openai",
            model = "gpt-5.4",
          },
        },
      },
    },
    keys = {
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanion Chat Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion Actions",
        mode = { "n", "v" },
      },
      {
        "<leader>ai",
        "<cmd>CodeCompanion<cr>",
        desc = "CodeCompanion Inline Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "CodeCompanion Add to Chat",
        mode = { "v" },
      },
    },
  },
}
