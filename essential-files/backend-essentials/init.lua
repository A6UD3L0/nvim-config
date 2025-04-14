-- Backend Development and Data Science essential configurations
-- This file consolidates the core functionality needed for backend development

local M = {}

-- Backend development language servers configuration
M.setup_lsp = function()
  local lspconfig = require("lspconfig")
  
  -- Python configuration
  lspconfig.pyright.setup({
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
          },
        },
      },
    },
  })
  
  -- Go configuration
  lspconfig.gopls.setup({
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
        usePlaceholders = true,
        completeUnimported = true,
      },
    },
  })
  
  -- SQL configuration
  lspconfig.sqlls.setup({})
  
  -- C/C++ configuration
  lspconfig.clangd.setup({})
  
  -- Docker configuration
  lspconfig.dockerls.setup({})
  
  -- YAML for Kubernetes
  lspconfig.yamlls.setup({
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        },
      },
    },
  })
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
  
  -- Create keymappings for all terminal commands
  vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", {desc = "Toggle Python Terminal"})
  vim.keymap.set("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", {desc = "Toggle IPython Terminal"})
  vim.keymap.set("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", {desc = "Run Python File"})
  vim.keymap.set("n", "<leader>tv", "<cmd>lua _VENV_ACTIVATE()<CR>", {desc = "Activate Virtual Environment"})
  vim.keymap.set("n", "<leader>td", "<cmd>lua _DOCKER_TERM()<CR>", {desc = "Docker Terminal"})
  vim.keymap.set("n", "<leader>tb", "<cmd>lua _DATABASE_TERM()<CR>", {desc = "Database Terminal"})
end

-- Configure debugging for backend development
M.setup_debugging = function()
  -- Python debugging
  local dap = require("dap")
  local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
  
  dap.adapters.python = {
    type = 'executable',
    command = path,
    args = { '-m', 'debugpy.adapter' },
  }
  
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = "${file}",
      pythonPath = function()
        -- Try to detect python path from virtual environments
        local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
        if venv_path ~= "" then
          return vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
        else
          return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
        end
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'FastAPI',
      module = "uvicorn",
      args = { "app.main:app", "--reload" },
      pythonPath = function()
        local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
        if venv_path ~= "" then
          return vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
        else
          return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
        end
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Django',
      program = vim.fn.getcwd() .. '/manage.py',
      args = {'runserver', '--noreload'},
      pythonPath = function()
        local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
        if venv_path ~= "" then
          return vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
        else
          return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
        end
      end,
    },
  }
  
  -- Go debugging
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
  
  -- C/C++ debugging
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
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
      runInTerminal = false,
    },
  }
  
  dap.configurations.c = dap.configurations.cpp
end

return M
