-- ADHD-Friendly Theme Configuration
-- Based on research about colors that help with focus and attention

local M = {}

-- Color palette specifically designed for ADHD
-- Combines calming colors (blues, greens, muted browns) with strategic accent colors
M.colors = {
  -- Calming Base Colors
  bg = "#1d2021", -- Deep muted brown - calming background
  fg = "#c8ccd4", -- Light neutral - easy on the eyes
  
  -- Blues - create sense of tranquility and stability
  blue1 = "#5CB8E4", -- Soft sky blue - main accent
  blue2 = "#266D98", -- Deeper blue - secondary accent
  blue3 = "#1F5673", -- Dark blue - subtle elements
  
  -- Greens - balance, harmony, focus
  green1 = "#8fc8a9", -- Soft sage green - positive indicators
  green2 = "#5d8d72", -- Medium green - secondary elements
  green3 = "#3a5f49", -- Deep green - tertiary elements
  
  -- Earth Tones - grounding and calming
  brown1 = "#ab9683", -- Soft brown - neutral accent
  brown2 = "#7d6655", -- Medium brown - borders and separators
  
  -- Strategic Accent Colors - for important elements only
  yellow = "#e2d07a", -- Muted yellow - warnings, search highlights
  orange = "#e39a50", -- Soft orange - important elements, modified files
  red = "#d57a7a",    -- Muted red - errors, deletions
  
  -- Additional Support Colors
  purple = "#b48ead", -- Muted purple - special text, keywords
  cyan = "#92c5c5",   -- Soft teal - strings, links
  
  -- UI Elements
  selection = "#394149", -- Subtle selection highlight
  comment = "#7c8a94",   -- Muted blue-gray for less distracting comments
  line = "#2a2e32",      -- Current line highlight
  panel_bg = "#1a1c1e",  -- Darker for panels
  
  none = "NONE",
}

-- Apply this color palette to customize any theme
function M.setup()
  -- Check if we can access the colorscheme API
  if vim.g.colors_name then
    -- Store the current color scheme
    local current_scheme = vim.g.colors_name
    
    -- Define highlight groups using our ADHD-friendly palette
    local highlights = {
      -- Editor UI
      Normal = { fg = M.colors.fg, bg = M.colors.bg },
      LineNr = { fg = M.colors.comment },
      CursorLine = { bg = M.colors.line },
      Search = { fg = M.colors.bg, bg = M.colors.yellow },
      IncSearch = { fg = M.colors.bg, bg = M.colors.orange },
      
      -- Syntax
      Comment = { fg = M.colors.comment, italic = true },
      String = { fg = M.colors.cyan },
      Keyword = { fg = M.colors.purple, bold = true },
      Function = { fg = M.colors.blue1 },
      Identifier = { fg = M.colors.blue2 },
      Constant = { fg = M.colors.orange },
      Type = { fg = M.colors.green1 },
      Statement = { fg = M.colors.purple },
      
      -- Diagnostics - color coded but not too distracting
      DiagnosticError = { fg = M.colors.red },
      DiagnosticWarn = { fg = M.colors.yellow },
      DiagnosticInfo = { fg = M.colors.blue1 },
      DiagnosticHint = { fg = M.colors.green1 },
      
      -- Git indicators
      GitSignsAdd = { fg = M.colors.green1 },
      GitSignsChange = { fg = M.colors.blue1 },
      GitSignsDelete = { fg = M.colors.red },
      
      -- Status line
      StatusLine = { fg = M.colors.fg, bg = M.colors.panel_bg },
      StatusLineNC = { fg = M.colors.comment, bg = M.colors.panel_bg },
      
      -- Tab line
      TabLine = { fg = M.colors.comment, bg = M.colors.panel_bg },
      TabLineSel = { fg = M.colors.fg, bg = M.colors.blue3 },
      TabLineFill = { bg = M.colors.panel_bg },
      
      -- Special highlighting for important elements
      MatchParen = { fg = M.colors.orange, bold = true },
      Visual = { bg = M.colors.selection },
      
      -- Terminal colors
      Terminal = { fg = M.colors.fg, bg = M.colors.bg },
    }
    
    -- Apply our highlights
    for group, settings in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, settings)
    end
    
    vim.notify("Applied ADHD-friendly color enhancements", vim.log.levels.INFO)
  else
    vim.notify("No active colorscheme found", vim.log.levels.WARN)
  end
end

-- Apply colors to lualine if it's available
function M.setup_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then return end
  
  -- Define a custom lualine theme based on our ADHD color palette
  local lualine_theme = {
    normal = {
      a = { fg = M.colors.bg, bg = M.colors.blue1, gui = 'bold' },
      b = { fg = M.colors.fg, bg = M.colors.blue3 },
      c = { fg = M.colors.fg, bg = M.colors.panel_bg }
    },
    insert = {
      a = { fg = M.colors.bg, bg = M.colors.green1, gui = 'bold' },
      b = { fg = M.colors.fg, bg = M.colors.green3 },
      c = { fg = M.colors.fg, bg = M.colors.panel_bg }
    },
    visual = {
      a = { fg = M.colors.bg, bg = M.colors.purple, gui = 'bold' },
      b = { fg = M.colors.fg, bg = M.colors.blue3 },
      c = { fg = M.colors.fg, bg = M.colors.panel_bg }
    },
    replace = {
      a = { fg = M.colors.bg, bg = M.colors.orange, gui = 'bold' },
      b = { fg = M.colors.fg, bg = M.colors.blue3 },
      c = { fg = M.colors.fg, bg = M.colors.panel_bg }
    },
    command = {
      a = { fg = M.colors.bg, bg = M.colors.yellow, gui = 'bold' },
      b = { fg = M.colors.fg, bg = M.colors.blue3 },
      c = { fg = M.colors.fg, bg = M.colors.panel_bg }
    },
    inactive = {
      a = { fg = M.colors.comment, bg = M.colors.panel_bg, gui = 'bold' },
      b = { fg = M.colors.comment, bg = M.colors.panel_bg },
      c = { fg = M.colors.comment, bg = M.colors.panel_bg }
    }
  }
  
  -- Update lualine configuration with our theme
  lualine.setup {
    options = {
      theme = lualine_theme,
      component_separators = '|',
      section_separators = '',
    }
  }
  
  vim.notify("Applied ADHD-friendly lualine theme", vim.log.levels.INFO)
end

-- Call this once to apply the theme enhancements
vim.api.nvim_create_user_command("ApplyADHDTheme", function()
  M.setup()
  M.setup_lualine()
end, {})

return M
