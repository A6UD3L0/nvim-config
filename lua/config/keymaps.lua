-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Better window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

-- Navigate buffers
map('n', '<S-l>', ':bnext<CR>')
map('n', '<S-h>', ':bprevious<CR>')
map('n', '<leader>q', ':Bdelete<CR>', { desc = 'Close buffer' })

-- Clear search highlights
map('n', '<Esc>', ':noh<CR><Esc>', { desc = 'Clear search highlights' })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move selected line / block of text in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Better tabbing
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Terminal mappings
map('t', '<Esc>', '<C-\><C-n>', { desc = 'Exit terminal mode' })

-- LSP and completion
map('n', 'gd', function() vim.lsp.buf.definition() end, { desc = 'Go to definition' })
map('n', 'gD', function() vim.lsp.buf.declaration() end, { desc = 'Go to declaration' })
map('n', 'gr', function() vim.lsp.buf.references() end, { desc = 'Show references' })
map('n', 'gI', function() vim.lsp.buf.implementation() end, { desc = 'Go to implementation' })
map('n', 'K', function() vim.lsp.buf.hover() end, { desc = 'Show documentation' })
map('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { desc = 'Code action' })
map('n', '<leader>rn', function() vim.lsp.buf.rename() end, { desc = 'Rename symbol' })
map('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, { desc = 'Format buffer' })

-- Telescope
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live grep' })
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Find buffers' })
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Help tags' })

-- Toggle diagnostics
map('n', '<leader>td', function()
  local config = vim.diagnostic.config
  local current = config().virtual_text
  config { virtual_text = not current }
end, { desc = 'Toggle diagnostics' })

-- Auto pairs
map('i', '<C-h>', '<C-w>', { desc = 'Delete previous word' })

-- Terminal
map('n', '<leader>tt', ':ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('t', '<C-t>', '<C-\><C-n>:ToggleTerm<CR>', { desc = 'Toggle terminal' })
