-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Create a module for exported functions
local M = {}

-- =============================================
-- KEYBINDING ORGANIZATION REFERENCE
-- =============================================
--
-- Namespace structure for leader-prefixed commands:
-- <leader>b  - Buffer operations
-- <leader>c  - Code actions (LSP related)
-- <leader>cd - Change directory operations
-- <leader>d  - Debug operations
-- <leader>do - Documentation view
-- <leader>e  - File explorer operations
-- <leader>f  - File operations (Telescope/find)
-- <leader>g  - Git operations
-- <leader>h  - Harpoon operations
-- <leader>l  - LSP operations
-- <leader>o  - Poetry operations
-- <leader>r  - Requirements.txt operations
-- <leader>t  - Terminal operations
-- <leader>u  - Undotree operations
-- <leader>v  - Virtual environment operations
-- <leader>w  - Window operations
-- <leader>y  - Python operations
--
-- This structure ensures no key conflict and provides logical grouping

-- =============================================
-- TERMINAL OPERATIONS
-- =============================================

-- Generic terminal toggle (from ToggleTerm plugin)
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })

-- Toggle terminal instances (these rely on functions in backend-essentials)
if _G._PYTHON_TOGGLE then
  map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python Terminal" })
end

if _G._IPYTHON_TOGGLE then
  map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython Terminal" })
end

if _G._PYTHON_RUN_FILE then
  map("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", { desc = "Run Python File" })
end

if _G._VENV_ACTIVATE then
  map("n", "<leader>va", "<cmd>lua _VENV_ACTIVATE()<CR>", { desc = "Activate Virtual Environment" })
end

if _G._DOCKER_TERM then
  map("n", "<leader>td", "<cmd>lua _DOCKER_TERM()<CR>", { desc = "Docker Terminal" })
end

if _G._DATABASE_TERM then
  map("n", "<leader>tb", "<cmd>lua _DATABASE_TERM()<CR>", { desc = "Database Terminal" })
end

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

-- =============================================
-- PYTHON OPERATIONS (y namespace)
-- =============================================

-- Python functions
M._python_run_file = function()
  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end
  
  if vim.fn.fnamemodify(file, ':e') ~= 'py' then
    vim.notify("Not a Python file", vim.log.levels.ERROR)
    return
  end
  
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local python_cmd = ""
  
  if venv_path ~= "" then
    -- Use venv python if it exists
    python_cmd = venv_path .. "/bin/python"
  else
    python_cmd = "python"
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = python_cmd .. " " .. file,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Execute selected Python code in IPython
M._python_execute_in_ipython = function()
  local visual_selection = vim.fn.getreg("v")
  if visual_selection == "" then
    vim.notify("No code selected", vim.log.levels.ERROR)
    return
  end
  
  -- Check if IPython terminal exists and is running
  local Terminal = require("toggleterm.terminal").Terminal
  local ipython = Terminal:new({
    cmd = "ipython",
    direction = "horizontal",
    close_on_exit = false,
    hidden = true,
  })
  
  -- Function to send code to IPython
  local function send_to_ipython()
    ipython:send(visual_selection)
  end
  
  -- Check if terminal exists
  if ipython:is_open() then
    send_to_ipython()
  else
    ipython:toggle()
    -- Wait for IPython to start before sending code
    vim.defer_fn(function()
      send_to_ipython()
    end, 1000)
  end
end

-- Python snippet execution in terminal
M._python_execute_snippet = function()
  local lines = vim.api.nvim_buf_get_visual_selection()
  if #lines == 0 then
    vim.notify("No code selected", vim.log.levels.ERROR)
    return
  end
  
  local code = table.concat(lines, "\n")
  
  -- Create temporary file
  local tmp_file = os.tmpname() .. ".py"
  local file = io.open(tmp_file, "w")
  if file then
    file:write(code)
    file:close()
    
    local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
    local python_cmd = ""
    
    if venv_path ~= "" then
      -- Use venv python if it exists
      python_cmd = venv_path .. "/bin/python"
    else
      python_cmd = "python"
    end
    
    local term = require("toggleterm.terminal").Terminal:new({
      cmd = python_cmd .. " " .. tmp_file,
      direction = "horizontal",
      close_on_exit = false,
      on_exit = function()
        -- Remove temp file after execution
        os.remove(tmp_file)
      end,
    })
    term:toggle()
  else
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
  end
end

-- Create Python file with boilerplate
M._python_new_file = function()
  local filename = vim.fn.input("New Python file name: ")
  if filename == "" then
    return
  end
  
  -- Add .py extension if not provided
  if not filename:match("%.py$") then
    filename = filename .. ".py"
  end
  
  -- Create the file
  local file = io.open(filename, "w")
  if file then
    local date = os.date("%Y-%m-%d")
    local boilerplate = string.format([[#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on %s

Description: 

@author: %s
"""

def main():
    pass

if __name__ == "__main__":
    main()
]], date, vim.fn.expand("$USER"))
    
    file:write(boilerplate)
    file:close()
    
    -- Open the file in a new buffer
    vim.cmd("edit " .. filename)
    vim.notify("Created new Python file: " .. filename, vim.log.levels.INFO)
  else
    vim.notify("Failed to create file: " .. filename, vim.log.levels.ERROR)
  end
end

-- Python mappings
map("n", "<leader>yr", function() M._python_run_file() end, { desc = "Run Python file" })
map("v", "<leader>ye", function() M._python_execute_snippet() end, { desc = "Execute selected Python code" })
map("v", "<leader>yi", function() M._python_execute_in_ipython() end, { desc = "Execute in IPython" })
map("n", "<leader>yt", function() vim.cmd("Telescope python_tests") end, { desc = "Python tests" })
map("n", "<leader>yn", function() M._python_new_file() end, { desc = "New Python file" })

-- Documentation operations (do namespace)
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

-- Create a new Poetry project
M._poetry_new = function()
  local project_name = vim.fn.input("New Poetry project name: ")
  if project_name == "" then
    return
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry new " .. project_name,
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      vim.notify("Poetry project created: " .. project_name, vim.log.levels.INFO)
      -- Ask if user wants to cd into the new project
      if vim.fn.confirm("Change to new project directory?", "&Yes\n&No", 1) == 1 then
        vim.cmd("cd " .. project_name)
        vim.cmd("NvimTreeRefresh")
      end
    end,
  })
  term:toggle()
end

-- Create a Poetry virtual environment in the current project
M._poetry_create_venv = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry install",
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      vim.notify("Poetry virtual environment created", vim.log.levels.INFO)
    end,
  })
  term:toggle()
end

-- Add a package with Poetry
M._poetry_add_package = function()
  local package_name = vim.fn.input("Package name: ")
  if package_name == "" then
    return
  end
  
  local dev = vim.fn.confirm("Add as dev dependency?", "&Yes\n&No", 2) == 1
  local cmd = "poetry add " .. (dev and "--group dev " or "") .. package_name
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      vim.notify("Package added: " .. package_name, vim.log.levels.INFO)
    end,
  })
  term:toggle()
end

-- Remove a package with Poetry
M._poetry_remove_package = function()
  local package_name = vim.fn.input("Package to remove: ")
  if package_name == "" then
    return
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry remove " .. package_name,
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      vim.notify("Package removed: " .. package_name, vim.log.levels.INFO)
    end,
  })
  term:toggle()
end

-- Update packages with Poetry
M._poetry_update = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry update",
    direction = "float",
    close_on_exit = false,
  })
  term:toggle()
end

-- Show outdated packages
M._poetry_show_outdated = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry show --outdated",
    direction = "float",
    close_on_exit = false,
  })
  term:toggle()
end

-- Generate requirements.txt from Poetry
M._poetry_generate_requirements = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry export -f requirements.txt --output requirements.txt --without-hashes",
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      vim.notify("Generated requirements.txt", vim.log.levels.INFO)
    end,
  })
  term:toggle()
end

-- Poetry build
M._poetry_build = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry build",
    direction = "float",
    close_on_exit = false,
  })
  term:toggle()
end

-- Poetry publish
M._poetry_publish = function()
  local repo = vim.fn.input("Repository (leave empty for default PyPI): ")
  local cmd = "poetry publish"
  if repo ~= "" then
    cmd = cmd .. " --repository " .. repo
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
  })
  term:toggle()
end

-- Poetry shell
M._poetry_shell = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry shell",
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Edit pyproject.toml
M._poetry_edit_pyproject = function()
  if vim.fn.filereadable("pyproject.toml") == 1 then
    vim.cmd("edit pyproject.toml")
  else
    vim.notify("pyproject.toml not found in current directory", vim.log.levels.ERROR)
  end
end

-- Poetry run
M._poetry_run = function()
  local command = vim.fn.input("Command to run with poetry run: ")
  if command == "" then
    return
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry run " .. command,
    direction = "float",
    close_on_exit = false,
  })
  term:toggle()
end

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
-- VIRTUAL ENV OPERATIONS (v namespace)
-- =============================================

-- Virtual environment mappings
map("n", "<leader>vs", "<cmd>VenvSelect<CR>", { desc = "Select Python venv" })
map("n", "<leader>vc", "<cmd>VenvSelectCached<CR>", { desc = "Select cached venv" })
map("n", "<leader>vd", "<cmd>VenvDiagnostics<CR>", { desc = "Run venv diagnostics" })
map("n", "<leader>vt", "<cmd>TestVenv<CR>", { desc = "Test current venv" })

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
-- GIT OPERATIONS (g namespace)
-- =============================================

-- Git mappings - these will be setup when gitsigns is loaded
M.setup_git_mappings = function(gs)
  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
  end, { expr = true, desc = "Next git hunk" })

  map("n", "[c", function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
  end, { expr = true, desc = "Previous git hunk" })

  -- Actions
  map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
  map("v", "<leader>gs", function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage selected hunk" })
  map("v", "<leader>gr", function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset selected hunk" })
  map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
  map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
  map("n", "<leader>gb", function() gs.blame_line{full=true} end, { desc = "Blame line" })
end

-- =============================================
-- LSP OPERATIONS (l namespace)
-- =============================================

-- LSP mappings
M.setup_lsp_mappings = function(bufnr)
  -- LSP actions
  map("n", "<leader>lf", vim.lsp.buf.format, { buffer = bufnr, desc = "Format buffer" })
  map("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
  map("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
  map("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
  map("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
  map("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
  map("n", "<leader>lh", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
  map("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
  map("n", "<leader>lR", vim.lsp.buf.references, { buffer = bufnr, desc = "Find references" })
end

-- =============================================
-- GENERAL NAVIGATION IMPROVEMENTS
-- =============================================

-- Keep cursor centered when jumping half-pages or when searching
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Better J - join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Disable Ex mode (avoid accidental activation)
-- map("n", "Q", "<nop>", { desc = "Disable Ex mode" })
-- Map Q to quit
map("n", "Q", "q", { desc = "Quit (Q = q)" })

-- Quickfix navigation
map("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "<leader>qk", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>qj", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- Quick search and replace for word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })

-- Make current file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Tmux integration (only if tmux is installed)
if vim.fn.executable("tmux") == 1 then
  map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open tmux sessionizer" })
end

-- Format with conform.nvim if available
local has_conform, _ = pcall(require, "conform")
if has_conform then
  map("n", "<leader>cf", function()
    require("conform").format({ bufnr = 0 })
  end, { desc = "Format buffer with conform" })
end

-- =============================================
-- TEXT MANIPULATION & EDITING
-- =============================================

-- Format paragraph and return to position
map("n", "=ap", "ma=ap'a", { desc = "Format paragraph and return" })

-- Move selected lines up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- =============================================
-- INSERT MODE MAPPINGS
-- =============================================

-- Exit insert mode with jk (faster than Escape)
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Alternative escape with Ctrl+c
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode with Ctrl-c" })

-- =============================================
-- CLIPBOARD OPERATIONS
-- =============================================

-- Paste without losing register content
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- =============================================
-- BUFFER OPERATIONS (b namespace)
-- =============================================

-- Buffer management
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bl", "<cmd>buffers<CR>", { desc = "List buffers" })

-- =============================================
-- TERMINAL OPERATIONS (t namespace)
-- =============================================

-- Generic terminal toggle (from ToggleTerm plugin)
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })

-- Toggle terminal instances (these rely on functions in backend-essentials)
if _G._PYTHON_TOGGLE then
  map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python Terminal" })
end

if _G._IPYTHON_TOGGLE then
  map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython Terminal" })
end

if _G._PYTHON_RUN_FILE then
  map("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", { desc = "Run Python File" })
end

if _G._DOCKER_TERM then
  map("n", "<leader>td", "<cmd>lua _DOCKER_TERM()<CR>", { desc = "Docker Terminal" })
end

if _G._DATABASE_TERM then
  map("n", "<leader>tb", "<cmd>lua _DATABASE_TERM()<CR>", { desc = "Database Terminal" })
end

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

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
-- Virtual env integration with Poetry
map("n", "<leader>ov", "<cmd>VenvSelect<CR>", { desc = "Select any venv" })
map("n", "<leader>od", "<cmd>VenvDiagnostics<CR>", { desc = "Run venv diagnostics" })

-- =============================================
-- REQUIREMENTS MANAGEMENT (r namespace)
-- =============================================

-- Requirements management with Poetry integration
map("n", "<leader>rg", function() M._poetry_generate_requirements() end, { desc = "Generate from Poetry (recommended)" })
map("n", "<leader>re", "<cmd>edit requirements.txt<CR>", { desc = "Edit requirements.txt" })
map("n", "<leader>ri", "<cmd>TermExec cmd='pip install -r requirements.txt'<CR>", { desc = "Install from requirements.txt" })
map("n", "<leader>rp", "<cmd>echo 'Use Poetry for dependency management with <leader>o'<CR>", { desc = "Use Poetry (<leader>o)" })

-- =============================================
-- PYTHON TOOLS (v namespace)
-- =============================================

-- Python tools and venv management (alternative to Poetry for non-Poetry projects)
map("n", "<leader>va", "<cmd>VenvSelect<CR>", { desc = "Activate any venv" })
map("n", "<leader>vc", "<cmd>VenvSelectCached<CR>", { desc = "Cached venv" })
map("n", "<leader>vt", "<cmd>TestVenv<CR>", { desc = "Test current venv" })
map("n", "<leader>vp", function() M._python_run_file() end, { desc = "Run Python file" })
map("n", "<leader>vr", "<cmd>Telescope python_tests<CR>", { desc = "Run Python tests" })

-- =============================================
-- PYTHON OPERATIONS (y namespace)
-- =============================================

-- Python execution and file operations
map("n", "<leader>ye", function() M._python_execute_snippet() end, { desc = "Execute selection" })
map("n", "<leader>yi", function() M._python_execute_in_ipython() end, { desc = "Run in IPython" })
map("n", "<leader>yn", function() M._python_new_file() end, { desc = "New Python file" })
map("n", "<leader>yt", "<cmd>Telescope python_tests<CR>", { desc = "Run tests" })
map("n", "<leader>yp", "<cmd>echo 'Use <leader>o for Poetry dependency management'<CR>", { desc = "Dependency management ⟶ <leader>o" })

-- Register whichkey specific activate command
map("n", "<leader><leader>", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })

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
  
  -- Adjust selection boundaries
  if #lines == 0 then
    return {}
  elseif #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end
  
  return lines
end

return M
