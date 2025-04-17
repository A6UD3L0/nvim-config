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
        dim_inactive = true, -- dims inactive windows
        lualine_bold = false, -- When true, section headers in the lualine theme will be bold
        
        -- Add on_colors function to customize specific colors
        on_colors = function(colors)
          colors.border = "#3d59a1"  -- Distinctive border color
          colors.comment = "#737aa2"  -- More visible comments
        end,
        
        -- Add on_highlights function to enhance specific syntax elements
        on_highlights = function(highlights, colors)
          highlights.TelescopeBorder = { fg = colors.border }
          highlights.LineNr = { fg = "#3b4261" }
          highlights.CursorLineNr = { fg = colors.orange, bold = true }
        end,
      }

      -- Set colorscheme after options
      vim.cmd "colorscheme tokyonight"
    end,
  },

  -- Bufferline - Styled tab/buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup {
        options = {
          mode = "buffers",
          close_command = "Bdelete! %d",
          right_mouse_command = "Bdelete! %d",
          separator_style = "slant",
          always_show_bufferline = false,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local icons = {
              Error = " ",
              Warn = " ",
              Hint = " ",
              Info = " "
            }
            local ret = {}
            for severity, icon in pairs(icons) do
              if diag[severity] then
                table.insert(ret, icon)
              end
            end
            return table.concat(ret, " ")
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
        }
      }
    end
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
          disabled_filetypes = { 
            statusline = { "alpha", "dashboard" },
            winbar = { "alpha", "dashboard", "NvimTree" },
          },
        },
        sections = {
          lualine_a = { {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
            padding = { left = 2, right = 2 },
          } },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "[No Name]" } }, -- 0 = just filename, 1 = relative path, 2 = absolute path
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          },
          lualine_x = {
            { 
              function() return '  ' .. vim.pesc(vim.bo.filetype:upper()) end,
              cond = function() return vim.bo.filetype ~= '' end 
            },
            { "encoding" },
            { "fileformat", symbols = { unix = " UNIX", dos = " WIN", mac = " MAC" } },
          },
          lualine_y = { 
            { "progress" },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = { 
            function()
              local secs = os.time()
              return " " .. os.date("%H:%M", secs)
            end,
            padding = { left = 1, right = 2 },
          },
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix", "fugitive" },
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
        stages = "fade_in_slide_out",
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
      -- Using the nvim-notify plugin defined above
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
        messages = {
          enabled = true,
          view = "notify", -- Use the fancy notification system
          view_error = "notify", -- Special view for errors
          view_warn = "notify", -- Special view for warnings
          view_history = "messages", -- View for :messages
          view_search = "virtualtext", -- View for search count messages
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
            silent = false, -- Show a notification when there's no hover information
            view = nil, -- Use the default view
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing a trigger character
              luasnip = true, -- Auto-open signature help when passing a luasnip snippet argument
              throttle = 50, -- Throttle the signature help request
            },
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              replace = true,
              render = "plain",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
        },
        smart_move = {
          enabled = true, -- Smart move popups away from the cursor
          excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        views = {
          cmdline_popup = {
            position = {
              row = 5,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
          },
          popupmenu = {
            relative = "cmdline",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
      }
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
  
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { enabled = true },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      }
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup {
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb'},
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "sine",
        pre_hook = nil,
        post_hook = nil,
      }
    end
  },
  
  -- Better UI for code actions, rename, etc.
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        prompt_align = "left",
        insert_only = true,
        anchor = "SW",
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        win_options = {
          winblend = 0,
          winhighlight = "Normal:Normal,NormalNC:Normal",
        },
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },
        override = function(conf)
          return conf
        end,
        get_config = nil,
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        trim_prompt = true,
        telescope = nil,
        builtin = {
          anchor = "NW",
          border = "rounded",
          relative = "editor",
          win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal,NormalNC:Normal",
          },
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          override = function(conf)
            return conf
          end,
        },
        format_item_override = {},
        get_config = nil,
      },
    },
  },
}
