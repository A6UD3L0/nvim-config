-- Neovim options optimized for backend development
-- Combines ThePrimeagen's preferences with NvChad simplicity

local opt = vim.opt
local g = vim.g

-------------------------------------
-- UI Options
-------------------------------------
opt.termguicolors = true       -- True color support
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Show relative line numbers
opt.numberwidth = 2            -- Narrow number column
opt.cursorline = true          -- Highlight current line
opt.showmode = false           -- Don't show mode since statusline shows it
opt.signcolumn = "yes"         -- Always show the sign column
opt.laststatus = 3             -- Global statusline
opt.showtabline = 2            -- Always show tabline
opt.cmdheight = 1              -- Command line height
opt.pumheight = 10             -- Pop up menu height
opt.showcmd = true             -- Show command in status line
opt.title = true               -- Set window title
opt.guifont = "MonoLisa:h14"   -- Set GUI font
opt.conceallevel = 0           -- Don't hide markdown syntax

-------------------------------------
-- Behavior
-------------------------------------
opt.mouse = "a"                -- Enable mouse support
opt.clipboard = "unnamedplus"  -- Sync with system clipboard
opt.undofile = true            -- Persistent undo history
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.swapfile = false           -- No swap file
opt.backup = false             -- No backup file
opt.updatetime = 100           -- Faster completions
opt.timeoutlen = 300           -- Faster key sequence completion
opt.ttimeoutlen = 10           -- Faster key sequence timeout
opt.hidden = true              -- Enable background buffers

-------------------------------------
-- Editing
-------------------------------------
opt.expandtab = true           -- Use spaces instead of tabs
opt.shiftwidth = 2             -- Size of an indent
opt.tabstop = 2                -- Number of spaces tabs count for
opt.softtabstop = 2            -- Number of spaces for a tab
opt.smartindent = true         -- Insert indents automatically
opt.wrap = false               -- No line wrapping
opt.linebreak = true           -- Break lines at word boundaries
opt.breakindent = true         -- Indent wrapped lines
opt.scrolloff = 8              -- Lines of context
opt.sidescrolloff = 8          -- Columns of context

-------------------------------------
-- Search
-------------------------------------
opt.ignorecase = true          -- Ignore case in search patterns
opt.smartcase = true           -- Override ignorecase if search contains capitals
opt.incsearch = true           -- Incremental search
opt.hlsearch = true            -- Highlight search results

-------------------------------------
-- Performance
-------------------------------------
opt.lazyredraw = true          -- Faster scrolling
opt.synmaxcol = 240            -- Max column for syntax highlight
opt.history = 500              -- Remember more commands and search history

-------------------------------------
-- Window Splitting
-------------------------------------
opt.splitbelow = true          -- Split below
opt.splitright = true          -- Split right

-------------------------------------
-- Backend-specific settings
-------------------------------------
local backend_ft = { "python", "go", "c", "sql", "dockerfile", "yaml", "json" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = backend_ft,
  callback = function()
    -- Enable more strict indentation for backend languages
    local ft = vim.bo.filetype
    if ft == "python" then
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.textwidth = 88  -- Black formatter width
    elseif ft == "go" then
      vim.opt_local.expandtab = false  -- Go uses tabs
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
    elseif ft == "c" then
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
    end
  end,
})

-- File specific settings for Docker/YAML
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"yaml", "dockerfile"},
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- SQL-specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.textwidth = 120
  end,
})
