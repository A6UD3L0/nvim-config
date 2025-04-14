-- venv_diagnostics.lua
-- A diagnostic tool for testing Python virtual environment integration in Neovim

local M = {}

-- Utility function to check if a file exists
local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- Utility function to check if a command exists
local function command_exists(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then return false end
  
  local result = handle:read("*a")
  handle:close()
  
  return result and #result > 0
end

-- Check Python installation
function M.check_python()
  local results = {}
  
  -- Check python3 command
  if command_exists("python3") then
    results.python3_exists = true
    -- Get Python version
    local handle = io.popen("python3 --version 2>&1")
    if handle then
      results.python3_version = handle:read("*a"):gsub("%s+$", "")
      handle:close()
    end
  else
    results.python3_exists = false
  end
  
  -- Check python command (might be aliased to python3)
  if command_exists("python") then
    results.python_exists = true
    -- Get Python version
    local handle = io.popen("python --version 2>&1")
    if handle then
      results.python_version = handle:read("*a"):gsub("%s+$", "")
      handle:close()
    end
  else
    results.python_exists = false
  end
  
  -- Check for pip
  if command_exists("pip3") then
    results.pip3_exists = true
  else
    results.pip3_exists = false
  end
  
  if command_exists("pip") then
    results.pip_exists = true
  else
    results.pip_exists = false
  end
  
  -- Check Neovim's Python provider
  results.python3_host_prog = vim.g.python3_host_prog
  if results.python3_host_prog then
    results.python3_host_prog_exists = file_exists(results.python3_host_prog)
  else
    results.python3_host_prog_exists = false
  end
  
  return results
end

-- Check virtual environment
function M.check_venv()
  local results = {}
  
  -- Check if VIRTUAL_ENV is set
  results.virtual_env = vim.env.VIRTUAL_ENV
  
  -- Check for common venv directories
  local cwd = vim.fn.getcwd()
  local venv_dirs = {'.venv', 'venv', 'env', '.env', 'virtualenv'}
  
  results.found_venvs = {}
  for _, dir in ipairs(venv_dirs) do
    local venv_path = vim.fn.finddir(dir, cwd .. ';')
    if venv_path ~= "" then
      local python_path = cwd .. '/' .. venv_path .. '/bin/python'
      local full_path = vim.fn.fnamemodify(python_path, ':p')
      
      local entry = {
        name = venv_path,
        python_path = full_path,
        exists = file_exists(full_path)
      }
      
      -- Check if this venv is currently active
      if results.virtual_env and results.virtual_env:find(venv_path, 1, true) then
        entry.active = true
      else
        entry.active = false
      end
      
      table.insert(results.found_venvs, entry)
    end
  end
  
  return results
end

-- Check Neovim Python plugins
function M.check_python_plugins()
  local results = {}
  
  -- Check for pynvim
  local handle = io.popen("python3 -c 'import pynvim; print(\"installed\")' 2>/dev/null")
  if handle then
    local output = handle:read("*a")
    handle:close()
    results.pynvim_installed = output:find("installed") ~= nil
  else
    results.pynvim_installed = false
  end
  
  -- Check for common Python plugins
  results.plugins = {}
  
  -- Check jedi
  local plugins_to_check = {
    "jedi", "pylint", "black", "isort", "mypy", "pytest"
  }
  
  for _, plugin in ipairs(plugins_to_check) do
    local handle = io.popen("python3 -c 'import " .. plugin .. "; print(\"installed\")' 2>/dev/null")
    if handle then
      local output = handle:read("*a")
      handle:close()
      results.plugins[plugin] = output:find("installed") ~= nil
    else
      results.plugins[plugin] = false
    end
  end
  
  return results
end

-- Check LSP status
function M.check_lsp()
  local results = {}
  results.active_clients = {}
  
  -- Get active language servers
  local active_clients = vim.lsp.get_active_clients()
  for _, client in ipairs(active_clients) do
    table.insert(results.active_clients, {
      name = client.name,
      id = client.id,
      root_dir = client.config.root_dir
    })
  end
  
  -- Check if pyright or pylsp is installed with Mason
  local mason_registry_path = vim.fn.stdpath("data") .. "/mason/packages"
  results.pyright_installed = vim.fn.isdirectory(mason_registry_path .. "/pyright") == 1
  results.pylsp_installed = vim.fn.isdirectory(mason_registry_path .. "/python-lsp-server") == 1
  
  return results
end

-- Run a test Python script in current environment
function M.test_python_execution()
  local results = {}
  
  -- Create a temporary Python script
  local temp_file = os.tmpname() .. ".py"
  local f = io.open(temp_file, "w")
  if not f then
    results.error = "Failed to create temporary file"
    return results
  end
  
  -- Write a simple test script
  f:write([[
import sys
import os

print("Python Diagnostic Results:")
print("-" * 50)
print(f"Python version: {sys.version}")
print(f"Executable path: {sys.executable}")
print(f"Virtual env: {os.environ.get('VIRTUAL_ENV', 'Not activated')}")

# Try to import common libraries
libraries = [
    "pynvim", "jedi", "pylint", "black", "pytest", 
    "isort", "mypy", "flask", "requests", "numpy"
]

print("\nLibrary Check:")
for lib in libraries:
    try:
        __import__(lib)
        print(f"✓ {lib}")
    except ImportError:
        print(f"✗ {lib}")

print("\nSystem Paths:")
for path in sys.path:
    print(f"- {path}")
]])
  f:close()
  
  -- Execute the script with the current Python interpreter
  local python_cmd = "python3"
  if vim.g.python3_host_prog then
    python_cmd = vim.g.python3_host_prog
  end
  
  local handle = io.popen(python_cmd .. " " .. temp_file .. " 2>&1")
  if handle then
    results.output = handle:read("*a")
    handle:close()
  else
    results.error = "Failed to execute Python script"
  end
  
  -- Clean up
  os.remove(temp_file)
  
  return results
end

-- Activate a virtual environment and test it
function M.activate_and_test_venv(venv_path)
  -- Get absolute path
  local cwd = vim.fn.getcwd()
  local full_path = cwd .. '/' .. venv_path
  
  if venv_path:sub(1, 1) == '/' then
    full_path = venv_path
  end
  
  local python_path = full_path .. '/bin/python'
  
  -- Check if Python exists in the venv
  if not file_exists(python_path) then
    return {
      success = false,
      error = "Python executable not found in virtual environment: " .. python_path
    }
  end
  
  -- Set python3_host_prog
  vim.g.python3_host_prog = python_path
  
  -- Run a test with the venv Python
  local results = M.test_python_execution()
  results.venv_path = full_path
  results.python_path = python_path
  results.success = not results.error
  
  return results
end

-- Display results in a floating window
function M.display_results(results)
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer content
  local lines = {"=== Neovim Python Environment Diagnostics ===", ""}
  
  -- Python installation info
  table.insert(lines, "PYTHON INSTALLATION:")
  table.insert(lines, "-----------------------")
  if results.python then
    if results.python.python3_exists then
      table.insert(lines, "✓ " .. results.python.python3_version)
    else
      table.insert(lines, "✗ Python3 not found")
    end
    
    if results.python.pip3_exists then
      table.insert(lines, "✓ pip3 installed")
    else
      table.insert(lines, "✗ pip3 not found")
    end
    
    if results.python.python3_host_prog then
      if results.python.python3_host_prog_exists then
        table.insert(lines, "✓ python3_host_prog: " .. results.python.python3_host_prog)
      else
        table.insert(lines, "✗ python3_host_prog points to non-existent file: " .. results.python.python3_host_prog)
      end
    else
      table.insert(lines, "✗ python3_host_prog not set")
    end
  end
  
  table.insert(lines, "")
  
  -- Virtual environment info
  table.insert(lines, "VIRTUAL ENVIRONMENTS:")
  table.insert(lines, "-----------------------")
  if results.venv then
    if results.venv.virtual_env then
      table.insert(lines, "✓ VIRTUAL_ENV set: " .. results.venv.virtual_env)
    else
      table.insert(lines, "✗ VIRTUAL_ENV not set")
    end
    
    if results.venv.found_venvs and #results.venv.found_venvs > 0 then
      table.insert(lines, "\nFound virtual environments:")
      for _, venv in ipairs(results.venv.found_venvs) do
        local status = venv.exists and "✓" or "✗"
        local active = venv.active and " (ACTIVE)" or ""
        table.insert(lines, status .. " " .. venv.name .. active)
        table.insert(lines, "    Path: " .. venv.python_path)
      end
    else
      table.insert(lines, "\n✗ No virtual environments found")
    end
  end
  
  table.insert(lines, "")
  
  -- LSP info
  table.insert(lines, "LSP STATUS:")
  table.insert(lines, "-----------------------")
  if results.lsp then
    if results.lsp.active_clients and #results.lsp.active_clients > 0 then
      table.insert(lines, "✓ Active Language Servers:")
      for _, client in ipairs(results.lsp.active_clients) do
        table.insert(lines, "  - " .. client.name)
      end
    else
      table.insert(lines, "✗ No active language servers")
    end
    
    table.insert(lines, "")
    if results.lsp.pyright_installed then
      table.insert(lines, "✓ Pyright installed")
    else
      table.insert(lines, "✗ Pyright not installed")
    end
    
    if results.lsp.pylsp_installed then
      table.insert(lines, "✓ Python LSP Server installed")
    else
      table.insert(lines, "✗ Python LSP Server not installed")
    end
  end
  
  -- Test execution results
  if results.test_execution then
    table.insert(lines, "")
    table.insert(lines, "PYTHON EXECUTION TEST:")
    table.insert(lines, "-----------------------")
    if results.test_execution.error then
      table.insert(lines, "✗ Error: " .. results.test_execution.error)
    else
      table.insert(lines, results.test_execution.output)
    end
  end
  
  -- Set content and styling
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Calculate dimensions
  local width = 100
  local height = 30
  local win_height = vim.api.nvim_get_option("lines")
  local win_width = vim.api.nvim_get_option("columns")
  local row = math.floor((win_height - height) / 2)
  local col = math.floor((win_width - width) / 2)
  
  -- Create the floating window
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Set window options
  vim.api.nvim_win_set_option(win, 'winblend', 0)
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  
  -- Use centralized mapping function from mappings.lua
  require("mappings").setup_diagnostic_window_mappings(buf)
  
  return { buf = buf, win = win }
end

-- Run all diagnostics
function M.run_diagnostics()
  local results = {}
  
  -- Run all the checks
  results.python = M.check_python()
  results.venv = M.check_venv()
  results.python_plugins = M.check_python_plugins()
  results.lsp = M.check_lsp()
  results.test_execution = M.test_python_execution()
  
  -- Display results
  M.display_results(results)
  
  return results
end

-- Python virtual environment diagnostics and management for Neovim
-- Enhances the virtual environment experience with smart detection and activation

local VenvDiagnostics = {}

-- Get current Python environment information
VenvDiagnostics.get_current_env = function()
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local pyenv_path = vim.fn.finddir(".python-version", vim.fn.getcwd() .. ";")
  local poetry_path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
  
  local env_info = {
    has_venv = venv_path ~= "",
    has_pyenv = pyenv_path ~= "",
    has_poetry = poetry_path ~= "",
    venv_path = venv_path,
    pyenv_path = pyenv_path,
    poetry_path = poetry_path,
  }
  
  return env_info
end

-- Run diagnostics on the Python environment
VenvDiagnostics.run_diagnostics = function()
  local env_info = VenvDiagnostics.get_current_env()
  local results = {}
  
  if env_info.has_venv then
    table.insert(results, { status = "INFO", message = "Found local .venv directory: " .. env_info.venv_path })
  else
    table.insert(results, { status = "WARN", message = "No local .venv directory found" })
  end
  
  if env_info.has_pyenv then
    -- Check if pyenv is installed
    local pyenv_installed = vim.fn.executable("pyenv") == 1
    if pyenv_installed then
      table.insert(results, { status = "INFO", message = "Found .python-version file with pyenv support" })
    else
      table.insert(results, { status = "WARN", message = "Found .python-version file but pyenv not installed" })
    end
  end
  
  if env_info.has_poetry then
    -- Check if poetry is installed
    local poetry_installed = vim.fn.executable("poetry") == 1
    if poetry_installed then
      table.insert(results, { status = "INFO", message = "Found Poetry project (pyproject.toml)" })
    else
      table.insert(results, { status = "WARN", message = "Found pyproject.toml but Poetry not installed" })
    end
  end
  
  -- Display results
  local title = "Python Environment Diagnostics"
  local header = title .. "\n" .. string.rep("=", string.len(title))
  
  print(header)
  for _, result in ipairs(results) do
    local prefix = result.status == "INFO" and "[✓]" or "[!]"
    print(prefix .. " " .. result.message)
  end
  
  return results
end

-- Activate the best available Python environment
VenvDiagnostics.smart_activate = function()
  local env_info = VenvDiagnostics.get_current_env()
  local term = require("toggleterm.terminal").Terminal
  
  if env_info.has_poetry then
    -- Poetry takes precedence as it manages dependencies properly
    local poetry_shell = term:new({
      cmd = "poetry shell",
      direction = "float",
      close_on_exit = false,
    })
    poetry_shell:toggle()
    vim.notify("Activated Poetry environment", vim.log.levels.INFO)
    
  elseif env_info.has_venv then
    -- Use local venv if available
    local venv_activate = term:new({
      cmd = "source " .. env_info.venv_path .. "/bin/activate && python --version",
      direction = "float",
      close_on_exit = false,
    })
    venv_activate:toggle()
    vim.notify("Activated local .venv environment", vim.log.levels.INFO)
    
  elseif env_info.has_pyenv then
    -- Use pyenv if .python-version exists
    local pyenv_activate = term:new({
      cmd = "pyenv shell $(cat " .. env_info.pyenv_path .. ") && python --version",
      direction = "float",
      close_on_exit = false,
    })
    pyenv_activate:toggle()
    vim.notify("Activated pyenv environment from .python-version", vim.log.levels.INFO)
    
  else
    -- No environment found, use VenvSelect if available
    local has_venv_select = pcall(require, "venv-selector")
    if has_venv_select then
      vim.cmd("VenvSelect")
    else
      -- Fallback to a helpful message
      vim.notify("No Python environment found. Consider creating a virtual environment.", vim.log.levels.WARN)
    end
  end
end

-- Create a new Python virtual environment
VenvDiagnostics.create_venv = function()
  local venv_name = vim.fn.input("Virtual environment name (.venv): ", ".venv")
  if venv_name == "" then
    venv_name = ".venv"
  end
  
  vim.notify("Creating Python virtual environment: " .. venv_name, vim.log.levels.INFO)
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "python -m venv " .. venv_name,
    direction = "float",
    close_on_exit = false,
    on_exit = function() 
      vim.notify("Virtual environment created: " .. venv_name, vim.log.levels.INFO)
    end,
  })
  term:toggle()
end

-- Run current Python file with environment
VenvDiagnostics.run_with_env = function()
  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end
  
  if vim.fn.fnamemodify(file, ':e') ~= 'py' then
    vim.notify("Not a Python file", vim.log.levels.ERROR)
    return
  end
  
  local env_info = VenvDiagnostics.get_current_env()
  local python_cmd = "python"
  
  if env_info.has_poetry then
    python_cmd = "poetry run python"
  elseif env_info.has_venv then
    python_cmd = "source " .. env_info.venv_path .. "/bin/activate && python"
  elseif env_info.has_pyenv then
    python_cmd = "pyenv shell $(cat " .. env_info.pyenv_path .. ") && python"
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = python_cmd .. " " .. file,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Register module commands
function VenvDiagnostics.setup()
  vim.api.nvim_create_user_command("VenvDiagnostics", function()
    VenvDiagnostics.run_diagnostics()
  end, { desc = "Run diagnostics on Python environment" })
  
  vim.api.nvim_create_user_command("VenvActivate", function()
    VenvDiagnostics.smart_activate()
  end, { desc = "Activate Python environment" })
  
  vim.api.nvim_create_user_command("VenvCreate", function()
    VenvDiagnostics.create_venv()
  end, { desc = "Create a new Python virtual environment" })
  
  vim.api.nvim_create_user_command("RunPythonWithEnv", function()
    VenvDiagnostics.run_with_env()
  end, { desc = "Run Python file with current environment" })
  
  -- Make functions available globally
  _G._VENV_DIAGNOSTICS = VenvDiagnostics.run_diagnostics
  _G._VENV_ACTIVATE = VenvDiagnostics.smart_activate
  _G._VENV_CREATE = VenvDiagnostics.create_venv
  _G._PYTHON_RUN_WITH_ENV = VenvDiagnostics.run_with_env
end

return M, VenvDiagnostics
