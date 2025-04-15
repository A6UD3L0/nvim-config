-- Configure nvim-notify with rose-pine-moon background color
require("notify").setup({
  -- Use rose-pine-moon background color for notifications
  -- #232136 is the rose-pine-moon base color
  background_colour = "#232136",
  
  -- Styling
  stages = "fade",
  timeout = 3000,
  
  -- Max width as percentage of screen width
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
  
  -- Max height as percentage of screen height
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  
  -- Icons for different message levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

-- Set as default notify handler
vim.notify = require("notify")
