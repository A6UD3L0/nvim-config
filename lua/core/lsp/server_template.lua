-- LSP Server Configuration Template Module
-- Provides standardized templates for common server configurations
-- Reduces redundancy and ensures consistent options across servers

local M = {}

-- Base template with shared configuration options
M.base_template = {
  capabilities = nil, -- Will be set by core/lsp/init.lua
  on_attach = nil,    -- Will be set by core/lsp/init.lua
  flags = {
    debounce_text_changes = 150,
  },
}

-- Template for language servers with root_dir detection
M.standard_template = vim.tbl_deep_extend("force", M.base_template, {
  root_dir = function(fname)
    -- Try to find the project root
    local util = require("lspconfig.util")
    return util.root_pattern(".git", "package.json", "Cargo.toml", "pyproject.toml")(fname) or
           util.root_pattern(".gitignore", "Makefile", "setup.py")(fname) or
           util.find_git_ancestor(fname) or
           util.path.dirname(fname)
  end,
})

-- Template for language servers with support for configuration via config files
M.file_config_template = vim.tbl_deep_extend("force", M.standard_template, {
  -- Default settings that respect config files
  settings = {
    -- Will be overridden with language-specific settings
  },
})

-- Template for Python language servers
M.python_template = vim.tbl_deep_extend("force", M.standard_template, {
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "poetry.lock", "Pipfile")(fname) or
           util.find_git_ancestor(fname) or
           util.path.dirname(fname)
  end,
  before_init = function(_, config)
    -- Check for virtual environments
    if vim.env.VIRTUAL_ENV then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        python = {
          pythonPath = vim.env.VIRTUAL_ENV .. (vim.fn.has("win32") == 1 and "\\Scripts\\python.exe" or "/bin/python"),
        }
      })
    end
  end,
  -- Common Python server settings
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- Template for web development servers
M.web_template = vim.tbl_deep_extend("force", M.standard_template, {
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".eslintrc", ".prettierrc")(fname) or
           util.find_git_ancestor(fname) or
           util.path.dirname(fname)
  end,
  -- Common web server settings
  settings = {
    -- Placeholder for format options, linting, etc.
  },
})

-- Template for Lua language servers
M.lua_template = vim.tbl_deep_extend("force", M.standard_template, {
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "init.lua")(fname) or
           util.find_git_ancestor(fname) or
           util.path.dirname(fname)
  end,
  -- Common lua server settings
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
    },
  },
})

-- Create a new server configuration from a template
-- @param template table The template to use as base
-- @param overrides table Settings that override the template
-- @return table The merged configuration
function M.create_config(template, overrides)
  return vim.tbl_deep_extend("force", template, overrides or {})
end

return M
