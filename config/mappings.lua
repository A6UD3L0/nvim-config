-- Key mappings for Neovim (single source of truth)
-- All custom and plugin keymaps should be defined here
-- This file supersedes any other keymap or which-key config files

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Example: Leader key
vim.g.mapleader = " "

-- Window management
map("n", "<leader>wo", "<cmd>only<CR>", opts)
map("n", "<leader>wt", "<C-w>T", opts)
map("n", "<leader>w=", "<C-w>=", opts)
map("n", "<leader>ws", "<cmd>split<CR>", opts)
map("n", "<leader>wv", "<cmd>vsplit<CR>", opts)

-- Project navigation (ThePrimeagen style)
map("n", "<leader>pf", function()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then telescope.find_files() end
end, { desc = "Find files in project" })

-- ToggleTerm integration
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal" })

-- UndoTree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle UndoTree" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })

-- Diagnostics
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

-- Which-key registration (if available)
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.register({
    ["<leader>w"] = { name = "+windows" },
    ["<leader>f"] = { name = "+find" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>t"] = { name = "+terminal" },
    ["<leader>p"] = { name = "+project" },
    ["<leader>u"] = { "Toggle UndoTree" },
    ["<leader>e"] = { "Toggle file explorer" },
  })
end

return {}
