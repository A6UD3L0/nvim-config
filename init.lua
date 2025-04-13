-- Neovim IDE Configuration optimized for backend development
-- Combines ThePrimeagen's functionality with NvChad simplicity

-- Set leader key early
vim.g.mapleader = " "

---------------------------------------------------------
-- Bootstrap lazy.nvim (plugin manager)
---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

---------------------------------------------------------
-- Performance optimizations
---------------------------------------------------------
-- Disable unnecessary providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable built-in plugins not needed
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---------------------------------------------------------
-- Theme and UI setup
---------------------------------------------------------
-- Create theme cache directory
local cache_dir = vim.fn.stdpath("data") .. "/theme_cache/"
vim.fn.mkdir(cache_dir, "p")

---------------------------------------------------------
-- Load core configuration
---------------------------------------------------------
-- Load options (editor behavior)
require "options"

-- Load key mappings
vim.schedule(function()
  require "mappings"
end)

-- Load auto commands
require "nvchad.autocmds"

---------------------------------------------------------
-- Load plugins with lazy.nvim
---------------------------------------------------------
local lazy_config = require "configs.lazy"

require("lazy").setup({
  -- Core plugins
  { import = "plugins" },           -- Automatically loads plugins/init.lua
  { import = "plugins.extra" },     -- Load extra plugins
  { import = "plugins.copilot" },   -- Load GitHub Copilot integration
  { import = "plugins.datascience" },  -- Load Data Science plugins
}, lazy_config)

---------------------------------------------------------
-- Final setup and initialization
---------------------------------------------------------
-- Set colorscheme
vim.schedule(function()
  -- Try to use catppuccin first, fall back to default colorschemes if not available
  local colorscheme_ok, _ = pcall(vim.cmd, "colorscheme catppuccin")
  if not colorscheme_ok then
    -- Try tokyonight
    colorscheme_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
    
    -- If tokyonight isn't available, try another common one
    if not colorscheme_ok then
      pcall(vim.cmd, "colorscheme habamax") -- This is a default Neovim colorscheme
    end
  end
end)

-- Run any post-startup commands
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Display startup time if desired
    if vim.g.startup_time then
      vim.notify("Neovim loaded in " .. vim.g.startup_time .. " ms", vim.log.levels.INFO)
    end
  end,
})
