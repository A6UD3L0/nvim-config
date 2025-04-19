-- Core Keybindings Module
-- Essential keybindings that don't require plugins
-- These are always available regardless of plugin status

local keybindings = require("core.keybindings")
local map = keybindings.map
require("core.keybindings.base")

local M = {}

function M.setup()
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    Window Navigation                      │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Better window navigation (moved to base keymaps)
  -- map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
  -- map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
  -- map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
  -- map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
  
  -- Window resizing (moved to base keymaps)
  -- map("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
  -- map("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
  -- map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
  -- map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    Buffer Navigation                      │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Navigate buffers (moved to base keymaps)
  -- map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
  -- map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
  
  -- Close buffer handled by base keymaps
  -- map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
  -- map("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force delete buffer" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Text Editing                         │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Stay in indent mode when indenting
  map("v", "<", "<gv", { desc = "Decrease indent and keep selection" })
  map("v", ">", ">gv", { desc = "Increase indent and keep selection" })
  
  -- Move text up and down
  map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
  map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
  
  -- Maintain paste register
  map("v", "p", '"_dP', { desc = "Paste without overwriting register" })
  
  -- Clear search highlighting moved to base keymaps
  -- map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Configuration                         │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Reload Neovim configuration
  map("n", "<leader><leader>r", function()
    -- Save all modified buffers
    vim.cmd("silent! wall")
    -- Source init.lua
    vim.cmd("source $MYVIMRC")
    vim.notify("Configuration reloaded", vim.log.levels.INFO)
  end, { desc = "Reload nvim config" })
  
  -- Open config file
  map("n", "<leader><leader>c", ":e $MYVIMRC<CR>", { desc = "Edit nvim config" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                  Normal Mode Improvements                 │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Better line operations
  -- map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
  
  -- Better scrolling
  map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
  map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
  
  -- Better search navigation
  map("n", "n", "nzzzv", { desc = "Next search result and center" })
  map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
  
  -- Better command-line access
  map("n", ";", ":", { desc = "Enter command mode", noremap = true })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Editor Functionality                 │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Toggle relative line numbers
  map("n", "<leader>tr", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.notify("Relative line numbers: " .. (vim.wo.relativenumber and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle relative line numbers" })
  
  -- Toggle line wrap
  map("n", "<leader>tw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify("Line wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle line wrap" })
  
  -- Save file
  map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
  map("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
  
  -- Quit
  map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
  map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })
  
  -- Register which-key groups (now registered in base keymaps)
  -- keybindings.register_group("<leader>b", "Buffer", "", "#E0AF68")
  -- keybindings.register_group("<leader>t", "Toggle", "", "#B4F9F8")
end

return M
