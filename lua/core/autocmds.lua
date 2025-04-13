-- Autocommands for better editor behavior
-- Optimized for backend development workflow

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight text on yank for better UX
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Format options
autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "a" -- Don't autoformat
      - "t" -- Don't auto wrap text
      + "c" -- Auto wrap comments
      + "q" -- Allow formatting of comments with gq
      - "o" -- Don't continue comments with o and O
      + "r" -- Continue comments after return
      + "n" -- Recognize numbered lists
      + "j" -- Remove comment leader when joining lines when possible
      - "2" -- Don't use indent of second line for rest of paragraph
  end,
})

-- Filetype-specific indentation
autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "typescriptreact", "javascriptreact", "json", "yaml", "html", "css" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Automatically enable formatting for code files
autocmd("FileType", {
  pattern = { "lua", "python", "javascript", "typescript", "go" },
  callback = function()
    vim.b.autoformat = true
  end,
})

-- Disable autoformatting for certain files
autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Auto-create directories when saving a file
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if not vim.uv.fs_stat(dir) then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Terminal-specific settings
autocmd("TermOpen", {
  group = augroup("TerminalOptions", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- Auto-close certain filetypes with 'q'
autocmd("FileType", {
  pattern = {
    "qf", "help", "man", "lspinfo", "checkhealth", "spectre_panel", "copilot",
    "lir", "DressingSelect", "tsplayground", "notify", "fugitive",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
