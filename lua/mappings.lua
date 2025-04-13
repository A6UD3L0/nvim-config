-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Safely require which-key so we avoid an error if it's not loaded yet
local wk_status, wk = pcall(require, "which-key")
if not wk_status then
  vim.defer_fn(function()
    -- Try requiring which-key again after a short delay
    wk_status, wk = pcall(require, "which-key")
    if wk_status then
      -- Configure which-key if it's loaded after the delay
      setup_which_key(wk)
    else
      vim.notify("which-key plugin not found. Basic keybindings will still work.", vim.log.levels.WARN)
    end
  end, 500) -- 500ms delay to allow lazy.nvim to load which-key
else
  -- If which-key loaded successfully, set it up
  setup_which_key(wk)
end

-- Function to set up which-key
function setup_which_key(wk)
  wk.setup {
    plugins = { spelling = true },
    triggers = "<leader>",
    triggers_blacklist = {
      n = { "v", "s" },
      i = { "j", "k" },
      v = { "j", "k" },
    },
    window = {
      border = "rounded",
      winblend = 0,
    },
  }

  -- Add specific mapping for Space+Space to show all keybindings
  map("n", "<leader><leader>", "<cmd>WhichKey <CR>", { desc = "Show all keybindings" })

  --------------------------
  -- WhichKey Leader Mappings (New Format)
  --------------------------
  -- Register all leader commands in which-key using the new format
  wk.register({
    mode = { "n", "v" },
    -- Buffer management
    { "b", group = "Buffer" },
    { "bb", "<cmd>Telescope buffers<cr>", desc = "Buffer list" },
    { "bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
    { "bn", "<cmd>bnext<cr>", desc = "Next buffer" },
    { "bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
    
    -- Debug
    { "d", group = "Debug" },
    { "db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
    { "dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
    { "di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step into" },
    { "do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step over" },
    { "dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "REPL" },
    { "dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
    
    -- Find (Telescope)
    { "f", group = "Find" },
    { "fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
    { "fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
    { "fB", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
    
    -- Git
    { "g", group = "Git" },
    { "gb", "<cmd>Git blame<cr>", desc = "Blame" },
    { "gc", "<cmd>Git commit<cr>", desc = "Commit" },
    { "gd", "<cmd>Gdiffsplit<cr>", desc = "Diff" },
    { "gg", "<cmd>Git<cr>", desc = "Status" },
    { "gl", "<cmd>Git pull<cr>", desc = "Pull" },
    { "gp", "<cmd>Git push<cr>", desc = "Push" },
    
    -- Harpoon
    { "h", group = "Harpoon" },
    { "ha", function() require("harpoon.mark").add_file() end, desc = "Add file" },
    { "hh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Menu" },
    
    -- LSP
    { "l", group = "LSP" },
    { "lS", "<cmd>LspStop<cr>", desc = "Stop LSP" },
    { "la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
    { "ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
    { "lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
    { "li", "<cmd>LspInfo<cr>", desc = "LSP info" },
    { "ln", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "lr", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
    { "ls", "<cmd>LspStart<cr>", desc = "Start LSP" },
    
    -- Python/Project
    { "p", group = "Python/Project" },
    { "pi", "<cmd>!pip install -r requirements.txt<cr>", desc = "Install requirements" },
    { "pT", "<cmd>!python %<cr>", desc = "Run file" },
    { "pt", "<cmd>!pytest %<cr>", desc = "Run tests" },
    { "pv", "<cmd>!python -m venv .venv<cr>", desc = "Create venv" },
    
    -- Go specific
    { "gr", "<cmd>!go run %<CR>", desc = "Run current Go file" },
    { "gt", "<cmd>!go test ./...<CR>", desc = "Run Go tests" },
    { "gb", "<cmd>!go build<CR>", desc = "Build Go project" },
    { "gi", "<cmd>!go mod tidy<CR>", desc = "Go mod tidy" },
    
    -- REPL
    { "r", group = "REPL" },
    { "rs", function() vim.cmd("so") end, desc = "Source current file" },
    
    -- Terminal/Toggle
    { "t", group = "Terminal/Toggle" },
    { "tn", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    { "tt", "<cmd>terminal<cr>", desc = "Terminal" },
    { "tu", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    
    -- Docker commands
    { "dc", "<cmd>!docker-compose up -d<CR>", desc = "Docker-compose up" },
    { "dd", "<cmd>!docker-compose down<CR>", desc = "Docker-compose down" },
    { "dl", "<cmd>!docker ps<CR>", desc = "List Docker containers" },
    
    -- SQL
    { "sq", "<cmd>%!sqlformat --reindent --keywords upper --identifiers lower -<CR>", desc = "Format SQL" },
    
    -- Keep ThePrimeagen's mappings
    { "y", [["+y]], desc = "Yank to system clipboard" },
    { "Y", [["+Y]], desc = "Yank line to system clipboard" },
    { "d", [["_d]], desc = "Delete without yanking" },
    { "p", [["_dP]], desc = "Paste without yanking selection", mode = "x" },
    { "s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Search & replace word under cursor" },
    { "x", "<cmd>!chmod +x %<CR>", desc = "Make file executable" },
  }, { prefix = "<leader>" })
end

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

-- Reload config (mapped now to <leader>rs to avoid conflicting with WhichKey)
map("n", "<leader>rs", function()
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
