local M = {}

function M.setup()
  -- Initialize Mason first
  local mason_status, mason = pcall(require, "mason")
  if mason_status then
    mason.setup()
  end

  -- Load all configuration modules in the correct order
  require("configs.lazy")           -- Load plugin manager first
  require("configs.lspconfig")      -- Load LSP config
  require("configs.telescope")      -- Load telescope
  require("configs.dap")            -- Load DAP first
  require("configs.dapui")          -- Then load DAP UI
  require("configs.conform")        -- Load formatter
  require("configs.commands")       -- Load custom commands
  require("configs.copilot_patches") -- Load copilot patches
end

return M 