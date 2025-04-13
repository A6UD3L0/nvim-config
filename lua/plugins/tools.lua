-- Tools for better development workflow
return {
  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in current buffer" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fi", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".pytest_cache/",
            "__pycache__/",
            "venv/",
            ".venv/",
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      
      telescope.load_extension("file_browser")
      telescope.load_extension("fzf")
    end,
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        
        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")
        
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Previous hunk")
        
        -- Actions
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage selected hunk")
        map("v", "<leader>gr", function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset selected hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line{full=true} end, "Blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff this")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this ~")
      end,
    },
  },
  
  -- Fugitive for git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git status" },
      { "<leader>gB", "<cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gC", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gP", "<cmd>Git push<CR>", desc = "Git push" },
    },
  },
  
  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gl", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
  
  -- Diff view
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview file history" },
    },
  },
  
  -- Undotree for better history visualization
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
  },
  
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon: Add file" },
      { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon: Quick menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon: File 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon: File 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon: File 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon: File 4" },
    },
  },
  
  -- Better motion with leap
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  
  -- Debugging support
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", config = true },
      { "nvim-telescope/telescope-dap.nvim" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" }, -- Lua debugging
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue debugging" },
      { "<leader>ds", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Conditional breakpoint" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last debug configuration" },
    },
    config = function()
      local dap = require("dap")
      
      -- Python configuration
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Find a virtual environment in the project
            local venv = vim.fn.getcwd() .. "/venv/bin/python"
            if vim.fn.executable(venv) == 1 then
              return venv
            end
            
            local venv2 = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv2) == 1 then
              return venv2
            end
            
            -- Fallback to system Python
            return "python"
          end,
        },
      }
      
      -- Go configuration
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = {"dap", "-l", "127.0.0.1:${port}"},
        }
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Package",
          request = "launch",
          program = "${fileDirname}",
        },
      }
      
      -- C/C++ configuration
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp
      
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
    end,
  },
}
