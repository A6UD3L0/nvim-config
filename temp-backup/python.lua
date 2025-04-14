-- Python debugging configuration
local M = {}

function M.setup()
  local dap = require("dap")
  
  -- Configure Python adapter
  dap.adapters.python = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
    args = { '-m', 'debugpy.adapter' },
  }
  
  -- Configure Python configurations
  dap.configurations.python = {
    {
      -- The first configuration will be the default one used
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = "${file}",
      pythonPath = function()
        -- Try to detect python path from virtual environment
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path then
          return venv_path .. "/bin/python"
        end
        
        -- Fallback to system Python
        return '/usr/bin/python3'
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch with arguments',
      program = "${file}",
      args = function()
        local args_string = vim.fn.input('Arguments: ')
        return vim.split(args_string, " ")
      end,
      pythonPath = function()
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path then
          return venv_path .. "/bin/python"
        end
        return '/usr/bin/python3'
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Django',
      program = "${workspaceFolder}/manage.py",
      args = {'runserver', '--noreload'},
      pythonPath = function()
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path then
          return venv_path .. "/bin/python"
        end
        return '/usr/bin/python3'
      end,
      django = true,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Flask',
      module = 'flask',
      args = {'run', '--no-debugger', '--no-reload'},
      env = {
        FLASK_APP = "${workspaceFolder}/app.py",
        FLASK_ENV = "development",
      },
      pythonPath = function()
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path then
          return venv_path .. "/bin/python"
        end
        return '/usr/bin/python3'
      end,
    },
    {
      type = 'python',
      request = 'attach',
      name = 'Attach remote',
      connect = {
        host = function()
          return vim.fn.input('Host [127.0.0.1]: ', '127.0.0.1')
        end,
        port = function()
          return tonumber(vim.fn.input('Port [5678]: ', '5678'))
        end,
      },
    },
  }
end

return M
