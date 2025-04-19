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

-- UV Project Manager
map("n", "<leader>pu", ":!uv pip install -r requirements.txt<CR>", { desc = "UV: Install Python deps" })
map("n", "<leader>pv", ":!uv venv .venv<CR>", { desc = "UV: Create venv" })
map("n", "<leader>pa", ":!uv pip install <C-r><C-w><CR>", { desc = "UV: Add package under cursor" })
map("n", "<leader>pr", ":!uv pip remove <C-r><C-w><CR>", { desc = "UV: Remove package under cursor" })
map("n", "<leader>ps", ":!uv pip sync<CR>", { desc = "UV: Sync environment" })
map("n", "<leader>pt", ":!uv pip list<CR>", { desc = "UV: List packages" })
map("n", "<leader>pl", ":!uv venv list<CR>", { desc = "UV: List venvs" })
map("n", "<leader>pd", ":!uv venv destroy .venv<CR>", { desc = "UV: Destroy current venv" })

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

-- LSP buffer-local mappings setup stub (for lsp.lua)
local M = {}

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
    ["<leader>pu"] = { "UV: Install Python deps" },
    ["<leader>pv"] = { "UV: Create venv" },
    ["<leader>pa"] = { "UV: Add package under cursor" },
    ["<leader>pr"] = { "UV: Remove package under cursor" },
    ["<leader>ps"] = { "UV: Sync environment" },
    ["<leader>pt"] = { "UV: List packages" },
    ["<leader>pl"] = { "UV: List venvs" },
    ["<leader>pd"] = { "UV: Destroy current venv" },
  })
end

function M.setup_lsp_mappings(bufnr)
  -- Example: buffer-local LSP mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

function M.setup_diagnostic_window_mappings(buf)
  -- Example: diagnostic window mappings
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set("n", "q", ":close<CR>", opts)
end

return M
