-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Basic key mappings that work without which-key
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

-- Window resizing
map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ThePrimeagen's Best Mappings
-- Quick access to file explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })

-- Better navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down & center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up & center" })
map("n", "n", "nzzzv", { desc = "Next search result & center" })
map("n", "N", "Nzzzv", { desc = "Prev search result & center" })
map("n", "=ap", "ma=ap'a", { desc = "Format paragraph & restore cursor" })

-- Move text up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Join line without cursor movement
map("n", "J", "mzJ`z", { desc = "Join line and keep cursor position" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Quick-fix list navigation
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

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
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace word under cursor" })

-- Make file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- Add specific mapping for Space+Space to show all keybindings
map("n", "<leader><leader>", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })

-- Shortcut for saving and quitting
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Terminal mappings
map("n", "<C-t>", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode (jk)" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to below window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to above window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right window" })

-- Python specific mappings
map("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", { desc = "Run Python file" })
map("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python REPL" })
map("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython" })

-- NvimTree file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Better split navigation
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Code folding
map("n", "<leader>zc", "zc", { desc = "Close fold" })
map("n", "<leader>zo", "zo", { desc = "Open fold" })
map("n", "<leader>zC", "zC", { desc = "Close all folds" })
map("n", "<leader>zO", "zO", { desc = "Open all folds" })
map("n", "<leader>za", "za", { desc = "Toggle fold" })
map("n", "<leader>zA", "zA", { desc = "Toggle all folds" })

-- Diagnostic mappings
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic in float" })
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- DAP debugging
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue debug" })
map("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step into" })
map("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step over" })
map("n", "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out" })
map("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })

-- Comment
map("n", "gcc", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment" })
map("v", "gc", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Database UI
map("n", "<leader>da", "<cmd>DBUI<CR>", { desc = "Open Database UI" })

-- Working directory mappings for Python projects
-- Mapping for changing directories and activating virtual environments
map("n", "<leader>cd", function()
  local file_path = vim.fn.expand('%:p:h')
  vim.cmd('cd ' .. file_path)
  print('Working directory changed to: ' .. file_path)
end, { desc = "Change to file's directory" })

map("n", "<leader>cD", function()
  local file_path = vim.fn.expand('%:p:h')
  local repo_root = vim.fn.system('git -C ' .. file_path .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  if repo_root ~= "" then
    vim.cmd('cd ' .. repo_root)
    print('Working directory changed to: ' .. repo_root)
  else
    print('Not a git repository')
  end
end, { desc = "Change to git root" })

map("n", "<leader>cv", function()
  local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
  if venv_path ~= "" then
    vim.g.python3_host_prog = vim.fn.getcwd() .. '/' .. venv_path .. '/bin/python'
    print('Virtual environment activated: ' .. venv_path)
  else
    print('No .venv directory found')
  end
end, { desc = "Activate virtual environment" })
