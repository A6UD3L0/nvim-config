-- Core Utilities Module
-- Common utility functions with consistent interfaces and error handling
-- Used throughout the Neovim configuration to standardize operations

local M = {}

-- ╭──────────────────────────────────────────────────────────╮
-- │                    Plugin Utilities                       │
-- ╰──────────────────────────────────────────────────────────╯

--- Check if a plugin is available (standardized interface)
-- @param plugin_name string The name of the plugin to check
-- @return boolean, table|nil True if plugin exists, plus the module if loaded successfully
function M.has_plugin(plugin_name)
  local status, plugin = pcall(require, plugin_name)
  if status then
    return status, plugin
  end
  return status
end

--- Safely require a module with fallbacks
-- @param module_name string The name of the module to require
-- @param default any The default value to return if the module cannot be loaded
-- @return any The loaded module or the default value
function M.safe_require(module_name, default)
  local status, module = pcall(require, module_name)
  if not status then
    vim.notify("Could not load module: " .. module_name, vim.log.levels.DEBUG)
    return default
  end
  return module
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                    System Utilities                       │
-- ╰──────────────────────────────────────────────────────────╯

--- Check if a system command exists
-- @param cmd string The command to check
-- @return boolean True if the command exists
function M.command_exists(cmd)
  if not cmd or cmd == "" then 
    return false 
  end
  
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then 
    return false 
  end
  
  local result = handle:read("*a")
  handle:close()
  return result and #result > 0
end

--- Execute a shell command and return the output
-- @param cmd string The command to execute
-- @return string|nil The command output or nil if failed
function M.execute_command(cmd)
  local handle = io.popen(cmd .. " 2>&1")
  if not handle then
    return nil
  end
  
  local result = handle:read("*a")
  local success = handle:close()
  return success and result or nil
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                     File Utilities                        │
-- ╰──────────────────────────────────────────────────────────╯

--- Check if a file exists
-- @param path string The path to check
-- @return boolean True if the file exists
function M.file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

--- Ensure a directory exists, creating it if necessary
-- @param dir string The directory path
-- @return boolean True if the directory exists or was created
function M.ensure_dir(dir)
  local is_dir = vim.fn.isdirectory(dir)
  if is_dir == 0 then
    local success, err = pcall(vim.fn.mkdir, dir, "p")
    if not success then
      vim.notify("Failed to create directory: " .. dir, vim.log.levels.ERROR)
      return false
    end
  end
  return true
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                Notification Utilities                     │
-- ╰──────────────────────────────────────────────────────────╯

--- Display a formatted error message
-- @param msg string The error message
-- @param level number The log level (defaults to ERROR)
function M.display_error(msg, level)
  level = level or vim.log.levels.ERROR
  local formatted_msg = string.format("Error: %s", msg)
  
  if vim.notify then
    vim.notify(formatted_msg, level)
  else
    print(formatted_msg)
  end
end

-- ╭──────────────────────────────────────────────────────────╮
-- │              Function Call Utilities                      │
-- ╰──────────────────────────────────────────────────────────╯

--- Safely call a function with error handling
-- @param fn function The function to call
-- @param ... any Arguments to pass to the function
-- @return boolean, any True if successful, plus the function result
function M.safe_call(fn, ...)
  if type(fn) ~= "function" then
    return false, nil
  end
  
  local status, result = pcall(fn, ...)
  if not status then
    M.display_error("Function call failed: " .. tostring(result), vim.log.levels.DEBUG)
    return false, nil
  end
  
  return true, result
end

--- Create a debounced function
-- @param fn function The function to debounce
-- @param ms number Debounce time in milliseconds
-- @return function The debounced function
function M.debounce(fn, ms)
  local timer = vim.loop.new_timer()
  return function(...)
    local args = {...}
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule(function()
        fn(unpack(args))
      end)
    end)
  end
end

return M
