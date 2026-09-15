local M = {}

function M.is_absolute(path)
  return path:match("^%a:[\\/]") or path:sub(1, 1) == "/"
end

function M.joinpath(base, relative)
  if not base or base == "" then
    return relative
  end
  if not relative or relative == "" then
    return base
  end
  if vim.fs and vim.fs.joinpath then
    return vim.fs.joinpath(base, relative)
  end
  if base:sub(-1) == "/" then
    return base .. relative
  end
  return base .. "/" .. relative
end

function M.normalize(path)
  if not path or path == "" then
    return nil
  end
  local uv = vim.uv or vim.loop
  local home = uv.os_homedir()
  if home then
    path = path:gsub("^~", home)
  end
  path = vim.fn.expand(path)
  return vim.fs.normalize(path)
end

function M.canonical(path)
  if not path or path == "" then
    return path
  end
  local uv = vim.uv or vim.loop
  local real = uv.fs_realpath(path)
  return real and vim.fs.normalize(real) or path
end

function M.stat(path)
  local uv = vim.uv or vim.loop
  return path and uv.fs_stat(path) or nil
end

return M
