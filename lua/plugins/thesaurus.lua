vim.g.thesaurus = {
  provider = "freedictionaryapi",
  picker = "snacks",
  api_key = nil,
  loading = true,
}

return {
  {
    "rafi/telescope-thesaurus.nvim",
    dependencies = { "folke/snacks.nvim" },
  },
}
