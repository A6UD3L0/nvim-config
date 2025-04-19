-- Python Development Plugin 
-- Implements Python specific tooling and integrations
-- Configured as a plugin in the new architecture

local events = require("core.events")
local utils = require("core.utils")
local settings = require("core.settings")

-- Define the plugin
local M = {
  name = "python",
  description = "Python development environment with uv.nvim integration",
  version = "1.0.0",
  dependencies = {},
  enabled = true,
}

-- Configuration
M.config = {
  -- Python interpreter path
  python_path = "",
  
  -- Virtual environment handling
  venv = {
    enabled = true,
    auto_activate = true,
    path = ".venv",
  },
  
  -- uv.nvim integration
  uv = {
    enabled = true,
    auto_install_deps = false,
  },
  
  -- Linting and formatting
  linters = {
    enabled = true,
    ruff = true,
    pylint = false,
  },
  
  formatters = {
    enabled = true,
    black = true,
    ruff = true,
  },
  
  -- Testing integration
  testing = {
    enabled = true,
    framework = "pytest", -- or unittest
    test_dir = "tests",
  },
}

-- Helper function to find Python executable
local function get_python_path()
  -- Check for active virtual environment
  local venv = vim.env.VIRTUAL_ENV
  if venv then
    if vim.fn.has("win32") == 1 then
      return venv .. "\\Scripts\\python.exe"
    else
      return venv .. "/bin/python"
    end
  end
  
  -- Check for configured path
  if M.config.python_path and M.config.python_path ~= "" then
    if utils.file_exists(M.config.python_path) then
      return M.config.python_path
    end
  end
  
  -- Check for common Python executables
  for _, name in ipairs({ "python3", "python" }) do
    if utils.command_exists(name) then
      return name
    end
  end
  
  return "python" -- Default fallback
end

-- Set up uv.nvim integration
local function setup_uv()
  -- Check if uv.nvim is available
  local has_uv, uv = utils.has_plugin("uv")
  if not has_uv then
    if M.config.uv.enabled then
      vim.notify("uv.nvim not found but enabled in config. Python tooling will be limited.", vim.log.levels.WARN)
    end
    return false
  end
  
  -- Initialize uv
  uv.setup({
    python = {
      auto_venv_activation = M.config.venv.auto_activate,
      default_venv_path = M.config.venv.path,
    },
    project = {
      auto_install_deps = M.config.uv.auto_install_deps,
    },
  })
  
  -- Register uv handlers for Python events
  events.on("python:install_package", function(package)
    uv.packages.install({ package })
  end)
  
  events.on("python:venv_activated", function(venv_path)
    vim.notify("Activated Python environment: " .. venv_path, vim.log.levels.INFO)
  end)
  
  events.on("buffer:enter", function(bufnr)
    -- Check if file is Python
    if vim.api.nvim_buf_get_option(bufnr, "filetype") == "python" then
      -- Try to auto-activate venv
      if M.config.venv.auto_activate then
        pcall(uv.venv.auto_activate)
      end
    end
  end)
  
  -- Create user command for common uv.nvim operations
  vim.api.nvim_create_user_command("UVInstall", function(opts)
    uv.packages.install({ opts.args })
  end, {
    nargs = 1,
    desc = "Install a Python package with uv",
  })
  
  vim.api.nvim_create_user_command("UVUninstall", function(opts)
    uv.packages.uninstall({ opts.args })
  end, {
    nargs = 1,
    desc = "Uninstall a Python package with uv",
  })
  
  vim.api.nvim_create_user_command("UVCreateVenv", function()
    uv.venv.create()
  end, {
    desc = "Create a new virtual environment with uv",
  })
  
  vim.api.nvim_create_user_command("UVGenerate", function()
    uv.requirements.generate()
  end, {
    desc = "Generate requirements.txt with uv",
  })
  
  vim.api.nvim_create_user_command("UVInstallRequirements", function()
    uv.requirements.install()
  end, {
    desc = "Install from requirements.txt with uv",
  })
  
  vim.api.nvim_create_user_command("UVToolInstall", function(opts)
    uv.tools.install(opts.args)
  end, {
    nargs = 1,
    desc = "Install a Python tool with uv",
  })
  
  vim.api.nvim_create_user_command("UVToolRun", function(opts)
    uv.tools.run(opts.args)
  end, {
    nargs = 1,
    desc = "Run a Python tool with uv",
  })
  
  return true
end

-- Set up Python LSP servers
local function setup_lsp()
  -- LSP configuration is now handled by core.lsp.servers.python
  -- We just need to ensure that the settings reflect our plugin config
  
  -- Apply testing framework configuration to LSP settings
  if M.config.testing.enabled then
    local lsp_config = settings.get("lsp.python", {})
    lsp_config.testing = M.config.testing
    settings.set("lsp.python", lsp_config)
  end
  
  return true
end

-- Set up testing integration
local function setup_testing()
  if not M.config.testing.enabled then
    return false
  end
  
  -- Set up test runner
  if M.config.testing.framework == "pytest" then
    -- Check if pytest is available
    if not utils.command_exists("pytest") then
      vim.notify("pytest not found. Python testing will be limited.", vim.log.levels.WARN)
      return false
    end
    
    -- Create test runner command
    vim.api.nvim_create_user_command("PyTest", function(opts)
      -- Build command
      local cmd = "pytest"
      
      -- Add args if provided
      if opts.args and opts.args ~= "" then
        cmd = cmd .. " " .. opts.args
      else
        -- If no args, use current file if it's a test file
        local current_file = vim.fn.expand("%:p")
        if current_file:match("test_.+%.py$") or current_file:match("_test%.py$") then
          cmd = cmd .. " " .. vim.fn.shellescape(current_file)
        end
      end
      
      -- Run the command
      if utils.has_plugin("toggleterm") then
        require("core.keybindings").run_in_terminal(cmd)
      else
        vim.cmd("!" .. cmd)
      end
    end, {
      nargs = "?",
      desc = "Run pytest",
      complete = function(_, _, _)
        -- Get test files for completion
        local test_dir = vim.fn.getcwd() .. "/" .. M.config.testing.test_dir
        if vim.fn.isdirectory(test_dir) == 1 then
          return vim.fn.glob(test_dir .. "/test_*.py", false, true)
        end
        return {}
      end,
    })
  end
  
  return true
end

-- Set up the Python plugin
function M.setup(config)
  -- Merge configs
  if config then
    M.config = vim.tbl_deep_extend("force", M.config, config)
  end
  
  -- Get Python path
  local python_path = get_python_path()
  M.config.python_path = python_path
  
  -- Store the path in settings for other modules to use
  settings.set("python.path", python_path)
  
  -- Set up uv.nvim
  if M.config.uv.enabled then
    setup_uv()
  end
  
  -- Set up LSP
  setup_lsp()
  
  -- Set up testing
  setup_testing()
  
  return true
end

-- Tear down the plugin
function M.teardown()
  -- Remove commands
  pcall(vim.api.nvim_del_user_command, "PyTest")
  pcall(vim.api.nvim_del_user_command, "UVInstall")
  pcall(vim.api.nvim_del_user_command, "UVUninstall")
  pcall(vim.api.nvim_del_user_command, "UVCreateVenv")
  pcall(vim.api.nvim_del_user_command, "UVGenerate")
  pcall(vim.api.nvim_del_user_command, "UVInstallRequirements")
  pcall(vim.api.nvim_del_user_command, "UVToolInstall")
  pcall(vim.api.nvim_del_user_command, "UVToolRun")
  
  return true
end

return M
