-- Create the custom command ':ReadFile <path>' inside Neovim
vim.api.nvim_create_user_command("DyTheme", function(opts)
  local dytheme = require("dytheme")
  dytheme.load_scheme_from_file(opts)
  dytheme.compile_and_save_cache()
end, { nargs = 1, complete = "file" })

vim.api.nvim_create_user_command("DythemeCompile", function()
  require("dytheme").compile_and_save_cache()
  vim.notify("dytheme: Cache re-compiled successfully!", vim.log.levels.INFO)
end, {})
