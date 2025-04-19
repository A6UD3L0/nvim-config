-- Centralized LSP Configuration Module
-- Provides a unified interface for LSP server setup and configuration
-- Eliminates duplicated server configuration across the codebase

local utils = require("core.utils")
local keybindings = require("core.keybindings")
local M = {}

-- Store registered servers and their configurations
M.servers = {}

-- Default capabilities with completion integration
local function get_default_capabilities()
  -- Start with vim's default capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Add completion capabilities if nvim-cmp is available
  local has_cmp, cmp_lsp = utils.has_plugin("cmp_nvim_lsp")
  if has_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
  
  -- Add folding capabilities
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }
  
  return capabilities
end

-- Default on_attach function to set up buffer-local keymappings
local function default_on_attach(client, bufnr)
  -- Apply LSP keybindings to the buffer
  keybindings.on_lsp_attach(client, bufnr)
  
  -- Set up document highlight if the client supports it
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document highlight on cursor hold",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear document highlight on cursor move",
    })
  end
  
  -- Set up formatting on save if the client supports it
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_format_on_save" })
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        -- Only format if auto_format is enabled (default: true)
        if vim.g.lsp_auto_format == nil or vim.g.lsp_auto_format == true then
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      end,
      buffer = bufnr,
      group = "lsp_format_on_save",
      desc = "Format on save",
    })
  end
  
  -- Enable inlay hints if the client and Neovim support it
  if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

-- Register a server with its configuration
function M.register_server(name, config)
  -- Store base configuration
  M.servers[name] = vim.tbl_deep_extend("force", {
    capabilities = get_default_capabilities(),
    on_attach = default_on_attach,
  }, config or {})
end

-- Configure and set up all registered servers
function M.setup_servers()
  -- Check if lspconfig is available
  local has_lspconfig, lspconfig = utils.has_plugin("lspconfig")
  if not has_lspconfig then
    vim.notify("lspconfig not found. LSP features will not be available.", vim.log.levels.WARN)
    return
  end
  
  -- Check for mason integration
  local has_mason_lspconfig, mason_lspconfig = utils.has_plugin("mason-lspconfig")
  
  -- Set up each registered server
  for server_name, server_config in pairs(M.servers) do
    lspconfig[server_name].setup(server_config)
  end
  
  -- Set up Mason automatic server installation if available
  if has_mason_lspconfig then
    local mason_servers = vim.tbl_keys(M.servers)
    mason_lspconfig.setup({
      ensure_installed = mason_servers,
      automatic_installation = true,
    })
  end
end

-- Load server configurations from language modules
function M.load_server_configs()
  -- Load common language server configurations
  require("core.lsp.servers.python")
  require("core.lsp.servers.lua")
  require("core.lsp.servers.web")
  
  -- Load additional server configurations if available
  pcall(require, "core.lsp.servers.go")
  pcall(require, "core.lsp.servers.rust")
  pcall(require, "core.lsp.servers.java")
  pcall(require, "core.lsp.servers.bash")
  pcall(require, "core.lsp.servers.c")
end

-- Initialize the LSP system
function M.setup()
  -- Load diagnostic symbols
  require("core.lsp.diagnostics").setup()
  
  -- Load server configurations
  M.load_server_configs()
  
  -- Set up configured servers
  M.setup_servers()
  
  -- Register LSP commands
  vim.api.nvim_create_user_command("LspFormat", function()
    vim.lsp.buf.format()
  end, { desc = "Format buffer with LSP" })
  
  vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
    vim.g.lsp_auto_format = not (vim.g.lsp_auto_format == true)
    vim.notify("LSP auto format: " .. (vim.g.lsp_auto_format and "enabled" or "disabled"), vim.log.levels.INFO)
  end, { desc = "Toggle LSP auto format on save" })
end

return M
