-- Core keymaps based on ThePrimeagen's style with NvChad simplicity
-- Optimized for backend development workflow

local map = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Tab navigation
map("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tl", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Move text up and down (ThePrimeagen style)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Keep cursor centered when navigating search results & when joining lines
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "J", "mzJ`z", { desc = "Join lines (preserve cursor)" })

-- Yank to end of line (consistent with D and C)
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Clear search highlights
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Quick save/quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })

-- Escape insert mode with 'jk'
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- File Explorer (nvim-tree)
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Git (fugitive)
map("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff" })
map("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>f/", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })

-- Harpoon (ThePrimeagen style)
map("n", "<leader>a", function() require("harpoon.mark").add_file() end, { desc = "Harpoon: Add file" })
map("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Harpoon: Quick menu" })
map("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end, { desc = "Harpoon: File 1" })
map("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end, { desc = "Harpoon: File 2" })
map("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end, { desc = "Harpoon: File 3" })
map("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end, { desc = "Harpoon: File 4" })

-- Undotree
map("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle undotree" })

-- LSP keybindings
-- (These will only work when an LSP is attached, which-key will handle this)
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "gr", function() vim.lsp.buf.references() end, { desc = "Find references" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover documentation" })
map("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>D", function() vim.lsp.buf.type_definition() end, { desc = "Type definition" })
map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format document" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
map("n", "<leader>dl", function() vim.diagnostic.setloclist() end, { desc = "Diagnostics list" })

-- Terminal
map("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Debugging (DAP)
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue debugging" })
map("n", "<leader>ds", function() require("dap").step_over() end, { desc = "Step over" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step out" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
