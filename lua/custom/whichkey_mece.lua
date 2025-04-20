-- MECE-structured WhichKey registration for all major plugins and actions
-- Mutually Exclusive, Collectively Exhaustive keymap groups

local wk = require('which-key')

wk.register({
  -- 🐍 Python/Project
  P = {
    name = 'Python/Project',
    v = { ':UvPython ', 'Set Python Version' },
    i = { ':UvInit ', 'Init Project' },
    a = { ':UvAdd ', 'Add Dependency' },
    r = { ':UvRun ', 'Run Command' },
    l = { ':UvLock<CR>', 'Lock Dependencies' },
    s = { ':UvSync<CR>', 'Sync Project' },
    p = { ':UvPin ', 'Pin Python' },
  },
  -- 📂 Files/Explorer
  e = {
    name = 'Explorer',
    e = { ':NvimTreeToggle<CR>', 'Toggle File Explorer' },
    f = { ':NvimTreeFocus<CR>', 'Focus File Explorer' },
  },
  -- 🔍 Search/Fuzzy Finder
  s = {
    name = 'Search',
    f = { ":Telescope find_files<CR>", 'Find Files' },
    g = { ":Telescope live_grep<CR>", 'Grep' },
    b = { ":Telescope buffers<CR>", 'Buffers' },
    h = { ":Telescope help_tags<CR>", 'Help Tags' },
    k = { ":Telescope keymaps<CR>", 'Keymaps' },
    r = { ":Telescope oldfiles<CR>", 'Recent Files' },
  },
  -- 🗂 Buffers/Windows
  b = {
    name = 'Buffers',
    n = { ':enew<CR>', 'New Buffer' },
    x = { ':Bdelete!<CR>', 'Close Buffer' },
    l = { ':ls<CR>', 'List Buffers' },
    p = { ':bprevious<CR>', 'Prev Buffer' },
    N = { ':bnext<CR>', 'Next Buffer' },
  },
  -- 🕒 Undo/History
  u = {
    name = 'Undo',
    u = { ':UndotreeToggle<CR>', 'Toggle UndoTree' },
  },
  -- 🔖 Bookmarks/Harpoon
  h = {
    name = 'Harpoon',
    a = { function() require('harpoon.mark').add_file() end, 'Add File' },
    m = { function() require('harpoon.ui').toggle_quick_menu() end, 'Menu' },
    n = { function() require('harpoon.ui').nav_next() end, 'Next' },
    p = { function() require('harpoon.ui').nav_prev() end, 'Prev' },
    ['1'] = { function() require('harpoon.ui').nav_file(1) end, 'File 1' },
    ['2'] = { function() require('harpoon.ui').nav_file(2) end, 'File 2' },
    ['3'] = { function() require('harpoon.ui').nav_file(3) end, 'File 3' },
    ['4'] = { function() require('harpoon.ui').nav_file(4) end, 'File 4' },
  },
  -- 🔧 LSP/Code
  l = {
    name = 'LSP',
    r = { ':LspRestart<CR>', 'Restart LSP' },
    k = { ':lua vim.lsp.buf.hover()<CR>', 'Hover' },
    d = { ':lua vim.lsp.buf.definition()<CR>', 'Goto Definition' },
    R = { ':lua vim.lsp.buf.rename()<CR>', 'Rename' },
    a = { ':lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
    f = { ':lua vim.lsp.buf.format()<CR>', 'Format' },
    e = { ':lua vim.diagnostic.open_float()<CR>', 'Show Diagnostics' },
    n = { ':lua vim.diagnostic.goto_next()<CR>', 'Next Diagnostic' },
    p = { ':lua vim.diagnostic.goto_prev()<CR>', 'Prev Diagnostic' },
  },
  -- ⬇️ Folds
  f = {
    name = 'Folds',
    o = { 'zR', 'Open All Folds' },
    c = { 'zM', 'Close All Folds' },
    n = { 'zo', 'Open Fold' },
    m = { 'zc', 'Close Fold' },
  },
  -- 🗑️ Misc/Utilities
  x = {
    name = 'Misc',
    s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Substitute Word' },
    c = { function() require('cellular-automaton').start_animation('make_it_rain') end, 'Cellular Automaton' },
    S = { function() vim.cmd('so') end, 'Source File' },
  },
}, { prefix = '<leader>' })

wk.setup({
  window = {
    border = 'rounded',
    margin = { 1, 2, 1, 2 },
    padding = { 2, 2, 2, 2 },
    position = 'center',
  },
  layout = {
    height = { min = 8, max = 25 },
    width = { min = 30, max = 60 },
    spacing = 6,
    align = 'center',
  },
  icons = {
    group = ' ',
  },
})
