-- null-ls.lua: Configure formatters and linters for all languages
local null_ls = require('null-ls')
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.diagnostics.hadolint,
  },
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('LspFormatting', {}),
        buffer = bufnr,
        callback = function() vim.lsp.buf.format { async = false } end,
      })
    end
  end,
}
