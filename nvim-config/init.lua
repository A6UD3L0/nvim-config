-- Streamlined Neovim Configuration for Backend Development
-- Clean, minimal UI with Tokyonight theme

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core editor settings - clean and focused
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true     -- Highlight current line
vim.opt.mouse = 'a'           -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.smartcase = true      -- Smart case searching
vim.opt.ignorecase = true     -- Ignore case in searches
vim.opt.smartindent = true    -- Smart autoindenting
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Number of spaces for indentation
vim.opt.tabstop = 2           -- Number of spaces for tab
vim.opt.undofile = true       -- Persistent undo
vim.opt.updatetime = 300      -- Faster completion
vim.opt.timeoutlen = 300      -- Faster key sequence completion
vim.opt.completeopt = {'menuone', 'noselect'} -- Better completion
vim.opt.wrap = false          -- Don't wrap lines
vim.opt.scrolloff = 8         -- Minimum number of screen lines above/below cursor
vim.opt.sidescrolloff = 8     -- Minimum number of screen columns to keep left/right of cursor
vim.opt.showmode = false      -- Don't show mode in command line 
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.splitbelow = true     -- Open horizontal splits below
vim.opt.splitright = true     -- Open vertical splits to the right
vim.opt.signcolumn = "yes"    -- Always show sign column

-- Create necessary directories
local function ensure_dir(dir)
  local is_dir = vim.fn.isdirectory(dir)
  if is_dir == 0 then
    vim.fn.mkdir(dir, "p")
  end
end
ensure_dir(vim.fn.stdpath("data") .. "/undo")
ensure_dir(vim.fn.stdpath("data") .. "/swap")
ensure_dir(vim.fn.stdpath("data") .. "/shada")

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins with error handling
local plugins_loaded = pcall(function()
  require("lazy").setup({
    -- Load UI plugins first
    { import = "plugins.ui" },
    -- Then load all other plugins
    { import = "plugins" },
  })
end)

if not plugins_loaded then
  vim.notify("Error loading plugins. Falling back to basic setup.", vim.log.levels.WARN)
  -- Try loading UI plugins separately
  pcall(function()
    require("lazy").setup({import = "plugins.ui"})
  end)
end

-- Set up which-key (if available)
pcall(function()
  require("which_key_setup").setup()
end)

-- Load mappings with error handling
pcall(function()
  require("mappings")
end)

-- Backend development specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go", "c", "cpp", "sql", "dockerfile", "yaml", "json" },
  callback = function()
    vim.opt_local.expandtab = true
    
    -- Language-specific settings
    if vim.bo.filetype == "go" then
      vim.opt_local.expandtab = false
    elseif vim.bo.filetype == "python" then
      vim.opt_local.colorcolumn = "88" -- Black formatter uses 88 characters
    end
  end
})
