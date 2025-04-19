-- LSP Diagnostics Configuration Module
-- Sets up consistent diagnostic display and symbols
-- Centralizes diagnostic settings to avoid duplication

local M = {}

function M.setup()
  -- Define diagnostic signs with icons
  local signs = {
    { name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignHint", text = "", texthl = "DiagnosticSignHint" },
    { name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo" },
  }

  -- Set diagnostic signs
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, {
      text = sign.text,
      texthl = sign.texthl,
      numhl = sign.name .. "Nr",
      linehl = sign.name .. "Line",
    })
  end

  -- Configure diagnostic display
  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = "●", -- Use a dot as prefix for virtual text
      source = "if_many",
    },
    signs = true,
    update_in_insert = false, -- Don't update diagnostics in insert mode
    severity_sort = true,     -- Sort by severity
    float = {
      focusable = true,
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
      width = 60,
      focusable = true,
    }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      focusable = false,
      relative = "cursor",
    }
  )
  
  -- Auto show diagnostic popup on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
    group = vim.api.nvim_create_augroup("diagnostic_popup", { clear = true }),
  })
end

return M
