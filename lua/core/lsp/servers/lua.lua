-- Lua LSP Configuration Module
-- Centralizes Lua language server setup
-- Optimized for Neovim Lua development

local lsp = require("core.lsp")

-- Get Neovim's runtime path and library path for Lua LSP
local function get_neovim_lua_libraries()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")
  
  -- Get library path for proper completion
  local library = {}
  
  -- Add Neovim runtime path for API completion
  library[vim.fn.expand("$VIMRUNTIME/lua")] = true
  library[vim.fn.stdpath("config") .. "/lua"] = true
  
  -- Add any plugins you want to have proper completion for
  local plugin_paths = vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/*", true, true)
  for _, plugin_path in ipairs(plugin_paths) do
    if vim.fn.isdirectory(plugin_path .. "/lua") == 1 then
      library[plugin_path .. "/lua"] = true
    end
  end
  
  return runtime_path, library
end

local runtime_path, library = get_neovim_lua_libraries()

-- Lua Language Server configuration
lsp.register_server("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",          -- Neovim's global API
          "assert",       -- Lua assertions
          "describe",     -- Busted testing
          "it",           -- Busted testing
          "before_each",  -- Busted testing
          "after_each",   -- Busted testing
          "teardown",     -- Busted testing
          "pending",      -- Busted testing
          "use",          -- Packer use
        },
        -- Configure diagnostics severity
        disable = {
          "trailing-space", -- Handled by other tools
          "unused-local",   -- Sometimes we define locals for clarity
        },
        -- Enable all Lua diagnostics
        enable = true,
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = library,
        -- Don't check third-party libraries from workspace
        checkThirdParty = false,
        -- Maximum files to analyze
        maxPreload = 5000,
        preloadFileSize = 10000,
      },
      -- Configure telemetry
      telemetry = {
        enable = false,
      },
      -- Configure completion
      completion = {
        callSnippet = "Replace",
        keywordSnippet = "Replace",
        displayContext = 5, -- Lines of context for completion items
      },
      -- Configure inlay hints
      hint = {
        enable = true,
        setType = true,
        paramType = true,
        paramName = "Literal",
        semicolon = "Disable",
        arrayIndex = "Enable",
      },
      -- Configure code formatting
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "single", -- 'single' or 'double'
          max_line_length = "120",
          trailing_table_separator = "smart", -- "smart" or "always" or "never"
          call_arg_parentheses = "keep", -- "keep" or "remove"
        }
      },
    },
  },
})
