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

-- Load theme and statusline setups from the base46 cache
-- Note the added ".lua" extension to correctly load the files.
dofile(vim.g.base46_cache .. "defaults.lua")
dofile(vim.g.base46_cache .. "statusline.lua")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
