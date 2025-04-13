-- NvChad configuration with enhancements for backend development and data science
-- Reference: https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

--------------------------------------------------------------------------------
-- Base46: Colors, Themes, and Highlight Customizations
--------------------------------------------------------------------------------
M.base46 = {
  -- Choose a dark theme good for coding
  theme = "catppuccin",
  
  -- Highlight overrides for better code readability
  hl_override = {
    Comment = { italic = true, fg = "#63677f" },
    ["@comment"] = { italic = true, fg = "#63677f" },
    ["@keyword"] = { italic = true, bold = true },
    ["@variable"] = { bold = false },
    ["@function"] = { bold = true },
    ["@method"] = { bold = true, italic = false },
    ["@type"] = { bold = true },
    ["@parameter"] = { italic = true },
    ["@string"] = { fg = "#a6da95" },
    ["@number"] = { fg = "#f5a97f" },
    ["@operator"] = { fg = "#8bd5ca" },
    ["@punctuation.bracket"] = { fg = "#b7bdf8" },
    
    -- Data science specific highlights for better readability
    ["@variable.builtin"] = { fg = "#ed8796", italic = true }, -- For Python builtins
    ["@field"] = { fg = "#ed8796" }, -- For dataframe fields and properties
    
    -- Improved diff and git highlighting
    DiffAdd = { fg = "#a6da95", bg = "#2d382d" },
    DiffChange = { fg = "#f0c6c6", bg = "#342d3b" },
    DiffDelete = { fg = "#ed8796", bg = "#3b2d35" },
    
    -- Line numbers and cursor
    LineNr = { fg = "#63677f" },
    CursorLineNr = { fg = "#c6a0f6", bold = true },
    CursorLine = { bg = "#303347" },
    
    -- WhichKey specific colors for better visibility
    WhichKey = { fg = "#c6a0f6", bold = true },
    WhichKeyDesc = { fg = "#8bd5ca" },
    WhichKeyGroup = { fg = "#ed8796" },
    WhichKeySeperator = { fg = "#63677f" },
    WhichKeySeparator = { fg = "#63677f" },
    WhichKeyFloat = { bg = "#1e1e2e" },
    WhichKeyValue = { fg = "#63677f" },
  },
  
  -- Custom highlights specific to plugins
  hl_add = {
    -- Better dashboard highlighting
    NvDashAscii = { fg = "#c6a0f6", bold = true },
    NvDashButtons = { fg = "#8bd5ca" },
    
    -- Telescope enhancements
    TelescopePromptPrefix = { fg = "#c6a0f6" },
  },
  
  -- Configure transparency (disabled by default)
  transparency = false,
}

--------------------------------------------------------------------------------
-- nvdash: Dashboard (Startup Screen) Configuration
--------------------------------------------------------------------------------
M.nvdash = {
  load_on_startup = true,  -- Automatically load the dashboard on Neovim start.
  header = {
    "                                            ",
    "      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗ ",
    "      ████╗  ██║██╔════╝██╔═══██╗██║   ██║ ",
    "      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║ ",
    "      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝ ",
    "      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝  ",
    "      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝   ",
    "                                            ",
    "       Press SPACE + SPACE to see all keybindings",
    "                                            ",
  },
  buttons = {
    { "  Find File", "Spc f f", "Telescope find_files" },
    { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
    { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
    { "  Bookmarks", "Spc m a", "Telescope marks" },
    { "  Themes", "Spc t h", "Telescope themes" },
    { "  Mappings", "Spc + SPACE", "WhichKey" },
  },
}

--------------------------------------------------------------------------------
-- UI: Additional Interface Component Customizations
--------------------------------------------------------------------------------
M.ui = {
  -- Theme settings from updated configuration
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "one_light" },
  
  -- Set up a nice terminal color scheme that matches editor
  terminal_colors = true,
  
  -- Status line config
  statusline = {
    theme = "catppuccin",   -- Match with main theme
    separator_style = "round",
    overriden_modules = function()
      return {
        mode = function()
          local modes = {
            ["n"] = { "NORMAL", "St_NormalMode" },
            ["niI"] = { "NORMAL i", "St_NormalMode" },
            ["niR"] = { "NORMAL r", "St_NormalMode" },
            ["niV"] = { "NORMAL v", "St_NormalMode" },
            ["no"] = { "N-PENDING", "St_NormalMode" },
            ["i"] = { "INSERT", "St_InsertMode" },
            ["ic"] = { "INSERT", "St_InsertMode" },
            ["ix"] = { "INSERT", "St_InsertMode" },
            ["t"] = { "TERMINAL", "St_TerminalMode" },
            ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
            ["v"] = { "VISUAL", "St_VisualMode" },
            ["V"] = { "V-LINE", "St_VisualMode" },
            ["Vs"] = { "V-LINE", "St_VisualMode" },
            [""] = { "V-BLOCK", "St_VisualMode" },
            ["R"] = { "REPLACE", "St_ReplaceMode" },
            ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
            ["s"] = { "SELECT", "St_SelectMode" },
            ["S"] = { "S-LINE", "St_SelectMode" },
            [""] = { "S-BLOCK", "St_SelectMode" },
            ["c"] = { "COMMAND", "St_CommandMode" },
            ["cv"] = { "COMMAND", "St_CommandMode" },
            ["ce"] = { "COMMAND", "St_CommandMode" },
            ["r"] = { "PROMPT", "St_ConfirmMode" },
            ["rm"] = { "MORE", "St_ConfirmMode" },
            ["r?"] = { "CONFIRM", "St_ConfirmMode" },
            ["!"] = { "SHELL", "St_TerminalMode" },
          }

          local m = vim.api.nvim_get_mode().mode
          return " %#" .. modes[m][2] .. "# " .. modes[m][1] .. " %#St_EmptySpace#"
        end,
      }
    end,
  },
  
  -- Tab configuration
  tabufline = {
    show_numbers = true,
    enabled = true,
    lazyload = false,
    overriden_modules = nil,
  },
  
  -- Terminal settings
  terminal = {
    float_opts = {
      border = "rounded",
      width = 90,
      height = 30,
    },
  },
  
  -- Improved visual feedback
  hl_add = {},
  cmp = {
    style = "atom", -- Better completion menu style
    border_color = "teal",
    selected_item_bg = "colored",
  },
  
  -- Telescope theme
  telescope = { 
    style = "bordered",
    border_color = "teal",
  },
  
  -- Better icons for code navigation
  lsp = {
    signature = { enabled = true },
    hover = { enabled = true },
  },
  
  -- Notification appearance
  notify = {
    enabled = true,
    border = "rounded",
    minimal = false,
  },
  
  -- Theme settings
  theme = {
    name = "catppuccin",  -- Use catppuccin as the primary theme
    style = "mocha",      -- Choose mocha style (options: latte, frappe, macchiato, mocha)
    transparency = false, -- Set to true for transparent background
    
    -- Override specific theme properties
    custom = {
      -- Override specific colors if desired
      bg = "#1E1E2E", -- Dark background
      
      -- Override specific highlights for elements
      highlights = {
        -- Example: make current line number stand out more
        CursorLineNr = { fg = "#89B4FA" },
        
        -- Make which-key look better
        WhichKeyFloat = { bg = "#1E1E2E" },
        
        -- Make comments more visible
        Comment = { fg = "#9399B2", italic = true },
        
        -- Better diagnostic highlights
        DiagnosticError = { fg = "#F38BA8" },
        DiagnosticWarn = { fg = "#FAB387" },
        DiagnosticInfo = { fg = "#89B4FA" },
        DiagnosticHint = { fg = "#A6E3A1" },
      },
    },
  },
}

--------------------------------------------------------------------------------
-- NvChad features
--------------------------------------------------------------------------------
M.nvchad = {
  updater = {
    enable = true,
  },
}

--------------------------------------------------------------------------------
-- Plugins specific configuration that affects UI
--------------------------------------------------------------------------------
M.plugins = {
  -- NvimTree config for better file navigation
  nvimtree = {
    git = {
      enable = true,
    },
    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
    view = {
      side = "left",
      width = 30,
    },
    ui = {
      confirm = {
        remove = true,
        trash = true,
      },
    },
  },
  
  -- Treesitter folding for better code organization
  telescope = {
    extensions_list = { "themes", "terms", "fzf" },
    style = "bordered",
  },
  
  -- LSP configuration
  lspconfig = {
    border = "rounded",
  },
  
  -- Which-key specific settings
  which_key = {
    window = {
      border = "rounded",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "center",
    },
    icons = {
      breadcrumb = "»", 
      separator = "➜",
      group = "+",
    },
  },
}

-- Required for NvChad
return M
