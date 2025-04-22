 -- whichkey_mece.lua: Central which-key group registration for all major features.
-- Only register project/UV (<leader>P), terminal (<leader>t), and debug (<leader>d) keymaps here for clarity and DRYness.
-- Do NOT duplicate these in remap.lua or editor_commands.lua.

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

  --  Undo/History
  u = {
    name = " Undo",
    u = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
  },

  --  Folds
  d = {
    name = " Folds",
    o = { "zR", "Open All Folds" },
    c = { "zM", "Close All Folds" },
    n = { "zo", "Open Fold" },
    m = { "zc", "Close Fold" },
  },

  --  Python/Project (UV) - CANONICAL <leader>P
  P = {
    name = " Python/Project (UV)",
    i = { ":UvInit<Space>", "Init Project" },
    a = { ":UvActivate<Space>", "Activate .venv" },
    r = { ":UvRun<Space>", "Run Main" },
    t = { ":UvTest<Space>", "Run Tests" },
    s = { ":UvShell<Space>", "Shell in venv" },
    c = { ":UvConsole<Space>", "Python Console" },
    p = { ":UvPip<Space>", "Pip Install" },
    u = { ":UvUpdate<Space>", "Update Deps" },
    l = { ":UvLint<Space>", "Lint" },
    f = { ":UvFormat<Space>", "Format" },
    d = { ":UvDocs<Space>", "Docs" },
    m = { ":UvMigrate<Space>", "Migrate" },
  },

  --  Terminal (ToggleTerm) - CANONICAL <leader>t
  t = {
    name = " Terminal",
    t = { ":ToggleTerm<CR>", "Toggle Horizontal Terminal" },
    v = { function() require("toggleterm").toggle(1, nil, nil, "vertical") end, "Toggle Vertical Terminal" },
    f = { function() require("toggleterm").toggle(1, nil, nil, "float") end, "Toggle Floating Terminal" },
  },

  --  Misc/Utilities
  x = {
    name = " Misc/Utilities",
    s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Substitute Word" },
    c = { function() require("cellular-automaton").start_animation("make_it_rain") end, "Cellular Automaton" },
    S = { function() vim.cmd("so") end, "Source File" },
  },

  --  Debug (nvim-dap & nvim-dap-ui) - CANONICAL <leader>d
  d = {
    name = " Debug",
    s = { function() require('dap').continue() end, "Start/Continue Debug" },
    i = { function() require('dap').step_into() end, "Step Into" },
    o = { function() require('dap').step_over() end, "Step Over" },
    u = { function() require('dap').step_out() end, "Step Out" },
    b = { function() require('dap').toggle_breakpoint() end, "Toggle Breakpoint" },
    B = { function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Set Conditional Breakpoint" },
    r = { function() require('dap').repl.open() end, "Open REPL" },
    l = { function() require('dap').run_last() end, "Run Last Debug" },
    t = {
      function()
        local ok, dapui = pcall(require, "dapui")
        if ok then dapui.toggle() end
      end,
      "Toggle DAP UI"
    },
    e = {
      function()
        local ok, dapui = pcall(require, "dapui")
        if ok then dapui.eval() end
      end,
      "Eval Expression"
    },
    c = { function() require('dap').clear_breakpoints() end, "Clear Breakpoints" },
  },
}, { prefix = "<leader>" })