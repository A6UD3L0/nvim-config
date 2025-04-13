-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

local wk_status, wk = pcall(require, "which-key")
if not wk_status then
  return
end

-- Initialize Copilot-cmp if available
local copilot_cmp_status, copilot_cmp = pcall(require, "copilot_cmp")
if copilot_cmp_status then
  copilot_cmp.setup()
end

-- Function to set up which-key
wk.setup {
  plugins = { spelling = true },
  triggers = { "<leader>" },
  defer = { gc = "Comments" },
  win = {
    border = "rounded",
    winblend = 0,
  },
}

-- Add specific mapping for Space+Space to show all keybindings
map("n", "<leader><leader>", "<cmd>WhichKey <CR>", { desc = "Show all keybindings" })

--------------------------
-- Basic key mappings that work without which-key
--------------------------
-- These key mappings will always work, even if which-key isn't loaded
map("n", ";", ":", { desc = "CMD: Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<C-c>", "<ESC>", { desc = "Alternative exit insert mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

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
map("n", "J", "mzJ`z", { desc = "Join line and keep cursor position" })

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
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace word under cursor" })

-- Make file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- Register all leader commands in which-key using the new format
wk.register({
  -- Error handling
  ["<leader>e"] = { name = "Error handling" },
  ["<leader>ee"] = { "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", desc = "Go error snippet: return" },
  ["<leader>ef"] = { "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>", desc = "Go error snippet: fatal" },

  -- Docker commands
  ["<leader>D"] = { name = "Docker" },
  ["<leader>Dc"] = { "<cmd>!docker-compose up -d<CR>", desc = "Docker-compose up" },
  ["<leader>Dd"] = { "<cmd>!docker-compose down<CR>", desc = "Docker-compose down" },
  ["<leader>Dl"] = { "<cmd>!docker ps<CR>", desc = "List Docker containers" },

  -- SQL formatting
  ["<leader>sq"] = { "<cmd>%!sqlformat --reindent --keywords upper --identifiers lower -<CR>", desc = "Format SQL" },

  -- File operations
  ["<leader>w"] = { "<cmd>w<CR>", desc = "Save file" },
  ["<leader>wq"] = { "<cmd>wq<CR>", desc = "Save and quit" },

  -- Comment mappings
  ["gc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "Comment toggle linewise" },
  ["gcc"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "Comment toggle current line" },
}, { mode = "n" })
