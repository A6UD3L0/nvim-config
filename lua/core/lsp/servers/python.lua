-- Python LSP Configuration Module
-- Centralizes Python language server setup
-- Supports pyright, pylsp, and ruff_lsp with optimized settings

local lsp = require("core.lsp")
local utils = require("core.utils")

-- Find Python executable
local function get_python_path()
  -- Check for active virtual environment
  local venv = vim.env.VIRTUAL_ENV
  if venv then
    if vim.fn.has("win32") == 1 then
      return venv .. "\\Scripts\\python.exe"
    else
      return venv .. "/bin/python"
    end
  end
  
  -- Check for common Python executables
  for _, name in ipairs({ "python3", "python" }) do
    if utils.command_exists(name) then
      return name
    end
  end
  
  return "python" -- Default fallback
end

-- Python executable to use for LSP servers
local python_path = get_python_path()

-- Pyright configuration
lsp.register_server("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        autoImportCompletions = true, -- Add imports automatically
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
      pythonPath = python_path,
    },
  },
  before_init = function(_, config)
    -- Set pythonPath in Pyright dynamically
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.python then
      config.settings.python = {}
    end
    config.settings.python.pythonPath = python_path
  end,
})

-- Python LSP configuration
lsp.register_server("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        -- Linting plugins
        pylint = {
          enabled = true,
          executable = "pylint",
        },
        flake8 = {
          enabled = false, -- Use ruff instead
        },
        pyflakes = {
          enabled = false, -- Use ruff instead
        },
        pycodestyle = {
          enabled = false, -- Use ruff instead
        },
        
        -- Auto-formatting plugins
        autopep8 = {
          enabled = false, -- Use ruff instead
        },
        yapf = {
          enabled = false, -- Use ruff instead
        },
        black = {
          enabled = true,
          line_length = 88,
        },
        
        -- Type checking
        pylsp_mypy = {
          enabled = true,
          live_mode = true,
          dmypy = false,
        },
        
        -- Enhanced functionality
        rope_autoimport = {
          enabled = true,
        },
        rope_completion = {
          enabled = true,
        },
        jedi = {
          environment = python_path,
        },
        jedi_completion = {
          enabled = true,
          include_params = true,
          include_class_objects = true,
          include_function_objects = true,
        },
        jedi_definition = {
          enabled = true,
          follow_imports = true,
          follow_builtin_imports = true,
        },
        jedi_hover = {
          enabled = true,
        },
        jedi_references = {
          enabled = true,
        },
        jedi_signature_help = {
          enabled = true,
        },
        jedi_symbols = {
          enabled = true,
          all_scopes = true,
        },
      },
    },
  },
})

-- Ruff LSP configuration (for linting and formatting)
lsp.register_server("ruff_lsp", {
  init_options = {
    settings = {
      -- Ruff settings
      args = {},
      organizeImports = true,
      fixAll = true,
      -- Don't provide hover since it conflicts with pyright
      showNotifications = true,
    }
  },
  -- Limit ruff to linting and formatting operations
  on_attach = function(client, bufnr)
    -- Disable hover in favor of other Python LSPs
    client.server_capabilities.hoverProvider = false
    
    -- Execute default on_attach
    require("core.lsp").servers.ruff_lsp.on_attach(client, bufnr)
  end,
})

-- When using multiple Python LSPs, we may need additional configuration
-- to avoid conflicts. This function can be called to sort out precedence.
local function configure_multiple_python_lsps()
  -- Check if both pyright and ruff_lsp are active in a buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      
      if not client then
        return
      end
      
      if client.name == "ruff_lsp" then
        -- When ruff_lsp is attached, find other Python LSPs
        local clients = vim.lsp.get_active_clients({ bufnr = buffer })
        for _, other_client in ipairs(clients) do
          if other_client.name == "pyright" then
            -- Prioritize diagnostics from ruff_lsp
            other_client.server_capabilities.diagnosticProvider = false
          end
        end
      end
    end,
  })
end

-- Call this to set up multi-LSP configuration
configure_multiple_python_lsps()
