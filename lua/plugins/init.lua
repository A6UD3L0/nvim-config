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
  },

  -- Git integration - enhance built-in Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
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
    config = function()
      require("keytrainer").setup({
        timeout = 90,  -- 90 seconds per game
        popup_width = 90,
        popup_height = 20,
        default_mode = "beginner", -- Start with beginner mode
      })
      -- Add a command to toggle the keybinding trainer
      vim.api.nvim_create_user_command("KeyMap", function()
        vim.cmd("KeyTrainer")
      end, {})
    end,
  },

  -- DATA SCIENCE SPECIFIC PLUGINS
  
  -- Jupyter Notebook integration
  {
    "kiyoon/jupynium.nvim",
    enabled = false, -- Set to true after installing dependencies manually
    build = "pip3 install --user .",
    dependencies = {
      "rcarriga/nvim-notify",  -- optional
      "stevearc/dressing.nvim", -- optional, UI improvements
    },
    cmd = { "JupyniumStartSync", "JupyniumStartAndAttachToServer" },
    config = true,
  },
  
  -- Python REPL and code sending
  {
    "michaelb/sniprun",
    enabled = false, -- Set to true after installing Rust toolchain
    branch = "master", 
    build = "sh install.sh",
    cmd = {"SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose"},
    config = function()
      require("sniprun").setup({
        display = {
          "Classic",
          "VirtualTextOk",
        },
        live_mode_toggle = "enable"
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
