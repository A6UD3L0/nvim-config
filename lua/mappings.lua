-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

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
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Find text" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })
map("n", "<leader>fc", function() require("telescope.builtin").current_buffer_fuzzy_find() end, { desc = "Find in current buffer" })
map("n", "<leader>fd", function() require("telescope.builtin").diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document symbols" })
map("n", "<leader>ft", function() require("telescope.builtin").treesitter() end, { desc = "Treesitter symbols" })
map("n", "<leader>fB", function() require("telescope").extensions.file_browser.file_browser() end, { desc = "File browser" })

-- LSP mappings (enhanced for backend development)
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>ls", "<cmd>LspStart<CR>", { desc = "Start LSP" })
map("n", "<leader>lS", "<cmd>LspStop<CR>", { desc = "Stop LSP" })
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

-- Backend development specific
-- Python
map("n", "<leader>pt", "<cmd>!pytest %<CR>", { desc = "Run pytest on current file" })
map("n", "<leader>pT", "<cmd>!python %<CR>", { desc = "Run current Python file" })
map("n", "<leader>pi", "<cmd>!pip install -r requirements.txt<CR>", { desc = "Install requirements" })
map("n", "<leader>pv", "<cmd>!python -m venv .venv<CR>", { desc = "Create venv" })

-- Go
map("n", "<leader>gr", "<cmd>!go run %<CR>", { desc = "Run current Go file" })
map("n", "<leader>gt", "<cmd>!go test ./...<CR>", { desc = "Run Go tests" })
map("n", "<leader>gb", "<cmd>!go build<CR>", { desc = "Build Go project" })
map("n", "<leader>gi", "<cmd>!go mod tidy<CR>", { desc = "Go mod tidy" })

-- SQL
map("n", "<leader>sq", "<cmd>%!sqlformat --reindent --keywords upper --identifiers lower -<CR>", { desc = "Format SQL" })

-- Docker
map("n", "<leader>dc", "<cmd>!docker-compose up -d<CR>", { desc = "Docker-compose up" })
map("n", "<leader>dd", "<cmd>!docker-compose down<CR>", { desc = "Docker-compose down" })
map("n", "<leader>dl", "<cmd>!docker ps<CR>", { desc = "List Docker containers" })

-- Git enhanced
map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })

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
