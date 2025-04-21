-- settings.lua: Minimal, high-performance Neovim options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

-- Always keep context around cursor
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
