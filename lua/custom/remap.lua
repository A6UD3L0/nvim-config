-- remap.lua: Only for non-<leader> direct key mappings. All <leader> mappings are in whichkey_mece.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
local opts = { noremap = true, silent = true }

-- Ensure <Space> triggers which-key popup
vim.keymap.set('n', '<Space>', function()
  local ok, wk = pcall(require, 'which-key')
  if ok then
    wk.show('')
  end
end, { desc = 'Show which-key' })

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

-- Neo-tree: Open with <backslash> (\\) in normal mode
vim.keymap.set('n', '\\', ':Neotree toggle<CR>', { desc = 'Toggle File Explorer (Neo-tree)' })

-- ToggleTerm: <leader>tt opens terminal, <leader>tg opens lazygit in terminal
vim.keymap.set('n', '<leader>tt', function() require('toggleterm').toggle() end, { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>tg', function()
  require('toggleterm.terminal').Terminal:new({
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    close_on_exit = true,
  }):toggle()
end, { desc = 'Lazygit (in terminal)' })

-- Optional: <C-Space> for terminal autocompletion (if using nvim-cmp or similar)
-- For shell completion, ensure your shell (bash/zsh/fish) is configured for completion inside terminal.

-- (All <leader> mappings, Go snippets, and UV commands have been moved to whichkey_mece.lua)
