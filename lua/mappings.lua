-- Load NvChad mappings as base
require "nvchad.mappings"

-- Map leader key to space
vim.g.mapleader = " "

local map = vim.keymap.set

--------------------------
-- General Keybindings
--------------------------
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<C-c>", "<Esc>", { desc = "Alternative exit from insert mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Disable Ex mode (avoid accidental entry)
map("n", "Q", "<nop>", { desc = "Disabled Ex mode" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })

--------------------------
-- ThePrimeagen's Best Mappings
--------------------------
-- Quick access to file explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })

-- Better navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down & center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up & center" })
map("n", "n", "nzzzv", { desc = "Next search result & center" })
map("n", "N", "Nzzzv", { desc = "Prev search result & center" })

-- Move text up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Join line without cursor movement
map("n", "J", "mzJ`z", { desc = "Join line & keep cursor position" })

-- Better copy/paste management
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

--------------------------
-- Development Specific
--------------------------
-- Code formatting 
map("n", "<leader>f", function()
  require("conform").format({ bufnr = 0 })
end, { desc = "Format code" })

-- LSP restart (useful for zig and other languages)
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Search and replace word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 
    { desc = "Search & replace word under cursor" })

-- Make current file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

--------------------------
-- Plugin Specific Mappings
--------------------------
-- Telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", { desc = "Find oldfiles" })

-- Harpoon (if installed)
map("n", "<leader>ha", function()
    local harpoon = require("harpoon.mark")
    if harpoon then harpoon.add_file() end
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
    local harpoon_ui = require("harpoon.ui")
    if harpoon_ui then harpoon_ui.toggle_quick_menu() end
end, { desc = "Harpoon toggle menu" })

-- Reload config
map("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source current file" })

--------------------------
-- Language Specific
--------------------------
-- Go error handling snippets
map("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", 
    { desc = "Go error snippet: return" })

map("n", "<leader>ef", "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>", 
    { desc = "Go error snippet: fatal" })

-- Debug/Test
map("n", "<leader>dt", "<cmd>lua require('dap').toggle_breakpoint()<CR>", 
    { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", 
    { desc = "Debug continue" })
