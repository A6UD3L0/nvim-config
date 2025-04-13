vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

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

-- Ensure base46 cache files are generated before loading them
local present, base46 = pcall(require, "base46")
if present then
  base46.load_all_highlights()
end

-- Load theme and statusline setups from the base46 cache with error handling
local function load_base46_file(file)
  local file_path = vim.g.base46_cache .. file
  
  -- Check if the cache directory exists, create if not
  if not vim.uv.fs_stat(vim.g.base46_cache) then
    vim.fn.mkdir(vim.g.base46_cache, "p")
  end
  
  -- Check if the file exists, otherwise skip
  if vim.uv.fs_stat(file_path) then
    dofile(file_path)
  else
    print("Warning: Could not load " .. file_path .. ". Base46 cache may not be generated yet.")
    -- Try to generate it
    if present then
      base46.compile() -- This will compile base46 theme
      if vim.uv.fs_stat(file_path) then
        dofile(file_path)
      end
    end
  end
end

-- Load base46 files safely
load_base46_file("defaults.lua")
load_base46_file("statusline.lua")

-- Load other configs
require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
