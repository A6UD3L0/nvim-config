-- null-ls.lua: Configure formatters and linters for all languages, with safe loading
do
  local ok, null_ls = pcall(require, 'null-ls')
  if not ok then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'null-ls'. Formatting and linting will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
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
end
