-- Web Development LSP Configuration Module
-- Centralizes web-related language server setup
-- Supports TypeScript, JavaScript, HTML, CSS, and related technologies

local lsp = require("core.lsp")

-- Shared settings for JavaScript/TypeScript LSPs
local ts_settings = {
  typescript = {
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    suggest = {
      completeFunctionCalls = true,
    },
  },
  javascript = {
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    suggest = {
      completeFunctionCalls = true,
    },
  },
  completions = {
    completeFunctionCalls = true,
  },
}

-- TypeScript/JavaScript language server
lsp.register_server("tsserver", {
  settings = ts_settings,
  -- Configure to work optimally with other web tools
  on_attach = function(client, bufnr)
    -- Disable formatting if prettier/eslint are handling it
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    
    -- Apply default on_attach afterward
    require("core.lsp").servers.tsserver.on_attach(client, bufnr)
  end,
})

-- ESLint language server
lsp.register_server("eslint", {
  settings = {
    workingDirectory = { mode = "auto" },
    format = true,
    validate = "on",
    packageManager = "npm",
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
    lintTask = {
      enable = true,
    },
  },
  on_attach = function(client, bufnr)
    -- Set up autoformat on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
      group = vim.api.nvim_create_augroup("eslint_fix_" .. bufnr, { clear = true }),
    })
    
    -- Apply default on_attach afterward
    require("core.lsp").servers.eslint.on_attach(client, bufnr)
  end,
})

-- HTML language server
lsp.register_server("html", {
  settings = {
    html = {
      format = {
        indentInnerHtml = true,
        wrapLineLength = 120,
        wrapAttributes = "auto",
      },
      hover = {
        documentation = true,
        references = true,
      },
      validate = {
        scripts = true,
        styles = true,
      },
      smartComplete = true,
    },
  },
})

-- CSS language server
lsp.register_server("cssls", {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore", -- Ignore unknown at-rules for framework compatibility
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

-- Tailwind CSS language server
lsp.register_server("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          -- Support for string-based Tailwind class references
          "tw`([^`]*)",
          "tw\\.[^`]+`([^`]*)",
          "tw\\(.*?\\).*?`([^`]*)",
          "className=\"([^\"]*)",
          -- Support for JSX className attribute
          ["className={{?([^}]*)}?"] = 1,
          -- Support for styled-components
          { "styled\\.[^`]+`([^`]*)", "\\." },
          { "styled\\([^`]+\\)`([^`]*)", "\\." },
        },
      },
      validate = true,
      includeLanguages = {
        typescript = "javascript",
        typescriptreact = "javascript",
        javascript = "javascript",
        javascriptreact = "javascript",
        html = "html",
      },
    },
  },
})

-- Emmet language server
lsp.register_server("emmet_ls", {
  filetypes = {
    "html", "css", "scss", "javascript", 
    "javascriptreact", "typescript", "typescriptreact",
    "svelte", "vue",
  },
  init_options = {
    html = {
      options = {
        -- Use comment in JSX/TSX
        ["jsx.enabled"] = true,
      },
    },
  },
})

-- JSON language server
lsp.register_server("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
      format = { enable = true },
    },
  },
  setup = function(server, opts)
    -- Try to load schemastore plugin for enhanced JSON schema support
    local has_schemastore, schemastore = pcall(require, "schemastore")
    if has_schemastore then
      opts.settings.json.schemas = schemastore.json.schemas()
    end
    return true
  end,
})

-- Vue language server
lsp.register_server("volar", {
  filetypes = { "vue" },
  settings = {
    vue = {
      complete = {
        casing = {
          props = "autoKebab",
        },
      },
    },
  },
})

-- Svelte language server
lsp.register_server("svelte", {
  settings = {
    svelte = {
      plugin = {
        svelte = {
          defaultScriptLanguage = "ts",
          compilerWarnings = {
            ["css-unused-selector"] = "ignore",
          },
        },
      },
    },
  },
})
