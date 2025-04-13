-- Health check compatibility layer for Neovim 0.11.0+
local M = {}

-- Create compatibility layer for health reporting
function M.setup_health_compat()
  -- Only set up if vim.health is already defined (Neovim 0.10+)
  if vim.health then
    -- Check if we need to set up compatibility for vim.health
    if not vim.health.report_start then
      -- Store original vim.health
      local health = vim.health
      
      -- Create compatibility layer for report functions
      vim.health.report_start = vim.health.start or function(msg) vim.notify("Health check: " .. msg, vim.log.levels.INFO) end
      vim.health.report_ok = vim.health.ok or function(msg) vim.notify("Health OK: " .. msg, vim.log.levels.INFO) end
      vim.health.report_warn = vim.health.warn or function(msg) vim.notify("Health WARNING: " .. msg, vim.log.levels.WARN) end
      vim.health.report_error = vim.health.error or function(msg) vim.notify("Health ERROR: " .. msg, vim.log.levels.ERROR) end
      vim.health.report_info = vim.health.info or function(msg) vim.notify("Health INFO: " .. msg, vim.log.levels.INFO) end
    end
  end
end

return M
