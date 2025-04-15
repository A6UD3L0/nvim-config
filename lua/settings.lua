-- Basic Neovim settings
local M = {}

-- Editor behavior
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
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.background = "dark"   -- Set background to dark
vim.opt.syntax = "on"         -- Enable syntax highlighting

-- Appearance
vim.opt.wrap = false          -- Don't wrap lines
vim.opt.scrolloff = 8         -- Minimum number of screen lines above/below cursor
vim.opt.sidescrolloff = 8     -- Minimum number of screen columns to keep left/right of cursor
vim.opt.showmode = false      -- Don't show mode in command line (use statusline instead)
vim.opt.signcolumn = 'yes'    -- Always show sign column

-- Apply Tokyonight theme
local theme_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not theme_ok then
  vim.cmd("colorscheme default")
end

return M
