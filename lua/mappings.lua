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

-- Global keybindings (not namespace specific)
-- Map jk to escape insert mode (faster alternative to Escape key)
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Helper to run a command in a toggleterm window
M._run_in_terminal = function(cmd, direction)
  direction = direction or "horizontal"
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  })
  term:toggle()
end

-- Python venv smart activation
M._venv_smart_activate = function()
  -- Check if venv_diagnostics module is available
  if _G.VenvDiagnostics and _G.VenvDiagnostics.smart_activate then
    _G.VenvDiagnostics.smart_activate()
    return true
  end
  
  -- Fallback implementation
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local pyenv_path = vim.fn.finddir(".python-version", vim.fn.getcwd() .. ";")
  local poetry_path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
  
  if venv_path ~= "" then
    vim.notify("Detected .venv directory", vim.log.levels.INFO)
    return true
  elseif pyenv_path ~= "" then
    vim.notify("Detected .python-version file", vim.log.levels.INFO)
    return true
  elseif poetry_path ~= "" then
    vim.notify("Detected poetry project", vim.log.levels.INFO)
    return true
  else
    vim.notify("No Python environment detected", vim.log.levels.WARN)
    return false
  end
end

-- Run Python file with environment
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
  
  -- Fallback implementation
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local pyenv_path = vim.fn.finddir(".python-version", vim.fn.getcwd() .. ";")
  local poetry_path = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
  local python_cmd = "python"
  
  if venv_path ~= "" then
    python_cmd = "source " .. venv_path .. "/bin/activate && python"
  elseif pyenv_path ~= "" then
    python_cmd = "pyenv shell $(cat " .. pyenv_path .. ") && python"
  elseif poetry_path ~= "" then
    python_cmd = "poetry run python"
  end
  
  M._run_in_terminal(python_cmd .. " \"" .. file .. "\"")
end

-- Execute Python snippet (selected text)
M._python_execute_snippet = function()
  -- Get visual selection
  local lines = vim.api.nvim_buf_get_visual_selection()
  
  -- Create a temporary file
  local temp_file = os.tmpname() .. ".py"
  local f = io.open(temp_file, "w")
  if not f then
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end
  
  -- Write the selection to the file
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  
  -- Run the file
  M._run_in_terminal("python " .. temp_file)
end

-- Run current selection in IPython
M._python_execute_in_ipython = function()
  -- Get visual selection
  local lines = vim.api.nvim_buf_get_visual_selection()
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
    vim.cmd("DevdocsOpenFloat")
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
    ["scikit-learn"] = "scikit_learn",
    ["ml"] = "scikit_learn",
    ["machinelearning"] = "scikit_learn",
    ["numpy"] = "numpy~1.24",
    ["pandas"] = "pandas~1",
    ["tensorflow"] = "tensorflow~2.12",
    ["pytorch"] = "pytorch",
  }
  
  local doc_type = ft_map[ft] or specialized_docs[ft] or ft
  
  -- Try to open documentation for the specific filetype
  local success = pcall(vim.cmd, "DevdocsOpenFloat " .. vim.fn.shellescape(doc_type))
  
  -- If it fails, try to install the documentation
  if not success then
    vim.notify("Documentation for " .. doc_type .. " not found. Attempting to install...", vim.log.levels.INFO)
    vim.cmd("DevdocsFetch")
    vim.defer_fn(function()
      pcall(vim.cmd, "DevdocsInstall " .. vim.fn.shellescape(doc_type))
      vim.defer_fn(function()
        pcall(vim.cmd, "DevdocsOpenFloat " .. vim.fn.shellescape(doc_type))
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
    ["sklearn"] = "scikit_learn",
    ["scikit-learn"] = "scikit_learn",
    ["numpy"] = "numpy~1.24",
    ["pandas"] = "pandas~1",
    ["tf"] = "tensorflow~2.12",
    ["tensorflow"] = "tensorflow~2.12",
    ["pytorch"] = "pytorch",
    ["matplotlib"] = "matplotlib~3",
    ["ml"] = "scikit_learn",  -- Default to scikit-learn for generic ML request
  }
  
  local target_doc = ml_docs[doc_type] or doc_type
  
  -- Try to open documentation
  local success = pcall(vim.cmd, "DevdocsOpenFloat " .. vim.fn.shellescape(target_doc))
  
  -- If failed, try to install the documentation
  if not success then
    vim.notify("Documentation for " .. target_doc .. " not found. Attempting to install...", vim.log.levels.INFO)
    vim.cmd("DevdocsFetch")
    vim.defer_fn(function()
      pcall(vim.cmd, "DevdocsInstall " .. vim.fn.shellescape(target_doc))
      vim.defer_fn(function()
        pcall(vim.cmd, "DevdocsOpenFloat " .. vim.fn.shellescape(target_doc))
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

-- =============================================
-- TERMINAL OPERATIONS (t namespace)
-- =============================================

-- Smart Terminal - automatically uses local virtual environment if available
M._smart_terminal = function()
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
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Generic terminal toggle (from ToggleTerm plugin)
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
map("n", "<leader>ts", function() M._smart_terminal() end, { desc = "Smart terminal (with venv)" })

-- Python terminal instances
if _G._PYTHON_TOGGLE then
  map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python Terminal" })
else
  -- Fallback to our local implementation
  map("n", "<leader>tp", function() 
    M._venv_smart_activate()
    vim.defer_fn(function() 
      local term = require("toggleterm.terminal").Terminal:new({
        cmd = "python",
        direction = "horizontal",
        close_on_exit = false,
      })
      term:toggle()
    end, 500)
  end, { desc = "Python Terminal" })
end

if _G._IPYTHON_TOGGLE then
  map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython Terminal" })
else
  -- Fallback to our local implementation using IPython
  map("n", "<leader>ti", function() 
    local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
    local cmd = ""
    
    if venv_path ~= "" then
      cmd = "source " .. venv_path .. "/bin/activate && ipython"
    elseif vim.fn.filereadable(".python-version") == 1 then
      cmd = "pyenv shell $(cat .python-version) && ipython"  
    else
      cmd = "ipython"
    end
    
    local term = require("toggleterm.terminal").Terminal:new({
      cmd = cmd,
      direction = "horizontal",
      close_on_exit = false,
    })
    term:toggle()
  end, { desc = "IPython Terminal" })
end

-- Run current Python file
map("n", "<leader>tr", function() M._python_run_file() end, { desc = "Run current Python file" })

-- Docker terminal
if _G._DOCKER_TERM then
  map("n", "<leader>td", "<cmd>lua _DOCKER_TERM()<CR>", { desc = "Docker Terminal" })
end

-- Database terminal
if _G._DATABASE_TERM then
  map("n", "<leader>tb", "<cmd>lua _DATABASE_TERM()<CR>", { desc = "Database Terminal" })
end

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

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

-- File explorer mappings
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Quick access to built-in file explorer (complements NvimTree)
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw file explorer" })

-- =============================================
-- FILE/FIND OPERATIONS (f namespace)
-- =============================================

-- Telescope/find mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find in files (grep)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks" })
map("n", "<leader>fd", "<cmd>lua require('dashboard').find_directory_and_cd()<CR>", { desc = "Find directory and cd" })
map("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Find projects" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Find commands" })
map("n", "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Find document symbols" })
map("n", "<leader>fz", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Find workspace symbols" })

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
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- =============================================
-- UNDOTREE OPERATION (u namespace)
-- =============================================

-- Undotree toggle
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

-- =============================================
-- DOCUMENTATION (d namespace)
-- =============================================

-- Documentation operations
map("n", "<leader>do", function() M._toggle_documentation() end, { desc = "Toggle documentation" })
map("n", "<leader>dO", "<cmd>DevdocsOpen<CR>", { desc = "Open documentation in buffer" })
map("n", "<leader>df", "<cmd>DevdocsFetch<CR>", { desc = "Fetch documentation index" })
map("n", "<leader>di", "<cmd>DevdocsInstall<CR>", { desc = "Install documentation" })
map("n", "<leader>du", "<cmd>DevdocsUpdate<CR>", { desc = "Update documentation" })
map("n", "<leader>dU", "<cmd>DevdocsUpdateAll<CR>", { desc = "Update all documentation" })
map("n", "<leader>dh", "<cmd>DevdocsSearch<CR>", { desc = "Search in documentation" })

-- Machine learning documentation (d + m subfolder)
map("n", "<leader>dm", function() 
  vim.ui.select(
    { "sklearn", "numpy", "pandas", "tensorflow", "pytorch", "matplotlib" },
    { prompt = "Select ML Documentation:" },
    function(choice) 
      if choice then M._open_ml_docs(choice) end
    end
  )
end, { desc = "Browse ML documentation" })

-- Specific ML docs shortcuts
map("n", "<leader>dmn", function() M._open_ml_docs("numpy") end, { desc = "NumPy docs" })
map("n", "<leader>dmp", function() M._open_ml_docs("pandas") end, { desc = "Pandas docs" })
map("n", "<leader>dmt", function() M._open_ml_docs("tensorflow") end, { desc = "TensorFlow docs" })
map("n", "<leader>dmy", function() M._open_ml_docs("pytorch") end, { desc = "PyTorch docs" })
map("n", "<leader>dmm", function() M._open_ml_docs("matplotlib") end, { desc = "Matplotlib docs" })
map("n", "<leader>dmk", function() M._open_ml_docs("scikit-learn") end, { desc = "Scikit-learn docs" })

-- =============================================
-- POETRY OPERATIONS (o namespace)
-- =============================================

-- Poetry keybindings
map("n", "<leader>oi", function() M._poetry_create_venv() end, { desc = "Poetry install dependencies" })
map("n", "<leader>oc", function() M._poetry_new() end, { desc = "Create new Poetry project" })
map("n", "<leader>oa", function() M._poetry_add_package() end, { desc = "Add package" })
map("n", "<leader>or", function() M._poetry_remove_package() end, { desc = "Remove package" })
map("n", "<leader>ou", function() M._poetry_update() end, { desc = "Update packages" })
map("n", "<leader>oo", function() M._poetry_show_outdated() end, { desc = "Show outdated" })
map("n", "<leader>og", function() M._poetry_generate_requirements() end, { desc = "Generate requirements.txt" })
map("n", "<leader>ob", function() M._poetry_build() end, { desc = "Build package" })
map("n", "<leader>op", function() M._poetry_publish() end, { desc = "Publish package" })
map("n", "<leader>os", function() M._poetry_shell() end, { desc = "Poetry shell" })
map("n", "<leader>oe", function() M._poetry_edit_pyproject() end, { desc = "Edit pyproject.toml" })
map("n", "<leader>oR", function() M._poetry_run() end, { desc = "Poetry run command" })

-- =============================================
-- REQUIREMENTS MANAGEMENT (r namespace)
-- =============================================

-- Requirements management with Poetry integration
map("n", "<leader>rg", function() M._poetry_generate_requirements() end, { desc = "Generate from Poetry (recommended)" })
map("n", "<leader>re", "<cmd>edit requirements.txt<CR>", { desc = "Edit requirements.txt" })
map("n", "<leader>ri", "<cmd>TermExec cmd='pip install -r requirements.txt'<CR>", { desc = "Install from requirements.txt" })
map("n", "<leader>rp", "<cmd>echo 'Use Poetry for dependency management with <leader>o'<CR>", { desc = "Use Poetry (<leader>o)" })

-- =============================================
-- VIRTUAL ENV OPERATIONS (v namespace)
-- =============================================

-- Smart activation that checks for common environment patterns
map("n", "<leader>va", "<cmd>VenvActivate<CR>", { desc = "Smart activate Python environment" })
-- Standard VenvSelect for choosing any environment
map("n", "<leader>vs", "<cmd>VenvSelect<CR>", { desc = "Select Python environment" })
-- Cached environment selection
map("n", "<leader>vc", "<cmd>VenvSelectCached<CR>", { desc = "Select cached environment" })
-- Create a new virtual environment
map("n", "<leader>vn", "<cmd>VenvCreate<CR>", { desc = "Create new venv" })
-- Show environment info
map("n", "<leader>vi", "<cmd>VenvDiagnostics<CR>", { desc = "Show environment info" })
-- Run diagnostics on current environment
map("n", "<leader>vd", "<cmd>VenvDiagnostics<CR>", { desc = "Run venv diagnostics" })
-- Test current environment
map("n", "<leader>vt", "<cmd>TestVenv<CR>", { desc = "Test current venv" })
-- Run current file with venv
map("n", "<leader>vr", "<cmd>RunPythonWithEnv<CR>", { desc = "Run file with venv" })

-- =============================================
-- EXECUTE CODE OPERATIONS (x namespace)
-- =============================================

-- Python execution and file operations 
map("n", "<leader>xr", "<cmd>RunPythonWithEnv<CR>", { desc = "Run current file" })
map("n", "<leader>xe", function() M._python_execute_snippet() end, { desc = "Execute selection" })
map("n", "<leader>xi", function() M._python_execute_in_ipython() end, { desc = "Run in IPython" })
map("n", "<leader>xn", function() M._python_new_file() end, { desc = "New Python file" })
map("n", "<leader>xt", "<cmd>Telescope python_tests<CR>", { desc = "Run tests" })
map("n", "<leader>xp", "<cmd>echo 'Use <leader>o for Poetry dependency management'<CR>", { desc = "Dependency management ⟶ <leader>o" })
map("n", "<leader>xv", "<cmd>VenvActivate<CR>", { desc = "Activate virtual environment" })

-- =============================================
-- KEYMAPS HELPER (k namespace)
-- =============================================

-- Register whichkey specific activate command
map("n", "<leader>k", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })

-- =============================================
-- GIT OPERATIONS (g namespace)
-- =============================================

-- LazyGit mappings
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
map("n", "<leader>gc", "<cmd>LazyGitConfig<CR>", { desc = "LazyGit config" })
map("n", "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", { desc = "LazyGit current file" })
map("n", "<leader>gF", "<cmd>LazyGitFilter<CR>", { desc = "LazyGit filter" })
map("n", "<leader>gb", "<cmd>LazyGitFilterCurrentFile<CR>", { desc = "LazyGit branches" })

-- Git window commands (telescope integration)
map("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
map("n", "<leader>gC", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gS", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
map("n", "<leader>gd", "<cmd>Telescope git_bcommits<CR>", { desc = "Git diff this buffer" })

-- Function for gitsigns keybindings setup
M.setup_git_mappings = function(gitsigns)
  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gitsigns.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })

  map("n", "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gitsigns.prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Previous hunk" })

  -- Actions
  map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
  map("v", "<leader>gs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage hunk" })
  map("v", "<leader>gr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset hunk" })
  map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
  map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
  map("n", "<leader>gl", function()
    gitsigns.blame_line({ full = true })
  end, { desc = "Blame line" })
  map("n", "<leader>gL", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
  map("n", "<leader>gD", gitsigns.diffthis, { desc = "Diff this" })
  map("n", "<leader>gx", function()
    gitsigns.toggle_deleted()
  end, { desc = "Toggle deleted" })
end

-- Function for diagnostic window keybindings
M.setup_diagnostic_window_mappings = function(buf)
  -- Add keybindings for the diagnostic window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
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
-- HELPER FUNCTIONS
-- =============================================

-- Helper function to get visual selection
function vim.api.nvim_buf_get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  
  -- Get lines in the selection
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- If there's only one line in the selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    -- Adjust first and last lines of the selection
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end
  
  return lines
end

-- Export the module
return M
