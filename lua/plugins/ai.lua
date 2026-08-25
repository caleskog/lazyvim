-- small helper: read a key file and strip trailing whitespace/newline
local function read_key(path)
  local f = io.open(vim.fn.expand(path), "r")
  if not f then
    vim.notify("minuet: could not read key file " .. path, vim.log.levels.ERROR)
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
          mistral = function()
            return require("codecompanion.adapters").extend("mistral", {
              env = {
                -- admin.mistral.ai
                api_key = "file:~/.dotfiles/.mistral_api_key",
              },
              schema = {
                model = { default = "mistral-medium-3-5" },
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
            name = "mistral",
            model = "mistral-medium-3-5",
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
            name = "mistral",
            model = "mistral-medium-3-5",
          },
        },
        cmd = {
          adapter = {
            name = "mistral",
            model = "mistral-medium-3-5",
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
        show_on_completion_menu = false, -- Don't show virtual text when completion menu is visible
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
        -- Add "minuet" to `default` if minuet's suggestions should be automatically
        -- shown in completions list.
        -- default = { "minuet" },
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
