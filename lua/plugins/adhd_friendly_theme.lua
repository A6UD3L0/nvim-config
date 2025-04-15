-- Define the colors once at the module level
local colors = {
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

-- Create a local module
local M = {}

-- Expose colors for use by other modules
M.colors = colors

-- Function to apply highlights
function M.setup()
  -- Check if we can access the colorscheme API
  if not vim.g.colors_name then
    -- Set a default colorscheme first 
    pcall(vim.cmd.colorscheme, "default")
  end
  
  -- Define highlight groups using our ADHD-friendly palette
  local highlights = {
    -- Editor UI
    Normal = { fg = colors.fg, bg = colors.bg },
    LineNr = { fg = colors.comment },
    CursorLine = { bg = colors.line },
    Search = { fg = colors.bg, bg = colors.yellow },
    IncSearch = { fg = colors.bg, bg = colors.orange },
    
    -- Syntax
    Comment = { fg = colors.comment, italic = true },
    String = { fg = colors.cyan },
    Keyword = { fg = colors.purple, bold = true },
    Function = { fg = colors.blue1 },
    Identifier = { fg = colors.blue2 },
    Constant = { fg = colors.orange },
    Type = { fg = colors.green1 },
    Statement = { fg = colors.purple },
    
    -- Diagnostics - color coded but not too distracting
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.blue1 },
    DiagnosticHint = { fg = colors.green1 },
    
    -- Git indicators
    GitSignsAdd = { fg = colors.green1 },
    GitSignsChange = { fg = colors.blue1 },
    GitSignsDelete = { fg = colors.red },
    
    -- Status line
    StatusLine = { fg = colors.fg, bg = colors.panel_bg },
    StatusLineNC = { fg = colors.comment, bg = colors.panel_bg },
    
    -- Tab line
    TabLine = { fg = colors.comment, bg = colors.panel_bg },
    TabLineSel = { fg = colors.fg, bg = colors.blue3 },
    TabLineFill = { bg = colors.panel_bg },
    
    -- Special highlighting for important elements
    MatchParen = { fg = colors.orange, bold = true },
    Visual = { bg = colors.selection },
    
    -- Terminal colors
    Terminal = { fg = colors.fg, bg = colors.bg },
  }
  
  -- Apply our highlights
  for group, settings in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, settings)
  end
  
  vim.notify("ADHD-friendly color enhancements applied", vim.log.levels.INFO)
end

-- Apply colors to lualine if it's available
function M.setup_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then return end
  
  -- Define a custom lualine theme based on our ADHD color palette
  local lualine_theme = {
    normal = {
      a = { fg = colors.bg, bg = colors.blue1, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.blue3 },
      c = { fg = colors.fg, bg = colors.panel_bg }
    },
    insert = {
      a = { fg = colors.bg, bg = colors.green1, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.green3 },
      c = { fg = colors.fg, bg = colors.panel_bg }
    },
    visual = {
      a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.blue3 },
      c = { fg = colors.fg, bg = colors.panel_bg }
    },
    replace = {
      a = { fg = colors.bg, bg = colors.orange, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.blue3 },
      c = { fg = colors.fg, bg = colors.panel_bg }
    },
    command = {
      a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.blue3 },
      c = { fg = colors.fg, bg = colors.panel_bg }
    },
    inactive = {
      a = { fg = colors.comment, bg = colors.panel_bg, gui = 'bold' },
      b = { fg = colors.comment, bg = colors.panel_bg },
      c = { fg = colors.comment, bg = colors.panel_bg }
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
end

-- Create user command to apply the theme
vim.api.nvim_create_user_command("ApplyADHDTheme", function()
  M.setup()
  M.setup_lualine()
end, {})

-- Return the module
return M
