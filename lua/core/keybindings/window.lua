-- Window Management Keybindings Module
-- Controls window creation, navigation, and manipulation

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register window group
  keybindings.register_group("<leader>w", "Window", "", "#41A6B5") -- Window (teal)
  
  -- Window splitting
  map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window horizontally" })
  map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
  
  -- Window closing
  map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
  map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close all other windows" })
  
  -- Window navigation (enhanced with ctrl keys already defined in core)
  map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
  map("n", "<leader>wj", "<C-w>j", { desc = "Go to bottom window" })
  map("n", "<leader>wk", "<C-w>k", { desc = "Go to top window" })
  map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
  
  -- Window moving
  map("n", "<leader>wH", "<cmd>wincmd H<CR>", { desc = "Move window to far left" })
  map("n", "<leader>wJ", "<cmd>wincmd J<CR>", { desc = "Move window to bottom" })
  map("n", "<leader>wK", "<cmd>wincmd K<CR>", { desc = "Move window to top" })
  map("n", "<leader>wL", "<cmd>wincmd L<CR>", { desc = "Move window to far right" })
  
  -- Window resizing
  map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
  map("n", "<leader>w-", "<cmd>resize -5<CR>", { desc = "Decrease window height" })
  map("n", "<leader>w+", "<cmd>resize +5<CR>", { desc = "Increase window height" })
  map("n", "<leader>w<", "<cmd>vertical resize -5<CR>", { desc = "Decrease window width" })
  map("n", "<leader>w>", "<cmd>vertical resize +5<CR>", { desc = "Increase window width" })
  
  -- Window maximizing
  map("n", "<leader>wm", function()
    -- Check if maximize.nvim is available
    local has_maximize, maximize = utils.has_plugin("maximize")
    if has_maximize then
      maximize.toggle()
    else
      -- Fallback to close all other windows
      vim.cmd("only")
    end
  end, { desc = "Maximize window" })
  
  -- Moving windows between tabs
  map("n", "<leader>wt", "<C-w>T", { desc = "Move window to new tab" })
  
  -- Tab navigation 
  map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
  map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
  map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
  map("n", "<leader>tj", "<cmd>tabnext<CR>", { desc = "Next tab" })
  map("n", "<leader>tk", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
  map("n", "<leader>tl", "<cmd>tablast<CR>", { desc = "Last tab" })
  map("n", "<leader>tf", "<cmd>tabfirst<CR>", { desc = "First tab" })
  
  -- Register tab group
  keybindings.register_group("<leader>t", "Tab/Toggle", "", "#B4F9F8") -- Tab (turquoise)
end

return M
