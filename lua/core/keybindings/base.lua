-- Global, non‑plugin keybindings consolidated here
-- Requiring this module once sets up all fundamental mappings shared across the
-- entire configuration. Other keybinding modules should simply `require` it and
-- avoid re‑defining these maps.

local keybindings = require("core.keybindings")
local map = keybindings.map
local register_group = keybindings.register_group

-- Guard against multiple executions (in case several modules require us)
if _G.__NVIM_CONFIG_BASE_KEYMAPS_LOADED then
  return true
end
_G.__NVIM_CONFIG_BASE_KEYMAPS_LOADED = true

---------------------------------------------------------------------
-- Which‑key groups that are used from many places
---------------------------------------------------------------------
register_group("<leader>b", "Buffer", "", "#E0AF68") -- Buffer (orange)
register_group("<leader>t", "Toggle", "", "#B4F9F8") -- Toggle (turquoise)

---------------------------------------------------------------------
-- Buffer management
---------------------------------------------------------------------
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force delete buffer" })

---------------------------------------------------------------------
-- Window navigation & sizing
---------------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

---------------------------------------------------------------------
-- Editing quality‑of‑life
---------------------------------------------------------------------
-- Join lines without moving the cursor
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Clear search highlighting
map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

return true
