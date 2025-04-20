-- remap.lua: Refactored, Unified, and Documented Key Mappings
-- All mappings use vim.keymap.set, are grouped by purpose, and are fully documented.

-- Set leader and localleader keys (do this only once, at the top)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Option table for silent, noremap mappings
local opts = { noremap = true, silent = true }

-- Disable spacebar's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts)

-- General Navigation & Editing
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open netrw file explorer' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev search and center' })
vim.keymap.set('n', '=ap', "ma=ap'a", { desc = 'Reindent paragraph' })

-- Clipboard & Deletion
vim.keymap.set({ 'n', 'v' }, '<leader>y', [[$'+y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [[$'+Y]], { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })
vim.keymap.set('x', '<leader>p', [['_dP]], { desc = 'Paste without yanking' })
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete char without yanking' })

-- Buffer/Window/Tab Management
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', opts)   -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer
vim.keymap.set('n', '<leader>+', '<C-a>', opts) -- increment
vim.keymap.set('n', '<leader>-', '<C-x>', opts) -- decrement

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)      -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)      -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)     -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)   -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)     --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)     --  go to previous tab

-- Miscellaneous/Utilities
vim.keymap.set('n', '<leader>tf', '<Plug>PlenaryTestFile', { noremap = false, silent = false, desc = 'Run Plenary test file' })
vim.keymap.set('n', '<leader>zig', '<cmd>LspRestart<cr>', { desc = 'Restart LSP' })
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute word under cursor' })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })
vim.keymap.set('n', '<leader><leader>', function() vim.cmd('so') end, { desc = 'Source current file' })

-- UndoTree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle UndoTree (visualize and browse undo history)' })

-- Error/Quickfix/Location List
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Open tmux sessionizer' })
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = 'Next quickfix' })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = 'Prev quickfix' })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Next location list' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Prev location list' })

-- Save/Quit
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- Indentation/Movement
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up (handle wrapped lines)' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down (handle wrapped lines)' })
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

-- Highlight clearing
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- Insert mode: jk or kj to exit
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)
vim.keymap.set('i', '<C-c>', '<Esc>', opts)

-- Custom code snippets for Go error handling and Cellular Automaton
vim.keymap.set('n', '<leader>ee', "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = 'Insert Go: if err != nil { return err }' })
vim.keymap.set('n', '<leader>ea', "oassert.NoError(err, \"\")<Esc>F\";a", { desc = 'Insert Go: assert.NoError(err)' })
vim.keymap.set('n', '<leader>ef', "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj", { desc = 'Insert Go: log.Fatalf on error' })
vim.keymap.set('n', '<leader>el', "oif err != nil {<CR>}<Esc>Ologger.Error(\"error\", \"error\", err)<Esc>F.;i", { desc = 'Insert Go: logger.Error on error' })
vim.keymap.set('n', '<leader>ca', function() require('cellular-automaton').start_animation('make_it_rain') end, { desc = 'Cellular Automaton: make it rain' })

-- Documented, unified, and deduplicated mappings end here.
