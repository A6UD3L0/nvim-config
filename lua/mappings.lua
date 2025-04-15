-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Create a module for exported functions
local M = {}

-- Helper for checking if a command exists
M._command_exists = function(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then return false end
  
  local result = handle:read("*a")
  handle:close()
  
  return result and #result > 0
end

-- Generic plugin availability check function
M._has_plugin = function(plugin_name)
  local status_ok, _ = pcall(require, plugin_name)
  return status_ok
end

-- Helper to run a command in a toggleterm window
M._run_in_terminal = function(cmd, direction)
  direction = direction or "horizontal"
  
  -- Check that toggleterm is available
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end
  
  local term = toggleterm.Terminal:new({
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  })
  term:toggle()
end

-- IPython terminal toggle implementation
M._toggle_ipython = function()
  -- Check if ipython is installed
  if not M._command_exists("ipython") then
    vim.notify("IPython is not installed. Please install it first.", vim.log.levels.ERROR)
    return
  end
  
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local cmd = ""
  
  if venv_path ~= "" then
    cmd = "source " .. venv_path .. "/bin/activate && ipython"
  elseif vim.fn.filereadable(".python-version") == 1 then
    cmd = "pyenv shell $(cat .python-version) && ipython"  
  else
    cmd = "ipython"
  end
  
  M._run_in_terminal(cmd)
end

-- Docker terminal implementation
M._toggle_docker_terminal = function()
  -- Check if docker is installed
  if not M._command_exists("docker") then
    vim.notify("Docker is not installed. Please install it first.", vim.log.levels.ERROR)
    return
  end
  
  M._run_in_terminal("docker ps")
end

-- Database terminal implementation
M._toggle_database_terminal = function()
  -- Try to determine which database tools are available
  local db_clients = {
    { cmd = "psql", name = "PostgreSQL" },
    { cmd = "mysql", name = "MySQL" },
    { cmd = "sqlite3", name = "SQLite" },
    { cmd = "mongosh", name = "MongoDB" },
  }
  
  local available_clients = {}
  for _, client in ipairs(db_clients) do
    if M._command_exists(client.cmd) then
      table.insert(available_clients, client)
    end
  end
  
  if #available_clients == 0 then
    vim.notify("No database clients found. Please install a database client.", vim.log.levels.ERROR)
    return
  elseif #available_clients == 1 then
    -- Only one client available, use it directly
    local client = available_clients[1]
    vim.notify("Opening " .. client.name .. " terminal", vim.log.levels.INFO)
    M._run_in_terminal(client.cmd)
  else
    -- Multiple clients available, let user choose
    local choices = {}
    for _, client in ipairs(available_clients) do
      table.insert(choices, client.name)
    end
    
    vim.ui.select(choices, {
      prompt = "Select database client:",
    }, function(choice)
      if not choice then return end
      
      for _, client in ipairs(available_clients) do
        if client.name == choice then
          M._run_in_terminal(client.cmd)
          break
        end
      end
    end)
  end
end

-- Helper function to validate that a required plugin is available
-- Useful for keybinding validation
M._validate_plugin = function(plugin_name, friendly_name)
  friendly_name = friendly_name or plugin_name
  local status_ok, _ = pcall(require, plugin_name)
  if not status_ok then
    vim.notify("Plugin " .. friendly_name .. " not available for this keybinding", vim.log.levels.WARN)
    return false
  end
  return true
end

-- Execute Python helper with better error handling
M._python_run_file = function()
  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end
  
  if vim.bo.filetype ~= "python" then
    vim.notify("Not a Python file", vim.log.levels.ERROR)
    return
  end
  
  -- Call VenvDiagnostics.run_with_env if available
  if _G.VenvDiagnostics and _G.VenvDiagnostics.run_with_env then
    _G.VenvDiagnostics.run_with_env()
    return
  end
  
  -- Get Python command with virtual environment
  local python_cmd = M._get_python_command()
  
  -- Run the command in a terminal
  M._run_in_terminal(python_cmd .. " \"" .. file .. "\"")
end

-- Helper to determine the best Python command based on environment
M._get_python_command = function()
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local pyenv_path = vim.fn.finddir(".python-version", vim.fn.getcwd() .. ";")
  local poetry_path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
  local python_cmd = "python"
  
  if venv_path ~= "" then
    if vim.fn.has("win32") == 1 then
      python_cmd = venv_path .. "\\Scripts\\python.exe"
    else
      python_cmd = "source " .. venv_path .. "/bin/activate && python"
    end
  elseif pyenv_path ~= "" then
    python_cmd = "pyenv shell $(cat " .. pyenv_path .. ") && python"
  elseif poetry_path ~= "" then
    python_cmd = "poetry run python"
  end
  
  return python_cmd
end

-- Activate virtual environment based on project
M._venv_smart_activate = function()
  if _G.VenvDiagnostics and _G.VenvDiagnostics.smart_activate then
    _G.VenvDiagnostics.smart_activate()
    return true
  elseif M._has_venv_selector() then
    vim.cmd("VenvSelectCached")
    return true
  else
    local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
    local pyenv_path = vim.fn.finddir(".python-version", vim.fn.getcwd() .. ";")
    local poetry_path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    
    if venv_path ~= "" then
      vim.notify("Using venv: " .. venv_path, vim.log.levels.INFO)
      return true
    elseif pyenv_path ~= "" then
      vim.notify("Using pyenv from: " .. pyenv_path, vim.log.levels.INFO)
      return true
    elseif poetry_path ~= "" then
      vim.notify("Using poetry from: " .. poetry_path, vim.log.levels.INFO)
      return true
    end
  end
  
  return false
end

-- Function to get visual selection text
vim.api.nvim_buf_get_visual_selection = function()
  local _, line_start, col_start, _ = unpack(vim.fn.getpos("'<"))
  local _, line_end, col_end, _ = unpack(vim.fn.getpos("'>"))
  
  -- Normalize for selection direction
  if line_start > line_end then
    line_start, line_end = line_end, line_start
    col_start, col_end = col_end, col_start
  end
  
  -- Get the lines
  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  
  -- If no lines were selected, return empty table
  if #lines == 0 then
    return {}
  end
  
  -- Handle single line selections
  if line_start == line_end then
    lines[1] = string.sub(lines[1], col_start, col_end)
  else
    -- First and last lines need trimming
    lines[1] = string.sub(lines[1], col_start)
    lines[#lines] = string.sub(lines[#lines], 1, col_end)
  end
  
  return lines
end

-- Execute Python snippet (selected text)
M._python_execute_snippet = function()
  -- Get visual selection
  local lines = vim.api.nvim_buf_get_visual_selection()
  
  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.ERROR)
    return
  end
  
  -- Create a temporary file with error handling
  local temp_file = os.tmpname() .. ".py"
  local f, err = io.open(temp_file, "w")
  if not f then
    vim.notify("Failed to create temporary file: " .. (err or "unknown error"), vim.log.levels.ERROR)
    return
  end
  
  -- Write the selection to the file
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  
  -- Get the best Python command for the environment
  local python_cmd = M._get_python_command()
  
  -- Run the file with proper error handling
  vim.notify("Executing Python code...", vim.log.levels.INFO)
  M._run_in_terminal(python_cmd .. " \"" .. temp_file .. "\"")
end

-- Run current selection in IPython
M._python_execute_in_ipython = function()
  -- Get visual selection
  local lines = vim.api.nvim_buf_get_visual_selection()
  
  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.ERROR)
    return
  end
  
  local code = table.concat(lines, "\n")
  
  -- Escape any quotes
  code = code:gsub('"', '\\"')
  
  -- Run in IPython
  M._run_in_terminal('ipython -c "' .. code .. '"')
end

-- Create a new Python file
M._python_new_file = function()
  vim.ui.input({ prompt = "Enter filename: " }, function(name)
    if not name or name == "" then return end
    
    -- Add .py extension if not present
    if not name:match("%.py$") then
      name = name .. ".py"
    end
    
    -- Open the file
    vim.cmd("e " .. name)
    
    -- Add a basic header
    local lines = {
      "#!/usr/bin/env python3",
      "# -*- coding: utf-8 -*-",
      '"""',
      name .. " - [Brief description]",
      "",
      "Created on " .. os.date("%Y-%m-%d"),
      '"""',
      "",
      "",
      "def main():",
      "    pass",
      "",
      "",
      'if __name__ == "__main__":',
      "    main()",
      "",
    }
    
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
    -- Position cursor at a sensible position (line 11, column 5)
    vim.api.nvim_win_set_cursor(0, {11, 4})
  end)
end

-- POETRY FUNCTIONS

-- Check if Poetry is installed
M._check_poetry = function()
  local poetry_installed = M._command_exists("poetry")
  if not poetry_installed then
    vim.notify("Poetry is not installed. Please install it first.", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Poetry shell
M._poetry_shell = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry shell")
end

-- Create Poetry environment and install dependencies
M._poetry_create_venv = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry install")
end

-- Add a package with Poetry
M._poetry_add_package = function()
  if not M._check_poetry() then return end
  
  vim.ui.input({ prompt = "Package to add: " }, function(package)
    if not package or package == "" then return end
    
    -- Ask if it's a dev dependency
    vim.ui.select({ "regular", "dev" }, {
      prompt = "Dependency type:",
    }, function(choice)
      if not choice then return end
      
      local cmd = "poetry add " .. package
      if choice == "dev" then
        cmd = cmd .. " --group dev"
      end
      
      M._run_in_terminal(cmd)
    end)
  end)
end

-- Remove a package with Poetry
M._poetry_remove_package = function()
  if not M._check_poetry() then return end
  
  -- Get list of installed packages
  local handle = io.popen("poetry show --no-ansi | awk '{print $1}'")
  if not handle then
    vim.notify("Failed to get package list", vim.log.levels.ERROR)
    return
  end
  
  local packages = {}
  for line in handle:lines() do
    table.insert(packages, line)
  end
  handle:close()
  
  if #packages == 0 then
    vim.notify("No packages installed", vim.log.levels.INFO)
    return
  end
  
  -- Select package to remove
  vim.ui.select(packages, {
    prompt = "Select package to remove:",
  }, function(package)
    if not package then return end
    
    M._run_in_terminal("poetry remove " .. package)
  end)
end

-- Update packages with Poetry
M._poetry_update = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry update")
end

-- Show outdated packages
M._poetry_show_outdated = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry show --outdated")
end

-- Generate requirements.txt from Poetry
M._poetry_generate_requirements = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry export --format requirements.txt --output requirements.txt --without-hashes")
end

-- Create a new Poetry project
M._poetry_new = function()
  if not M._check_poetry() then return end
  
  vim.ui.input({ prompt = "Project name: " }, function(name)
    if not name or name == "" then return end
    M._run_in_terminal("poetry new " .. name)
    
    -- Ask if user wants to cd into the project
    vim.ui.select({ "Yes", "No" }, {
      prompt = "Change to project directory?",
    }, function(choice)
      if choice == "Yes" then
        vim.cmd("cd " .. name)
        vim.notify("Changed to directory: " .. name, vim.log.levels.INFO)
      end
    end)
  end)
end

-- Build Poetry package
M._poetry_build = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry build")
end

-- Publish Poetry package
M._poetry_publish = function()
  if not M._check_poetry() then return end
  M._run_in_terminal("poetry publish")
end

-- Edit pyproject.toml
M._poetry_edit_pyproject = function()
  local path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
  if path == "" then
    vim.notify("pyproject.toml not found", vim.log.levels.ERROR)
    return
  end
  
  vim.cmd("edit " .. path)
end

-- Run a command with Poetry
M._poetry_run = function()
  if not M._check_poetry() then return end
  
  vim.ui.input({ prompt = "Command to run: " }, function(cmd)
    if not cmd or cmd == "" then return end
    M._run_in_terminal("poetry run " .. cmd)
  end)
end

-- Documentation functions
M._toggle_documentation = function()
  -- Check if DevDocs is available
  local devdocs_ok, _ = pcall(require, "nvim-devdocs")
  if not devdocs_ok then
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
    return
  end
  
  -- Check if a buffer with DevDocs is already open
  local found = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:match("DevDocs") or buf_name:match("devdocs://") then
        -- Find windows containing this buffer
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_set_current_win(win)
            found = true
            break
          end
        end
        
        if found then
          -- If found but not visible in a window, close it - this effectively toggles
          vim.cmd("close")
          return
        end
      end
    end
  end
  
  -- If not found or not visible, open new documentation
  local ft = vim.bo.filetype
  if ft == "" then
    -- No filetype, just open general docs
    vim.cmd("DevdocsOpenCmd")
    return
  end
  
  -- Map filetypes to their documentation types
  local ft_map = {
    python = "python~3.11",  -- Use specific Python version
    javascript = "javascript",
    typescript = "typescript",
    go = "go",
    rust = "rust",
    lua = "lua",
    c = "c",
    cpp = "cpp",
    bash = "bash",
    sh = "bash",
    html = "html",
    css = "css",
    markdown = "markdown",
    sql = "sql",
    postgresql = "postgresql",
    docker = "docker",
    json = "json",
    yaml = "yaml",
    toml = "toml",
  }
  
  -- Additional documentation mapping for specialized topics
  local specialized_docs = {
    ["sklearn"] = "scikit_learn",
    ["numpy"] = "numpy~1.24",
    ["pandas"] = "pandas~1",
    ["tensorflow"] = "tensorflow~2.12",
    ["pytorch"] = "pytorch",
  }
  
  local doc_type = ft_map[ft] or specialized_docs[ft] or ft
  
  -- Try to open documentation for the specific filetype
  local success = pcall(vim.cmd, "DevdocsOpenFloatCmd " .. vim.fn.shellescape(doc_type))
  
  -- If it fails, try to install the documentation
  if not success then
    vim.notify("Documentation for " .. doc_type .. " not found. Attempting to install...", vim.log.levels.INFO)
    vim.cmd("DevdocsFetch")
    vim.defer_fn(function()
      pcall(vim.cmd, "DevdocsInstall " .. vim.fn.shellescape(doc_type))
      vim.defer_fn(function()
        pcall(vim.cmd, "DevdocsOpenFloatCmd " .. vim.fn.shellescape(doc_type))
      end, 2000)
    end, 1000)
  end
end

-- Documentation keybinding
map("n", "<leader>do", function() M._toggle_documentation() end, { desc = "Toggle documentation" })

-- Add specialized documentation commands for machine learning
M._open_ml_docs = function(doc_type)
  -- Check if DevDocs is available
  local devdocs_ok, _ = pcall(require, "nvim-devdocs")
  if not devdocs_ok then
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
    return
  end
  
  -- Map shorthand names to full documentation IDs
  local ml_docs = {
    -- Core ML and data science
    ["sklearn"] = "scikit_learn",  -- Common shorthand
    ["ml"] = "scikit_learn",       -- Generic ML request defaults to scikit-learn
    ["numpy"] = "numpy~1.24",
    ["pandas"] = "pandas~1",
    
    -- Deep learning frameworks
    ["tf"] = "tensorflow~2.12",
    ["pytorch"] = "pytorch",
    
    -- Visualization
    ["matplotlib"] = "matplotlib~3",
  }
  
  local target_doc = ml_docs[doc_type] or doc_type
  
  -- Try to open documentation
  local success = pcall(vim.cmd, "DevdocsOpenFloatCmd " .. vim.fn.shellescape(target_doc))
  
  -- If failed, try to install the documentation
  if not success then
    vim.notify("Documentation for " .. target_doc .. " not found. Attempting to install...", vim.log.levels.INFO)
    vim.cmd("DevdocsFetch")
    vim.defer_fn(function()
      pcall(vim.cmd, "DevdocsInstall " .. vim.fn.shellescape(target_doc))
      vim.defer_fn(function()
        pcall(vim.cmd, "DevdocsOpenFloatCmd " .. vim.fn.shellescape(target_doc))
      end, 2000)
    end, 1000)
  end
end

-- Machine learning documentation keybindings
map("n", "<leader>dm", function() 
  vim.ui.select(
    { "sklearn", "numpy", "pandas", "tensorflow", "pytorch", "matplotlib" },
    { prompt = "Select ML Documentation:" },
    function(choice) 
      if choice then M._open_ml_docs(choice) end
    end
  )
end, { desc = "Browse ML documentation" })

-- Enhanced Python test runner with better validation
M._run_python_tests = function()
  -- Try telescope plugin first
  if M._has_telescope() then
    local status_ok, telescope = pcall(require, "telescope")
    if status_ok and telescope.extensions and telescope.extensions.python_tests then
      local success, err = pcall(function()
        telescope.extensions.python_tests.python_tests()
      end)
      if success then
        return
      else
        vim.notify("Failed to run Python tests via Telescope: " .. tostring(err), vim.log.levels.WARN)
      end
    end
  end
  
  -- Fallback to pytest if available
  if M._command_exists("pytest") then
    M._run_in_terminal("pytest")
    return
  end
  
  -- Last resort: use python -m unittest
  if M._command_exists("python") then
    -- Check for test directory structure
    local test_dirs = { "tests", "test", "unit_tests" }
    local test_dir_exists = false
    
    for _, dir in ipairs(test_dirs) do
      if vim.fn.isdirectory(dir) == 1 then
        test_dir_exists = true
        break
      end
    end
    
    if test_dir_exists then
      M._run_in_terminal("python -m unittest discover")
    else
      -- No test directory found, run the current file if it's a test file
      local filename = vim.fn.expand("%:t")
      if filename:match("test_.*%.py$") or filename:match(".*_test%.py$") then
        M._run_in_terminal("python -m unittest " .. vim.fn.expand("%:r"))
      else
        vim.notify("No test files or directories found", vim.log.levels.ERROR)
      end
    end
  else
    vim.notify("No Python test runner found", vim.log.levels.ERROR)
  end
end

-- Fixed and improved Python helper functions
M._create_python_venv = function()
  if _G.VenvDiagnostics and _G.VenvDiagnostics.create_venv then
    vim.cmd("VenvCreate")
    return
  end
  
  if M._command_exists("python") then
    vim.ui.input({
      prompt = "Virtual environment name (.venv): ",
      default = ".venv",
    }, function(venv_name)
      if not venv_name or venv_name == "" then
        venv_name = ".venv"
      end
      
      -- Execute with better feedback
      vim.notify("Creating Python virtual environment: " .. venv_name, vim.log.levels.INFO)
      M._run_in_terminal("python -m venv " .. venv_name)
    end)
  else
    vim.notify("Python not found", vim.log.levels.ERROR)
  end
end

-- Update the keybinding group for Python with improved error handling
local python_group = {
  { key = "<leader>pa", fn = function()
    if _G.VenvDiagnostics and _G.VenvDiagnostics.smart_activate then
      vim.cmd("VenvActivate")
    elseif M._has_venv_selector() then
      pcall(vim.cmd, "VenvSelectCached")
    else
      vim.notify("No virtual environment selector available", vim.log.levels.WARN)
    end
  end, desc = "Activate Python environment" },
  
  { key = "<leader>ps", fn = function()
    if M._has_venv_selector() then
      pcall(vim.cmd, "VenvSelect")
    else
      vim.notify("VenvSelector not available", vim.log.levels.ERROR)
    end
  end, desc = "Select Python environment" },
  
  { key = "<leader>pc", fn = function()
    if M._has_venv_selector() then
      pcall(vim.cmd, "VenvSelectCached")
    else
      vim.notify("VenvSelector not available", vim.log.levels.ERROR)
    end
  end, desc = "Select cached environment" },
  
  { key = "<leader>pn", fn = M._create_python_venv, desc = "Create new venv" },
  
  { key = "<leader>pi", fn = function()
    if _G.VenvDiagnostics then
      pcall(vim.cmd, "VenvDiagnostics")
    else
      vim.notify("VenvDiagnostics module not available", vim.log.levels.ERROR)
    end
  end, desc = "Show environment info" },
  
  { key = "<leader>pr", fn = function()
    if _G.VenvDiagnostics and _G.VenvDiagnostics.run_with_env then
      pcall(vim.cmd, "RunPythonWithEnv")
    else
      M._python_run_file()
    end
  end, desc = "Run current file with env" },
  
  { key = "<leader>pe", fn = M._python_execute_snippet, desc = "Execute selection" },
  
  { key = "<leader>pp", fn = function()
    if M._command_exists("ipython") then
      M._python_execute_in_ipython()
    else
      vim.notify("IPython not installed. Please install it first.", vim.log.levels.ERROR)
    end
  end, desc = "Run selection in IPython" },
  
  { key = "<leader>pnf", fn = M._python_new_file, desc = "New Python file" },
  
  { key = "<leader>pt", fn = M._run_python_tests, desc = "Run Python tests" },
}

-- Apply all mappings in the python_group
for _, mapping in ipairs(python_group) do
  map("n", mapping.key, mapping.fn, { desc = mapping.desc })
end

-- =============================================
-- TERMINAL OPERATIONS (t namespace)
-- =============================================

-- Smart Terminal - automatically uses local virtual environment if available
M._smart_terminal = function()
  -- Check that toggleterm is available
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end

  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local cmd = ""
  
  if venv_path ~= "" then
    cmd = "source " .. venv_path .. "/bin/activate && clear"
    vim.notify("Terminal using .venv environment", vim.log.levels.INFO)
  elseif vim.fn.filereadable(".python-version") == 1 then
    cmd = "pyenv shell $(cat .python-version) && clear"
    vim.notify("Terminal using pyenv environment", vim.log.levels.INFO)
  else
    cmd = "clear"
  end
  
  local term = toggleterm.Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Generic terminal toggle (from ToggleTerm plugin)
map("n", "<leader>tt", function()
  -- Check that toggleterm is available
  local toggleterm_ok, _ = pcall(require, "toggleterm")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end
  vim.cmd("ToggleTerm direction=horizontal")
end, { desc = "Toggle horizontal terminal" })

map("n", "<leader>tf", function()
  -- Check that toggleterm is available
  local toggleterm_ok, _ = pcall(require, "toggleterm")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end
  vim.cmd("ToggleTerm direction=float")
end, { desc = "Toggle floating terminal" })

map("n", "<leader>tv", function()
  -- Check that toggleterm is available
  local toggleterm_ok, _ = pcall(require, "toggleterm")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end
  vim.cmd("ToggleTerm direction=vertical")
end, { desc = "Toggle vertical terminal" })

map("n", "<leader>ts", function() M._smart_terminal() end, { desc = "Smart terminal (with venv)" })

-- Python terminal instances
map("n", "<leader>tp", function() 
  -- Check that python is available
  if not M._command_exists("python") then
    vim.notify("Python is not installed or not in PATH", vim.log.levels.ERROR)
    return
  end

  -- Check that toggleterm is available
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end

  M._venv_smart_activate()
  vim.defer_fn(function() 
    local term = toggleterm.Terminal:new({
      cmd = "python",
      direction = "horizontal",
      close_on_exit = false,
    })
    term:toggle()
  end, 500)
end, { desc = "Python Terminal" })

-- IPython terminal
map("n", "<leader>ti", function() M._toggle_ipython() end, { desc = "IPython Terminal" })

-- Run current Python file
map("n", "<leader>tr", function() M._python_run_file() end, { desc = "Run current Python file" })

-- Docker terminal
map("n", "<leader>td", function() M._toggle_docker_terminal() end, { desc = "Docker Terminal" })

-- Database terminal
map("n", "<leader>tb", function() M._toggle_database_terminal() end, { desc = "Database Terminal" })

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

-- Exit insert mode with jk (MECE, does not interfere with terminal mode mapping)
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- =============================================
-- BUFFER OPERATIONS (b namespace)
-- =============================================

-- Buffer management
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bl", "<cmd>buffers<CR>", { desc = "List buffers" })

-- =============================================
-- FILE EXPLORER OPERATIONS (e namespace)
-- =============================================

-- Helper for checking if NvimTree is available
M._has_nvim_tree = function()
  if not M._has_plugin("nvim-tree") then
    vim.notify("NvimTree plugin not found. Please install nvim-tree/nvim-tree.lua", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Toggle file explorer with error handling
M._toggle_nvim_tree = function()
  if not M._has_nvim_tree() then
    return
  end
  
  local success, err = pcall(vim.cmd, "NvimTreeToggle")
  if not success then
    vim.notify("Error toggling NvimTree: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Focus file explorer with error handling
M._focus_nvim_tree = function()
  if not M._has_nvim_tree() then
    return
  end
  
  local success, err = pcall(vim.cmd, "NvimTreeFocus")
  if not success then
    vim.notify("Error focusing NvimTree: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- File explorer mappings
map("n", "<leader>e", function() M._toggle_nvim_tree() end, { desc = "Toggle file explorer" })

map("n", "<leader>ef", function() M._focus_nvim_tree() end, { desc = "Focus file explorer" })

-- Quick access to built-in file explorer (complements NvimTree)
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw file explorer" })

-- =============================================
-- FILE/FIND OPERATIONS (f namespace)
-- =============================================

-- Helper functions for testing if plugins exist
M._has_telescope = function()
  if not M._has_plugin("telescope") then
    vim.notify("Telescope plugin not found. Please install nvim-telescope/telescope.nvim", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- More robust telescope run function that properly handles errors
M._run_telescope_command = function(telescope_cmd, opts)
  if not M._has_telescope() then
    return
  end
  
  opts = opts or {}
  local status_ok, telescope = pcall(require, "telescope.builtin")
  if not status_ok then
    vim.notify("Failed to require telescope.builtin", vim.log.levels.ERROR)
    return
  end
  
  if not telescope[telescope_cmd] then
    vim.notify("Telescope command not found: " .. telescope_cmd, vim.log.levels.ERROR)
    return
  end
  
  -- Execute the telescope command with error handling
  local success, err = pcall(telescope[telescope_cmd], opts)
  if not success then
    vim.notify("Error running Telescope " .. telescope_cmd .. ": " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Update telescope find files to be more robust
M._telescope_find_files = function()
  if not M._has_telescope() then
    return
  end
  
  local opts = {
    hidden = true,
    no_ignore = false,
    follow = true,  -- Follow symbolic links
  }
  
  M._run_telescope_command("find_files", opts)
end

-- Update telescope live grep to be more robust
M._telescope_live_grep = function()
  if not M._has_telescope() then
    return
  end
  
  local opts = {
    additional_args = function()
      return {"--hidden"}
    end
  }
  
  M._run_telescope_command("live_grep", opts)
end

-- Telescope/find mappings
map("n", "<leader>ff", function() M._telescope_find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() M._telescope_live_grep() end, { desc = "Find in files (grep)" })
map("n", "<leader>fb", function() 
  if M._has_telescope() then
    M._run_telescope_command("buffers")
  end
end, { desc = "Find buffers" })
map("n", "<leader>fh", function() 
  if M._has_telescope() then
    M._run_telescope_command("help_tags")
  end
end, { desc = "Find help tags" })
map("n", "<leader>fr", function() 
  if M._has_telescope() then
    M._run_telescope_command("oldfiles")
  end
end, { desc = "Recent files" })
map("n", "<leader>fm", function() 
  if M._has_telescope() then
    M._run_telescope_command("marks")
  end
end, { desc = "Find marks" })
map("n", "<leader>fd", function()
  if M._has_plugin("dashboard") then
    require('dashboard').find_directory_and_cd()
  else
    vim.notify("Dashboard plugin not found", vim.log.levels.ERROR)
  end
end, { desc = "Find directory and cd" })
map("n", "<leader>fp", function()
  if M._has_telescope() and M._has_plugin("telescope") and pcall(require, "telescope").extensions.projects then
    vim.cmd("Telescope projects")
  else
    vim.notify("Telescope projects extension not available", vim.log.levels.ERROR)
  end
end, { desc = "Find projects" })
map("n", "<leader>fc", function() 
  if M._has_telescope() then
    M._run_telescope_command("commands")
  end
end, { desc = "Find commands" })
map("n", "<leader>f/", function() 
  if M._has_telescope() then
    M._run_telescope_command("current_buffer_fuzzy_find")
  end
end, { desc = "Find in current buffer" })
map("n", "<leader>fs", function() 
  if M._has_telescope() then
    M._run_telescope_command("lsp_document_symbols")
  end
end, { desc = "Find document symbols" })
map("n", "<leader>fz", function() 
  if M._has_telescope() then
    M._run_telescope_command("lsp_dynamic_workspace_symbols")
  end
end, { desc = "Find workspace symbols" })

-- File operations
map("n", "<leader>fw", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fW", "<cmd>wa<CR>", { desc = "Save all files" })
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New file" })

-- =============================================
-- WINDOW OPERATIONS (w namespace)
-- =============================================

-- Window management
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })
map("n", "<leader>wq", "<cmd>q<CR>", { desc = "Quit window" })
map("n", "<leader>wQ", "<cmd>qa<CR>", { desc = "Quit all windows" })
map("n", "<leader>wL", "<cmd>vertical resize +10<CR>", { desc = "Increase width" })
map("n", "<leader>wH", "<cmd>vertical resize -10<CR>", { desc = "Decrease width" })
map("n", "<leader>wK", "<cmd>resize +5<CR>", { desc = "Increase height" })
map("n", "<leader>wJ", "<cmd>resize -5<CR>", { desc = "Decrease height" })

-- Window navigation (without leader key for frequent operations)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Additional window navigation with leader key
map("n", "<leader>ww", "<C-w>w", { desc = "Cycle through windows" })
map("n", "<leader>wp", "<C-w>p", { desc = "Go to previous window" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close all other windows" })
map("n", "<leader>wt", "<C-w>T", { desc = "Move window to new tab" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

-- Tab management
map("n", "<leader>wn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>wc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>wo", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>wl", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>wj", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- =============================================
-- UNDOTREE OPERATION (u namespace)
-- =============================================

-- Check if Undotree is available
M._has_undotree = function()
  if vim.fn.exists(':UndotreeToggle') ~= 2 then
    vim.notify("Undotree plugin not found. Please install mbbill/undotree", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Undotree toggle
map("n", "<leader>u", function()
  if M._has_undotree() then
    vim.cmd("UndotreeToggle")
  end
end, { desc = "Toggle Undotree" })

-- =============================================
-- DOCUMENTATION (d namespace)
-- =============================================

-- Documentation operations
map("n", "<leader>do", function() M._toggle_documentation() end, { desc = "Toggle documentation" })

map("n", "<leader>dO", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsOpenCmd")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Open documentation in buffer" })

map("n", "<leader>df", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsFetch")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Fetch documentation index" })

map("n", "<leader>di", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsInstall")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Install documentation" })

map("n", "<leader>du", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsUpdate")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Update documentation" })

map("n", "<leader>dU", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsUpdateAll")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Update all documentation" })

map("n", "<leader>dh", function()
  if M._has_plugin("nvim-devdocs") then
    vim.cmd("DevdocsSearch")
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Search in documentation" })

-- Machine learning documentation (d + m subfolder)
map("n", "<leader>dm", function()
  if not M._has_plugin("nvim-devdocs") then
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
    return
  end
  
  vim.ui.select(
    { "sklearn", "numpy", "pandas", "tensorflow", "pytorch", "matplotlib" },
    { prompt = "Select ML Documentation:" },
    function(choice) 
      if choice then M._open_ml_docs(choice) end
    end
  )
end, { desc = "Browse ML documentation" })

-- Specific ML docs shortcuts with proper error checking
map("n", "<leader>dmn", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("numpy") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "NumPy docs" })

map("n", "<leader>dmp", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("pandas") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Pandas docs" })

map("n", "<leader>dmt", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("tensorflow") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "TensorFlow docs" })

map("n", "<leader>dmy", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("pytorch") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "PyTorch docs" })

map("n", "<leader>dmm", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("matplotlib") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Matplotlib docs" })

map("n", "<leader>dmk", function() 
  if M._has_plugin("nvim-devdocs") then 
    M._open_ml_docs("scikit-learn") 
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Scikit-learn docs" })

-- =============================================
-- PYTHON / ENV / DEPENDENCIES (p namespace)
-- =============================================
-- All python, venv, poetry, requirements, and code execution actions grouped under <leader>p
local python_group = {
  { key = "<leader>pa", fn = function() if _G.VenvDiagnostics and _G.VenvDiagnostics.smart_activate then vim.cmd("VenvActivate") elseif M._has_venv_selector() then vim.cmd("VenvSelectCached") end end, desc = "Activate Python environment" },
  { key = "<leader>ps", fn = function() if M._has_venv_selector() then vim.cmd("VenvSelect") end end, desc = "Select Python environment" },
  { key = "<leader>pc", fn = function() if M._has_venv_selector() then vim.cmd("VenvSelectCached") end end, desc = "Select cached environment" },
  { key = "<leader>pn", fn = M._create_python_venv, desc = "Create new venv" },
  { key = "<leader>pi", fn = function() if _G.VenvDiagnostics then vim.cmd("VenvDiagnostics") else vim.notify("VenvDiagnostics module not available", vim.log.levels.ERROR) end end, desc = "Show environment info" },
  { key = "<leader>pr", fn = function() if _G.VenvDiagnostics and _G.VenvDiagnostics.run_with_env then vim.cmd("RunPythonWithEnv") else M._python_run_file() end end, desc = "Run current file with env" },
  { key = "<leader>pe", fn = M._python_execute_snippet, desc = "Execute selection" },
  { key = "<leader>pp", fn = function() if M._command_exists("ipython") then M._python_execute_in_ipython() else vim.notify("IPython not installed. Please install it first.", vim.log.levels.ERROR) end end, desc = "Run selection in IPython" },
  { key = "<leader>pnf", fn = M._python_new_file, desc = "New Python file" },
  { key = "<leader>pt", fn = M._run_python_tests, desc = "Run Python tests" },
  { key = "<leader>pg", fn = M._poetry_generate_requirements, desc = "Generate requirements.txt from Poetry" },
  { key = "<leader>pb", fn = M._poetry_build, desc = "Build Poetry package" },
  { key = "<leader>ppub", fn = M._poetry_publish, desc = "Publish Poetry package" },
  { key = "<leader>psh", fn = M._poetry_shell, desc = "Poetry shell" },
  { key = "<leader>ped", fn = M._poetry_edit_pyproject, desc = "Edit pyproject.toml" },
  { key = "<leader>prun", fn = function() if M._check_poetry() then vim.ui.input({ prompt = "Poetry run command: " }, function(cmd) if cmd and cmd ~= "" then M._run_in_terminal("poetry run " .. cmd) end end) end end, desc = "Poetry run command" },
  { key = "<leader>prq", fn = function() vim.cmd("edit requirements.txt") end, desc = "Edit requirements.txt" },
  { key = "<leader>pinst", fn = function() if M._has_plugin("toggleterm") then vim.cmd("TermExec cmd='pip install -r requirements.txt'") elseif M._command_exists("pip") then M._run_in_terminal("pip install -r requirements.txt") else vim.notify("pip command not found", vim.log.levels.ERROR) end end, desc = "Install from requirements.txt" },
}
for _, m in ipairs(python_group) do
  map("n", m.key, m.fn, { desc = m.desc })
end

-- =============================================
-- KEYMAPS HELPER (k namespace)
-- =============================================

-- Check if which-key is available
M._has_which_key = function()
  if not M._has_plugin("which-key") then
    vim.notify("Which-key plugin not found. Please install folke/which-key.nvim", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Register whichkey specific activate command
map("n", "<leader>k", function()
  if M._has_which_key() then
    vim.cmd("WhichKey")
  end
end, { desc = "Show all keybindings" })

-- =============================================
-- GIT OPERATIONS (g namespace)
-- =============================================

-- Check if LazyGit is available
M._has_lazygit = function()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("LazyGit executable not found. Please install lazygit", vim.log.levels.ERROR)
    return false
  end
  
  if not M._has_plugin("lazygit.nvim") then
    vim.notify("LazyGit plugin not found. Please install kdheepak/lazygit.nvim", vim.log.levels.ERROR)
    return false
  end
  
  return true
end

-- LazyGit mappings
map("n", "<leader>gg", function()
  if M._has_lazygit() then
    vim.cmd("LazyGit")
  end
end, { desc = "Open LazyGit" })

map("n", "<leader>gc", function()
  if M._has_lazygit() then
    vim.cmd("LazyGitConfig")
  end
end, { desc = "LazyGit config" })

map("n", "<leader>gf", function()
  if M._has_lazygit() then
    vim.cmd("LazyGitCurrentFile")
  end
end, { desc = "LazyGit current file" })

map("n", "<leader>gF", function()
  if M._has_lazygit() then
    vim.cmd("LazyGitFilter")
  end
end, { desc = "LazyGit filter" })

map("n", "<leader>gb", function()
  if M._has_lazygit() then
    vim.cmd("LazyGitFilterCurrentFile")
  end
end, { desc = "LazyGit branches" })

-- Git window commands (telescope integration)
map("n", "<leader>gB", function()
  if M._has_telescope() then
    vim.cmd("Telescope git_branches")
  end
end, { desc = "Git branches" })

map("n", "<leader>gC", function()
  if M._has_telescope() then
    vim.cmd("Telescope git_commits")
  end
end, { desc = "Git commits" })

map("n", "<leader>gS", function()
  if M._has_telescope() then
    vim.cmd("Telescope git_status")
  end
end, { desc = "Git status" })

map("n", "<leader>gd", function()
  if M._has_telescope() then
    vim.cmd("Telescope git_bcommits")
  end
end, { desc = "Git diff this buffer" })

-- =============================================
-- HARPOON (h namespace)
-- =============================================

-- Check if Harpoon is available
M._has_harpoon = function()
  local ok, _ = pcall(require, "harpoon")
  if not ok then
    vim.notify("Harpoon plugin not found. Please install ThePrimeagen/harpoon", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Add current file to Harpoon (use new API)
map("n", "<leader>ha", function()
  if not M._has_harpoon() then return end
  require("harpoon.mark").add_file()
  vim.notify("File added to Harpoon", vim.log.levels.INFO)
end, { desc = "Harpoon add file" })

-- Toggle Harpoon quick menu (fix modifiable bug)
map("n", "<leader>hh", function()
  if not M._has_harpoon() then return end
  vim.schedule(function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.bo[bufnr].modifiable then
      vim.bo[bufnr].modifiable = true
    end
    require("harpoon.ui").toggle_quick_menu()
  end)
end, { desc = "Harpoon menu" })

-- Dynamically create jump mappings for Harpoon files, using static string for desc
for i = 1, 4 do
  map("n", string.format("<leader>h%d", i), function()
    if not M._has_harpoon() then return end
    require("harpoon.ui").nav_file(i)
  end, {
    desc = "Harpoon file " .. i
  })
end

-- =============================================
-- LSP MAPPINGS
-- =============================================

-- Function for LSP keybindings that is called on LspAttach
M.setup_lsp_mappings = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  
  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- Go to definition/references commands
  map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
  map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
  map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
  map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
  
  -- Documentation and signature help
  map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation" })
  map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Show signature help" })
  
  -- Code actions and workspace management
  map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "Format code" })
  
  -- Diagnostics
  map("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })
  map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
  map("n", "<leader>cq", vim.diagnostic.setloclist, { buffer = bufnr, desc = "List all diagnostics" })
  
  -- Workspace management
  map("n", "<leader>cw", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "Add workspace folder" })
  map("n", "<leader>cW", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "Remove workspace folder" })
  map("n", "<leader>cl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = "List workspace folders" })
end

-- =============================================
-- WHICH-KEY GROUP REGISTRATION (for MECE clarity)
-- =============================================
local function setup_which_key()
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    -- Don't show errors if which-key is not installed
    return false
  end
  
  -- Use the proper format for which-key
  -- This addresses the warning about using an old format
  wk.register({
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>c"] = { name = "+code/lsp" },
    ["<leader>d"] = { name = "+docs" },
    ["<leader>dm"] = { name = "+ml-docs" },
    ["<leader>e"] = { name = "+explorer" },
    ["<leader>f"] = { name = "+find/file" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>h"] = { name = "+harpoon" },
    ["<leader>k"] = { name = "+keymaps" },
    ["<leader>l"] = { name = "+lsp" },
    ["<leader>p"] = { name = "+python/env/dependencies" },
    ["<leader>r"] = { name = "+run/requirements" },
    ["<leader>s"] = { name = "+search" },
    ["<leader>t"] = { name = "+terminal" },
    ["<leader>u"] = { name = "+utilities" },
    ["<leader>w"] = { name = "+window/tab" },
    ["<leader>x"] = { name = "+execute" },
    ["<leader>z"] = { name = "+zen/focus" },
    ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
  })
  
  -- Register individual keymaps for non-prefixed leader keys
  wk.register({
    ["<leader>k"] = { name = "Show all keybindings" },
    ["<leader>?"] = { name = "Show all keymaps (cheatsheet)" },
  })
  
  return true
end

-- Try to set up which-key (will silently fail if not installed)
if M._has_which_key() then
  local wk = require("which-key")
  
  -- Use the proper format for which-key
  -- This addresses the warning about using an old format
  wk.register({
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>c"] = { name = "+code/lsp" },
    ["<leader>d"] = { name = "+docs" },
    ["<leader>dm"] = { name = "+ml-docs" },
    ["<leader>e"] = { name = "+explorer" },
    ["<leader>f"] = { name = "+find/file" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>h"] = { name = "+harpoon" },
    ["<leader>k"] = { name = "+keymaps" },
    ["<leader>l"] = { name = "+lsp" },
    ["<leader>p"] = { name = "+python/env/dependencies" },
    ["<leader>r"] = { name = "+run/requirements" },
    ["<leader>s"] = { name = "+search" },
    ["<leader>t"] = { name = "+terminal" },
    ["<leader>u"] = { name = "+utilities" },
    ["<leader>w"] = { name = "+window/tab" },
    ["<leader>x"] = { name = "+execute" },
    ["<leader>z"] = { name = "+zen/focus" },
    ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
  })
  
  -- Register individual keymaps for non-prefixed leader keys
  wk.register({
    ["<leader>k"] = { name = "Show all keybindings" },
    ["<leader>?"] = { name = "Show all keymaps (cheatsheet)" },
  })
end

-- =============================================
-- KEYBINDING CHEATSHEET
-- =============================================
-- Show all custom mappings in a Telescope window
map("n", "<leader>?", function()
  if pcall(require, "telescope.builtin") then
    require('telescope.builtin').keymaps({
      prompt_title = 'All Keymaps',
      only_buf = false,
    })
  else
    vim.cmd('map')
    vim.notify("Telescope not found, showing default :map", vim.log.levels.INFO)
  end
end, { desc = "Show all keymaps (cheatsheet)" })

-- =============================================
-- GROUPED, MECE MAPPINGS
-- =============================================
-- All mappings are grouped by namespace and have clear, non-overlapping descriptions
-- Buffer (b), Code/LSP (c), Docs (d), Explorer (e), Find/File (f), Git (g), Harpoon (h), Keymaps (k)
-- LSP (l), Python/Env (p), Run (r), Search (s), Terminal (t), Utilities (u), Window/Tab (w), Execute (x), Zen (z)
-- Each group is registered with which-key for discoverability

-- THEME POLISH
-- Use Tokyonight as the primary theme
local function setup_theme()
  -- Apply Tokyonight theme
  local theme_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
  if not theme_ok then
    -- If Tokyonight fails, fall back to default theme
    vim.notify("Could not apply Tokyonight theme, falling back to default", vim.log.levels.WARN)
    vim.cmd.colorscheme("default")
  end
end

-- Set up the theme
setup_theme()

-- Export the module
return M
