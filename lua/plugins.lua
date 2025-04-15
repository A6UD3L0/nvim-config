return {
  -- UI/Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", config = true },
  
  -- Telescope UI/UX improvements
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require('telescope').setup{
        defaults = {
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          prompt_prefix = '🔍 ',
          selection_caret = ' ',
          entry_prefix = '  ',
          layout_strategy = 'horizontal',
          layout_config = {
            prompt_position = 'top',
            width = 0.95,
            height = 0.85,
            preview_cutoff = 120,
          },
          sorting_strategy = 'ascending',
          winblend = 10,
          color_devicons = true,
          results_title = false,
          preview_title = false,
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "dropdown",
          },
        },
        extensions = {},
      }
    end
  },

  -- NvimTree UI/UX improvements
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 35,
          side = "left",
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          float = {
            enable = true,
            open_win_config = {
              border = "rounded"
            }
          }
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "all",
          root_folder_label = ":t",
          indent_markers = {
            enable = true
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" }
        },
      }
    end
  },

  -- Mason UI/UX improvements
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      }
    end
  },

  -- Lazy plugin manager UI/UX improvements
  {
    "folke/lazy.nvim",
    config = function()
      require("lazy").setup {
        ui = {
          border = "rounded",
          icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📄",
            init = "⚙️ ",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📦",
            start = "🚀",
            task = "📌",
          },
        },
      }
    end
  },

  -- LSP UI/UX improvements (if using lspsaga)
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          code_action = '💡',
          colors = {
            normal_bg = '#1e2030',
          },
        },
      })
    end
  },

  -- Notifications with PROPER MODULE LOADING
  { "rcarriga/nvim-notify", 
    event = "VeryLazy",
    config = function()
      -- Create a basic fallback if notify isn't available
      local ok, notify = pcall(require, "notify")
      if not ok then
        -- If module isn't found, set up a simple fallback
        vim.notify = function(msg, level, opts)
          return vim.api.nvim_echo({{msg, level or ""}}, true, {})
        end
        return
      end
      
      -- Normal setup if module is found
      notify.setup({
        background_colour = "#000000",
        stages = "fade",
        timeout = 3000,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        on_open = function() pcall(vim.api.nvim_set_hl, 0, "NotifyBackground", { bg = "#000000" }) end,
        silent = true,
      })
      vim.notify = notify
    end
  },
  
  -- Which-key with PROPER ERROR HANDLING
  { "folke/which-key.nvim", 
    lazy = false, -- Load immediately to ensure it's available for leader key press
    priority = 100, -- High priority to ensure it loads early
    config = function()
      -- Create a basic setup that won't fail
      local ok, wk = pcall(require, "which-key")
      if not ok then
        vim.notify("Which-key not found, some keybindings may not work", vim.log.levels.WARN)
        return
      end
      
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = false,
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
        window = {
          border = "single",
          position = "bottom",
        },
        layout = {
          spacing = 6,
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        triggers = {"<leader>"}, -- Only show which-key for leader
        triggers_nowait = {}, -- Don't use nowait triggers
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
        show_help = true,
        show_keys = true,
      })
      
      -- Register key groups
      wk.register({
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code/lsp" },
        ["<leader>d"] = { name = "+docs" },
        ["<leader>dm"] = { name = "+ml-docs" },
        ["<leader>e"] = { name = "+explorer" },
        ["<leader>f"] = { name = "+find/file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>k"] = { name = "+keymaps" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>p"] = { name = "+python/env/dependencies" },
        ["<leader>r"] = { name = "+run/requirements" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>u"] = { name = "+utilities" },
        ["<leader>w"] = { name = "+window/tab" },
        ["<leader>x"] = { name = "+execute" },
        ["<leader>z"] = { name = "+zen/focus" },
        ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
      })
    end
  },
}
