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
    align = "center",
  },
  icons = {
    group = " ",
  },
})

-- DRY helper for workflow groups
local function register_group(prefix, name, mappings)
  wk.register({ [prefix] = vim.tbl_extend('force', { name = name }, mappings) }, { prefix = '<leader>' })
end

-- Workflow groups: REPL, Test, Debug, Docker, SQL
register_group('r', ' REPL', {
  s = { '<cmd>IronRepl<CR>', 'Start REPL' },
  l = { '<cmd>IronSendLine<CR>', 'Send Line' },
  f = { '<cmd>IronSendFile<CR>', 'Send File' },
})
register_group('t', ' Test', {
  n = { function() require('neotest').run.run() end, 'Nearest Test' },
  f = { function() require('neotest').run.run(vim.fn.expand('%')) end, 'Test File' },
})
register_group('d', ' Debug', {
  b = { function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint' },
  c = { function() require('dap').continue() end, 'Continue' },
  o = { function() require('dap').step_over() end, 'Step Over' },
  i = { function() require('dap').step_into() end, 'Step Into' },
  O = { function() require('dap').step_out() end, 'Step Out' },
  r = { function() require('dap').repl.open() end, 'Open REPL' },
  u = { function() require('dapui').toggle() end, 'Toggle UI' },
})
register_group('D', ' Docker', {
  c = { ":TermExec cmd='docker compose up' direction=horizontal<CR>", 'Compose Up' },
  b = { ":TermExec cmd='docker build .' direction=horizontal<CR>", 'Build' },
  r = { ":TermExec cmd='docker run -it --rm' direction=horizontal<CR>", 'Run' },
})
register_group('s', ' SQL', {
  q = { ':DBUI<CR>', 'Open DB UI' },
  e = { ':DB<CR>', 'Execute SQL' },
})

wk.register({
  --  File & Search (Telescope, File Explorer)
  f = {
    name = " File & Search",
    f = { ":Telescope find_files<CR>", "Find Files" },
    g = { ":Telescope live_grep<CR>", "Live Grep" },
    b = { ":Telescope buffers<CR>", "Buffers" },
    h = { ":Telescope help_tags<CR>", "Help Tags" },
    e = { ":NvimTreeToggle<CR>", "File Explorer" },
    r = { ":Telescope oldfiles<CR>", "Recent Files" },
    k = { ":Telescope keymaps<CR>", "Keymaps" },
    E = { ":Ex<CR>", "netrw Explorer" },
  },
  --  Git
  g = {
    name = " Git",
    s = { ":LazyGit<CR>", "Status (LazyGit)" },
    c = { ":Git commit<CR>", "Commit" },
    p = { ":Git push<CR>", "Push" },
    l = { ":Git pull<CR>", "Pull" },
    b = { ":Git blame<CR>", "Blame" },
    d = { ":Gitsigns diffthis<CR>", "Diff" },
    S = { ":Gitsigns stage_buffer<CR>", "Stage Buffer" },
    h = { name = "Hunk", s = { ":Gitsigns stage_hunk<CR>", "Stage Hunk" }, r = { ":Gitsigns reset_hunk<CR>", "Reset Hunk" }, u = { ":Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" }, p = { ":Gitsigns preview_hunk<CR>", "Preview Hunk" } },
  },
  --  LSP & Code
  l = {
    name = " LSP",
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
  },
  --  Harpoon
  h = {
    name = " Harpoon",
    a = { function() require("harpoon.mark").add_file() end, "Add File" },
    m = { function() require("harpoon.ui").toggle_quick_menu() end, "Menu" },
    n = { function() require("harpoon.ui").nav_next() end, "Next" },
    p = { function() require("harpoon.ui").nav_prev() end, "Prev" },
    ["1"] = { function() require("harpoon.ui").nav_file(1) end, "File 1" },
    ["2"] = { function() require("harpoon.ui").nav_file(2) end, "File 2" },
    ["3"] = { function() require("harpoon.ui").nav_file(3) end, "File 3" },
    ["4"] = { function() require("harpoon.ui").nav_file(4) end, "File 4" },
  },
  --  Buffers/Windows
  b = {
    name = " Buffers",
    n = { ":enew<CR>", "New Buffer" },
    x = { ":Bdelete!<CR>", "Close Buffer" },
    l = { ":ls<CR>", "List Buffers" },
    p = { ":bprevious<CR>", "Prev Buffer" },
    N = { ":bnext<CR>", "Next Buffer" },
  },
  --  Tabs
  t = {
    name = " Tabs",
    to = { ":tabnew<CR>", "New Tab" },
    tx = { ":tabclose<CR>", "Close Tab" },
    tn = { ":tabn<CR>", "Next Tab" },
    tp = { ":tabp<CR>", "Prev Tab" },
  },
  --  Undo
  u = {
    name = " Undo",
    u = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
  },
  --  Folds
  F = {
    name = " Folds",
    o = { "zR", "Open All Folds" },
    c = { "zM", "Close All Folds" },
    n = { "zo", "Open Fold" },
    m = { "zc", "Close Fold" },
  },
  --  Python/Project (UV)
  p = {
    name = " Python/Project",
    i = { ":UvInit ", "Init Project" },
    a = { ":UvAdd ", "Add Dependency" },
    r = { ":UvRun ", "Run" },
    l = { ":UvLock<CR>", "Lock" },
    s = { ":UvSync<CR>", "Sync" },
    p = { ":UvPython ", "Python REPL" },
    v = { ":UvPin ", "Pin Package" },
    ti = { ":UvToolInstall ", "Tool Install" },
    tx = { ":Uvx ", "Run with uvx" },
  },
  --  Edit/Go Snippets
  e = {
    name = " Edit/Go Snippets",
    a = { "oassert.NoError(err, \"\")<Esc>F\"a", "Insert Go: assert.NoError(err)" },
    f = { "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj", "Insert Go: log.Fatalf on error" },
    l = { "oif err != nil {<CR>}<Esc>Ologger.Error(\"error\", \"error\", err)<Esc>F.;i", "Insert Go: logger.Error on error" },
  },
  --  Custom/Cellular Automaton
  c = {
    name = " Custom/Cellular Automaton",
    a = { function() require('cellular-automaton').start_animation('make_it_rain') end, "Cellular Automaton: make it rain" },
    x = { ":!chmod +x %<CR>", "Make file executable" },
  },
  -- 󰑓 Substitute/Save
  S = {
    name = "󰑓 Substitute/Save",
    w = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Substitute word under cursor" },
    n = { ":noautocmd w <CR>", "Save (noautocmd)" },
  },
}, { prefix = "<leader>" })