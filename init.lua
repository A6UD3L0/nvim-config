-- Streamlined Neovim Configuration for Backend Development
-- Clean, minimal UI with Tokyonight theme

-- Load all core editor settings (MECE separation)
require("settings")

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Apply Tokyonight theme after plugins are loaded
local theme_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not theme_ok then
  vim.notify("Could not apply Tokyonight theme, falling back to default", vim.log.levels.WARN)
  vim.cmd("colorscheme default")
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
