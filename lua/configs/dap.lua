-- Debugger configuration for backend development languages
local dap = require("dap")

-- Python configuration
dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      -- Find python from the current environment
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        return venv_path .. "/bin/python"
      end
      -- Default to system python if no venv is activated
      return "/usr/bin/python3"
    end,
  },
}

-- Go configuration
dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = {"dap", "-l", "127.0.0.1:${port}"},
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test file",
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test package",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }
}

-- C/C++ configuration
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- Adjust this path based on your Mac setup
  name = 'lldb'
}

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
  },
}

dap.configurations.c = dap.configurations.cpp

-- Define some visual signs for breakpoints and debugging
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='🟠', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='DapStoppedLine', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='⛔', texthl='', linehl='', numhl=''})
