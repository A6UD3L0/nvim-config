-- Data Science and Machine Learning specific plugins
return {
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
