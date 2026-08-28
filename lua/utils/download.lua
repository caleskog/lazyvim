M = {}

--- Downloads a file using curl
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@return boolean true if download succeeded, false otherwise
M.curl = function(url, dest)
  if vim.fn.executable("curl") ~= 1 then
    return false
  end
  local download_cmd = string.format("curl -fL -o %s %s", vim.fn.shellescape(dest), vim.fn.shellescape(url))
  local output = vim.fn.system(download_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("curl failed: " .. output, vim.log.levels.DEBUG)
    return false
  end
  return true
end

--- Downloads a file using wget
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@return boolean true if download succeeded, false otherwise
M.wget = function(url, dest)
  if vim.fn.executable("wget") ~= 1 then
    return false
  end
  local download_cmd = string.format("wget -O %s %s", vim.fn.shellescape(dest), vim.fn.shellescape(url))
  local output = vim.fn.system(download_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("wget failed: " .. output, vim.log.levels.DEBUG)
    return false
  end
  return true
end

--- Attempts to download a file using available download methods (curl or wget)
--- Tries each method in order until one succeeds
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@return boolean true if download succeeded, false otherwise
M.get = function(url, dest)
  local fncs = { M.curl, M.wget }
  for _, fn in ipairs(fncs) do
    if fn(url, dest) then
      return true
    end
  end
  return false
end

--- Downloads a file asynchronously using curl
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@param callback function(success: boolean) Callback executed with result
M.async_curl = function(url, dest, callback)
  if vim.fn.executable("curl") ~= 1 then
    callback(false)
    return
  end

  local cmd = { "curl", "-fL", "-o", dest, url }

  vim.system(cmd, { text = true }, function(obj)
    -- Schedule interaction back to the main Neovim thread
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify("curl failed: " .. (obj.stderr or obj.stdout or ""), vim.log.levels.DEBUG)
        callback(false)
      else
        callback(true)
      end
    end)
  end)
end

--- Downloads a file asynchronously using wget
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@param callback function(success: boolean) Callback executed with result
M.async_wget = function(url, dest, callback)
  if vim.fn.executable("wget") ~= 1 then
    callback(false)
    return
  end

  local cmd = { "wget", "-O", dest, url }

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify("wget failed: " .. (obj.stderr or obj.stdout or ""), vim.log.levels.DEBUG)
        callback(false)
      else
        callback(true)
      end
    end)
  end)
end

--- Attempts to download a file using available methods (curl or wget)
--- Fallback chain executes sequentially without blocking the UI
---@param url string URL of the file to download
---@param dest string Destination path for the downloaded file
---@param callback function(success: boolean) Callback executed with final result
M.async_get = function(url, dest, callback)
  -- Try curl first
  M.async_curl(url, dest, function(success)
    if success then
      callback(true)
    else
      -- Fallback to wget if curl fails
      M.async_wget(url, dest, function(wget_success)
        callback(wget_success)
      end)
    end
  end)
end

return M
