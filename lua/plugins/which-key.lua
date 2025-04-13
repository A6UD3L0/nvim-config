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
        { "", group = "leader" },
        { "", group = "code" },
        { "", group = "harpoon" },
        { "", group = "window" },
        { "", group = "project" },
        { "", group = "search" },
        { "", group = "terminal" },
        { "", group = "lsp" },
        { "", group = "find" },
        { "", group = "debug" },
        { "", group = "git" },
        { "", group = "buffer" },
        { "", group = "explorer" },
      },
    })

    -- Register specific key mappings to avoid overlaps
    wk.register({
      -- Find mappings
      { "", "<leader>ff", desc = "<cmd>Telescope find_files<cr>" },
      { "", "<leader>fg", desc = "<cmd>Telescope live_grep<cr>" },
      { "", "<leader>fb", desc = "<cmd>Telescope buffers<cr>" },
      { "", "<leader>fh", desc = "<cmd>Telescope help_tags<cr>" },
      { "", "<leader>fr", desc = "<cmd>Telescope oldfiles<cr>" },
      { "", "<leader>fc", desc = "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
      { "", "<leader>fs", desc = "<cmd>Telescope lsp_document_symbols<cr>" },
      { "", "<leader>fS", desc = "<cmd>Telescope lsp_workspace_symbols<cr>" },
      { "", "<leader>ft", desc = "<cmd>Telescope treesitter<cr>" },
      { "", "<leader>fd", desc = "<cmd>Telescope diagnostics<cr>" },
      { "", "<leader>f/", desc = "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
      { "", "<leader>fB", desc = "<cmd>Telescope file_browser<cr>" },
      { "", "<leader>fi", desc = "<cmd>Telescope file_browser<cr>" },

      -- Debug mappings
      { "", "<leader>db", desc = "<cmd>lua require('dap').toggle_breakpoint()<cr>" },
      { "", "<leader>dc", desc = "<cmd>lua require('dap').continue()<cr>" },
      { "", "<leader>di", desc = "<cmd>lua require('dap').step_into()<cr>" },
      { "", "<leader>do", desc = "<cmd>lua require('dap').step_over()<cr>" },
      { "", "<leader>dO", desc = "<cmd>lua require('dap').step_out()<cr>" },
      { "", "<leader>dr", desc = "<cmd>lua require('dap').repl.open()<cr>" },
      { "", "<leader>dt", desc = "<cmd>lua require('dapui').toggle()<cr>" },
      { "", "<leader>du", desc = "<cmd>lua require('dapui').toggle()<cr>" },
      { "", "<leader>dB", desc = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>" },
      { "", "<leader>dl", desc = "<cmd>Telescope diagnostics<cr>" },
      { "", "<leader>da", desc = "<cmd>DBUI<cr>" },
      { "", "<leader>dd", desc = "<cmd>lua vim.lsp.buf.hover()<cr>" },

      -- Git mappings
      { "", "<leader>gg", desc = "<cmd>Git<cr>" },
      { "", "<leader>gb", desc = "<cmd>Git blame<cr>" },
      { "", "<leader>gd", desc = "<cmd>Git diff<cr>" },
      { "", "<leader>gc", desc = "<cmd>Git commit<cr>" },

      -- Harpoon mappings
      { "", "<leader>hh", desc = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>" },
      { "", "<leader>ha", desc = "<cmd>lua require('harpoon.mark').add_file()<cr>" },

      -- Window mappings
      { "", "<leader>wq", desc = "<cmd>wq<cr>" },
      { "", "<leader>w", desc = "<cmd>w<cr>" },

      -- LSP mappings
      { "", "gr", desc = "<cmd>lua vim.lsp.buf.references()<cr>" },
      { "", "gri", desc = "<cmd>lua vim.lsp.buf.implementation()<cr>" },
      { "", "gra", desc = "<cmd>lua vim.lsp.buf.code_action()<cr>" },
      { "", "grn", desc = "<cmd>lua vim.lsp.buf.rename()<cr>" },

      -- Comment mappings
      { "", "gc", desc = "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>" },
      { "", "gcc", desc = "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>" },
    }, { mode = "n" })
  end,
} 