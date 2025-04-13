local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "gofumpt", "goimports" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    sql = { "sqlfluff" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    rust = { "rustfmt" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    ["*"] = { "trim_whitespace", "trim_newlines" },
  },

  format_on_save = {
    -- Format on save is enabled
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
