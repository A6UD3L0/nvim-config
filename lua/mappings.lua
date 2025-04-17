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
  if not handle then
    return false
  end

  local result = handle:read "*a"
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

  local term = toggleterm.Terminal:new {
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  }
  term:toggle()
end

-- IPython terminal toggle implementation
M._toggle_ipython = function()
  -- Check if ipython is installed
  if not M._command_exists "ipython" then
    vim.notify("IPython is not installed. Please install it first.", vim.log.levels.ERROR)
    return
  end

  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local cmd = ""

  if venv_path ~= "" then
    cmd = "source " .. venv_path .. "/bin/activate && ipython"
  elseif vim.fn.filereadable ".python-version" == 1 then
    cmd = "pyenv shell $(cat .python-version) && ipython"
  else
    cmd = "ipython"
  end

  M._run_in_terminal(cmd)
end

-- Docker terminal implementation
M._toggle_docker_terminal = function()
  -- Check if docker is installed
  if not M._command_exists "docker" then
    vim.notify("Docker is not installed. Please install it first.", vim.log.levels.ERROR)
    return
  end

  M._run_in_terminal "docker ps"
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
      if not choice then
        return
      end

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

-- Enhanced Python file runner - Improved to reliably run Python files
M._python_run_file = function()
  local file = vim.fn.expand("%:p")
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end

  if vim.bo.filetype ~= "python" then
    vim.notify("Not a Python file", vim.log.levels.ERROR)
    return
  end

  -- Get the best Python command for the current environment
  local python_cmd = "python"
  
  -- Check for virtual environment
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  if venv_path ~= "" then
    if vim.fn.has("win32") == 1 then
      python_cmd = venv_path .. "\\Scripts\\python.exe"
    else
      python_cmd = "source " .. venv_path .. "/bin/activate && python"
    end
  elseif vim.fn.filereadable(".python-version") == 1 then
    python_cmd = "pyenv shell $(cat .python-version) && python"
  elseif vim.fn.filereadable("pyproject.toml") == 1 then
    python_cmd = "poetry run python"
  end
  
  -- Execute the file in a terminal
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if toggleterm_ok then
    local term = toggleterm.Terminal:new({
      cmd = python_cmd .. " \"" .. file .. "\"",
      direction = "horizontal",
      close_on_exit = false,
      on_open = function(term)
        vim.cmd("startinsert!")
      end,
    })
    term:toggle()
  else
    -- Fallback to built-in terminal if toggleterm is not available
    vim.cmd("split | terminal " .. python_cmd .. " \"" .. file .. "\"")
  end
end

-- Update keybindings for running Python files
map("n", "<leader>pr", function()
  M._python_run_file()
end, { desc = "Run current Python file" })

-- Ensure run key also works
map("n", "<F5>", function()
  M._python_run_file()
end, { desc = "Run current file" })

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
  local python_cmd = "python"
  
  -- Check for virtual environment
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  if venv_path ~= "" then
    if vim.fn.has("win32") == 1 then
      python_cmd = venv_path .. "\\Scripts\\python.exe"
    else
      python_cmd = "source " .. venv_path .. "/bin/activate && python"
    end
  elseif vim.fn.filereadable(".python-version") == 1 then
    python_cmd = "pyenv shell $(cat .python-version) && python"
  elseif vim.fn.filereadable("pyproject.toml") == 1 then
    python_cmd = "poetry run python"
  end
  
  -- Run the file with proper error handling
  vim.notify("Executing Python code...", vim.log.levels.INFO)
  M._run_in_terminal(python_cmd .. ' "' .. temp_file .. '"')
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
    if not name or name == "" then
      return
    end

    -- Add .py extension if not present
    if not name:match "%.py$" then
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
      "Created on " .. os.date "%Y-%m-%d",
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
    vim.api.nvim_win_set_cursor(0, { 11, 4 })
  end)
end

-- POETRY FUNCTIONS

-- Check if Poetry is installed
M._check_poetry = function()
  local poetry_installed = M._command_exists "poetry"
  if not poetry_installed then
    vim.notify("Poetry is not installed. Please install it first.", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Poetry shell
M._poetry_shell = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry shell"
end

-- Create Poetry environment and install dependencies
M._poetry_create_venv = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry install"
end

-- Add a package with Poetry
M._poetry_add_package = function()
  if not M._check_poetry() then
    return
  end

  vim.ui.input({ prompt = "Package to add: " }, function(package)
    if not package or package == "" then
      return
    end

    -- Ask if it's a dev dependency
    vim.ui.select({ "regular", "dev" }, {
      prompt = "Dependency type:",
    }, function(choice)
      if not choice then
        return
      end

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
  if not M._check_poetry() then
    return
  end

  -- Get list of installed packages
  local handle = io.popen "poetry show --no-ansi | awk '{print $1}'"
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
    if not package then
      return
    end

    M._run_in_terminal("poetry remove " .. package)
  end)
end

-- Update packages with Poetry
M._poetry_update = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry update"
end

-- Show outdated packages
M._poetry_show_outdated = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry show --outdated"
end

-- Generate requirements.txt from Poetry with improved options and error handling
M._poetry_generate_requirements = function()
  if not M._check_poetry() then
    return
  end
  
  -- Check if pyproject.toml exists
  if vim.fn.filereadable("pyproject.toml") == 0 then
    vim.notify("No pyproject.toml found in the current directory.", vim.log.levels.ERROR)
    return
  end
  
  -- Offer different export options
  local options = {
    "Standard requirements.txt (main dependencies)",
    "Development requirements.txt (with dev dependencies)",
    "Requirements with versions pinned",
    "Requirements without hashes",
  }
  
  vim.ui.select(options, {
    prompt = "Choose export option:",
    format_item = function(item) return item end,
  }, function(choice)
    if not choice then return end
    
    local cmd
    if choice == options[1] then
      cmd = "poetry export --format requirements.txt --output requirements.txt --without-hashes"
    elseif choice == options[2] then
      cmd = "poetry export --format requirements.txt --output requirements-dev.txt --with dev --without-hashes"
    elseif choice == options[3] then
      cmd = "poetry export --format requirements.txt --output requirements.txt"
    elseif choice == options[4] then
      cmd = "poetry export --format requirements.txt --output requirements.txt --without-hashes"
    end
    
    M._run_in_terminal(cmd)
    vim.notify("Generating requirements.txt...", vim.log.levels.INFO)
  end)
end

-- Import requirements.txt into poetry project
M._poetry_import_requirements = function()
  if not M._check_poetry() then
    return
  end
  
  -- First check if requirements.txt exists
  if vim.fn.filereadable("requirements.txt") == 0 then
    vim.notify("No requirements.txt found in the current directory.", vim.log.levels.ERROR)
    return
  end
  
  -- Check if pyproject.toml exists, if not offer to init a new project
  if vim.fn.filereadable("pyproject.toml") == 0 then
    vim.notify("No pyproject.toml found. Initialize a new Poetry project first.", vim.log.levels.WARN)
    vim.ui.select({"Yes", "No"}, {
      prompt = "Initialize new Poetry project?",
    }, function(choice)
      if choice == "Yes" then
        M._run_in_terminal("poetry init --no-interaction")
      else
        return
      end
    end)
    return
  end
  
  M._run_in_terminal("poetry add $(cat requirements.txt)")
  vim.notify("Importing dependencies from requirements.txt...", vim.log.levels.INFO)
end

-- Build Poetry package
M._poetry_build = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry build"
end

-- Publish Poetry package
M._poetry_publish = function()
  if not M._check_poetry() then
    return
  end
  M._run_in_terminal "poetry publish"
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
  if not M._check_poetry() then
    return
  end

  vim.ui.input({ prompt = "Command to run: " }, function(cmd)
    if not cmd or cmd == "" then
      return
    end
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
      if buf_name:match "DevDocs" or buf_name:match "devdocs://" then
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
          vim.cmd "close"
          return
        end
      end
    end
  end

  -- If not found or not visible, open new documentation
  local ft = vim.bo.filetype
  if ft == "" then
    -- No filetype, just open general docs
    vim.cmd "DevdocsOpenCmd"
    return
  end

  -- Map filetypes to their documentation types
  local ft_map = {
    python = "python~3.11", -- Use specific Python version
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
    vim.cmd "DevdocsFetch"
    vim.defer_fn(function()
      pcall(vim.cmd, "DevdocsInstall " .. vim.fn.shellescape(doc_type))
      vim.defer_fn(function()
        pcall(vim.cmd, "DevdocsOpenFloatCmd " .. vim.fn.shellescape(doc_type))
      end, 2000)
    end, 1000)
  end
end

-- Documentation keybinding
map("n", "<leader>do", function()
  M._toggle_documentation()
end, { desc = "Toggle documentation" })

map("n", "<leader>dO", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsOpenCmd"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Open documentation in buffer" })

map("n", "<leader>df", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsFetch"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Fetch documentation index" })

map("n", "<leader>di", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsInstall"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Install documentation" })

map("n", "<leader>du", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsUpdate"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Update documentation" })

map("n", "<leader>dU", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsUpdateAll"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Update all documentation" })

map("n", "<leader>dh", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd "DevdocsSearch"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Search in documentation" })

-- Machine learning documentation (d + m subfolder)
map("n", "<leader>dm", function()
  if not M._has_plugin "nvim-devdocs" then
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(
    { "sklearn", "numpy", "pandas", "tensorflow", "pytorch", "matplotlib" },
    { prompt = "Select ML Documentation:" },
    function(choice)
      if choice then
        M._open_ml_docs(choice)
      end
    end
  )
end, { desc = "Browse ML documentation" })

-- Specific ML docs shortcuts with proper error checking
map("n", "<leader>dmn", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "numpy"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "NumPy docs" })

map("n", "<leader>dmp", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "pandas"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Pandas docs" })

map("n", "<leader>dmt", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "tensorflow"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "TensorFlow docs" })

map("n", "<leader>dmy", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "pytorch"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "PyTorch docs" })

map("n", "<leader>dmm", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "matplotlib"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Matplotlib docs" })

map("n", "<leader>dmk", function()
  if M._has_plugin "nvim-devdocs" then
    M._open_ml_docs "scikit-learn"
  else
    vim.notify("DevDocs plugin not found. Please install luckasRanarison/nvim-devdocs", vim.log.levels.ERROR)
  end
end, { desc = "Scikit-learn docs" })

-- =============================================
-- LSP MAPPINGS
-- =============================================

-- Function for LSP keybindings that is called on LspAttach
M.setup_lsp_mappings = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
  map("n", "<leader>cf", function()
    vim.lsp.buf.format { async = true }
  end, { buffer = bufnr, desc = "Format code" })

  -- Advanced Diagnostics
  map("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })
  map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
  map("n", "<leader>cq", vim.diagnostic.setloclist, { buffer = bufnr, desc = "List all diagnostics" })

  -- Diagnostic severity navigation (only go to errors/warnings)
  map("n", "[e", function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, { buffer = bufnr, desc = "Previous error" })

  map("n", "]e", function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  end, { buffer = bufnr, desc = "Next error" })

  map("n", "[w", function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
  end, { buffer = bufnr, desc = "Previous warning" })

  map("n", "]w", function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
  end, { buffer = bufnr, desc = "Next warning" })

  -- Workspace management
  map("n", "<leader>cw", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "Add workspace folder" })
  map("n", "<leader>cW", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "Remove workspace folder" })
  map("n", "<leader>cl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = "List workspace folders" })

  -- Advanced Symbol Navigation
  local ok_telescope, telescope = pcall(require, "telescope.builtin")
  if ok_telescope then
    -- Symbol navigation with Telescope
    map("n", "<leader>cs", telescope.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
    map("n", "<leader>cS", telescope.lsp_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
    map("n", "<leader>ci", telescope.lsp_implementations, { buffer = bufnr, desc = "Find implementations" })
    map("n", "<leader>cD", telescope.lsp_type_definitions, { buffer = bufnr, desc = "Find type definitions" })
    map("n", "<leader>cu", telescope.lsp_references, { buffer = bufnr, desc = "Find usages/references" })
    map("n", "<leader>cC", telescope.lsp_incoming_calls, { buffer = bufnr, desc = "Incoming calls" })
    map("n", "<leader>cO", telescope.lsp_outgoing_calls, { buffer = bufnr, desc = "Outgoing calls" })
  end

  -- Toggle Inline Diagnostics
  map("n", "<leader>cT", function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config { virtual_text = not current }
    vim.notify("Inline diagnostics " .. (not current and "enabled" or "disabled"))
  end, { buffer = bufnr, desc = "Toggle inline diagnostics" })

  -- LSP Info and Restart
  map("n", "<leader>cI", "<cmd>LspInfo<CR>", { buffer = bufnr, desc = "LSP info" })
  map("n", "<leader>cR", "<cmd>LspRestart<CR>", { buffer = bufnr, desc = "LSP restart" })

  -- Peek Definition
  map("n", "<leader>cp", function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
      if not result or vim.tbl_isempty(result) then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end

      local target = result[1]
      if target.targetUri then
        target.uri = target.targetUri
        target.range = target.targetSelectionRange
      end

      -- Create a small floating window to preview definition
      vim.lsp.util.preview_location(target, { border = "rounded" })
    end)
  end, { buffer = bufnr, desc = "Peek definition" })
end

-- Function for diagnostic window keybindings with enhanced UX
M.setup_diagnostic_window_mappings = function(buf)
  -- Add better keybindings for the diagnostic window with descriptive comments
  -- Aesthetically pleasing window navigation

  -- Create a more user-friendly diagnostic window header
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, {
    "  📌 LSP Diagnostics",
    "  ══════════════════",
    "",
    "  Navigation:",
    "    j/k  - Move up/down",
    "    q/Esc - Close window",
    "    <CR>  - Jump to location",
    "    o     - Open in split",
    "    <C-v> - Open in vertical split",
    "    <C-t> - Open in new tab",
    "    <C-f> - Page down",
    "    <C-b> - Page up",
    "    gg/G  - Go to top/bottom",
    "",
    "  Filter Severity:",
    "    1     - Show errors only",
    "    2     - Show warnings & errors",
    "    3     - Show info & above",
    "    4     - Show all diagnostics",
    "",
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    "",
  })

  -- Set readonly and modified flags to false
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Basic window navigation
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "q",
    ":q<CR>",
    { noremap = true, silent = true, desc = "Close diagnostic window" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<Esc>",
    ":q<CR>",
    { noremap = true, silent = true, desc = "Close diagnostic window" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<CR>",
    "<CMD>lua vim.lsp.buf.definition()<CR>",
    { noremap = true, silent = true, desc = "Go to definition" }
  )

  -- Advanced window navigation
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "o",
    "<CMD>lua vim.lsp.buf.definition()<CMD>split<CR>",
    { noremap = true, silent = true, desc = "Open in horizontal split" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<C-v>",
    "<CMD>lua vim.lsp.buf.definition()<CMD>vsplit<CR>",
    { noremap = true, silent = true, desc = "Open in vertical split" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<C-t>",
    "<CMD>lua vim.lsp.buf.definition()<CMD>tabnew<CR>",
    { noremap = true, silent = true, desc = "Open in new tab" }
  )

  -- Filtering diagnostics by severity
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "1",
    "<CMD>lua vim.diagnostic.setqflist({severity = vim.diagnostic.severity.ERROR})<CR>",
    { noremap = true, silent = true, desc = "Show errors only" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "2",
    "<CMD>lua vim.diagnostic.setqflist({severity = {min = vim.diagnostic.severity.WARN}})<CR>",
    { noremap = true, silent = true, desc = "Show warnings & errors" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "3",
    "<CMD>lua vim.diagnostic.setqflist({severity = {min = vim.diagnostic.severity.INFO}})<CR>",
    { noremap = true, silent = true, desc = "Show info & above" }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "4",
    "<CMD>lua vim.diagnostic.setqflist()<CR>",
    { noremap = true, silent = true, desc = "Show all diagnostics" }
  )

  -- Visual enhancements for the diagnostic window
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  -- Set colorful highlighting
  vim.api.nvim_set_hl(0, "DiagnosticHeader", { fg = "#7DCFFF", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSubHeader", { fg = "#BB9AF7", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticSeparator", { fg = "#FF9E64" })

  -- Apply highlighting to the header lines
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticHeader", 0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticSubHeader", 1, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticSubHeader", 3, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticSubHeader", 15, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticSeparator", 21, 0, -1)

  -- Set window layout options for the diagnostic buffer
  vim.cmd [[
    setlocal signcolumn=yes
    setlocal cursorline
    setlocal conceallevel=3
    setlocal concealcursor=nvic
  ]]
end

-- Helper function to toggle LSP inlay hints if server supports it
M.toggle_inlay_hints = function(bufnr)
  local inlay_hint_enabled = vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
  if inlay_hint_enabled ~= nil then
    vim.lsp.inlay_hint.enable(not inlay_hint_enabled, { bufnr = bufnr })
    vim.notify("Inlay hints " .. (not inlay_hint_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
  else
    vim.notify("Inlay hints not supported by current Neovim version", vim.log.levels.WARN)
  end
end

-- Global LSP keymaps (not buffer-specific)
map("n", "<leader>lh", function()
  M.toggle_inlay_hints(0)
end, { desc = "Toggle inlay hints" })
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "LSP restart" })
map("n", "<leader>ls", "<cmd>LspStart<CR>", { desc = "LSP start" })
map("n", "<leader>lS", "<cmd>LspStop<CR>", { desc = "LSP stop" })

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
  wk.register {
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
  }

  -- Register individual keymaps for non-prefixed leader keys
  wk.register {
    ["<leader>k"] = { name = "Show all keybindings" },
    ["<leader>?"] = { name = "Show all keymaps (cheatsheet)" },
  }

  return true
end

-- Try to set up which-key (will silently fail if not installed)
setup_which_key()

-- =============================================
-- KEYBINDING CHEATSHEET
-- =============================================
-- Show all custom mappings in a Telescope window
map("n", "<leader>?", function()
  if pcall(require, "telescope.builtin") then
    require("telescope.builtin").keymaps {
      prompt_title = "All Keymaps",
      only_buf = false,
    }
  else
    vim.cmd "map"
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
    vim.cmd.colorscheme "default"
  end
end

-- Set up the theme
setup_theme()

-- ===========================================
-- ThePrimeagen's keybindings integration
-- ===========================================

-- Map Q to q in normal and visual mode (disable Ex mode)
vim.keymap.set("n", "Q", "<nop>")

-- Map <Esc> to <A-Esc> (Option+Esc) in normal, insert, and visual mode
map({ "n", "i", "v" }, "<Esc>", "<A-Esc>", { noremap = true, silent = true, desc = "Esc is Option+Esc" })

-- Exit insert mode with jk (faster than Escape)
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Quick movement between windows
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move visual blocks up and down with J and K
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Better line joining without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Half-page jumping with centered cursor
map("n", "<C-d>", "<C-d>zz", { desc = "Move down half page and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up half page and center" })

-- Keep search terms in the middle of the screen
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Preserve clipboard when pasting over text in visual mode
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- Yank to system clipboard with leader
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Delete to void register (don't fill clipboard with deletions)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Quickfix navigation
map("n", "<C-n>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<C-p>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "<leader>qq", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })

-- Replace word under cursor (global)
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Make current file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })

-- LazyGit shortcuts (these complement the ones in the plugin config)
map("n", "<leader>gl", "<cmd>LazyGitFilterCurrentFile<CR>", { desc = "LazyGit current file logs" })
map("n", "<leader>gb", "<cmd>LazyGitFilter<CR>", { desc = "LazyGit blame" })

-- Harpoon marks (ThePrimeagen's navigation tool)
local function setup_harpoon_mappings()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    vim.notify("Harpoon not available", vim.log.levels.WARN)
    return
  end

  -- Set up harpoon keymaps
  map("n", "<leader>ha", function()
    harpoon.list():append()
  end, { desc = "Add to Harpoon" })
  map("n", "<leader>hh", function()
    harpoon.ui:toggle_quick_menu(harpoon.list())
  end, { desc = "Show Harpoon" })

  -- Quick file navigation with harpoon
  map("n", "<leader>1", function()
    harpoon.list():select(1)
  end, { desc = "Harpoon file 1" })
  map("n", "<leader>2", function()
    harpoon.list():select(2)
  end, { desc = "Harpoon file 2" })
  map("n", "<leader>3", function()
    harpoon.list():select(3)
  end, { desc = "Harpoon file 3" })
  map("n", "<leader>4", function()
    harpoon.list():select(4)
  end, { desc = "Harpoon file 4" })
  map("n", "<leader>5", function()
    harpoon.list():select(5)
  end, { desc = "Harpoon file 5" })
end

-- Try to set up Harpoon (doesn't error if not available)
pcall(setup_harpoon_mappings)

-- Undotree mappings (complementing the plugin config)
map("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
map("n", "<leader>uf", "<cmd>UndotreeFocus<CR>", { desc = "Focus Undotree" })

-- DevDocs additional shortcuts
map("n", "<leader>df", function()
  local ft = vim.bo.filetype
  if ft == "python" then
    vim.cmd "DevdocsOpenFloat python"
  elseif ft == "go" then
    vim.cmd "DevdocsOpenFloat go"
  elseif ft == "lua" then
    vim.cmd "DevdocsOpenFloat lua"
  elseif ft == "bash" or ft == "sh" then
    vim.cmd "DevdocsOpenFloat bash"
  elseif ft == "javascript" or ft == "typescript" then
    vim.cmd "DevdocsOpenFloat javascript"
  elseif ft == "docker" or ft == "dockerfile" then
    vim.cmd "DevdocsOpenFloat docker"
  elseif ft == "sql" then
    vim.cmd "DevdocsOpenFloat sql"
  else
    vim.cmd "DevdocsOpenFloat"
  end
end, { desc = "Open docs for current filetype" })

-- ThePrimeagen's project navigation - find files
map("n", "<leader>pf", function()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    telescope.find_files()
  else
    vim.notify("Telescope not available", vim.log.levels.WARN)
  end
end, { desc = "Find files in project" })

-- Find Git files (if in Git repo)
map("n", "<C-p>", function()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    pcall(telescope.git_files)
  else
    vim.notify("Telescope not available", vim.log.levels.WARN)
  end
end, { desc = "Find Git files" })

-- Grep search with Telescope
map("n", "<leader>ps", function()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    telescope.live_grep()
  else
    vim.notify("Telescope not available", vim.log.levels.WARN)
  end
end, { desc = "Project search (grep)" })

-- Fuzzy find in current buffer
map("n", "<leader>/", function()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    telescope.current_buffer_fuzzy_find()
  else
    vim.notify("Telescope not available", vim.log.levels.WARN)
  end
end, { desc = "Fuzzy find in buffer" })

-- Improved Git mappings for <leader>g group
local wk = require "which-key"
wk.register({
  g = {
    name = "+git",
    s = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage hunk",
    },
    r = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },
    S = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage buffer",
    },
    u = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo stage hunk",
    },
    R = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Reset buffer",
    },
    p = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },
    B = {
      function()
        require("gitsigns").blame_line { full = true }
      end,
      "Blame line (full)",
    },
    L = {
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      "Toggle line blame",
    },
    d = {
      function()
        require("gitsigns").diffthis()
      end,
      "Diff this",
    },
    x = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
    f = { "<cmd>Telescope git_files<CR>", "Find git files" },
    c = { "<cmd>Telescope git_commits<CR>", "Git commits" },
    b = { "<cmd>Telescope git_branches<CR>", "Git branches" },
    l = { "<cmd>LazyGit<CR>", "Open LazyGit" },
  },
}, { prefix = "<leader>" })

-- =============================================
-- GIT MAPPINGS
-- =============================================
-- Git integration with superior UX
M.setup_git_mappings = function()
  -- Check if gitsigns is available
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    vim.notify("Gitsigns not available for Git keybindings", vim.log.levels.WARN)
    return
  end

  -- Navigation between hunks
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
    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Stage hunk" })
  map("v", "<leader>gr", function()
    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Reset hunk" })
  map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
  map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
  map("n", "<leader>gB", function()
    gitsigns.blame_line { full = true }
  end, { desc = "Blame line" })
  map("n", "<leader>gL", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
  map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
  map("n", "<leader>gx", function()
    gitsigns.toggle_deleted()
  end, { desc = "Toggle deleted" })
  
  -- Telescope git integration
  if M._has_plugin("telescope.builtin") then
    local telescope = require("telescope.builtin")
    map("n", "<leader>gf", telescope.git_files, { desc = "Find git files" })
    map("n", "<leader>gc", telescope.git_commits, { desc = "Git commits" })
    map("n", "<leader>gb", telescope.git_branches, { desc = "Git branches" })
  end
  
  -- LazyGit integration
  if M._command_exists("lazygit") then
    map("n", "<leader>gl", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
  end
  
  -- Register with which-key
  if M._has_plugin("which_key_setup") then
    require("which_key_setup").register_group({
      g = {
        name = "+git",
        s = { function() gitsigns.stage_hunk() end, "Stage hunk" },
        r = { function() gitsigns.reset_hunk() end, "Reset hunk" },
        S = { function() gitsigns.stage_buffer() end, "Stage buffer" },
        u = { function() gitsigns.undo_stage_hunk() end, "Undo stage hunk" },
        R = { function() gitsigns.reset_buffer() end, "Reset buffer" },
        p = { function() gitsigns.preview_hunk() end, "Preview hunk" },
        B = { function() gitsigns.blame_line { full = true } end, "Blame line (full)" },
        L = { function() gitsigns.toggle_current_line_blame() end, "Toggle line blame" },
        d = { function() gitsigns.diffthis() end, "Diff this" },
        x = { function() gitsigns.toggle_deleted() end, "Toggle deleted" },
        f = { "<cmd>Telescope git_files<CR>", "Find git files" },
        c = { "<cmd>Telescope git_commits<CR>", "Git commits" },
        b = { "<cmd>Telescope git_branches<CR>", "Git branches" },
        l = { "<cmd>LazyGit<CR>", "Open LazyGit" },
      },
    }, { prefix = "<leader>" })
  end
end

-- Set up git mappings if available
pcall(M.setup_git_mappings)

-- Enhanced LSP mappings with better UX
M.setup_lsp_mappings = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Go to definition/references commands
  map("n", "gd", function() vim.lsp.buf.definition() end, opts)
  map("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  map("n", "gr", function() vim.lsp.buf.references() end, opts)
  map("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  map("n", "gt", function() vim.lsp.buf.type_definition() end, opts)

  -- Documentation and help
  map("n", "K", function() vim.lsp.buf.hover() end, opts)
  map("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)

  -- Code actions and navigation
  map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  map("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  map("n", "<leader>cf", function() vim.lsp.buf.format { async = true } end, opts)

  -- Workspace management
  map("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end, opts)
  map("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end, opts)
  map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)

  -- Diagnostic navigation
  map("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  map("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  map("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
  map("n", "<leader>q", function() vim.diagnostic.setloclist() end, opts)
  
  -- Register with which-key
  if M._has_plugin("which_key_setup") then
    local wk_status_ok, wk_setup = pcall(require, "which_key_setup")
    if wk_status_ok then
      wk_setup.register_group({
        ["g"] = {
          d = { function() vim.lsp.buf.definition() end, "Go to definition" },
          D = { function() vim.lsp.buf.declaration() end, "Go to declaration" },
          r = { function() vim.lsp.buf.references() end, "Go to references" },
          i = { function() vim.lsp.buf.implementation() end, "Go to implementation" },
          t = { function() vim.lsp.buf.type_definition() end, "Go to type definition" },
        },
        ["<leader>"] = {
          c = {
            a = { function() vim.lsp.buf.code_action() end, "Code action" },
            f = { function() vim.lsp.buf.format { async = true } end, "Format code" },
          },
          r = {
            n = { function() vim.lsp.buf.rename() end, "Rename symbol" },
          },
          w = {
            a = { function() vim.lsp.buf.add_workspace_folder() end, "Add workspace folder" },
            r = { function() vim.lsp.buf.remove_workspace_folder() end, "Remove workspace folder" },
            l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders" },
          },
        },
      }, { buffer = bufnr })
    end
  end
end

-- Function for diagnostic window keybindings
M.setup_diagnostic_window_mappings = function(buf)
  -- Add keybindings for the diagnostic window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
end

-- Helper function to toggle LSP inlay hints if server supports it
M.toggle_inlay_hints = function(bufnr)
  local inlay_hint_enabled = vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
  if inlay_hint_enabled ~= nil then
    vim.lsp.inlay_hint.enable(not inlay_hint_enabled, { bufnr = bufnr })
    vim.notify("Inlay hints " .. (not inlay_hint_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
  else
    vim.notify("Inlay hints not supported by current Neovim version", vim.log.levels.WARN)
  end
end

-- Global LSP keymaps (not buffer-specific)
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "LSP restart" })
map("n", "<leader>ls", "<cmd>LspStart<CR>", { desc = "LSP start" })
map("n", "<leader>lS", "<cmd>LspStop<CR>", { desc = "LSP stop" })

-- Make Q behave the same as q (for macro recording)
map("n", "Q", "q", { desc = "Use Q for macro recording (same as q)" })

-- Map common typos to their intended commands
vim.cmd("command! Q q")  -- Map :Q to :q (quit)
vim.cmd("command! Qa qa")  -- Map :Qa to :qa (quit all)
vim.cmd("command! QA qa")  -- Map :QA to :qa (quit all)
vim.cmd("command! Wq wq")  -- Map :Wq to :wq (write and quit)
vim.cmd("command! WQ wq")  -- Map :WQ to :wq (write and quit)
vim.cmd("command! W w")    -- Map :W to :w (write)

return M
