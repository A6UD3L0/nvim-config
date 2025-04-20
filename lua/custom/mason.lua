-- mason.lua: Ensure all required LSPs are installed and ready
require('mason').setup {}
require('mason-lspconfig').setup {
  ensure_installed = {
    'pyright', 'clangd', 'gopls', 'sqls', 'dockerls', 'bashls'
  },
  automatic_installation = true,
}
