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
        ["<leader>"] = { name = "+leader" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>p"] = { name = "+project" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>e"] = { name = "+explorer" },
      },
    })

    -- Register specific key mappings to avoid overlaps
    wk.register({
      -- Find mappings
      ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
      ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
      ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find buffers" },
      ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
      ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      ["<leader>fc"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in buffer" },
      ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
      ["<leader>fS"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
      ["<leader>ft"] = { "<cmd>Telescope treesitter<cr>", "Treesitter symbols" },
      ["<leader>fd"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
      ["<leader>f/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in current buffer" },
      ["<leader>fB"] = { "<cmd>Telescope file_browser<cr>", "File browser" },
      ["<leader>fi"] = { "<cmd>Telescope file_browser<cr>", "File browser" },

      -- Debug mappings
      ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
      ["<leader>dc"] = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
      ["<leader>di"] = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
      ["<leader>do"] = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
      ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
      ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<cr>", "Open REPL" },
      ["<leader>dt"] = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
      ["<leader>du"] = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
      ["<leader>dB"] = { "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional breakpoint" },
      ["<leader>dl"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics list" },
      ["<leader>da"] = { "<cmd>DBUI<cr>", "Add DB Connection" },
      ["<leader>dd"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Generate Documentation" },

      -- Git mappings
      ["<leader>gg"] = { "<cmd>Git<cr>", "Git status" },
      ["<leader>gb"] = { "<cmd>Git blame<cr>", "Git blame" },
      ["<leader>gd"] = { "<cmd>Git diff<cr>", "Git diff" },
      ["<leader>gc"] = { "<cmd>Git commit<cr>", "Git commit" },

      -- Harpoon mappings
      ["<leader>hh"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon menu" },
      ["<leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add file" },

      -- Window mappings
      ["<leader>wq"] = { "<cmd>wq<cr>", "Save and quit" },
      ["<leader>w"] = { "<cmd>w<cr>", "Save" },

      -- LSP mappings
      ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
      ["grr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
      ["gri"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
      ["gra"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
      ["grn"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },

      -- Comment mappings
      ["gc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", "Comment toggle linewise" },
      ["gcc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", "Comment toggle current line" },
    }, { mode = "n" })
  end,
} 