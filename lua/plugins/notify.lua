-- Configure nvim-notify with a completely black background
return {
  name = "notify_config",
  config = function()
    -- Only load if the plugin is available
    local status_ok, notify = pcall(require, "nvim-notify")
    if not status_ok then
      -- If nvim-notify isn't available, don't try to configure it
      vim.notify("nvim-notify plugin not found. Please install rcarriga/nvim-notify", vim.log.levels.WARN)
      return
    end
    
    -- Set background_colour directly via highlight groups first to prevent notification
    vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
    
    -- This setup will now not show the example notification
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
      
      -- Prevent notification about the background color itself
      silent = true,
    })
    
    -- Only set as notify handler if it loaded successfully
    vim.notify = notify
  end
}
