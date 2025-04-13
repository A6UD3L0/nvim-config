return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- Format on save 
    opts = require "configs.conform",
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "nvimdev/lspsaga.nvim",
        opts = {
          lightbulb = { enable = false },
          symbol_in_winbar = { enable = false },
        },
      },
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Mason for LSP, DAP, Linter, Formatter installation
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {
        -- LSP
        "pyright", "gopls", "clangd", "lua-language-server", "typescript-language-server",
        -- Data Science specific
        "ruff-lsp", "jedi-language-server", "jupyter-lsp",
        -- Formatter
        "stylua", "black", "gofumpt", "shfmt", "isort",
        -- DAP
        "debugpy", "delve",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- TreeSitter for better syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "go", "html", "javascript",
        "json", "lua", "markdown", "python", "rust", "tsx",
        "typescript", "yaml", "vim", "vimdoc", "query", "sql",
        "dockerfile", "gitignore", "make", "r", "toml", "julia",
      },
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
  },

  -- ThePrimeagen's Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup({})
    end,
  },

  -- UndoTree visualizes your vim undo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },

  -- Git integration - enhance built-in Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff" },
    },
  },
  
  -- Git signs in the gutter for added, modified, and deleted lines
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        
        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})
        
        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
        
        -- Actions
        map('n', '<leader>gh', gs.preview_hunk, { desc = "Preview Hunk" })
        map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
        map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset Buffer" })
        map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage Buffer" })
        map('n', '<leader>gB', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
        map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
        map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })
      end,
    },
  },
  
  -- Git diffview for branch and file differences
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "DiffView Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
  
  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
  
  -- Telescope for improved file and text searching
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find word" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
    },
    opts = function()
      return require "configs.telescope"
    end,
    config = function(_, opts)
      -- Telescope setup
      local telescope = require("telescope")
      telescope.setup(opts)
      
      -- Load telescope extensions if they exist
      pcall(function() telescope.load_extension("fzf") end)
    end,
  },

  -- Debugging capability
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    config = function()
      require("configs.dap")
    end,
  },

  -- Add auto pair completion
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Better commenting
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = {"n", "v"} },
      { "gb", mode = {"n", "v"} },
    },
    opts = {},
  },
  
  -- Highlight and search for todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
  },
  
  -- Custom KeyTrainer plugin to learn keybindings
  {
    dir = vim.fn.stdpath("config") .. "/lua/keytrainer",
    name = "keytrainer",
    cmd = {
      "KeyMap",
      "KeyTrainer",
      "HarpoonTrainer",
      "MotionsTrainer",
      "TextObjectsTrainer",
      "GitTrainer",
      "UndoTrainer"
    },
    config = function()
      -- Only setup once, avoiding conflicts with initialization
      if not package.loaded["keytrainer"] then 
        require("keytrainer")
      end
    end,
  },

  -- DATA SCIENCE SPECIFIC PLUGINS
  
  -- Python REPL and code sending
  {
    "geg2102/nvim-python-repl",
    ft = { "python" },
    config = function()
      require("nvim-python-repl").setup({
        execute_on_send = true,
        vsplit = true,
        spawn_commands = {
          python = {"python", "-i"},
        }
      })
      
      -- Set keymaps for REPL
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>ri", "<cmd>PythonREPLStart<CR>", opts)
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>rc", "<cmd>PythonREPLSendLine<CR>", opts)
          vim.api.nvim_buf_set_keymap(0, "v", "<leader>rs", "<cmd>PythonREPLSendSelection<CR>", opts)
        end,
      })
    end,
  },
  
  -- Interactive code evaluation for Python, R, and other data science languages
  {
    "jalvesaq/vimcmdline",
    ft = {"python", "r", "julia", "sql"},
    config = function()
      vim.g.cmdline_app = {
        python = "ipython",
        r = "R",
        julia = "julia",
        sql = "sqlite3",
      }
      vim.g.cmdline_vsplit = 1
      vim.g.cmdline_term_width = 80
      vim.g.cmdline_term_height = 24
    end,
  },
  
  -- Python docstring generator
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = { "<leader>dd" },
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "numpydoc",
            },
          },
        },
      })
      vim.keymap.set("n", "<leader>dd", function()
        require("neogen").generate()
      end, { desc = "Generate docstring" })
    end,
  },

  -- Database client
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {"DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer"},
    config = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
