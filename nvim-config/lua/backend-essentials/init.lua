-- Backend Development and Data Science essential configurations
-- This file consolidates the core functionality needed for backend development

local M = {}

-- Backend development language servers configuration
M.setup_lsp = function()
  -- LSP setup is now handled by the plugins/backend-essentials.lua file
  -- This function is kept for compatibility with the init.lua file
  
  -- Add any additional LSP configuration here if needed
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      
      -- Set autoformatting on save for supported languages
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            -- Don't format if the user has disabled it
            if vim.g.disable_autoformat then
              return
            end
            vim.lsp.buf.format({
              buffer = bufnr,
              timeout_ms = 3000,
            })
          end,
        })
      end
    end,
  })
  
  -- Add command to toggle autoformatting
  vim.api.nvim_create_user_command("FormatToggle", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Autoformatting on save: " .. (vim.g.disable_autoformat and "Disabled" or "Enabled"))
  end, {})
end

-- Backend development tools setup
M.setup_tools = function()
  -- Initialize terminals and Python runners
  local Terminal = require("toggleterm.terminal").Terminal
  
  -- Python terminal
  local python = Terminal:new({
    cmd = "python3",
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
    end,
  })
  
  -- Expose Python terminal function
  _G._PYTHON_TOGGLE = function()
    python:toggle()
  end
  
  -- Function to run current Python file
  _G._PYTHON_RUN_FILE = function()
    local file = vim.fn.expand("%:p")
    local python_exec = Terminal:new({
      cmd = "python3 " .. file,
      direction = "horizontal",
      close_on_exit = false,
      on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
        vim.cmd("startinsert!")
      end,
    })
    python_exec:toggle()
  end
  
  -- IPython terminal for data science
  local ipython = Terminal:new({
    cmd = "ipython",
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
    end,
  })
  
  _G._IPYTHON_TOGGLE = function()
    ipython:toggle()
  end
  
  -- Virtual environment activation 
  local venv_activate = Terminal:new({
    cmd = function()
      local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
      if venv_path ~= "" then
        return "source " .. vim.fn.getcwd() .. '/' .. venv_path .. '/bin/activate'
      else
        return "echo 'No .venv directory found in current project'"
      end
    end,
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  
  _G._VENV_ACTIVATE = function()
    venv_activate:toggle()
  end
  
  -- Terminal for Docker commands
  local docker_term = Terminal:new({
    cmd = "docker ps",
    direction = "float",
    hidden = true,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.8),
    },
  })
  
  _G._DOCKER_TERM = function()
    docker_term:toggle()
  end
  
  -- Database client terminal
  local db_term = Terminal:new({
    cmd = "pgcli",
    direction = "float",
    hidden = true,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.8),
    },
  })
  
  _G._DATABASE_TERM = function()
    db_term:toggle()
  end
  
  -- All terminal keymappings moved to mappings.lua for centralized management
  -- Do not define keymappings here to avoid redundancy
end

-- Configure debugging for backend development
M.setup_debugging = function()
  -- Ensure DAP is available
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    vim.notify("DAP not found, debugging functionality will be limited", vim.log.levels.WARN)
    return
  end
  
  -- Python debugging
  local python_path = function()
    -- Check for virtual environment
    local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
    if venv_path ~= "" then
      return vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
    else
      -- Try to detect system python
      return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
    end
  end
  
  dap.adapters.python = {
    type = 'executable',
    command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
    args = { '-m', 'debugpy.adapter' },
  }
  
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = "${file}",
      pythonPath = python_path,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'FastAPI',
      module = "uvicorn",
      args = { "app.main:app", "--reload" },
      pythonPath = python_path,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Django',
      program = vim.fn.getcwd() .. '/manage.py',
      args = {'runserver', '--noreload'},
      pythonPath = python_path,
    },
  }
  
  -- Go debugging (only configure if delve is available)
  local delve_path = vim.fn.exepath('dlv')
  if delve_path ~= "" then
    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = {'dap', '-l', '127.0.0.1:${port}'},
      }
    }

    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = "${file}"
      },
      {
        type = 'delve',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = "${file}"
      },
      {
        type = 'delve',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = "./${relativeFileDirname}"
      }
    }
  end
  
  -- C/C++ debugging
  local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
  local codelldb_exec = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
  
  if vim.fn.filereadable(codelldb_exec) == 1 then
    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = codelldb_exec,
        args = {"--port", "${port}"},
      }
    }
    
    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'codelldb',
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
    dap.configurations.rust = dap.configurations.cpp
  end
  
  -- Configure DAP UI if available
  local has_dapui, dapui = pcall(require, "dapui")
  if has_dapui then
    -- Setup better UI for debugging
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      element_mappings = {},
      expand_lines = vim.fn.has("nvim-0.7") == 1,
      force_buffers = true,
      floating = {
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
        indent = 1,
      },
    })
    
    -- Auto open/close UI when debugging starts/ends
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  end
end

return M
