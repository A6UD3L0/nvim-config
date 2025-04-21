-- remap.lua: Only for non-<leader> direct key mappings. All <leader> mappings are in whichkey_mece.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts)

-- General navigation, editing, and window management (non-leader)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev search and center' })
vim.keymap.set('n', '=ap', "ma=ap'a", { desc = 'Reindent paragraph' })

vim.keymap.set('n', 'x', '"_x', { desc = 'Delete char without yanking' })

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up (handle wrapped lines)' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down (handle wrapped lines)' })
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- (All <leader> mappings, Go snippets, and UV commands have been moved to whichkey_mece.lua)
