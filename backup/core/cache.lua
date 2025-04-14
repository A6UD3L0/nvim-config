-- Cache management for base46 and NvChad UI
local M = {}

-- Handle compatibility between different Neovim versions
local fs_stat = vim.loop and vim.loop.fs_stat or vim.uv and vim.uv.fs_stat

-- Ensure the cache directory exists
function M.ensure_cache_dir()
  local cache_dir = vim.g.base46_cache
  
  if not cache_dir then
    cache_dir = vim.fn.stdpath("data") .. "/base46/"
    vim.g.base46_cache = cache_dir
  end
  
  if not fs_stat or not fs_stat(cache_dir) then
    vim.fn.mkdir(cache_dir, "p")
    return false
  end
  
  return true
end

-- Generate theme highlights
function M.generate_highlights()
  local ok, base46 = pcall(require, "base46")
  
  if ok and base46 then
    pcall(function()
      base46.load_all_highlights()
    end)
    return true
  end
  
  return false
end

-- Check if a file exists in cache
function M.file_exists(file)
  if not file or file == "" then return false end
  
  local path = vim.g.base46_cache .. file
  return fs_stat and fs_stat(path) ~= nil
end

-- Generate and load a cached file
function M.load_cached_file(file)
  local path = vim.g.base46_cache .. file
  
  -- Check if the file exists
  if M.file_exists(file) then
    local ok, err = pcall(dofile, path)
    if not ok then
      vim.notify("Error loading " .. path .. ": " .. (err or "unknown error"), vim.log.levels.WARN)
      return false
    end
    return true
  else
    -- Try to regenerate highlights
    if M.generate_highlights() then
      -- Try loading again
      local ok, err = pcall(dofile, path)
      if not ok then
        vim.notify("Failed to load " .. path .. " after regeneration: " .. (err or "unknown error"), vim.log.levels.WARN)
        return false
      end
      return true
    end
  end
  
  return false
end

-- Initialize the cache system
function M.init()
  M.ensure_cache_dir()
  M.generate_highlights()
end

return M
