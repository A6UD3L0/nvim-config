-- Productivity boosters for a more efficient workflow
-- Includes terminal management, undo history, project management, and time tracking

return {
  -- Terminal integration with Toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-t>", desc = "Smart terminal toggle" },
      { "<leader>tt", desc = "Toggle bottom terminal" },
      { "<leader>tr", desc = "Toggle right terminal" },
      { "<leader>tf", desc = "Toggle floating terminal" },
      { "<leader>tg", desc = "Toggle LazyGit terminal" },
      { "<leader>tp", desc = "Toggle Python REPL" },
      { "<leader>tn", desc = "Toggle Node.js REPL" },
      { "<leader>tr", desc = "Run current file" },
    },
    config = function()
      require("config.terminal").setup()
    end,
  },

  -- UndoTree for visualizing and navigating undo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", desc = "Toggle UndoTree" },
      { "<leader>ur", desc = "Show Undo History" },
    },
    config = function()
      require("config.undotree").setup()
    end,
  },

  -- Project management with enhanced telescope integration
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      { "<leader>pp", desc = "List projects" },
      { "<leader>pf", desc = "Browse project files" },
      { "<leader>pr", desc = "Recent projects" },
      { "<leader>pF", desc = "Find all files" },
      { "<leader>pg", desc = "Grep in project" },
      { "<leader>pw", desc = "Work diary entry" },
    },
    config = function()
      require("config.project").setup()
    end,
  },

  -- Session management for persistence across Neovim sessions
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<leader>ps", desc = "Save session" },
      { "<leader>pl", desc = "Load session" },
      { "<leader>pd", desc = "Delete session" },
    },
    dependencies = {
      "ahmedkhalf/project.nvim",
    },
    -- Auto-session is configured in the project module
  },

  -- Telescope file-browser extension for better file navigation
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  -- WakaTime integration for tracking coding time
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },

  -- Time tracking with analytics dashboard
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    dependencies = {},
    config = function()
      require("config.time-tracking").setup()
    end,
    keys = {
      { "<leader>sd", desc = "Show coding stats dashboard" },
    },
  },

  -- Enhanced search and find in project
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>sp", function() require("spectre").open() end, desc = "Search & Replace (Spectre)" },
    },
    config = function()
      require("spectre").setup({
        color_devicons = true,
        highlight = {
          ui = "String",
          search = "DiffChange",
          replace = "DiffDelete",
        },
        mapping = {
          ["toggle_line"] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item",
          },
          ["enter_file"] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "goto current file",
          },
          ["send_to_qf"] = {
            map = "<leader>q",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix",
          },
          ["replace_cmd"] = {
            map = "<leader>c",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "input replace command",
          },
          ["show_option_menu"] = {
            map = "<leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show options",
          },
          ["run_current_replace"] = {
            map = "<leader>rc",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line",
          },
          ["run_replace"] = {
            map = "<leader>r",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all",
          },
          ["change_view_mode"] = {
            map = "<leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode",
          },
          ["change_replace_sed"] = {
            map = "trs",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "use sed to replace",
          },
          ["change_replace_oxi"] = {
            map = "tro",
            cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
            desc = "use oxi to replace",
          },
          ["toggle_live_update"] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "update changes when editing",
          },
          ["toggle_ignore_case"] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case",
          },
          ["toggle_ignore_hidden"] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden",
          },
          ["resume_last_search"] = {
            map = "<leader>l",
            cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
            desc = "resume last search before close",
          },
          -- you can put your mapping here it only use normal mode
        },
      })
    end,
  },

  -- Todo comments for better task tracking
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs (Telescope)" },
      { "<leader>sT", "<cmd>TodoQuickFix<cr>", desc = "List all TODOs" },
    },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#eb6f92" },
          warning = { "DiagnosticWarn", "WarningMsg", "#f6c177" },
          info = { "DiagnosticInfo", "#9ccfd8" },
          hint = { "DiagnosticHint", "#c4a7e7" },
          default = { "Identifier", "#e0def4" },
          test = { "Identifier", "#31748f" },
        },
      })
    end,
  },
}
