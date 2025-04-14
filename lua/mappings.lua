-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Create a module for exported functions
local M = {}

-- Define global Python toggle functions
-- These need to be global since they're called directly in keymappings
_PYTHON_TOGGLE = function()
  -- Create a persistent Python REPL terminal
  local python_term = require("toggleterm.terminal").Terminal:new({
    cmd = "python3",
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  python_term:toggle()
end

_IPYTHON_TOGGLE = function()
  -- Create a persistent IPython REPL terminal with enhanced features
  local ipython_term = require("toggleterm.terminal").Terminal:new({
    cmd = "ipython --matplotlib=auto --colors=Linux",
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  ipython_term:toggle()
end

_PYTHON_RUN_FILE = function()
  -- Run the current Python file
  local file = vim.fn.expand("%:p")
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "python3 " .. file,
    direction = "horizontal",
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

-- Basic key mappings that work without which-key
-- These key mappings will always work, even if which-key isn't loaded
map("n", ";", ":", { desc = "CMD: Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<C-c>", "<ESC>", { desc = "Alternative exit insert mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Remap Q to function as q (quit)
map("n", "Q", "q", { desc = "Q acts as q (quit)" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })

-- Window resizing
map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ThePrimeagen's Best Mappings
-- Quick access to file explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })

-- Better navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down & center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up & center" })
map("n", "n", "nzzzv", { desc = "Next search result & center" })
map("n", "N", "Nzzzv", { desc = "Prev search result & center" })
map("n", "=ap", "ma=ap'a", { desc = "Format paragraph & restore cursor" })

-- Move text up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Join line without cursor movement
map("n", "J", "mzJ`z", { desc = "Join line and keep cursor position" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Quick-fix list navigation
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- LSP global mappings (not prefixed with leader)
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- Clipboard mappings
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })

-- Search and replace
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace word under cursor" })

-- Make file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- Add specific mapping for Space+Space to show all keybindings
map("n", "<leader><leader>", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })

-- Shortcut for saving and quitting
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Terminal mappings
map("n", "<C-t>", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode (jk)" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to below window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to above window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right window" })

-- POETRY FUNCTIONS

-- Generate requirements.txt from Poetry dependencies
M._poetry_generate_requirements = function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "poetry export -f requirements.txt --output requirements.txt --without-hashes",
    direction = "horizontal",
    close_on_exit = false,
    on_exit = function(t, job, exit_code)
      if exit_code == 0 then
        vim.notify("Generated requirements.txt from Poetry dependencies", vim.log.levels.INFO)
      else
        vim.notify("Failed to generate requirements.txt", vim.log.levels.ERROR)
      end
    end,
  })
  term:toggle()
end

-- Install from requirements.txt
M._install_from_requirements = function()
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local pip_cmd = ""
  
  if venv_path ~= "" then
    -- Use venv pip if it exists
    pip_cmd = venv_path .. "/bin/pip"
  else
    pip_cmd = "pip"
  end
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = pip_cmd .. " install -r requirements.txt",
    direction = "horizontal",
    close_on_exit = false,
    on_exit = function(t, job, exit_code)
      if exit_code == 0 then
        vim.notify("Successfully installed requirements", vim.log.levels.INFO)
      else
        vim.notify("Failed to install requirements", vim.log.levels.ERROR)
      end
    end,
  })
  term:toggle()
end

-- Create requirements.txt if it doesn't exist
M._create_requirements = function()
  local req_path = vim.fn.getcwd() .. "/requirements.txt"
  if vim.fn.filereadable(req_path) == 0 then
    local file = io.open(req_path, "w")
    if file then
      file:write("# Python requirements\n# Generated on " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
      file:close()
      vim.notify("Created empty requirements.txt", vim.log.levels.INFO)
      vim.cmd("edit " .. req_path)
    else
      vim.notify("Failed to create requirements.txt", vim.log.levels.ERROR)
    end
  else
    vim.notify("requirements.txt already exists", vim.log.levels.WARN)
    vim.cmd("edit " .. req_path)
  end
end

-- Edit requirements.txt function
M._edit_requirements = function()
  local req_path = vim.fn.getcwd() .. "/requirements.txt"
  if vim.fn.filereadable(req_path) == 1 then
    vim.cmd("edit " .. req_path)
  else
    -- Offer to create requirements.txt if it doesn't exist
    if vim.fn.confirm("requirements.txt doesn't exist. Create it?", "Yes\nNo", 1) == 1 then
      M._create_requirements()
    end
  end
end

-- PYTHON EXECUTION FUNCTIONS

-- Run current Python file
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

-- Map Python and Poetry functions to keys
-- PYTHON KEY MAPPINGS (leader y prefix for "pYthon")
map("n", "<leader>yr", function() M._python_run_file() end, { desc = "Run Python file" })
map("v", "<leader>ye", function() M._python_execute_snippet() end, { desc = "Execute selected Python code" })
map("v", "<leader>yi", function() M._python_execute_in_ipython() end, { desc = "Execute in IPython" })
map("n", "<leader>yv", function() vim.cmd("VenvSelect") end, { desc = "Select Python venv" })

-- POETRY KEY MAPPINGS (leader o prefix for "pOetry")
map("n", "<leader>oi", function() vim.cmd("TermExec cmd='poetry install'") end, { desc = "Poetry install" })
map("n", "<leader>oc", function() M._poetry_create_venv() end, { desc = "Create Poetry .venv" })
map("n", "<leader>oa", function() M._poetry_add_package() end, { desc = "Add Poetry package" })
map("n", "<leader>or", function() M._poetry_remove_package() end, { desc = "Remove Poetry package" })
map("n", "<leader>ou", function() M._poetry_update() end, { desc = "Update Poetry packages" })
map("n", "<leader>oo", function() M._poetry_show_outdated() end, { desc = "Show outdated packages" })
map("n", "<leader>og", function() M._poetry_generate_requirements() end, { desc = "Generate requirements.txt" })

-- REQUIREMENTS.TXT MAPPINGS (leader r prefix)
map("n", "<leader>rc", function() M._create_requirements() end, { desc = "Create requirements.txt" })
map("n", "<leader>ri", function() M._install_from_requirements() end, { desc = "Install from requirements.txt" })
map("n", "<leader>re", function() M._edit_requirements() end, { desc = "Edit requirements.txt" })

-- Virtual environment activation with improved feedback and error handling
M._python_activate_venv = function()
  local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
  if venv_path ~= "" then
    -- Use absolute path for better compatibility
    local python_path = vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
    
    -- Check if Python executable exists in venv
    if vim.fn.executable(python_path) == 1 then
      vim.g.python3_host_prog = python_path
      -- Create visual notification
      vim.notify('Virtual environment activated: ' .. venv_path, vim.log.levels.INFO)
    else
      vim.notify('Python executable not found in ' .. venv_path, vim.log.levels.ERROR)
    end
  else
    -- Try to find other common virtual environment directories
    local alt_venvs = {'venv', 'env', '.env', 'virtualenv'}
    for _, v in ipairs(alt_venvs) do
      local alt_path = vim.fn.finddir(v, vim.fn.getcwd() .. ';')
      if alt_path ~= "" then
        vim.notify('Found alternative virtualenv: ' .. alt_path .. '\nUse <leader>ca to activate it.', vim.log.levels.INFO)
        return
      end
    end
    vim.notify('No virtual environment directory found. Try creating one with:\npython -m venv .venv', vim.log.levels.WARN)
  end
end

map("n", "<leader>cv", function() M._python_activate_venv() end, { desc = "Activate Python venv" })

-- Activate any specified virtual environment
M._python_activate_custom_venv = function()
  local venv_name = vim.fn.input("Virtual environment name: ", "", "file")
  if venv_name == "" then
    return
  end
  
  local venv_path = vim.fn.finddir(venv_name, vim.fn.getcwd() .. ';')
  if venv_path ~= "" then
    local python_path = vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
    if vim.fn.executable(python_path) == 1 then
      vim.g.python3_host_prog = python_path
      vim.notify('Virtual environment activated: ' .. venv_path, vim.log.levels.INFO)
    else
      vim.notify('Python executable not found in ' .. venv_path, vim.log.levels.ERROR)
    end
  else
    vim.notify('Virtual environment not found: ' .. venv_name, vim.log.levels.ERROR)
  end
end

map("n", "<leader>ca", function() M._python_activate_custom_venv() end, { desc = "Activate custom venv" })

-- Improved Python run with arguments support
M._python_run_with_args = function()
  local file = vim.fn.expand("%:p")
  local args = vim.fn.input("Arguments: ")
  local cmd = "python3 " .. file .. " " .. args
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

map("n", "<leader>pr", function() M._python_run_with_args() end, { desc = "Run Python file with args" })

-- Run Python file with default args (original behavior kept for convenience)
map("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", { desc = "Run Python file" })

-- Run selected Python code in terminal - Improved for visual mode
M._python_execute_selected = function()
  -- Use explicit visual mode selection
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= 'v' and mode ~= 'V' and mode ~= '' then
    vim.notify("This function must be used in visual mode", vim.log.levels.ERROR)
    return
  end

  -- Get selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  
  -- Handle partial line selections
  if end_pos[3] < 2147483647 then  -- Not end of line
    if #lines == 1 then
      lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
      lines[1] = string.sub(lines[1], start_pos[3])
      lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
  end
  
  -- Create temp file
  local tmpfile = os.tmpname() .. ".py"
  local f = io.open(tmpfile, "w")
  if not f then
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end
  
  f:write(table.concat(lines, "\n"))
  f:close()
  
  -- Show notification
  vim.notify("Executing selected Python code...", vim.log.levels.INFO)
  
  -- Execute in terminal
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "python3 " .. tmpfile .. "; rm " .. tmpfile,
    direction = "horizontal",
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

-- Visual mode mapping for Python code execution
map("v", "<leader>pe", function() 
  -- Preserve visual selection and execute
  M._python_execute_selected()
end, { desc = "Execute selected Python" })

-- Run current file in IPython
M._python_run_ipython = function()
  local file = vim.fn.expand("%:p")
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = "ipython -i " .. file,
    direction = "horizontal",
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

map("n", "<leader>pi", function() M._python_run_ipython() end, { desc = "Run file in IPython" })

-- Create Python file with boilerplate
M._python_new_file = function()
  local filename = vim.fn.input("New Python file name: ")
  if filename == "" then return end
  
  -- Add .py extension if not present
  if not string.match(filename, "%.py$") then
    filename = filename .. ".py"
  end
  
  -- Create the file with boilerplate
  local file = io.open(filename, "w")
  if file then
    file:write([[#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on ]] .. os.date("%Y-%m-%d") .. [[

Description: 

"""


def main():
    pass


if __name__ == "__main__":
    main()
]])
    file:close()
    
    -- Open the new file
    vim.cmd("edit " .. filename)
    vim.cmd("normal! G")  -- Move to end of file
    vim.notify("Created new Python file: " .. filename, vim.log.levels.INFO)
  else
    vim.notify("Failed to create file: " .. filename, vim.log.levels.ERROR)
  end
end

map("n", "<leader>pn", function() M._python_new_file() end, { desc = "New Python file" })

-- Toggle Python terminal 
map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python REPL" })

-- Toggle IPython terminal
map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython" })

-- NvimTree file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Better split navigation
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Code folding
map("n", "<leader>zc", "zc", { desc = "Close fold" })
map("n", "<leader>zo", "zo", { desc = "Open fold" })
map("n", "<leader>zC", "zC", { desc = "Close all folds" })
map("n", "<leader>zO", "zO", { desc = "Open all folds" })
map("n", "<leader>za", "za", { desc = "Toggle fold" })
map("n", "<leader>zA", "zA", { desc = "Toggle all folds" })

-- Diagnostic mappings
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic in float" })
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- DAP debugging with proper prefixes to avoid overlap
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue debug" })
map("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step into" })
map("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step over" })
map("n", "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out" })
map("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })
map("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>", { desc = "Open REPL" })

-- Comment with non-overlapping mappings
-- Using the Comment.api for clarity and to avoid mapping overlaps
map("n", "<leader>cc", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle line comment" })
map("n", "<leader>cb", function() require("Comment.api").toggle.blockwise.current() end, { desc = "Toggle block comment" })
map("v", "<leader>c", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Database UI with proper prefix
map("n", "<leader>dbu", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database UI" })
map("n", "<leader>dba", "<cmd>DBUIAddConnection<CR>", { desc = "Add DB Connection" })

-- Working directory mappings for Python projects
-- Mapping for changing directories and activating virtual environments
M._change_to_file_directory = function()
  local file_path = vim.fn.expand('%:p:h')
  vim.cmd('cd ' .. file_path)
  vim.notify('Working directory changed to: ' .. file_path, vim.log.levels.INFO)
  
  -- Refresh and focus nvim-tree to the new directory
  -- Delay slightly to ensure the change is registered
  vim.defer_fn(function()
    -- Check if nvim-tree is available
    local status_ok, _ = pcall(require, "nvim-tree")
    if status_ok then
      -- If NvimTree is open, refresh it to show the new directory
      if vim.fn.exists(":NvimTreeRefresh") > 0 then
        vim.cmd("NvimTreeRefresh")
      end
      -- Focus NvimTree to make it zoom to the current directory
      if vim.fn.exists(":NvimTreeFocus") > 0 then
        vim.cmd("NvimTreeFocus")
      end
    end
  end, 100) -- 100ms delay
end

M._change_to_git_root = function()
  local file_path = vim.fn.expand('%:p:h')
  local repo_root = vim.fn.system('git -C ' .. file_path .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  
  if repo_root ~= "" then
    vim.cmd('cd ' .. repo_root)
    vim.notify('Working directory changed to: ' .. repo_root, vim.log.levels.INFO)
    
    -- Refresh and focus nvim-tree to the new directory
    vim.defer_fn(function()
      -- Check if nvim-tree is available
      local status_ok, _ = pcall(require, "nvim-tree")
      if status_ok then
        -- If NvimTree is open, refresh it to show the new directory
        if vim.fn.exists(":NvimTreeRefresh") > 0 then
          vim.cmd("NvimTreeRefresh")
        end
        -- Focus NvimTree to make it zoom to the current directory
        if vim.fn.exists(":NvimTreeFocus") > 0 then
          vim.cmd("NvimTreeFocus")
        end
      end
    end, 100) -- 100ms delay
  else
    vim.notify('Not a git repository', vim.log.levels.WARN)
  end
end

map("n", "<leader>cd", function() M._change_to_file_directory() end, { desc = "Change to file's directory" })
map("n", "<leader>cD", function() M._change_to_git_root() end, { desc = "Change to git root" })

-- Poetry create virtual environment with .venv
M._poetry_create_venv = function()
  -- Check if pyproject.toml exists first
  local has_pyproject = vim.fn.filereadable(vim.fn.expand("%:p:h") .. "/pyproject.toml")
  if has_pyproject == 0 then
    has_pyproject = vim.fn.filereadable(vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";") .. "/pyproject.toml")
  end
  
  local cmd = ""
  
  if has_pyproject == 0 then
    -- No pyproject.toml - need to initialize a new Poetry project
    if vim.fn.confirm("No pyproject.toml found. Initialize a new Poetry project?", "Yes\nNo", 1) == 2 then
      return
    end
    
    cmd = "poetry init -n && poetry config virtualenvs.in-project true && poetry install"
  else
    -- pyproject.toml exists - just ensure .venv is created in-project
    cmd = "poetry config virtualenvs.in-project true && poetry install"
  end
  
  vim.notify("Creating Poetry environment in .venv...", vim.log.levels.INFO)
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
    on_exit = function(t, job, exit_code)
      if exit_code == 0 then
        vim.notify("Poetry environment created successfully!", vim.log.levels.INFO)
        -- Update Python host program
        local python_path = vim.fn.getcwd() .. '/.venv/bin/python'
        if vim.fn.filereadable(python_path) == 1 then
          vim.g.python3_host_prog = python_path
          vim.notify("Virtual environment activated: .venv", vim.log.levels.INFO)
        end
      else
        vim.notify("Failed to create Poetry environment", vim.log.levels.ERROR)
      end
    end,
  })
  term:toggle()
end

-- Map Poetry create venv function with a different key to avoid conflict
-- Using <leader>ppc for "Poetry create" instead of <leader>pv which is used for venv selection
map("n", "<leader>ppc", function() M._poetry_create_venv() end, { desc = "Create Poetry .venv" })

-- Python package management functions
M._python_install_requirements = function()
  local file = vim.fn.expand("%:p:h") .. "/requirements.txt"
  
  -- Check if requirements.txt exists
  if vim.fn.filereadable(file) ~= 1 then
    -- Try to find requirements.txt in project root
    local root = vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";")
    if root ~= "" then
      file = root .. "/requirements.txt"
      if vim.fn.filereadable(file) ~= 1 then
        vim.notify("No requirements.txt found in current directory or project root", vim.log.levels.ERROR)
        return
      end
    else
      vim.notify("No requirements.txt found in current directory or project root", vim.log.levels.ERROR)
      return
    end
  end
  
  -- Ask user which installation method to use
  local options = {"venv pip", "global pip", "poetry"}
  local choice = vim.fn.confirm("Install requirements using:", table.concat(options, "\n"), 1)
  
  local cmd = ""
  if choice == 1 then
    -- venv pip
    local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
    if venv_path == "" then
      local alt_venvs = {'venv', 'env', '.env'}
      for _, v in ipairs(alt_venvs) do
        venv_path = vim.fn.finddir(v, vim.fn.getcwd() .. ';')
        if venv_path ~= "" then break end
      end
    end
    
    if venv_path == "" then
      vim.notify("No virtual environment found. Creating .venv...", vim.log.levels.INFO)
      venv_path = ".venv"
      local term = require("toggleterm.terminal").Terminal:new({
        cmd = "python -m venv " .. venv_path,
        direction = "horizontal",
        close_on_exit = false,
        on_exit = function(t, job, exit_code)
          if exit_code == 0 then
            local pip_cmd = venv_path .. "/bin/pip install -r " .. file
            t:send(pip_cmd)
          end
        end,
      })
      term:toggle()
      return
    else
      cmd = venv_path .. "/bin/pip install -r " .. file
    end
  elseif choice == 2 then
    -- global pip
    cmd = "pip install -r " .. file
  elseif choice == 3 then
    -- poetry
    local has_pyproject = vim.fn.filereadable(vim.fn.expand("%:p:h") .. "/pyproject.toml")
    if has_pyproject == 0 then
      has_pyproject = vim.fn.filereadable(vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";") .. "/pyproject.toml")
    end
    
    if has_pyproject == 0 then
      vim.notify("Initializing new Poetry project...", vim.log.levels.INFO)
      cmd = "poetry init -n && poetry add -r " .. file
    else
      cmd = "poetry add -r " .. file
    end
  else
    return
  end
  
  -- Execute the command in terminal
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Poetry commands
M._poetry_add_package = function()
  local package = vim.fn.input("Package name: ")
  if package == "" then return end
  
  local dev = vim.fn.confirm("Add as dev dependency?", "Yes\nNo", 2) == 1
  
  local cmd = "poetry add " .. (dev and "--group dev " or "") .. package
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

M._poetry_remove_package = function()
  local package = vim.fn.input("Package name to remove: ")
  if package == "" then return end
  
  local cmd = "poetry remove " .. package
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

M._poetry_update = function()
  local cmd = "poetry update"
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

M._poetry_show_outdated = function()
  local cmd = "poetry show --outdated"
  
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Add key mappings for Python package management
map("n", "<leader>pi", function() M._python_install_requirements() end, { desc = "Install requirements.txt" })
map("n", "<leader>pp", function() M._poetry_add_package() end, { desc = "Poetry add package" })
map("n", "<leader>pr", function() M._poetry_remove_package() end, { desc = "Poetry remove package" })
map("n", "<leader>pu", function() M._poetry_update() end, { desc = "Poetry update" })
map("n", "<leader>po", function() M._poetry_show_outdated() end, { desc = "Poetry show outdated" })

-- Enhanced UI notification with icons
local function notify_with_icon(message, level, title, icon)
  local notify_opts = {
    title = title or "",
    icon = icon or "",
  }
  vim.notify(message, level, notify_opts)
end

-- Nicer UI for Poetry operations
M._poetry_add_package = function()
  vim.ui.input({
    prompt = " Enter package name: ",
    completion = "custom,v:lua.require'mappings'._python_package_completion",
  }, function(package)
    if not package or package == "" then return end
    
    notify_with_icon("Installing " .. package .. "...", vim.log.levels.INFO, "Poetry", "")
    
    -- Check if it's a dev dependency
    vim.ui.select({"Regular", "Development"}, {
      prompt = "Dependency type:",
    }, function(choice)
      if not choice then return end
      
      local cmd = "poetry add " .. package
      if choice == "Development" then
        cmd = cmd .. " --group dev"
      end
      
      local term = require("toggleterm.terminal").Terminal:new({
        cmd = cmd,
        direction = "horizontal",
        close_on_exit = false,
        on_exit = function(t, job, exit_code)
          if exit_code == 0 then
            notify_with_icon("Package " .. package .. " installed successfully!", vim.log.levels.INFO, "Poetry", "")
          else
            notify_with_icon("Failed to install " .. package, vim.log.levels.ERROR, "Poetry", "")
          end
        end,
      })
      term:toggle()
    end)
  end)
end

-- Nicer UI for Python execution
M._python_run_file = function()
  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 0 then
    notify_with_icon("No file to run", vim.log.levels.ERROR, "Python", "")
    return
  end
  
  if vim.fn.fnamemodify(file, ':e') ~= 'py' then
    notify_with_icon("Not a Python file", vim.log.levels.ERROR, "Python", "")
    return
  end
  
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  local python_cmd = ""
  
  if venv_path ~= "" then
    -- Use venv python if it exists
    python_cmd = venv_path .. "/bin/python"
    notify_with_icon("Running with venv Python", vim.log.levels.INFO, "Python", "")
  else
    python_cmd = "python"
    notify_with_icon("Running with system Python", vim.log.levels.INFO, "Python", "")
  end
  
  -- Create a floating terminal for better UI
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = python_cmd .. " " .. file,
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
    },
    close_on_exit = false,
    on_open = function()
      notify_with_icon("Running " .. vim.fn.fnamemodify(file, ':t'), vim.log.levels.INFO, "Python", "")
    end
  })
  term:toggle()
end

-- Enhanced Poetry venv creation with better UI
M._poetry_create_venv = function()
  -- Check if pyproject.toml exists first
  local has_pyproject = vim.fn.filereadable(vim.fn.expand("%:p:h") .. "/pyproject.toml")
  if has_pyproject == 0 then
    has_pyproject = vim.fn.filereadable(vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";") .. "/pyproject.toml")
  end
  
  local cmd = ""
  
  if has_pyproject == 0 then
    -- No pyproject.toml - need to initialize a new Poetry project
    if vim.fn.confirm(" No pyproject.toml found. Initialize a new Poetry project?", "Yes\nNo", 1) == 2 then
      return
    end
    
    notify_with_icon("Initializing new Poetry project...", vim.log.levels.INFO, "Poetry", "")
    cmd = "poetry init -n && poetry config virtualenvs.in-project true && poetry install"
  else
    -- pyproject.toml exists - just ensure .venv is created in-project
    notify_with_icon("Setting up Poetry environment...", vim.log.levels.INFO, "Poetry", "")
    cmd = "poetry config virtualenvs.in-project true && poetry install"
  end
  
  -- Create a floating terminal for better UI
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      title = "Poetry Environment Setup",
      title_pos = "center",
    },
    close_on_exit = false,
    on_exit = function(t, job, exit_code)
      if exit_code == 0 then
        notify_with_icon("Poetry environment created successfully!", vim.log.levels.INFO, "Poetry", "")
        -- Update Python host program
        local python_path = vim.fn.getcwd() .. '/.venv/bin/python'
        if vim.fn.filereadable(python_path) == 1 then
          vim.g.python3_host_prog = python_path
          notify_with_icon("Virtual environment activated: .venv", vim.log.levels.INFO, "Poetry", "")
        end
      else
        notify_with_icon("Failed to create Poetry environment", vim.log.levels.ERROR, "Poetry", "")
      end
    end,
  })
  term:toggle()
end

-- Prettier requirements.txt management
M._create_requirements = function()
  local req_path = vim.fn.getcwd() .. "/requirements.txt"
  if vim.fn.filereadable(req_path) == 0 then
    local file = io.open(req_path, "w")
    if file then
      file:write("# Python requirements\n# Generated on " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
      file:close()
      notify_with_icon("Created empty requirements.txt", vim.log.levels.INFO, "Python", "")
      vim.cmd("edit " .. req_path)
    else
      notify_with_icon("Failed to create requirements.txt", vim.log.levels.ERROR, "Python", "")
    end
  else
    notify_with_icon("requirements.txt already exists", vim.log.levels.WARN, "Python", "")
    vim.cmd("edit " .. req_path)
  end
end

-- Enhanced Python snippet execution in IPython
M._python_execute_in_ipython = function()
  -- Get visual selection
  local lines = vim.api.nvim_buf_get_visual_selection()
  if #lines == 0 then
    notify_with_icon("No code selected", vim.log.levels.ERROR, "IPython", "")
    return
  end
  
  local code = table.concat(lines, "\n")
  
  -- Check if IPython terminal exists and is running
  local Terminal = require("toggleterm.terminal").Terminal
  local ipython = Terminal:new({
    cmd = "ipython",
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      title = "IPython Interactive",
      title_pos = "center",
    },
    close_on_exit = false,
    hidden = true,
    on_open = function()
      notify_with_icon("IPython started", vim.log.levels.INFO, "IPython", "")
    end
  })
  
  -- Function to send code to IPython
  local function send_to_ipython()
    notify_with_icon("Executing code in IPython...", vim.log.levels.INFO, "IPython", "")
    ipython:send(code)
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

-- Return the module
return M
