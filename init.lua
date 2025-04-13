-- Initialize base46 cache directory and variables
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- Ensure the base46 cache directory exists
if not vim.loop.fs_stat or not vim.loop.fs_stat(vim.g.base46_cache) then
  vim.fn.mkdir(vim.g.base46_cache, "p")
end

-- Force regenerate base46 cache on startup if files are missing
local function regenerate_base46_cache()
  local base46_ok, base46 = pcall(require, "base46")
  if not base46_ok then
    vim.notify("Base46 module not found, theme compilation skipped.", vim.log.levels.WARN)
    return false
  end
  
  -- Check for required cache files
  local missing_cache = false
  for _, file in ipairs({"defaults", "statusline"}) do
    local file_path = vim.g.base46_cache .. file .. ".lua"
    if not vim.loop.fs_stat or not vim.loop.fs_stat(file_path) then
      missing_cache = true
      break
    end
  end
  
  -- Regenerate cache if files are missing
  if missing_cache then
    vim.notify("Regenerating base46 cache...", vim.log.levels.INFO)
    
    -- Load base46 highlights
    pcall(function()
      base46.load_all_highlights()
    end)
    
    -- Attempt to directly compile the theme
    pcall(function()
      if base46.compile then
        base46.compile()
      end
    end)
    
    return true
  end
  
  return false
end

-- Bootstrap lazy.nvim and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins using lazy.nvim:
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",  -- Load NvChad's own plugins
  },

  { import = "plugins" },        -- Load plugins from your default plugins folder
  { import = "plugins.extra" },  -- Load your extra plugins from a custom file
}, lazy_config)

-- Regenerate base46 cache after plugins are loaded
regenerate_base46_cache()

-- Initialize the cache system
local cache_ok, cache = pcall(require, "core.cache")
if cache_ok then
  cache.init()
else
  -- Fallback if cache module not loaded
  local present, base46 = pcall(require, "base46")
  if present then
    pcall(function() base46.load_all_highlights() end)
  end
end

-- Load theme and statusline setups from the base46 cache with error handling
local function load_base46_file(file)
  if cache_ok and cache then
    cache.load_cached_file(file)
  else
    local file_path = vim.g.base46_cache .. file .. ".lua"
    
    -- Check if file exists using either API (for compatibility)
    local exists = false
    
    -- Try vim.loop first (older Neovim versions)
    if vim.loop and vim.loop.fs_stat then
      exists = vim.loop.fs_stat(file_path) ~= nil
    -- Then try vim.uv (newer Neovim versions)
    elseif vim.uv and vim.uv.fs_stat then
      exists = vim.uv.fs_stat(file_path) ~= nil
    end
    
    -- Load the file if it exists
    if exists then
      local ok, err = pcall(dofile, file_path)
      if not ok then
        vim.notify("Warning: Could not load " .. file_path .. ". " .. (err or ""), vim.log.levels.WARN)
      end
    else
      vim.notify("Base46 cache file " .. file .. " not found. Try restarting Neovim.", vim.log.levels.WARN)
    end
  end
end

-- Load base46 files safely
load_base46_file("defaults")
load_base46_file("statusline")

-- Load other configs
require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
