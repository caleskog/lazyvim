M = {}

M.prompt_install = function(on_done)
  if vim.fn.executable("quarto") == 1 then
    on_done(false)
    return
  end

  local rpm = require("utils.rpm")

  local url = "https://github.com/quarto-dev/quarto-cli/releases/download/v1.11.1/quarto-1.11.1-linux-x86_64.rpm"
  rpm.start_install_workflow(url, "Quarto", on_done)
end

return M
