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
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    ["@keyword"] = { italic = true },
    ["@variable"] = { bold = false },
    ["@function"] = { bold = true },
    ["@type"] = { bold = true },
    ["@parameter"] = { italic = true },
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
    "    & DATA SCIENCE        Optimized for Development        ",
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
  },
  
  -- Terminal settings
  terminal = {
    float_opts = {
      border = "single",
    },
  },
  
  -- Improved visual feedback
  hl_add = {},
  cmp = {
    style = "default", -- Better completion menu style
  },
  
  -- Telescope theme
  telescope = { style = "bordered" },
  
  -- Better icons for code navigation
  lsp = {
    signature = { enabled = true },
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
  },
  
  -- Treesitter folding for better code organization
  telescope = {
    extensions_list = { "themes", "terms", "fzf" },
  },
}

-- Required for NvChad
return M
