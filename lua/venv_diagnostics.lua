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
  
  -- Add keybindings for the diagnostic window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
  
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

-- Register commands only (mappings are now in mappings.lua)
vim.api.nvim_create_user_command('VenvDiagnostics', M.run_diagnostics, {})
vim.api.nvim_create_user_command('TestVenv', function(opts)
  local venv_path = opts.args
  if venv_path == "" then
    -- If no path provided, try to find a venv
    local venv = M.check_venv()
    if venv.found_venvs and #venv.found_venvs > 0 then
      venv_path = venv.found_venvs[1].name
    else
      vim.notify("No virtual environment path provided and none found", vim.log.levels.ERROR)
      return
    end
  end
  
  local results = M.activate_and_test_venv(venv_path)
  
  if not results.success then
    vim.notify("Failed to activate venv: " .. (results.error or "Unknown error"), vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Successfully activated venv: " .. venv_path, vim.log.levels.INFO)
  
  -- Display test results
  local display_results = {
    test_execution = results
  }
  M.display_results(display_results)
end, {
  nargs = "?",
  complete = function()
    local venv = M.check_venv()
    local completions = {}
    if venv.found_venvs then
      for _, v in ipairs(venv.found_venvs) do
        table.insert(completions, v.name)
      end
    end
    return completions
  end
})

-- Keymappings have been centralized in mappings.lua

return M
