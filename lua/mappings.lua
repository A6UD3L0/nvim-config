-- Seamless Neovim keybindings for backend development
-- Combines ThePrimeagen's mappings with NvChad simplicity

-- Set leader key to space
vim.g.mapleader = " "

-- Create a local mapping function to use whether or not which-key is available
local map = vim.keymap.set

-- Create a module for exported functions
local M = {}

-- Helper for checking if a command exists
M._command_exists = function(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then
    return false
  end

  local result = handle:read "*a"
  handle:close()

  return result and #result > 0
end

-- Generic plugin availability check function
M._has_plugin = function(plugin_name)
  local status_ok, _ = pcall(require, plugin_name)
  return status_ok
end

-- Helper to run a command in a toggleterm window
M._run_in_terminal = function(cmd, direction)
  direction = direction or "horizontal"

  -- Check that toggleterm is available
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not toggleterm_ok then
    vim.notify("ToggleTerm plugin not found, using built-in terminal", vim.log.levels.WARN)
    
    -- Fall back to built-in terminal
    vim.cmd("split | terminal " .. cmd)
    return
  end

  local term = toggleterm.Terminal:new {
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  }
  term:toggle()
end

-- Enhanced Python file runner - Improved to reliably run Python files
M._python_run_file = function()
  local file = vim.fn.expand("%:p")
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end

  if vim.bo.filetype ~= "python" then
    vim.notify("Not a Python file", vim.log.levels.ERROR)
    return
  end

  -- Get the best Python command for the current environment
  local python_cmd = "python"
  
  -- Check for virtual environment
  local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  if venv_path ~= "" then
    if vim.fn.has("win32") == 1 then
      python_cmd = venv_path .. "\\Scripts\\python.exe"
    else
      python_cmd = "source " .. venv_path .. "/bin/activate && python"
    end
  elseif vim.fn.filereadable(".python-version") == 1 then
    python_cmd = "pyenv shell $(cat .python-version) && python"
  elseif vim.fn.filereadable("pyproject.toml") == 1 then
    python_cmd = "poetry run python"
  end
  
  -- Execute the file in a terminal
  M._run_in_terminal(python_cmd .. " \"" .. file .. "\"")
end

-- Run current file based on filetype
M._run_file = function()
  local ft = vim.bo.filetype
  
  if ft == "python" then
    M._python_run_file()
  elseif ft == "go" then
    M._run_in_terminal("go run " .. vim.fn.expand("%:p"))
  elseif ft == "sh" or ft == "bash" then
    M._run_in_terminal("bash " .. vim.fn.expand("%:p"))
  elseif ft == "c" or ft == "cpp" then
    -- Create a simple compilation command
    local out_file = vim.fn.expand("%:r")
    local compile_cmd = ft == "c" 
      and "gcc " .. vim.fn.expand("%:p") .. " -o " .. out_file
      or "g++ " .. vim.fn.expand("%:p") .. " -o " .. out_file
    
    M._run_in_terminal(compile_cmd .. " && " .. out_file)
  else
    vim.notify("No run command defined for filetype: " .. ft, vim.log.levels.WARN)
  end
end

-- Update keybindings for running files
map("n", "<leader>r", function()
  M._run_file()
end, { desc = "Run current file" })

map("n", "<F5>", function()
  M._run_file()
end, { desc = "Run current file" })

---------------------------------
-- ThePrimeagen's Core Mappings
---------------------------------

-- Better window navigation (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Paste over currently selected text without yanking it
map("v", "p", '"_dP', { desc = "Paste over selection without yanking" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })

-- Move cursor to beginning/end of line
map("n", "H", "^", { desc = "Move to beginning of line" })
map("n", "L", "$", { desc = "Move to end of line" })

-- Center cursor when navigating search results and when joining lines
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "J", "mzJ`z", { desc = "Join lines (centered)" })

-- Center when moving up/down half a page
map("n", "<C-d>", "<C-d>zz", { desc = "Move down half a page (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up half a page (centered)" })

-- Delete into blackhole register
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete into blackhole register" })

-- Never use Q
map("n", "Q", "<nop>", { desc = "Disabled key" })

-- Yank/paste with system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>P", [["+P]], { desc = "Paste from system clipboard (before)" })

-- Buffer navigation
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Window management
map("n", "<leader>w-", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>w|", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>wq", ":close<CR>", { desc = "Close window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Move to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Move to top window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Move to right window" })

-- Quick access to common commands
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })

---------------------------------
-- Plugin-specific mappings
---------------------------------

-- Harpoon (Quick file navigation)
map("n", "<leader>ha", function()
  if M._has_plugin "harpoon" then
    require("harpoon"):list():append()
  else
    vim.notify("Harpoon plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Harpoon add file" })

map("n", "<leader>ht", function()
  if M._has_plugin "harpoon" then
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
  else
    vim.notify("Harpoon plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Harpoon toggle menu" })

-- Harpoon file jumps
for i = 1, 4 do
  map("n", string.format("<leader>h%s", i), function()
    if M._has_plugin "harpoon" then
      require("harpoon"):list():select(i)
    else
      vim.notify("Harpoon plugin not found", vim.log.levels.WARN)
    end
  end, { desc = string.format("Harpoon file %s", i) })
end

-- NvimTree
map("n", "<leader>e", function()
  if M._has_plugin "nvim-tree" then
    vim.cmd("NvimTreeToggle")
  else
    vim.notify("NvimTree plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Toggle file explorer" })

-- Telescope
if M._has_plugin "telescope.builtin" then
  local builtin = require("telescope.builtin")
  
  -- File pickers
  map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
  map("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
  map("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
  
  -- Git pickers
  map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
  map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
  map("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
  
  -- LSP pickers
  map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Document symbols" })
  map("n", "<leader>lr", builtin.lsp_references, { desc = "References" })
  map("n", "<leader>ld", builtin.diagnostics, { desc = "Diagnostics" })
end

-- Git mappings
map("n", "<leader>gg", function()
  if M._has_plugin "neogit" then
    require("neogit").open()
  elseif M._command_exists "lazygit" then
    M._run_in_terminal("lazygit", "float")
  else
    vim.notify("No git UI plugin found", vim.log.levels.WARN)
  end
end, { desc = "Open git UI" })

-- LazyGit
map("n", "<leader>gl", function()
  if M._command_exists "lazygit" then
    if M._has_plugin "lazygit" then
      vim.cmd("LazyGit")
    else
      M._run_in_terminal("lazygit", "float")
    end
  else
    vim.notify("LazyGit not installed", vim.log.levels.WARN)
  end
end, { desc = "Open LazyGit" })

-- Undotree
map("n", "<leader>u", function()
  if M._has_plugin "undotree" then
    vim.cmd("UndotreeToggle")
  else
    vim.notify("Undotree plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Toggle Undotree" })

-- Python virtual environment
map("n", "<leader>vs", function()
  if M._has_plugin "venv-selector" then
    vim.cmd("VenvSelect")
  else
    vim.notify("venv-selector plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Select virtual environment" })

map("n", "<leader>vc", function()
  if M._has_plugin "venv-selector" then
    vim.cmd("VenvSelectCached")
  else
    vim.notify("venv-selector plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Select cached virtual environment" })

-- DevDocs
map("n", "<leader>dd", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd("DevdocsOpenFloat")
  else
    vim.notify("nvim-devdocs plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Open DevDocs" })

map("n", "<leader>df", function()
  if M._has_plugin "nvim-devdocs" then
    vim.cmd("DevdocsFetch")
  else
    vim.notify("nvim-devdocs plugin not found", vim.log.levels.WARN)
  end
end, { desc = "Fetch DevDocs" })

-- LSP mappings (these will be applied on LSP attach in the backend-essentials.lua)
-- These are here for reference but are set in the LSP attach event

-- Toggle LSP diagnostics inline
map("n", "<leader>lt", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  vim.notify("Inline diagnostics " .. (not current and "enabled" or "disabled"))
end, { desc = "Toggle diagnostic inline display" })

-- LSP Info and control
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "LSP restart" })

-- Diagnostics navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics to quickfix" })

-- Helper function to set up LSP mappings
M.setup_lsp_mappings = function(bufnr)
  local opts = { buffer = bufnr }
  
  map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
  map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
  map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
  map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
  map("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, vim.tbl_extend("force", opts, { desc = "Format" }))
end

return M
