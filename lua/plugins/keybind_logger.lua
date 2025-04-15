-- Simple keybinding error/warning logger for Neovim
-- Saves any keymap-triggered errors, warnings, or debug messages

local M = {}
M.log = {}
M.logfile = vim.fn.stdpath('data') .. '/keybind_error_log.txt'

-- Patch vim.notify to capture error/warning/debug messages
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.ERROR or level == vim.log.levels.WARN or level == vim.log.levels.DEBUG then
    local entry = {
      time = os.date('%Y-%m-%d %H:%M:%S'),
      msg = msg,
      level = level,
      trace = debug.traceback()
    }
    table.insert(M.log, entry)
    -- Also append to file for persistence
    local f = io.open(M.logfile, 'a')
    if f then
      f:write(string.format('[%s][%s] %s\n', entry.time, vim.log.levels[level] or "UNKNOWN", msg))
      f:close()
    end
  end
  orig_notify(msg, level, opts)
end

-- Command to view the log in a scratch buffer
function M.show_log()
  vim.cmd('new')
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  local lines = { 'Keybinding Error/Warning Log:' }
  for _, entry in ipairs(M.log) do
    table.insert(lines, string.format('[%s][%s] %s', entry.time, vim.log.levels[entry.level] or "UNKNOWN", entry.msg))
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- Create user command if supported
if vim.api.nvim_create_user_command then
  vim.api.nvim_create_user_command('KeybindLog', function() M.show_log() end, {})
end

-- Patch to make it work with lazy.nvim plugin format
-- Adding these ensures it's a valid plugin spec
M.name = "keybind_logger"
M.config = function() end

return M
