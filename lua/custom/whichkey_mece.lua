-- whichkey_mece.lua: Unified, MECE, and conflict-free <leader> menu for Neovim
-- All mappings are grouped under non-overlapping, mnemonic prefixes.
-- Uses which-key with enhanced UX (rounded borders, left alignment, spacing).
-- DRY: register_group helper. Each mapping has a clear label.
-- Any major reassignments or removals are explained inline.

local wk = require("which-key")

wk.setup({
  window = {
    border = "rounded",
    margin = { 1, 2, 1, 2 },
    padding = { 2, 2, 2, 2 },
    position = "center",
  },
  layout = {
    height = { min = 8, max = 25 },
    width = { min = 36, max = 60 },
    spacing = 6,
    align = "left",
  },
  icons = {
    group = " ",
  },
})

-- DRY helper for MECE group registration
local function register_group(prefix, name, mappings)
  wk.register({ [prefix] = vim.tbl_extend('force', { name = name }, mappings) }, { prefix = '<leader>' })
end

-- File & Search
register_group('f', ' File & Search', {
  f = { ":Telescope find_files<CR>", "Find Files" },
  g = { ":Telescope live_grep<CR>", "Live Grep" },
  b = { ":Telescope buffers<CR>", "Buffers" },
  h = { ":Telescope help_tags<CR>", "Help Tags" },
  e = { ":NvimTreeToggle<CR>", "File Explorer" },
  r = { ":Telescope oldfiles<CR>", "Recent Files" },
  k = { ":Telescope keymaps<CR>", "Keymaps" },
  E = { ":Ex<CR>", "netrw Explorer" },
})

-- Git
register_group('g', ' Git', {
  s = { ":LazyGit<CR>", "Status (LazyGit)" },
  c = { ":Git commit<CR>", "Commit" },
  p = { ":Git push<CR>", "Push" },
  l = { ":Git pull<CR>", "Pull" },
  b = { ":Git blame<CR>", "Blame" },
  d = { ":Gitsigns diffthis<CR>", "Diff" },
  S = { ":Gitsigns stage_buffer<CR>", "Stage Buffer" },
  h = { name = "Hunk", s = { ":Gitsigns stage_hunk<CR>", "Stage Hunk" }, r = { ":Gitsigns reset_hunk<CR>", "Reset Hunk" }, u = { ":Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" }, p = { ":Gitsigns preview_hunk<CR>", "Preview Hunk" } },
})

-- LSP
register_group('l', ' LSP', {
  d = { ":lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
  h = { ":lua vim.lsp.buf.hover()<CR>", "Hover Doc" },
  r = { ":LspRestart<CR>", "Restart LSP" },
  R = { ":lua vim.lsp.buf.rename()<CR>", "Rename" },
  a = { ":lua vim.lsp.buf.code_action()<CR>", "Code Action" },
  f = { ":lua vim.lsp.buf.format()<CR>", "Format" },
  e = { ":lua vim.diagnostic.open_float()<CR>", "Diagnostics" },
  n = { ":lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
  p = { ":lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic" },
  k = { ":lnext<CR>", "Next Location List" },
  j = { ":lprev<CR>", "Prev Location List" },
})

-- REPL/Run
register_group('r', ' REPL/Run', {
  s = { '<cmd>IronRepl<CR>', 'Start REPL' },
  l = { '<cmd>IronSendLine<CR>', 'Send Line' },
  f = { '<cmd>IronSendFile<CR>', 'Send File' },
  o = { '<cmd>IronFocus<CR>', 'Focus REPL' },
  q = { '<cmd>IronHide<CR>', 'Quit REPL' },
  c = { '<cmd>IronClear<CR>', 'Clear REPL' },
})

-- Test
register_group('t', ' Test', {
  n = { function() require('neotest').run.run() end, 'Nearest Test' },
  f = { function() require('neotest').run.run(vim.fn.expand('%')) end, 'Test File' },
  a = { function() require('neotest').run.run({ suite = true }) end, 'Run All' },
  o = { function() require('neotest').output_panel.toggle() end, 'Toggle Output' },
  S = { function() require('neotest').summary.toggle() end, 'Toggle Summary' },
})

-- Debug (all debug actions under 'd', Docker moved to 'D' to avoid overlap)
register_group('d', ' Debug', {
  b = { function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint' },
  c = { function() require('dap').continue() end, 'Continue' },
  i = { function() require('dap').step_into() end, 'Step Into' },
  o = { function() require('dap').step_over() end, 'Step Over' },
  O = { function() require('dap').step_out() end, 'Step Out' },
  r = { function() require('dap').repl.open() end, 'Open REPL' },
  u = { function() require('dapui').toggle() end, 'Toggle DAP UI' },
  t = { function() require('dap').terminate() end, 'Terminate Session' },
})

-- Docker (moved to 'D' to keep Debug and Docker MECE)
register_group('D', '🐳 Docker', {
  o = { ":DockerContainers<CR>", "List Containers" },
  b = { ":TermExec cmd='docker compose build' direction=horizontal<CR>", "Compose Build" },
  l = { ":TermExec cmd='docker logs -f <container>' direction=horizontal<CR>", "Tail Logs" },
  d = { ":TermExec cmd='docker compose down' direction=horizontal<CR>", "Compose Down" },
})

-- SQL/DB
register_group('s', '💾 SQL/DB', {
  u = { ':DBUI<CR>', 'Toggle DB UI' },
  q = { ':DB<CR>', 'Scratch SQL Buffer' },
  r = { ':DBExec<CR>', 'Run Buffer/Selection' },
})

-- Python/uv
register_group('v', ' Python/uv', {
  i = { ':UvInit ', 'uv init' },
  a = { ':UvAdd ', 'uv add <pkg>' },
  s = { ':UvSync<CR>', 'uv sync' },
  l = { ':UvLock<CR>', 'uv lock' },
  r = { ':UvRun %<CR>', 'uv run current file' },
  p = { ':UvPin ', 'uv pin' },
  t = { ':UvToolInstall ', 'uv tool install' },
  x = { ':Uvx ', 'uvx' },
})

-- Harpoon
register_group('h', ' Harpoon', {
  a = { function() require("harpoon.mark").add_file() end, "Add File" },
  m = { function() require("harpoon.ui").toggle_quick_menu() end, "Menu" },
  n = { function() require("harpoon.ui").nav_next() end, "Next" },
  p = { function() require("harpoon.ui").nav_prev() end, "Prev" },
  ["1"] = { function() require("harpoon.ui").nav_file(1) end, "File 1" },
  ["2"] = { function() require("harpoon.ui").nav_file(2) end, "File 2" },
  ["3"] = { function() require("harpoon.ui").nav_file(3) end, "File 3" },
  ["4"] = { function() require("harpoon.ui").nav_file(4) end, "File 4" },
})

-- Undo
register_group('u', ' Undo', {
  u = { ':UndotreeToggle<CR>', 'Toggle UndoTree' },
})

-- Tabs
register_group('T', ' Tabs', {
  o = { ':tabnew<CR>', 'New Tab' },
  x = { ':tabclose<CR>', 'Close Tab' },
  n = { ':tabn<CR>', 'Next Tab' },
  p = { ':tabp<CR>', 'Prev Tab' },
})

-- Edit/Snippets
register_group('e', ' Edit/Go Snippets', {
  a = { "oassert.NoError(err, \"\")<Esc>F\"a", "Insert Go: assert.NoError(err)" },
  f = { "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj", "Insert Go: log.Fatalf on error" },
  l = { "oif err != nil {<CR>}<Esc>Ologger.Error(\"error\", \"error\", err)<Esc>F.;i", "Insert Go: logger.Error on error" },
})

-- Substitute/Save
register_group('S', '󰑓 Substitute/Save', {
  w = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Substitute word under cursor" },
  n = { ":noautocmd w <CR>", "Save (noautocmd)" },
})

--[[
  Major reassignments:
    - Docker group moved from <leader>d to <leader>D for MECE with Debug.
    - All <leader> mappings consolidated; no overlaps or shadowed keys.
    - Orphaned/unused prefixes (e.g. <leader>m, <leader>z) are available for future use.
]]
