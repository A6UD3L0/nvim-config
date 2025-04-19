-- Utility functions for MECE Neovim config
-- Centralizes common patterns for plugin existence, directory checks, etc.

local M = {}

--- Safe require with notification (for plugins and modules)
-- @param plugin string: Name of the plugin/module to require
-- @param feature string|nil: Feature description for error message
-- @return boolean, any: status, module (or nil)
function M.require_safe(plugin, feature)
  local ok, mod = pcall(require, plugin)
  if not ok then
    local msg = (feature or plugin) .. " not found."
    vim.notify(msg, vim.log.levels.WARN)
    return false, nil
  end
  return true, mod
end

--- Ensure a directory exists (creates recursively if needed)
-- @param dir string: Directory path
function M.ensure_dir_exists(dir)
  local stat = vim.loop.fs_stat(dir)
  if not stat then
    vim.fn.mkdir(dir, 'p')
  end
end

--- Ensure a file exists (creates parent directory if needed)
-- @param file string: File path
function M.ensure_file_exists(file)
  local dir = vim.fn.fnamemodify(file, ':h')
  M.ensure_dir_exists(dir)
  local stat = vim.loop.fs_stat(file)
  if not stat then
    local fd = io.open(file, 'w')
    if fd then fd:close() end
  end
end

return M
