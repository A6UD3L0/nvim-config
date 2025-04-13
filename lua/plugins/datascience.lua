-- Data Science and Machine Learning specific plugins
return {
  -- Jupyter Notebook integration (properly enabled)
  {
    "kiyoon/jupynium.nvim",
    -- Enable after installing dependencies
    enabled = true,
    build = "pip3 install --user .",
    dependencies = {
      "rcarriga/nvim-notify",
      "stevearc/dressing.nvim",
    },
    cmd = { "JupyniumStartSync", "JupyniumStartAndAttachSync" },
    keys = {
      { "<leader>jS", "<cmd>JupyniumStartSync<CR>", desc = "Start Jupynium" },
      { "<leader>jA", "<cmd>JupyniumStartAndAttachSync<CR>", desc = "Attach Jupynium" },
      { "<leader>jE", "<cmd>JupyniumExecuteSelectedCells<CR>", desc = "Execute Selected" },
    },
    config = function()
      require("jupynium").setup({
        -- Path to python with jupyter and jupynium dependencies
        python_host = { "python3" },
        default_notebook_URL = "localhost:8888/",
        jupyter_command = "jupyter",
        auto_start_jupyter = {
          enable = true,
          file_pattern = { "*.ipynb" },
        },
        auto_attach_to_server = {
          enable = true,
          file_pattern = { "*.ipynb" },
        },
        auto_start_sync = {
          enable = true,
          file_pattern = { "*.ipynb" },
        },
        use_default_keybindings = true,
        textobjects = {
          -- Requires treesitter queries
          cell = {
            enable = true,
          },
        },
      })
    end,
  },

  -- Code execution for Python, R, Julia, etc.
  {
    "michaelb/sniprun",
    enabled = true,
    build = "bash ./install.sh",
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipLive" },
    keys = {
      { "<leader>sr", "<cmd>SnipRun<CR>", desc = "Run Code Snippet" },
      { "<leader>sl", "<cmd>SnipLive<CR>", desc = "Live Code Runner" },
      { "<leader>sc", "<cmd>SnipClose<CR>", desc = "Close Live Runner" },
      { "<leader>si", "<cmd>SnipInfo<CR>", desc = "Runner Info" },
      { "<leader>sr", ":SnipRun<CR>", mode = "v", desc = "Run Selected Code" },
    },
    config = function()
      require("sniprun").setup({
        selected_interpreters = { 
          "Python3_original", 
          "Numpy",
          "Pandas",
          "R_original",
          "Rust_original",
        },
        repl_enable = { 
          "Python3_original", 
          "R_original", 
          "Numpy",
          "Pandas",
        },
        display = {
          "Classic",
          "VirtualTextOk",
          "TerminalWithCode",
        },
        display_options = {
          terminal_width = 45,
          notification_timeout = 5,
        },
        live_mode_toggle = "enable",
      })
    end,
  },

  -- REPL integration for various languages
  {
    "jalvesaq/nvim-r",
    ft = { "r", "rmd", "quarto" },
    config = function()
      vim.g.R_app = "R"
      vim.g.R_cmd = "R"
      vim.g.R_hl_term = 0
      vim.g.R_bracketed_paste = 1
      vim.g.R_assign = 0
      vim.g.R_args = { "--no-save", "--no-restore", "--quiet" }
      vim.g.R_start_libs = "base,stats,graphics,grDevices,utils,methods"
    end,
  },

  -- Database client integration
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
      { "<leader>da", "<cmd>DBUIAddConnection<CR>", desc = "Add DB Connection" },
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      
      -- Register common database types
      vim.g.dbs = {
        dev_postgres = "postgresql://postgres:postgres@localhost:5432/postgres",
        dev_mysql = "mysql://root:root@localhost:3306/mysql",
      }
    end,
  },
  
  -- Documentation generation for Python and more
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    cmd = "Neogen",
    keys = {
      { "<leader>dd", "<cmd>Neogen<CR>", desc = "Generate Documentation" },
    },
  },
  
  -- CSV file handling
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
}
