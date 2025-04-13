local M = {
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
    win = {
      border = "rounded",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 2, 2, 2, 2 },
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

    -- Register mappings using the new specification format
    wk.register({
      ["<leader>"] = {
        D = { name = "Docker" },
        d = { name = "Debug" },
        e = { name = "Error" },
        f = { name = "Find" },
        g = { name = "Git" },
        h = { name = "Harpoon" },
        l = { name = "LSP" },
        w = { name = "Window" },
      },
    })

    -- Docker commands
    wk.register({
      ["<leader>Dc"] = { "<cmd>!docker-compose up -d<CR>", "Docker-compose up" },
      ["<leader>Dd"] = { "<cmd>!docker-compose down<CR>", "Docker-compose down" },
      ["<leader>Dl"] = { "<cmd>!docker ps<CR>", "List containers" },
    })

    -- Debug commands
    wk.register({
      ["<leader>dB"] = { "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional breakpoint" },
      ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
      ["<leader>da"] = { "<cmd>DBUI<cr>", "Add DB Connection" },
      ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
      ["<leader>dc"] = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
      ["<leader>di"] = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
      ["<leader>dl"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics list" },
      ["<leader>do"] = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
      ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<cr>", "Open REPL" },
      ["<leader>dt"] = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
    })

    -- Error handling
    wk.register({
      ["<leader>ee"] = { "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", "Return error" },
      ["<leader>ef"] = { 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>', "Fatal error" },
    })

    -- Find commands
    wk.register({
      ["<leader>fB"] = { "<cmd>Telescope file_browser<cr>", "File browser" },
      ["<leader>fS"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
      ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find buffers" },
      ["<leader>fc"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in buffer" },
      ["<leader>fd"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
      ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
      ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
      ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
      ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
      ["<leader>ft"] = { "<cmd>Telescope treesitter<cr>", "Treesitter symbols" },
    })

    -- Git commands
    wk.register({
      ["<leader>gb"] = { "<cmd>Git blame<cr>", "Git blame" },
      ["<leader>gc"] = { "<cmd>Git commit<cr>", "Git commit" },
      ["<leader>gd"] = { "<cmd>Git diff<cr>", "Git diff" },
      ["<leader>gg"] = { "<cmd>Git<cr>", "Git status" },
    })

    -- Harpoon commands
    wk.register({
      ["<leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add file" },
      ["<leader>hh"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon menu" },
    })

    -- LSP commands
    wk.register({
      ["<leader>lS"] = { "<cmd>LspStop<cr>", "Stop LSP" },
      ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
      ["<leader>ld"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
      ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation" },
      ["<leader>li"] = { "<cmd>LspInfo<cr>", "LSP info" },
      ["<leader>lk"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
      ["<leader>ln"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      ["<leader>lr"] = { "<cmd>LspRestart<cr>", "Restart LSP" },
      ["<leader>ls"] = { "<cmd>LspStart<cr>", "Start LSP" },
      ["<leader>lt"] = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type definition" },
    })

    -- Window commands
    wk.register({
      ["<leader>wq"] = { "<cmd>wq<CR>", "Save and quit" },
      ["<leader>ww"] = { "<cmd>w<CR>", "Save" },
    })

    -- SQL formatting
    wk.register({
      ["<leader>sq"] = { "<cmd>%!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format SQL" },
    })

    -- Comment mappings
    wk.register({
      ["gc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" },
    }, { mode = "n" })

    wk.register({
      ["gc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" },
    }, { mode = "v" })
  end,
}

return M 