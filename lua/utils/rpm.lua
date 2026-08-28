local downloader = require("utils.download")

local M = {}

--- Checks if a graphical Polkit authentication agent is currently running in the OS
---@return boolean true if a GUI agent is found, false otherwise
local function has_gui_polkit_agent()
  -- If we are in a pure headless TTY or SSH session, there's no GUI agent
  if os.getenv("DISPLAY") == nil and os.getenv("WAYLAND_DISPLAY") == nil then
    return false
  end

  -- Search the process list for common graphical authentication agents
  local handle = io.popen("ps -e | grep -E 'polkit.*(gnome|kde|mate|lx|qt|xfce|agent)'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      -- A graphical prompt handler is active!
      return true
    end
  end
  -- No graphical agent found
  return false
end

---@param rpm_path string The local path to the downloaded RPM file
---@param on_done function Callback function with success/failure bool as argument
local function run_installer_via_terminal_split(rpm_path, on_done)
  vim.cmd("botright 10new")
  local win = vim.api.nvim_get_current_win()

  local cmd = { "sudo", "rpm", "-i", rpm_path }

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("Package successfully installed via text run0!", vim.log.levels.INFO)
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          on_done(true)
        else
          vim.notify("Installation failed inside the terminal split.", vim.log.levels.ERROR)
          on_done(false)
        end
      end)
    end,
  })
  vim.cmd("startinsert") -- Drop into terminal insert mode so user can type immediately
end

--- Executes the final installation command using run0-sudo via vim.system
---@param rpm_path string The local path to the downloaded RPM file
---@param on_done function Callback function with success/failure bool as argument
local function run_installer_via_gui_popup(rpm_path, on_done)
  local cmd = { "sudo", "rpm", "-i", rpm_path }

  vim.notify("Triggering system authentication popup...", vim.log.levels.INFO)

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        vim.notify("Package successfully installed!", vim.log.levels.INFO)
        on_done(true)
      else
        -- Catch authentication denials or package errors
        local error_msg = (obj.stderr ~= "" and obj.stderr) or obj.stdout or "Installation or authentication canceled."
        vim.notify("Installation failed:\n" .. error_msg, vim.log.levels.ERROR)
        on_done(false)
      end
    end)
  end)
end

--- --- Prompts for password after a successful download
--- ---@param rpm_path string The path of the downloaded file to install
--- local function prompt_for_password(rpm_path, on_done)
---   -- Input secret hides typed characters
---   local password = vim.fn.inputsecret("Enter Root/Sudo Password to install: ")
---
---   if password == "" then
---     vim.notify("Installation canceled: Password required.", vim.log.levels.WARN)
---     on_done(false)
---     return
---   end
---
---   -- run_installer(password, rpm_path, on_done)
--- end

--- Main orchestrator function
---@param url string The remote URL of the RPM file
---@param label string Name of program to install
---@param on_done function Callback function with success/failure bool as argument
M.start_install_workflow = function(url, label, on_done)
  if vim.fn.executable("rpm") ~= 1 then
    vim.notify("`rpm` is required to install " .. label, vim.log.levels.ERROR)
    on_done(false)
    return
  end

  vim.ui.select({ "Yes", "No" }, {
    prompt = "Do you want to download and install " .. label .. "?",
  }, function(choice)
    if choice ~= "Yes" then
      vim.notify("Installation canceled by user.", vim.log.levels.INFO)
      on_done(false)
      return
    end

    local rpm_file = vim.fn.tempname() .. ".rpm"

    -- User chose 'Yes'
    downloader.async_get(url, rpm_file, function(download_success)
      if not download_success then
        vim.notify("Workflow aborted: Failed to download the RPM file.", vim.log.levels.ERROR)
        on_done(false)
        return
      end

      -- Download succeeded
      vim.schedule(function()
        -- prompt_for_password(rpm_file, on_done)
        if has_gui_polkit_agent() then
          run_installer_via_gui_popup(rpm_file, on_done)
        else
          run_installer_via_terminal_split(rpm_file, on_done)
        end
      end)
    end)
  end)
end

return M
