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

require("lazy").setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "c", "go", "sql", "bash", "json", "yaml" },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = true },
      })
    end,
  },

  -- LSP, Mason, nvim-cmp
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },

  -- DAP (debugging)
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "mfussenegger/nvim-dap-python" },
  { "leoluz/nvim-dap-go" },

  -- Testing
  { "vim-test/vim-test" },
  { "hkupty/iron.nvim" },

  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Git
  { "lewis6991/gitsigns.nvim", config = true },
  { "TimUntersberger/neogit" },
  { "kdheepak/lazygit.nvim" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- WhichKey
  { "folke/which-key.nvim", event = "VimEnter", config = true },
})

-- Only load the plugin spec. All plugin-dependent code is loaded by Lazy.nvim via config blocks.
require("lazy").setup(require("custom.plugins"))
