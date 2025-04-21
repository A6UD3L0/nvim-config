-- nvim-lspconfig configuration, with safe loading
do
  local ok, lspconfig = pcall(require, 'lspconfig')
  if not ok then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'lspconfig'. LSP configuration will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  local on_attach = function(client, bufnr)
    local buf_map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    buf_map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
    buf_map('n', 'K', vim.lsp.buf.hover, 'Hover')
    buf_map('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
    buf_map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
  end

  -- Use 'ruff' via none-ls/null-ls, not ruff-lsp
  -- Remove ruff_lsp from LSP servers
  local servers = { 'pyright', 'clangd', 'gopls', 'sqlls', 'dockerls', 'bashls' }
  for _, server in ipairs(servers) do
    lspconfig[server].setup {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
    }
  end

  vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  }
end
