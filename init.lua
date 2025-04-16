-- Streamlined Neovim Configuration for Backend Development
-- Clean, minimal UI with Tokyonight theme

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core settings
require("settings")

-- Load keymaps
require("mappings")

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

-- Load plugins
require("lazy").setup({ import = "plugins" })
