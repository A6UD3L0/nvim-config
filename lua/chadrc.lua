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
  },
  
  -- Custom highlights specific to plugins
  hl_add = {
    -- Better dashboard highlighting
    NvDashAscii = { fg = "#c6a0f6", bold = true },
    NvDashButtons = { fg = "#8bd5ca" },
    
    -- Telescope enhancements
    TelescopePromptPrefix = { fg = "#c6a0f6" },
    TelescopePromptTitle = { fg = "#c6a0f6", bold = true },
    
    -- LSP and diagnostics with softer colors
    DiagnosticVirtualTextError = { fg = "#ed8796", bg = "#35293b" },
    DiagnosticVirtualTextWarn = { fg = "#f5a97f", bg = "#38333b" },
    DiagnosticVirtualTextInfo = { fg = "#8bd5ca", bg = "#2e3444" },
    DiagnosticVirtualTextHint = { fg = "#a6da95", bg = "#2d382d" },
    
    -- Data Science related highlights
    JupyniumCodeCell = { bg = "#303347" },
    JupyniumMarkdownCell = { bg = "#2d2e3b" },
  },
  
  -- Add some transparency to floating windows
  transparency = false,
}

--------------------------------------------------------------------------------
-- nvdash: Dashboard (Startup Screen) Configuration
--------------------------------------------------------------------------------
M.nvdash = {
  load_on_startup = true,  -- Automatically load the dashboard on Neovim start.
  header = {
    "██████╗  █████╗  ██████╗██╗  ██╗███████╗███╗   ██╗██████╗ ",
    "██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝████╗  ██║██╔══██╗",
    "██████╔╝███████║██║     █████╔╝ █████╗  ██╔██╗ ██║██║  ██║",
    "██╔══██╗██╔══██║██║     ██╔═██╗ ██╔══╝  ██║╚██╗██║██║  ██║",
    "██████╔╝██║  ██║╚██████╗██║  ██╗███████╗██║ ╚████║██████╔╝",
    "╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═════╝ ",
    " & DATA SCIENCE        Optimized for Development        ",
  },
  
  buttons = {
    { "  Find File", "Spc f f", "Telescope find_files" },
    { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
    { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
    { "  Bookmarks", "Spc m a", "Telescope marks" },
    { "  Learn Keys", "Spc k m", "KeyMap" },
    { "  Mason", "Mason", "Mason" },
  },
}

--------------------------------------------------------------------------------
-- UI: Additional Interface Component Customizations
--------------------------------------------------------------------------------
M.ui = {
  -- Show dashboard on startup
  nvdash = { load_on_startup = true },
  
  -- Status line config
  statusline = {
    theme = "default",
    separator_style = "block",
    overriden_modules = nil,
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
}

-- Required for NvChad
return M
