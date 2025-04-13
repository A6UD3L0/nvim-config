-- ~/.config/nvim/lua/plugins/extra.lua

return {
  ----------------------------------------------------------------------
  -- LSP and Mason Plugins:
  ----------------------------------------------------------------------
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",             -- Python
          "gopls",               -- Go
          "clangd",              -- C/C++
          "ts_ls",               -- TypeScript
          "rust_analyzer",       -- Rust
          "lua-language-server", -- Lua
          "jdtls",               -- Java
          "ols",                 -- Odin
          "hls",                 -- Haskell
        },
      })
    end,
  },
  "neovim/nvim-lspconfig",  -- Built-in LSP configuration

  ----------------------------------------------------------------------
  -- Auto-completion and Snippet Support:
  ----------------------------------------------------------------------
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  ----------------------------------------------------------------------
  -- Debugging Support:
  ----------------------------------------------------------------------
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "nvim-neotest/nvim-nio",

  ----------------------------------------------------------------------
  -- UI Enhancements:
  ----------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "hoob3rt/lualine.nvim",
  "akinsho/bufferline.nvim", -- For tabline/buffer management
  "lewis6991/gitsigns.nvim",
  "mbbill/undotree",          -- Undotree
  "windwp/nvim-autopairs",

  ----------------------------------------------------------------------
  -- File Explorer and Icons:
  ----------------------------------------------------------------------
  "kyazdani42/nvim-web-devicons", -- Icons for files and folders
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
              },
            },
          },
        },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Additional Utilities:
  ----------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    config = function() require("harpoon").setup({}) end,
  },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },

  ----------------------------------------------------------------------
  -- Optional and Lazy-loaded Plugins:
  ----------------------------------------------------------------------
  { "stevearc/conform.nvim", lazy = true },
  { "eandrju/cellular-automaton.nvim", lazy = true },
}


