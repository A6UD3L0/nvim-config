-- Utility functions for Neovim configuration
-- A collection of helper functions used throughout the config

local M = {}

-- Check if a file or directory exists
M.file_exists = function(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil
end

-- Get visual selection text
M.get_visual_selection = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

-- Print a table (useful for debugging)
M.dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- Safe require that doesn't error on missing modules
M.safe_require = function(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil
  end
  return result
end

-- Check if running on macOS
M.is_mac = function()
  return vim.fn.has('macunix') == 1
end

-- Check if running on Linux
M.is_linux = function()
  return vim.fn.has('unix') == 1 and not M.is_mac()
end

-- Check if running on Windows
M.is_windows = function()
  return vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
end

return M
