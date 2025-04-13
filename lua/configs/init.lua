local M = {}

function M.setup()
  -- Load all configuration modules
  require("configs.lspconfig")
  require("configs.telescope")
  require("configs.dap")
  require("configs.conform")
  require("configs.commands")
  require("configs.lazy")
  require("configs.copilot_patches")

  -- Initialize Mason
  local mason_status, mason = pcall(require, "mason")
  if mason_status then
    mason.setup()
  end
end

return M 