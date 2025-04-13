return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    triggers = { "<leader>" },
    defer = { gc = "Comments" },
    replace = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    win = {
      border = "single",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- Register key mappings using the new format
    wk.register({
      {
        mode = { "n", "v" },
        { "<leader>", group = "leader" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "buffer" },
        { "<leader>l", group = "lsp" },
        { "<leader>d", group = "debug" },
        { "<leader>t", group = "terminal" },
        { "<leader>h", group = "harpoon" },
        { "<leader>c", group = "code" },
        { "<leader>w", group = "window" },
        { "<leader>p", group = "project" },
        { "<leader>s", group = "search" },
        { "<leader>e", group = "explorer" },
      },
    })

    -- Register specific key mappings to avoid overlaps
    wk.register({
      -- Find mappings
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer" },
      { "<leader>fB", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
      { "<leader>fi", "<cmd>Telescope file_browser<cr>", desc = "File browser" },

      -- Debug mappings
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step into" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step over" },
      { "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", desc = "Step out" },
      { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Open REPL" },
      { "<leader>dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
      { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
      { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional breakpoint" },
      { "<leader>dl", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics list" },
      { "<leader>da", "<cmd>DBUI<cr>", desc = "Add DB Connection" },
      { "<leader>dd", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Generate Documentation" },

      -- Git mappings
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Git diff<cr>", desc = "Git diff" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },

      -- Harpoon mappings
      { "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" },
      { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file" },

      -- Window mappings
      { "<leader>wq", "<cmd>wq<cr>", desc = "Save and quit" },
      { "<leader>w", "<cmd>w<cr>", desc = "Save" },

      -- LSP mappings
      { "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Go to references" },
      { "gri", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation" },
      { "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
      { "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },

      -- Comment mappings
      { "gc", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", desc = "Comment toggle linewise" },
      { "gcc", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", desc = "Comment toggle current line" },
    }, { mode = "n" })
  end,
} 