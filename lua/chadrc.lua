-- This file needs to have the same structure as nvconfig.lua
-- Reference: https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Also inspired by A6UD3L0's nvim-config:
-- https://github.com/A6UD3L0/nvim-config/blob/main/lua/

---@type ChadrcConfig
local M = {}

--------------------------------------------------------------------------------
-- Base46: Colors, Themes, and Highlight Customizations
--------------------------------------------------------------------------------
M.base46 = {
  theme = "vscode_dark",  -- Choose your color theme.

  -- Customize highlight overrides here.
  -- Uncomment to adjust appearance (e.g., make comments italic).
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

--------------------------------------------------------------------------------
-- nvdash: Dashboard (Startup Screen) Configuration
--------------------------------------------------------------------------------
M.nvdash = {
  load_on_startup = true,  -- Automatically load the dashboard on Neovim start.
  header = {
    "███████╗██╗   ██╗ ██████╗ ██╗     ",
    "██╔════╝██║   ██║██╔════╝ ██║     ",
    "█████╗  ██║   ██║██║  ███╗██║     ",
    "██╔══╝  ██║   ██║██║   ██║██║     ",
    "██║     ╚██████╔╝╚██████╔╝███████╗",
    "╚═╝      ╚═════╝  ╚═════╝ ╚══════╝",
    "Welcome to Neovim with NvChad",
    "Inspired by A6UD3L0's config",
  },
}

--------------------------------------------------------------------------------
-- UI: Additional Interface Component Customizations
--------------------------------------------------------------------------------
M.ui = {
  tabufline = {
    lazyload = false,    -- Ensure the tab line is loaded immediately.
    style = "default",   -- Modify with alternative styles if desired.
  },
  statusline = {
    theme = "vscode_dark",  -- Keep the statusline consistent with the overall theme.
    -- Extend with custom sections or icons if needed.
  },
  -- Additional UI elements (winbar, sidebar, etc.) can be added here.
}

--------------------------------------------------------------------------------
-- Return the configuration table.
--------------------------------------------------------------------------------
return M
