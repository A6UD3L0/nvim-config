-- Load default NvChad LSP configurations
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Backend development and data science focused servers
local servers = {
  -- Python ecosystem
  "pyright",        -- Python type checking
  "ruff_lsp",       -- Python linter
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

-- Setup handlers with NvChad defaults
for _, lsp in ipairs(servers) do
  if lspconfig[lsp] then -- Only setup if server exists
    lspconfig[lsp].setup {
      on_attach = function(client, bufnr)
        -- Call the default NvChad on_attach
        nvlsp.on_attach(client, bufnr)
        
        -- Add additional on_attach functionality here
        -- Enable inlay hints for supported servers if available
        if client.server_capabilities.inlayHintProvider and vim.fn.has("nvim-0.10.0") == 1 then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end

-- Language specific LSP configurations
-- Python specific settings
if lspconfig.pyright then
  lspconfig.pyright.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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

-- Jedi Language Server (Python intellisense with better import and docstring support)
if lspconfig.jedi_language_server then
  lspconfig.jedi_language_server.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end
