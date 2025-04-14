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
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      title = "Python REPL",
      title_pos = "center",
    },
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.notify("Python REPL started", vim.log.levels.INFO, { title = "Python" })
    end,
  })
  python_term:toggle()
end

_IPYTHON_TOGGLE = function()
  -- Create a persistent IPython REPL terminal with enhanced features
  local ipython_term = require("toggleterm.terminal").Terminal:new({
    cmd = "ipython --matplotlib=auto --colors=Linux",
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      title = "IPython Interactive",
      title_pos = "center",
    },
    hidden = true,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.notify("IPython started", vim.log.levels.INFO, { title = "Python" })
    end,
  })
  ipython_term:toggle()
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

-- =============================================
-- KEYBINDING ORGANIZATION REFERENCE
-- =============================================
--
-- Namespace structure for leader-prefixed commands:
-- <leader>b  - Buffer operations
-- <leader>c  - Code actions (LSP related)
-- <leader>cd - Change directory
-- <leader>d  - Debug operations
-- <leader>e  - File explorer operations
-- <leader>f  - File operations (Telescope/find)
-- <leader>g  - Git operations
-- <leader>h  - Harpoon operations
-- <leader>l  - LSP operations
-- <leader>o  - Poetry operations
-- <leader>r  - Requirements.txt operations
-- <leader>t  - Terminal operations
-- <leader>u  - Undotree operations
-- <leader>v  - Virtual environment diagnostics
-- <leader>w  - Window operations
-- <leader>y  - Python operations
--
-- This structure ensures no key conflict and provides logical grouping

-- Terminal toggles with consistent naming under t namespace
map("n", "<leader>tp", function() _PYTHON_TOGGLE() end, { desc = "Toggle Python REPL" })
map("n", "<leader>ti", function() _IPYTHON_TOGGLE() end, { desc = "Toggle IPython" })
map("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle terminal (float)" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal (horiz)" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle terminal (vert)" })

-- Python namespace (leader y for "pYthon")
map("n", "<leader>yr", function() M._python_run_file() end, { desc = "Run Python file" })
map("v", "<leader>ye", function() M._python_execute_snippet() end, { desc = "Execute selected Python code" })
map("v", "<leader>yi", function() M._python_execute_in_ipython() end, { desc = "Execute in IPython" })
map("n", "<leader>yt", function() vim.cmd("Telescope python_tests") end, { desc = "Python tests" })
map("n", "<leader>yn", function() M._python_new_file() end, { desc = "New Python file" })

-- File explorer operations (e namespace)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- File operations (f namespace for Telescope/find)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find in files (grep)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks" })
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save all files" })

-- Window operations namespace
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

-- Undotree toggle - Keep this clean single mapping
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

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

-- Return the module
return M
