-- Configure nvim-notify with a completely black background
-- Only load if the plugin is available
local status_ok, notify = pcall(require, "nvim-notify")
if not status_ok then
  -- If nvim-notify isn't available, don't try to configure it
  vim.notify("nvim-notify plugin not found. Please install rcarriga/nvim-notify", vim.log.levels.WARN)
  return
end

notify.setup({
  -- Use completely black background for notifications
  background_colour = "#000000",
  
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

-- Only set as notify handler if it loaded successfully
vim.notify = notify
