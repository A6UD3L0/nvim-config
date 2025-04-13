-- Neovim IDE Configuration optimized for backend development

-- Set leader key early
vim.g.mapleader = " "

---------------------------------------------------------
-- Bootstrap lazy.nvim (plugin manager)
---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install lazy.nvim if not already installed
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
-- Basic Vim Settings (leader, encodings, basic behaviors)
---------------------------------------------------------
require "options"

---------------------------------------------------------
-- Core Keymaps  
---------------------------------------------------------
require "mappings"

---------------------------------------------------------
-- Autocommands (basic editor behaviors)
---------------------------------------------------------
-- Load custom autocommands (previously using NvChad)
local autocmd = vim.api.nvim_create_autocmd

-- Disable autoformat for certain files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "javascript", "typescript", "lua", "python", "go" },
  callback = function()
    vim.b.autoformat = true
  end,
})

-- Highlight text on yank for better UX
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Format options
autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "a" -- Don't autoformat
      - "t" -- Don't auto wrap text
      + "c" -- Auto wrap comments
      + "q" -- Allow formatting of comments with gq
      - "o" -- Don't continue comments with o and O
      + "r" -- Continue comments after return
      + "n" -- Recognize numbered lists
      + "j" -- Remove comment leader when joining lines when possible
      - "2" -- Don't use indent of second line for rest of paragraph
  end,
})

---------------------------------------------------------
-- Plugin Manager Setup (lazy.nvim)
---------------------------------------------------------
local lazy_config = require "configs.lazy"

require("lazy").setup({
  -- Core plugins
  { import = "plugins" },            -- Automatically loads plugins/init.lua
  { import = "plugins.dev_tools" },  -- Development tools and LSP configurations
  { import = "plugins.completion" }, -- Load completion plugins
  { import = "plugins.copilot" },    -- Load GitHub Copilot integration
  { import = "plugins.datascience" },-- Load Data Science plugins
}, lazy_config)

-- Load custom commands including :MasonInstallAll
pcall(require, "configs.commands")

---------------------------------------------------------
-- Final setup and initialization
---------------------------------------------------------
-- Faster UI updates
vim.opt.updatetime = 200

-- Apply patches for deprecated APIs
vim.schedule(function()
  -- Apply patches for copilot-cmp and other plugins with deprecated warnings
  pcall(require, "configs.copilot_patches").setup()
end)

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
