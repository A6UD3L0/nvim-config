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

-- Python specific mappings
map("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", { desc = "Run Python file" })
map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python REPL" })
map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython" })

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
      vim.notify('Virtual environment activated: ' .. venv_path, vim.log.levels.INFO, {
        title = "Python Environment",
        icon = "🐍"
      })
    else
      vim.notify('Python executable not found in ' .. venv_path, vim.log.levels.ERROR, {
        title = "Python Environment Error"
      })
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

-- Run selected Python code in terminal
M._python_execute_selected = function()
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
  f:write(table.concat(lines, "\n"))
  f:close()
  
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

map("v", "<leader>pe", function() M._python_execute_selected() end, { desc = "Execute selected Python" })

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
map("n", "<leader>cd", function()
  local file_path = vim.fn.expand('%:p:h')
  vim.cmd('cd ' .. file_path)
  print('Working directory changed to: ' .. file_path)
end, { desc = "Change to file's directory" })

map("n", "<leader>cD", function()
  local file_path = vim.fn.expand('%:p:h')
  local repo_root = vim.fn.system('git -C ' .. file_path .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  if repo_root ~= "" then
    vim.cmd('cd ' .. repo_root)
    print('Working directory changed to: ' .. repo_root)
  else
    print('Not a git repository')
  end
end, { desc = "Change to git root" })

-- Return the module
return M
