-- Basic Neovim settings
local M = {}

-- Editor behavior
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.smartcase = true -- Smart case searching
vim.opt.ignorecase = true -- Ignore case in searches
vim.opt.smartindent = true -- Smart autoindenting
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces for indentation
vim.opt.tabstop = 2 -- Number of spaces for tab
vim.opt.undofile = true -- Persistent undo
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 300 -- Faster key sequence completion
vim.opt.completeopt = { "menuone", "noselect" } -- Better completion
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.background = "dark" -- Set background to dark
vim.opt.syntax = "on" -- Enable syntax highlighting

-- Appearance
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 25 -- Minimum number of screen lines above/below cursor
vim.opt.sidescrolloff = 8 -- Minimum number of screen columns to keep left/right of cursor
vim.opt.showmode = false -- Don't show mode in command line (use statusline instead)
vim.opt.signcolumn = "yes" -- Always show sign column

-- Ignore system directories that often cause permission errors
vim.opt.wildignore:append "*/Library/Calendars/*"
vim.opt.wildignore:append "*/Library/Reminders/*"
vim.opt.wildignore:append "*/Library/CloudStorage/*"

-- Increase Git timeouts to prevent "git integration disabled" errors
vim.g.gitsigns_timeout = 5000 -- 5000ms instead of default 400ms
vim.g.gitsigns_max_file_length = 100000 -- Increase max file size for git operations

return M
