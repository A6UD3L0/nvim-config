-- Advanced LSP configuration for backend development
-- Features comprehensive autocompletion, diagnostics, code navigation and more

local M = {}

-- Define colors for diagnostics in floating windows
local colors = {
  error = "#f7768e",
  warn = "#e0af68",
  info = "#7dcfff",
  hint = "#9ece6a",
}

-- Enhanced LSP setup function
function M.setup()
  -- Set up diagnostic signs and colors
  local signs = {
    { name = "DiagnosticSignError", text = "󰅚", texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn", text = "󰀪", texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignInfo", text = "󰋽", texthl = "DiagnosticSignInfo" },
    { name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.texthl })
  end

  -- Configure diagnostics display
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●", -- Using a dot as the prefix for inline diagnostics
      spacing = 4,
      source = "if_many",
      severity = {
        min = vim.diagnostic.severity.HINT,
      },
    },
    signs = { active = signs },
    underline = true,
    update_in_insert = false, -- Don't update diagnostics in insert mode
    severity_sort = true,     -- Sort by severity
    float = {
      focusable = true,
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      style = "minimal",
      format = function(diagnostic)
        local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp.code)
        local severity = vim.diagnostic.severity[diagnostic.severity]
        local icon = ({
          ERROR = " ", 
          WARN = " ", 
          INFO = " ", 
          HINT = " ",
        })[severity]
        
        -- Format based on severity and code if available
        local message = diagnostic.message
        if code then
          message = string.format("%s [%s]", message, code)
        end
        
        return string.format("%s %s", icon, message)
      end,
    },
  })

  -- Set up hover with advanced documentation
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded",
      max_width = 80,
      max_height = 40,
    }
  )

  -- Enhanced signature help display
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      close_events = { "CursorMoved", "BufHidden" },
      focusable = false,
    }
  )

  -- Auto attach LSP keybindings when a language server attaches
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LspAttachGroup', {}),
    callback = function(ev)
      local bufnr = ev.buf
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- Set up buffer-local keymaps and options
      -- Use our improved mappings function
      require("config.mappings").setup_lsp_mappings(bufnr)
      
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Enable inlay hints for supported servers
      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        -- Check if inlay hints is a function (Neovim 0.10+) or just a boolean toggle
        if type(vim.lsp.inlay_hint) == "function" then
          vim.lsp.inlay_hint(bufnr, true)
        elseif vim.lsp.inlay_hint.enable then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end

      -- Show signature help automatically while typing function calls
      local has_navic, navic = pcall(require, "nvim-navic")
      if has_navic and client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end
  })

  -- Enable auto-signature help while typing
  local has_signature = pcall(require, "lsp_signature")
  if has_signature then
    require("lsp_signature").setup({
      bind = true,
      handler_opts = {
        border = "rounded"
      },
      hint_enable = true,
      hint_prefix = "🔍 ",
      hint_scheme = "String",
      hi_parameter = "Search",
      max_height = 12,
      max_width = 120,
      padding = " ",
      transparency = 10,
      toggle_key = "<C-k>", -- Toggle signature on and off with Ctrl+k
    })
  end

  -- Configure completion sources integration for LSP servers
  local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_lsp_ok then
    M.capabilities = cmp_lsp.default_capabilities()
  else
    M.capabilities = vim.lsp.protocol.make_client_capabilities()
  end

  -- Add enhanced capabilities
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
  M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  M.capabilities.textDocument.completion.completionItem.preselectSupport = true
  M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  M.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
  M.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Set up language servers with enhanced features
  M.setup_servers()
end

-- Function to set up individual language servers with enhanced configuration
function M.setup_servers()
  local lspconfig = require("lspconfig")
  
  -- Python (Pyright) enhanced setup
  lspconfig.pyright.setup {
    capabilities = M.capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
          typeCheckingMode = "basic",
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            callArgumentNames = true,
            pytestParameters = true,
          },
        },
      },
    },
  }
  
  -- Go (gopls) enhanced setup
  lspconfig.gopls.setup {
    capabilities = M.capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
          fieldalignment = true,
          nilness = true,
          unusedwrite = true,
        },
        staticcheck = true,
        gofumpt = true,
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  }
  
  -- C/C++ (clangd) enhanced setup
  lspconfig.clangd.setup {
    capabilities = M.capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  }
  
  -- SQL (sqlls) enhanced setup
  lspconfig.sqlls.setup {
    capabilities = M.capabilities,
  }

  -- Docker (dockerls) enhanced setup
  lspconfig.dockerls.setup {
    capabilities = M.capabilities,
  }
  
  -- YAML (yamlls) enhanced setup with schema validation
  lspconfig.yamlls.setup {
    capabilities = M.capabilities,
    settings = {
      yaml = {
        schemas = require("schemastore").yaml.schemas(),
        validate = true,
        completion = true,
        hover = true,
      },
    },
  }
  
  -- JSON (jsonls) enhanced setup with schema validation
  lspconfig.jsonls.setup {
    capabilities = M.capabilities,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  }
  
  -- Bash (bashls) enhanced setup
  lspconfig.bashls.setup {
    capabilities = M.capabilities,
  }
  
  -- Lua (lua_ls) enhanced setup with better Neovim integration
  lspconfig.lua_ls.setup {
    capabilities = M.capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        hint = {
          enable = true,
          setType = true,
          paramType = true,
          paramName = "Literal",
          semicolon = "All",
          arrayIndex = "All",
        },
      },
    },
  }
end

return M
