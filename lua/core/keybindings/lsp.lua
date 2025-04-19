-- LSP Keybindings Module
-- Provides consistent mappings for language server protocol functionality
-- Designed to be applied when LSP attaches to a buffer

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

-- Standard LSP mappings to be applied to buffers with LSP attached
function M.setup()
  -- Register LSP groups with which-key
  keybindings.register_group("<leader>l", "LSP", "", "#2AC3DE") -- LSP (cyan)
  keybindings.register_group("<leader>lw", "LSP Workspace", "", "#2AC3DE") -- LSP Workspace (cyan)
  keybindings.register_group("<leader>lf", "LSP Format", "", "#2AC3DE") -- LSP Format (cyan)
  keybindings.register_group("<leader>ld", "LSP Definition", "", "#2AC3DE") -- LSP Definition (cyan)
end

-- Apply LSP keybindings to a specific buffer
-- These mappings will be applied when an LSP attaches to a buffer
function M.apply_buffer_mappings(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Create local function for setting buffer-local keymaps
  local function buf_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map(mode, lhs, rhs, opts)
  end

  -- LSP actions
  buf_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  buf_map("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
  buf_map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  buf_map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
  buf_map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  buf_map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
  buf_map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
  
  -- Diagnostics
  buf_map("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  buf_map("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  buf_map("n", "<leader>ll", vim.diagnostic.open_float, { desc = "Line diagnostics" })
  buf_map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set location list" })
  
  -- Workspace
  buf_map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
  buf_map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
  buf_map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List workspace folders" })
  
  -- Definitions and type definitions
  buf_map("n", "<leader>ldt", vim.lsp.buf.type_definition, { desc = "Type definition" })
  
  -- Document formatting
  if client.supports_method("textDocument/formatting") then
    buf_map("n", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end, { desc = "Format document" })
  end
  
  -- Range formatting
  if client.supports_method("textDocument/rangeFormatting") then
    buf_map("v", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end, { desc = "Format selection" })
  end
  
  -- Advanced LSP navigation with Telescope if available
  local has_telescope, _ = utils.has_plugin("telescope.builtin")
  if has_telescope then
    local telescope = require("telescope.builtin")
    
    buf_map("n", "<leader>lfd", telescope.lsp_definitions, { desc = "Telescope definitions" })
    buf_map("n", "<leader>lfi", telescope.lsp_implementations, { desc = "Telescope implementations" })
    buf_map("n", "<leader>lfr", telescope.lsp_references, { desc = "Telescope references" })
    buf_map("n", "<leader>lfs", telescope.lsp_document_symbols, { desc = "Telescope document symbols" })
    buf_map("n", "<leader>lws", telescope.lsp_workspace_symbols, { desc = "Telescope workspace symbols" })
    buf_map("n", "<leader>lwd", telescope.diagnostics, { desc = "Telescope diagnostics" })
  end
  
  -- Inlay hints (Neovim 0.10+)
  if vim.lsp.inlay_hint and client.supports_method("textDocument/inlayHint") then
    buf_map("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, { desc = "Toggle inlay hints" })
  end
  
  -- Apply any which-key mappings to this buffer
  local has_which_key, which_key = utils.has_plugin("which-key")
  if has_which_key then
    which_key.register({
      ["<leader>l"] = { name = " LSP" },
      ["<leader>lw"] = { name = " Workspace" },
      ["<leader>lf"] = { name = " Find/Format" },
      ["<leader>ld"] = { name = " Definition" },
    }, { buffer = bufnr })
  end
end

-- Setup diagnostic signs and highlights
function M.setup_diagnostics()
  -- Define diagnostic signs
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- Configure diagnostics display
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Configure hover and signature help windows
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded",
    }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
    }
  )
end

return M
