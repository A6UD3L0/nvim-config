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
      -- Find mappings
      ["<leader>f"] = { name = "Find" },
      ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
      ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      ["<leader>fc"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
      ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      ["<leader>fS"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      ["<leader>ft"] = { "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
      ["<leader>fd"] = { "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      ["<leader>fB"] = { "<cmd>Telescope file_browser<cr>", desc = "File browser" },

      -- Debug mappings
      ["<leader>d"] = { name = "Debug" },
      ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
      ["<leader>dc"] = { "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
      ["<leader>di"] = { "<cmd>lua require('dap').step_into()<cr>", desc = "Step into" },
      ["<leader>do"] = { "<cmd>lua require('dap').step_over()<cr>", desc = "Step over" },
      ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<cr>", desc = "Step out" },
      ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<cr>", desc = "Open REPL" },
      ["<leader>dt"] = { "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
      ["<leader>dB"] = { "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional breakpoint" },
      ["<leader>dl"] = { "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics list" },
      ["<leader>da"] = { "<cmd>DBUI<cr>", desc = "Add DB Connection" },

      -- Git mappings
      ["<leader>g"] = { name = "Git" },
      ["<leader>gg"] = { "<cmd>Git<cr>", desc = "Git status" },
      ["<leader>gb"] = { "<cmd>Git blame<cr>", desc = "Git blame" },
      ["<leader>gd"] = { "<cmd>Git diff<cr>", desc = "Git diff" },
      ["<leader>gc"] = { "<cmd>Git commit<cr>", desc = "Git commit" },

      -- Harpoon mappings
      ["<leader>h"] = { name = "Harpoon" },
      ["<leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file" },
      ["<leader>hh"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" },

      -- LSP mappings
      ["<leader>l"] = { name = "LSP" },
      ["<leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" },
      ["<leader>ld"] = { vim.lsp.buf.definition, desc = "Go to definition" },
      ["<leader>lf"] = { vim.lsp.buf.format, desc = "Format" },
      ["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP info" },
      ["<leader>ln"] = { vim.lsp.buf.rename, desc = "Rename" },
      ["<leader>lr"] = { "<cmd>LspRestart<cr>", desc = "Restart LSP" },
      ["<leader>ls"] = { "<cmd>LspStart<cr>", desc = "Start LSP" },
      ["<leader>lS"] = { "<cmd>LspStop<cr>", desc = "Stop LSP" },
      ["<leader>lh"] = { vim.lsp.buf.hover, desc = "Hover documentation" },
      ["<leader>lk"] = { vim.lsp.buf.signature_help, desc = "Signature help" },
      ["<leader>lt"] = { vim.lsp.buf.type_definition, desc = "Type definition" },
    }, { mode = "n" })
  end,
} 