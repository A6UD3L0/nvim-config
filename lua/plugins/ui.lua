-- Modern, streamlined UI components for Neovim
return {
  -- Tokyo Night Theme - A clean, dark theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- Load first
    config = function()
      require("tokyonight").setup {
        style = "night", -- The theme comes in night, storm, day, and moon variants
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal`
        styles = {
          -- Style to be applied to different syntax groups
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark", -- style for sidebars
          floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help", "terminal", "telescope", "explorer", "packer" }, -- Set a darker background on sidebar-like windows
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
        hide_inactive_statusline = false, -- Hide inactive statuslines
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When true, section headers in the lualine theme will be bold
      }

      -- Set colorscheme after options
      vim.cmd "colorscheme tokyonight"
    end,
  },

  -- Status line (lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup {
        options = {
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          } },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filename", path = 1 }, -- 0 = just filename, 1 = relative path, 2 = absolute path
            { "diagnostics", sources = { "nvim_diagnostic" } },
          },
          lualine_x = {
            { "encoding" },
            { "fileformat" },
            { "filetype", icon_only = true },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      }
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      notify.setup {
        background_colour = "#000000",
        fps = 60,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = "",
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade",
        timeout = 3000,
        top_down = true,
      }
      vim.notify = notify
    end,
  },

  -- Improved command line experience (centered command line)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        cmdline = {
          enabled = true,
          view = "cmdline_popup", -- "cmdline_popup" for centered popup
          format = {
            cmdline = { icon = ">" },
            search_down = { icon = "🔍⌄" },
            search_up = { icon = "🔍⌃" },
            filter = { icon = "$" },
            lua = { icon = "☾" },
            help = { icon = "?" },
          },
        },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
          },
          signature = {
            enabled = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
    end,
  },

  -- Dashboard (start screen)
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup()
    end,
  },

  -- Which-key for better keybindings display
  {
    "folke/which-key.nvim",
    lazy = false,
    priority = 100,
    config = function()
      -- Do not configure which-key here, use the centralized setup
      -- We'll let which_key_setup.lua handle the configuration
    end
  },

  -- Telescope UI/UX improvements
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup {
        defaults = {
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          entry_prefix = "  ",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            width = 0.95,
            height = 0.85,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
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
    end,
  },

  -- NvimTree UI/UX improvements
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 35,
          side = "right",
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "all",
          root_folder_label = ":t",
          indent_markers = {
            enable = true,
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
          custom = { ".git", "node_modules", ".cache" },
        },
        update_cwd = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
      }
    end,
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
            package_uninstalled = "✗",
          },
        },
      }
    end,
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
    end,
  },

  -- LSP UI/UX improvements (if using lspsaga)
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup {
        ui = {
          border = "rounded",
          code_action = "💡",
          colors = {
            normal_bg = "#1e2030",
          },
        },
      }
    end,
  },
}
