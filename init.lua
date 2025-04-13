-- Ultimate Backend Development Neovim Configuration
-- Simplified and organized for maximum productivity

-- Initialize early settings
vim.g.mapleader = " "           -- Set leader key (must be before lazy)
vim.g.maplocalleader = ","      -- Set local leader key

-- Disable unnecessary providers for performance
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load core Neovim settings
require("core")

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins with lazy.nvim
require("lazy").setup({
  -- Load all plugins defined in the plugins directory
  { import = "plugins" },
}, {
  install = {
    colorscheme = { "catppuccin" },
  },
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🔑",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Initialize colorscheme with fallbacks
vim.schedule(function()
  local colorscheme_ok, _ = pcall(vim.cmd, "colorscheme catppuccin")
  if not colorscheme_ok then
    vim.cmd("colorscheme habamax") -- Fallback colorscheme
  end
end)
