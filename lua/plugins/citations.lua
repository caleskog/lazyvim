if vim.fn.executable("quarto") == 0 then
  vim.notify("`citations.lua` require `quarto` to be installed", vim.log.levels.WARN)
  return {}
end

local bib_paths = function(ctx)
  local defaults = require("blink-cmp-bibtex.config").defaults()
  local scan = require("blink-cmp-bibtex.scan")
  local sources = scan.resolve_bib_sources(ctx.bufnr, ctx.opts or defaults)
  return scan.paths_from_sources(sources)
end

local function parse_bib(path)
  local result = vim
    .system({
      "quarto",
      "pandoc",
      "--from=biblatex",
      "--to=csljson",
      path,
    }, {
      text = true,
    })
    :wait()

  if result.code ~= 0 then
    vim.notify("Failed to parse bibliography: " .. path .. "\n" .. result.stderr, vim.log.levels.ERROR)
    return {}
  end

  local ok, entries = pcall(vim.json.decode, result.stdout)

  if not ok then
    vim.notify("Failed to decode CSL JSON: " .. path, vim.log.levels.ERROR)
    return {}
  end

  return entries
end

local function citation_finder(_, _)
  local opts = require("blink-cmp-bibtex").opts

  local paths = bib_paths({
    bufnr = vim.api.nvim_get_current_buf(),
    opts = opts,
  })

  ---@type snacks.picker.finder.Item[]
  local items = {}

  for _, path in ipairs(paths) do
    for _, entry in ipairs(parse_bib(path)) do
      local authors = {}

      for _, author in ipairs(entry.author or {}) do
        local name = author.family

        if author.given then
          name = (name or "") .. ", " .. author.given
        end

        if name then
          table.insert(authors, name)
        end
      end

      local author_text = table.concat(authors, "; ")

      local year = ""
      if entry.issued and entry.issued["date-parts"] then
        year = tostring(entry.issued["date-parts"][1][1] or "")
      end

      ---@type snacks.picker.finder.Item
      local item = {
        -- Everything here is searchable by Snacks.
        text = table.concat({
          entry.id or "",
          author_text,
          entry.title or "",
          year,
        }, " "),

        -- Data used for displaying/inserting.
        id = entry.id,
        author = author_text,
        title = entry.title or "",
        year = year,
        file = path,

        entry = entry,
      }

      table.insert(items, item)
    end
  end

  return items
end

return {
  {
    "krissen/blink-cmp-bibtex",
    opts = {
      filetypes = { "tex", "plaintex", "markdown", "quarto", "rmd", "typst" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "krissen/blink-cmp-bibtex",
    },
    ---@module "blink.cmp.config"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = function()
          return { "bibtex", "lsp", "path", "snippets", "buffer" }
        end,
        providers = {
          bibtex = {
            module = "blink-cmp-bibtex",
            name = "BibTeX",
            min_keyword_length = 2,
            score_offset = 10,
            async = true,
            opts = {
              -- provider-level overrides (optional)
            },
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      picker = {
        sources = {
          quarto_citations = {
            title = "Quarto Citations",
            finder = citation_finder,
            format = function(item)
              return {
                { "(" .. item.year .. ") ", "SnacksPickerComment" },
                { item.title, "SnacksPickerFile" },
              }
            end,
            preview = function(ctx)
              local item = ctx.item

              if not item then
                return
              end

              local json = vim.json.encode(item.entry)
              local formatted = vim.fn.system({
                "jq",
                ".",
              }, json)

              ctx.preview:reset()
              ctx.preview:set_lines(vim.split(formatted, "\n"))
              ctx.preview:highlight({ ft = "json" })
            end,
            confirm = function(picker, item)
              item = item or picker:selected()
              if not item then
                return
              end

              picker:close()

              vim.api.nvim_put({
                "[@" .. item.id .. "]",
              }, "c", true, true)
            end,
          },
        },
      },
    },
    keys = {
      {
        "<C-q>",
        function()
          Snacks.picker.pick("quarto_citations")
        end,
        desc = "Quarto Citations",
      },
    },
  },
}
