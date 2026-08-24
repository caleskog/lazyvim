-- small helper: read a key file and strip trailing whitespace/newline
local function read_key(path)
  local f = io.open(vim.fn.expand(path), "r")
  if not f then
    vim.notify("could not read key file " .. path, vim.log.levels.ERROR)
    return nil
  end
  local key = f:read("*a"):gsub("%s+$", "")
  f:close()
  return key
end

local kind_icons = {
  -- LLM Provider icons
  claude = "󰋦",
  openai = "󱢆",
  codestral = "󱎥",
  gemini = "",
  Groq = "",
  Openrouter = "󱂇",
  Ollama = "󰳆",
  ["Llama.cpp"] = "󰳆",
  Deepseek = "",
}

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
          tavily = function()
            return require("codecompanion.adapters").extend("tavily", {
              env = {
                api_key = "file:~/.dotfiles/.tavily_api_key",
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
          tools = {
            ["web_search"] = {
              opts = {
                adapter = "tavily", -- duckduckgo, jina, or tavily
              },
            },
            ["rg"] = {
              ---@param adapter CodeCompanion.HTTPAdapter
              ---@return boolean
              ---@diagnostic disable-next-line: unused-local
              enabled = function(adapter)
                return vim.fn.executable("rg") == 1
              end,
            },
          },
          icons = {
            chat_context = "📎️", -- fold icon
          },
          fold_context = true,
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

  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      vim.env.CODESTRAL_API_KEY = read_key("~/.dotfiles/.mistral_api_key")
      require("minuet").setup({
        provider = "codestral",
        provider_option = {
          codestral = {
            model = "codestral-latest",
            api_key = "CODESTRAL_API_KEY",
            -- Recommended to prevent request timeout from outputing too many tokens.
            optional = {
              max_tokens = 256,
              stop = { "\n\n" },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = {}, -- blink is the frontend
        },
      })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      appearance = {
        nerd_font_variant = "normal",
        kind_icons = kind_icons,
      },
      keymap = {
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
}
