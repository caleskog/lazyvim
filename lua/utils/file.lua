local M = {}

function M.read_file_lines(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end
  local lines = {}
  for line in fd:lines() do
    lines[#lines + 1] = line
  end
  fd:close()
  return lines
end

return M
