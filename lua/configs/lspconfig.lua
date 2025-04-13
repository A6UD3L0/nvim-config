-- Standalone LSP configuration for backend development
local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Common on_attach function to set keymaps and enable features
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- Add additional on_attach functionality here
  -- Enable inlay hints for supported servers if available
  if client.server_capabilities.inlayHintProvider and vim.fn.has("nvim-0.10.0") == 1 then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

-- Backend development and data science focused servers
local servers = {
  -- Python ecosystem
  "pyright",        -- Python type checking
  "ruff",           -- Python linter (updated from ruff_lsp)
  "jedi_language_server", -- Python intellisense
  "jupyter_lsp",    -- Jupyter notebook support
  
  -- Web development
  "html",
  "cssls",
  "tsserver",       -- TypeScript/JavaScript
  
  -- Go development
  "gopls",          -- Go language server
  
  -- C/C++ development
  "clangd",         -- C/C++ language server
  
  -- SQL
  "sqlls",          -- SQL language server
  
  -- Docker/Kubernetes
  "dockerls",       -- Docker
  "yamlls",         -- YAML (for k8s configs)
  
  -- Data Science specific
  "r_language_server", -- R language
  "julials",        -- Julia language
  
  -- General
  "lua_ls",         -- Lua language server
  "jsonls",         -- JSON
  "bashls",         -- Bash
  "marksman",       -- Markdown
}

-- Setup handlers with standard defaults
for _, lsp in ipairs(servers) do
  -- Check if the server exists in lspconfig
  if lspconfig[lsp] and type(lspconfig[lsp].setup) == "function" then
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

-- Language specific LSP configurations
-- Python specific settings
if lspconfig.pyright then
  lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic",
          -- Data science specific analysis settings
          autoImportCompletions = true,
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
          },
        },
      },
    },
  }
end

-- Ruff for Python linting (using ruff instead of deprecated ruff_lsp)
if lspconfig.ruff then
  lspconfig.ruff.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      settings = {
        -- Ruff settings
        lint = {
          run = "onSave",
        },
      },
    },
  }
end

-- Jedi Language Server (Python intellisense with better import and docstring support)
if lspconfig.jedi_language_server then
  lspconfig.jedi_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      diagnostics = {
        enable = true,
        didOpen = true,
        didChange = true,
        didSave = true,
      },
      completion = {
        disableSnippets = false,
        resolveEagerly = true,
      },
    },
  }
end

-- Go specific settings
if lspconfig.gopls then
  lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
        usePlaceholders = true,
        completeUnimported = true,
      },
    },
  }
end

-- Lua settings
if lspconfig.lua_ls then
  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" }, -- Recognize 'vim' global for Neovim config
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

-- SQL Language Server
if lspconfig.sqlls then
  lspconfig.sqlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      sqlLanguageServer = {
        lint = {
          rules = {
            "all", -- Enable all linting rules
          },
        },
        format = {
          uppercase = true,
          linesBetweenQueries = 2,
        },
      },
    },
  }
end

-- YAML Language Server with Kubernetes schema support
if lspconfig.yamlls then
  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
        },
        validate = true,
        format = {
          enable = true,
        },
      },
    },
  }
end

-- Julia Language Server
if lspconfig.julials then
  lspconfig.julials.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- C/C++ clangd configuration
if lspconfig.clangd then
  lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  }
end
