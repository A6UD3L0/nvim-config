-- Backend & Machine Learning Neovim Config
-- Portable, modern, and robust

-- 1. Dynamic config root for portability
local init_file = debug.getinfo(1, "S").source:sub(2)
local config_dir = vim.fn.fnamemodify(init_file, ":h")
vim.opt.runtimepath:prepend(config_dir)
package.path = table.concat({
  config_dir.."/lua/?.lua",
  config_dir.."/lua/?/init.lua",
  package.path,
}, ";")

-- 2. Editor settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- 3. Plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("custom.plugins"))
