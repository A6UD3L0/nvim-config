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
    
    -- Only use sqlfluff if installed and properly configured
    sql = function(utils)
      if vim.fn.executable("sqlfluff") == 1 then
        return { "sqlfluff" }
      else
        return { "sql_formatter" }
      end
    end,
    
    -- Only use rustfmt if installed
    rust = function(utils)
      if vim.fn.executable("rustfmt") == 1 then
        return { "rustfmt" }
      else
        return {}
      end
    end,
    
    c = { "clang_format" },
    cpp = { "clang_format" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    ["*"] = { "trim_whitespace", "trim_newlines" },
  },

  -- Format on save with nice UI feedback
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
    async = true,
    quiet = false, -- Shows formatting status messages
  },
  
  -- Customize formatter options
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" }, -- 2-space indentation
    },
    black = {
      prepend_args = { "--line-length", "88" }, -- Use black's default line length
    },
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
  
  -- Customize UI/notifications
  notify_on_error = true,
}

return options
