local M = {}

-- Read a JSON colorscheme file from tinty
function M.read_scheme(opts)
  -- opts.fargs contains the arguments split into an array by whitespace
  local filePath = opts.fargs[1]

  if not filePath or filePath == "" then
    print("Error: Please provide a file path.")
    return
  end

  local file, err = io.open(filePath, "r")
  if not file then
    print("Error opening file: " .. tostring(err))
    return
  end

  local content = file:read("*all")
  print(content)
  file:close()
end

-- Create the custom command ':ReadFile <path>' inside Neovim
vim.api.nvim_create_user_command("DyTheme", M.read_scheme, { nargs = "1" })

return M
