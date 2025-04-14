-- Go debugging configuration
local M = {}

function M.setup()
  local dap = require("dap")
  
  -- Configure Go adapter (uses Delve)
  dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/packages/delve/dlv',
      args = {'dap', '-l', '127.0.0.1:${port}'},
    }
  }
  
  -- Configure Go configurations
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test", -- Run specific test file
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    {
      type = "delve",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('dap.utils').pick_process,
    },
    {
      type = "delve",
      name = "Debug main package",
      request = "launch",
      program = "./"
    },
  }
end

return M
