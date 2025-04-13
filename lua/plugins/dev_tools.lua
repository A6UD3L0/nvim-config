-- ~/.config/nvim/lua/plugins/dev_tools.lua

return {
  ----------------------------------------------------------------------
  -- LSP and Mason Plugins:
  ----------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {
        -- LSP
        "pyright", "gopls", "clangd", "lua_ls", "typescript-language-server",
        "rust-analyzer", "jdtls", "ols",
        -- Data Science specific
        "ruff-lsp", "jedi-language-server", "basedpyright",
        -- Formatter
        "stylua", "black", "gofumpt", "shfmt", "isort",
        -- DAP
        "debugpy", "delve",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
  },
  
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
          "lua_ls",              -- Lua
          "jdtls",               -- Java
          "ols",                 -- Odin
          "ruff",                -- Python linter
          "jedi_language_server" -- Python intellisense
        },
        automatic_installation = true,
      })
    end,
  },
  
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "nvimdev/lspsaga.nvim",
        opts = {
          lightbulb = { enable = false },
          symbol_in_winbar = { enable = false },
        },
      },
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
}
