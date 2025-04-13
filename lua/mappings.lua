-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Function to set up which-key
local function setup_which_key(wk)
  wk.setup {
    plugins = { spelling = true },
    triggers = { "<leader>", "g", "z" },
    win = {
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
  wk.add({
    -- Buffer management
    { "<leader>b", name = "Buffer" },
    { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Buffer list" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
    
    -- Debug
    { "<leader>d", name = "Debug" },
    { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
    { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step into" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step over" },
    { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "REPL" },
    { "<leader>dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
    
    -- Find (Telescope)
    { "<leader>f", name = "Find" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
    { "<leader>fB", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
    
    -- Git
    { "<leader>g", name = "Git" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Blame" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Diff" },
    { "<leader>gg", "<cmd>Git<cr>", desc = "Status" },
    { "<leader>gl", "<cmd>Git pull<cr>", desc = "Pull" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
    
    -- Harpoon
    { "<leader>h", name = "Harpoon" },
    { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file" },
    { "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Menu" },
    
    -- LSP
    { "<leader>l", name = "LSP" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP info" },
    { "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
    { "<leader>ls", "<cmd>LspStart<cr>", desc = "Start LSP" },
    { "<leader>lS", "<cmd>LspStop<cr>", desc = "Stop LSP" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover documentation" },
    { "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help" },
    { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type definition" },
    
    -- Python/Project
    { "<leader>p", name = "Python/Project" },
    { "<leader>pi", "<cmd>!pip install -r requirements.txt<cr>", desc = "Install requirements" },
    { "<leader>pT", "<cmd>!python %<cr>", desc = "Run file" },
    { "<leader>pt", "<cmd>!pytest %<cr>", desc = "Run tests" },
    { "<leader>pv", "<cmd>!python -m venv .venv<cr>", desc = "Create venv" },
    { "<leader>pe", "<cmd>Ex<cr>", desc = "Open netrw file explorer" },
    
    -- Go specific
    { "<leader>go", name = "Go commands" },
    { "<leader>gor", "<cmd>!go run %<CR>", desc = "Run current Go file" },
    { "<leader>got", "<cmd>!go test ./...<CR>", desc = "Run Go tests" },
    { "<leader>gob", "<cmd>!go build<CR>", desc = "Build Go project" },
    { "<leader>goi", "<cmd>!go mod tidy<CR>", desc = "Go mod tidy" },
    
    -- REPL/Reload
    { "<leader>r", name = "REPL/Reload" },
    { "<leader>rs", "<cmd>so<cr>", desc = "Source current file" },
    
    -- Terminal/Toggle
    { "<leader>t", name = "Terminal/Toggle" },
    { "<leader>tn", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    { "<leader>tt", "<cmd>terminal<cr>", desc = "Terminal" },
    { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    
    -- Docker commands
    { "<leader>D", name = "Docker" },
    { "<leader>Dc", "<cmd>!docker-compose up -d<CR>", desc = "Docker-compose up" },
    { "<leader>Dd", "<cmd>!docker-compose down<CR>", desc = "Docker-compose down" },
    { "<leader>Dl", "<cmd>!docker ps<CR>", desc = "List Docker containers" },
    
    -- SQL
    { "<leader>sq", "<cmd>%!sqlformat --reindent --keywords upper --identifiers lower -<CR>", desc = "Format SQL" },
    
    -- ThePrimeagen's mappings
    { "<leader>y", [["+y]], desc = "Yank to system clipboard", mode = { "n", "v" } },
    { "<leader>Y", [["+Y]], desc = "Yank line to system clipboard" },
    { "<leader>d", [["_d]], desc = "Delete without yanking", mode = { "n", "v" } },
    
    -- Visual mode mappings for x mode only
    { "<leader>p", [["_dP]], desc = "Paste without yanking selection", mode = "x" },
    
    -- Other mappings
    { "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Search & replace word under cursor" },
    { "<leader>x", "<cmd>!chmod +x %<CR>", desc = "Make file executable" },
    
    -- Go error handling snippets
    { "<leader>e", name = "Error handling" },
    { "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", desc = "Go error snippet: return" },
    { "<leader>ef", "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>", desc = "Go error snippet: fatal" },
  })
end

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
