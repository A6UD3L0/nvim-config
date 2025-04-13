-- Essential autocommands for optimal backend development experience

local api = vim.api
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- Clear previous autocommands
local clear_augroup = function(name)
  local id = augroup(name, {})
  api.nvim_clear_autocmds({ group = id })
  return id
end

-- File operation autocommands
local file_operations = clear_augroup("FileOperations")

-- Highlight yanked text
autocmd("TextYankPost", {
  group = file_operations,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Resize windows when terminal resized
autocmd("VimResized", {
  group = file_operations,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  group = file_operations,
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Custom filetype settings
local filetype_settings = clear_augroup("FiletypeSettings")

-- Treat .jq files as jq
autocmd({ "BufRead", "BufNewFile" }, {
  group = filetype_settings,
  pattern = "*.jq",
  callback = function()
    vim.bo.filetype = "jq"
  end,
})

-- Backend-specific settings
local backend_settings = clear_augroup("BackendSettings")

-- Python settings
autocmd("FileType", {
  group = backend_settings,
  pattern = "python",
  callback = function()
    -- Set PEP8 indentation
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
    
    -- Python path for debugging and running code
    vim.g.python3_host_prog = vim.fn.exepath("python3")
  end
})

-- Go settings
autocmd("FileType", {
  group = backend_settings,
  pattern = "go",
  callback = function()
    -- Use tabs for Go (gofmt standard)
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
  end
})

-- Terminal settings
local terminal_settings = clear_augroup("TerminalSettings")

-- Enter insert mode when opening terminal
autocmd("TermOpen", {
  group = terminal_settings,
  callback = function()
    vim.cmd("startinsert")
    vim.wo.relativenumber = false
    vim.wo.number = false
  end,
})

-- Create buffer local mappings for terminal
autocmd("TermOpen", {
  group = terminal_settings,
  callback = function()
    local opts = { noremap = true, silent = true, buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
})

-- File change detection
local file_changes = clear_augroup("FileChanges")

-- Check if file has changed when Neovim is focused
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = file_changes,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

-- Show notification of external file changes
autocmd("FileChangedShellPost", {
  group = file_changes,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- LSP configuration
local lsp_autocommands = clear_augroup("LspAutocommands")

-- Format on save for certain filetypes
autocmd("BufWritePre", {
  group = lsp_autocommands,
  pattern = { "*.go", "*.py", "*.lua" },
  callback = function()
    -- Use conform.nvim if available
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({ bufnr = 0 })
    -- Otherwise fallback to LSP formatting
    else
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- Automatically show docs on cursor hold
autocmd("CursorHold", {
  group = lsp_autocommands,
  pattern = "*",
  callback = function()
    -- Use LSP hover if the filetype has an active LSP client
    if vim.lsp.buf.server_ready() then
      -- Use lspsaga if available for prettier hover
      local ok_saga, _ = pcall(require, "lspsaga.hover")
      if ok_saga then
        vim.cmd("Lspsaga hover_doc")
      else
        vim.lsp.buf.hover()
      end
    end
  end,
})
