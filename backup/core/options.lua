-- Core Neovim options and settings
-- Optimized for backend development workflow

local opt = vim.opt

-- Line numbers and relative line numbers for easy navigation
opt.number = true
opt.relativenumber = true

-- Indentation settings (4 spaces by default, adjust per language in ftplugin)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Interface enhancements
opt.termguicolors = true
opt.showmode = false
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Window and split behavior
opt.splitright = true
opt.splitbelow = true

-- Faster UI updates
opt.updatetime = 100
opt.timeoutlen = 300
opt.ttimeoutlen = 10

-- Better command-line completion
opt.wildmenu = true
opt.wildmode = "full"
opt.completeopt = "menuone,noselect"

-- File handling
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- System clipboard integration
opt.clipboard = "unnamedplus"

-- Better buffer handling
opt.hidden = true

-- Performance
opt.lazyredraw = true

-- Misc
opt.confirm = true
opt.mouse = "a"
opt.cmdheight = 1
opt.pumheight = 10
opt.wrap = false
opt.spell = false
opt.spelllang = "en_us"

-- Global statusline
opt.laststatus = 3
