-- mason.lua: Ensure all required LSPs are installed and ready, with safe loading
do
  local ok, mason = pcall(require, 'mason')
  if not ok then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'mason'. LSP installer will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  mason.setup {}
  local ok_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
  if not ok_lsp then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'mason-lspconfig'. LSP installer will be incomplete.", vim.log.levels.WARN)
    end)
    return
  end
  mason_lspconfig.setup {
    ensure_installed = {
      'pyright', 'clangd', 'gopls', 'sqls', 'dockerls', 'bashls'
    },
    automatic_installation = true,
  }
end
