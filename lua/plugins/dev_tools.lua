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
        "pyright", "gopls", "clangd", "lua-language-server", "typescript-language-server",
        "rust_analyzer", "jdtls", "ols",
        -- Data Science specific
        "ruff-lsp", "jedi-language-server", "jupyter-lsp",
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
          "tsserver",            -- TypeScript
          "rust_analyzer",       -- Rust
          "lua_ls",              -- Lua
          "jdtls",               -- Java
          "ols",                 -- Odin
          "ruff_lsp",            -- Python linter
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
