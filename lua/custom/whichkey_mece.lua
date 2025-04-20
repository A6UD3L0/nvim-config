-- MECE-structured WhichKey registration for all major plugins and actions
-- Mutually Exclusive, Collectively Exhaustive keymap groups

local wk = require('which-key')

wk.register({
  -- Project/Package Management (Python/UV)
  p = {
    name = 'Project/Package',
    i = { ':UvInit ', 'UV Init Project' },
    a = { ':UvAdd ', 'UV Add Dependency' },
    r = { ':UvRun ', 'UV Run Command' },
    l = { ':UvLock<CR>', 'UV Lock' },
    s = { ':UvSync<CR>', 'UV Sync' },
    p = { ':UvPython ', 'UV Python Version' },
    v = { ':UvPin ', 'UV Pin Python' },
  },
  -- Tooling (Python tools, formatters, linters)
  t = {
    name = 'Tooling',
    i = { ':UvToolInstall ', 'Install Tool' },
    x = { ':Uvx ', 'Run Tool (uvx)' },
    f = { '<Plug>PlenaryTestFile', 'Plenary Test File' },
  },
  -- File/Buffer/Window
  b = { '<cmd>enew<CR>', 'New Buffer' },
  x = { ':Bdelete!<CR>', 'Close Buffer' },
  v = { '<C-w>v', 'Vertical Split' },
  h = { '<C-w>s', 'Horizontal Split' },
  se = { '<C-w>=', 'Equalize Splits' },
  xs = { ':close<CR>', 'Close Split' },
  to = { ':tabnew<CR>', 'New Tab' },
  tx = { ':tabclose<CR>', 'Close Tab' },
  tn = { ':tabn<CR>', 'Next Tab' },
  tp = { ':tabp<CR>', 'Prev Tab' },
  -- Clipboard/Yank/Delete
  y = { [[$'+y]], 'Yank to Clipboard' },
  Y = { [[$'+Y]], 'Yank Line to Clipboard' },
  d = { '"_d', 'Delete (no yank)' },
  -- Undo/Redo
  u = { ':UndotreeToggle<CR>', 'Toggle UndoTree' },
  -- LSP/Diagnostics
  zig = { '<cmd>LspRestart<cr>', 'Restart LSP' },
  k = { '<cmd>lnext<CR>zz', 'Next Location List' },
  j = { '<cmd>lprev<CR>zz', 'Prev Location List' },
  -- Miscellaneous
  ca = { function() require('cellular-automaton').start_animation('make_it_rain') end, 'Cellular Automaton' },
  s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Substitute Word' },
  ['<leader>'] = { function() vim.cmd('so') end, 'Source File' },
}, { prefix = '<leader>' })

-- Optionally: register normal mode, visual mode, etc. separately for MECE clarity
