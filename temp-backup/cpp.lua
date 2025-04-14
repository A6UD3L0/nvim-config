-- C/C++ debugging configuration
local M = {}

function M.setup()
  local dap = require("dap")
  
  -- Configure LLDB adapter for C/C++
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- Adjust path if needed
    name = 'lldb'
  }
  
  -- Configure C/C++ configurations (uses LLDB)
  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
    {
      name = 'Attach to process',
      type = 'lldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
      runInTerminal = false,
    },
  }
  
  -- Use the same configuration for C
  dap.configurations.c = dap.configurations.cpp
end

return M
