-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Create a module for exported functions
local M = {}

-- =============================================
-- KEYBINDING ORGANIZATION REFERENCE (MECE)
-- =============================================
--
-- Namespace structure for leader-prefixed commands:
-- <leader>b  - Buffer operations (buffer navigation, management)
-- <leader>c  - Code actions (LSP, formatting, diagnostics)
-- <leader>d  - Debug operations (debugging workflow)
-- <leader>e  - Explorer operations (file explorer, project navigation)
-- <leader>f  - Find/File operations (Telescope, file search, save)
-- <leader>g  - Git operations (stage, commit, diff, blame)
-- <leader>h  - Harpoon operations (file marking, quick navigation)
-- <leader>k  - Keymaps (show key bindings, help)
-- <leader>l  - LSP operations (hover, definition, references)
-- <leader>o  - Organize (Python Poetry package/environment management)
-- <leader>p  - Project operations (project-wide actions)
-- <leader>r  - Run/Requirements (run code, manage dependencies)
-- <leader>s  - Search/Replace operations
-- <leader>t  - Terminal operations (toggle terminals, run commands)
-- <leader>u  - Utilities (undotree, misc helpers)
-- <leader>v  - Virtual environment (Python venv management)
-- <leader>w  - Window operations (splits, resize, navigation)
-- <leader>y  - Python code execution (run snippets, files)
-- <leader>z  - Zen/Focus mode (distraction-free coding)
--
-- Non-leader keys use standard Vim-like bindings where possible
-- Additional special keys are documented in relevant sections
--
-- This structure ensures no namespace conflicts and provides logical grouping

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

-- File operations
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save all files" })

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

-- =============================================
-- UNDOTREE OPERATION (u namespace)
-- =============================================

-- Undotree toggle
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

-- =============================================
-- DOCUMENTATION (do namespace)
-- =============================================

-- Documentation operations
map("n", "<leader>do", "<cmd>DevdocsOpenFloat<CR>", { desc = "Open documentation in float" })
map("n", "<leader>dO", "<cmd>DevdocsOpen<CR>", { desc = "Open documentation in buffer" })
map("n", "<leader>ds", "<cmd>Telescope devdocs search<CR>", { desc = "Search in documentation" })
map("n", "<leader>di", "<cmd>DevdocsInstall<CR>", { desc = "Install documentation" })
map("n", "<leader>du", "<cmd>DevdocsUpdate<CR>", { desc = "Update documentation" })
map("n", "<leader>dU", "<cmd>DevdocsUpdateAll<CR>", { desc = "Update all documentation" })
map("n", "<leader>df", "<cmd>DevdocsFetch<CR>", { desc = "Fetch documentation index" })

-- =============================================
-- POETRY OPERATIONS (o namespace)
-- =============================================

-- Poetry keybindings
map("n", "<leader>oi", function() M._poetry_create_venv() end, { desc = "Poetry install" })
map("n", "<leader>oc", function() M._poetry_create_venv() end, { desc = "Create Poetry env" })
map("n", "<leader>oa", function() M._poetry_add_package() end, { desc = "Add package" })
map("n", "<leader>or", function() M._poetry_remove_package() end, { desc = "Remove package" })
map("n", "<leader>ou", function() M._poetry_update() end, { desc = "Update packages" })
map("n", "<leader>oo", function() M._poetry_show_outdated() end, { desc = "Show outdated" })
map("n", "<leader>og", function() M._poetry_generate_requirements() end, { desc = "Generate requirements.txt" })
map("n", "<leader>on", function() M._poetry_new() end, { desc = "New Poetry project" })
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
-- PYTHON OPERATIONS (y namespace)
-- =============================================

-- Python execution and file operations
map("n", "<leader>yr", "<cmd>RunPythonWithEnv<CR>", { desc = "Run current file" })
map("n", "<leader>ye", function() M._python_execute_snippet() end, { desc = "Execute selection" })
map("n", "<leader>yi", function() M._python_execute_in_ipython() end, { desc = "Run in IPython" })
map("n", "<leader>yn", function() M._python_new_file() end, { desc = "New Python file" })
map("n", "<leader>yt", "<cmd>Telescope python_tests<CR>", { desc = "Run tests" })
map("n", "<leader>yp", "<cmd>echo 'Use <leader>o for Poetry dependency management'<CR>", { desc = "Dependency management ⟶ <leader>o" })
map("n", "<leader>yv", "<cmd>VenvActivate<CR>", { desc = "Activate virtual environment" })

-- =============================================
-- KEYMAPS HELPER (k namespace)
-- =============================================

-- Register whichkey specific activate command
map("n", "<leader>k", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })

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
