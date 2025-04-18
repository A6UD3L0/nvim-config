-- KeybindingManager: Comprehensive keybinding organization
-- Follows MECE principles with consistent UX and graceful fallbacks

local M = {}

-- ╭──────────────────────────────────────────────────────────╮
-- │                    Utils & Helpers                        │
-- ╰──────────────────────────────────────────────────────────╯

-- Store all mappings for registration with which-key
local all_mappings = {}

-- Enhanced mapping function that stores mappings for which-key
local function map(mode, lhs, rhs, opts)
  -- Handle options with defaults
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  opts.silent = opts.silent == nil and true or opts.silent
  
  -- Set the mapping
  local status_ok, _ = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not status_ok then
    -- Just skip this mapping if it fails (may be due to missing function)
    return false
  end
  
  -- Track leader mappings for which-key using the new format
  if lhs:match("^<leader>") and opts.desc then
    -- Extract the key sequence after <leader>
    local suffix = lhs:match("^<leader>(.+)")
    if suffix and suffix ~= "" then
      -- Create mapping entry in the format expected by newer which-key versions
      table.insert(all_mappings, {
        "<leader>" .. suffix,
        desc = opts.desc,
        mode = type(mode) == "table" and mode or { mode },
        nowait = opts.nowait,
        remap = not (opts.noremap == true),
        silent = opts.silent
      })
    end
  end
  
  return true
end

-- Plugin availability checker
local function has_plugin(plugin_name)
  return pcall(require, plugin_name)
end

-- External tool availability checker
local function command_exists(cmd)
  if not cmd or cmd == "" then return false end
  
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then return false end
  
  local result = handle:read("*a")
  handle:close()
  return result and #result > 0
end

-- Check if a module setup function exists
local function has_module(module_name)
  if not module_name or module_name == "" then return false end
  
  local ok, mod = pcall(require, module_name)
  return ok and mod and type(mod.setup) == "function"
end

-- Run command in terminal (if toggleterm is available)
local function run_in_terminal(cmd, direction)
  if not cmd or cmd == "" then return false end
  direction = direction or "horizontal"
  
  -- First try using our terminal module
  if has_module("config.terminal") then
    local term = require("config.terminal")
    if term.run_command then
      return term.run_command(cmd)
    end
  end
  
  -- Fallback to direct toggleterm use
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not toggleterm_ok then
    vim.notify("ToggleTerm not available", vim.log.levels.WARN)
    return false
  end
  
  local term = toggleterm.Terminal:new({
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  })
  term:toggle()
  return true
end

-- Get safe function from module
local function get_safe_func(module_name, func_name)
  if not module_name or not func_name then return nil end
  
  local mod_ok, mod = pcall(require, module_name)
  if not mod_ok or not mod then return nil end
  
  if type(mod[func_name]) ~= "function" then return nil end
  
  return function(...)
    local status_ok, result = pcall(mod[func_name], ...)
    if not status_ok then
      vim.notify(
        string.format("Error executing %s.%s: %s", module_name, func_name, result),
        vim.log.levels.ERROR
      )
      return nil
    end
    return result
  end
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                   Domain Categories                       │
-- ╰──────────────────────────────────────────────────────────╯

-- Each function should:
-- 1. Be MECE (Mutually Exclusive, Collectively Exhaustive)
-- 2. Check for plugin availability with graceful fallbacks
-- 3. Use consistent mapping patterns
-- 4. Have clear, descriptive binding descriptions

local function setup_core_mappings()
  -- Basics that don't require plugins
  
  -- Better window navigation
  map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
  
  -- Window management
  map("n", "<leader>wh", "<C-w>h", { desc = "Move to left window" })
  map("n", "<leader>wj", "<C-w>j", { desc = "Move to bottom window" })
  map("n", "<leader>wk", "<C-w>k", { desc = "Move to top window" })
  map("n", "<leader>wl", "<C-w>l", { desc = "Move to right window" })
  map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
  map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window horizontally" })
  map("n", "<leader>wq", "<cmd>close<CR>", { desc = "Close window" })
  map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close all other windows" })
  map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
  map("n", "<leader>wt", "<C-w>T", { desc = "Move window to new tab" })
  
  -- Resize windows with arrows
  map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
  map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
  map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
  map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })
  
  -- Buffer navigation
  map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
  map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
  map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
  map("n", "<leader>bb", ":e #<CR>", { desc = "Switch to last buffer" })
  map("n", "<leader>bl", ":buffers<CR>", { desc = "List all buffers" })
  
  -- Tab navigation
  map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
  map("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
  map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
  map("n", "<leader>tt", ":tabnew<CR>", { desc = "New tab" })
  map("n", "<leader>to", ":tabonly<CR>", { desc = "Close all other tabs" })
  
  -- Text navigation improvements
  map("n", "<C-d>", "<C-d>zz", { desc = "Move down half-page and center" })
  map("n", "<C-u>", "<C-u>zz", { desc = "Move up half-page and center" })
  map("n", "n", "nzzzv", { desc = "Next search result and center" })
  map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
  map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
  
  -- Quick save and quit
  map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
  map("n", "<leader>q", ":confirm qa<CR>", { desc = "Quit all (confirm)" })
  map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })
  
  -- Exit insert mode with jk
  map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
  
  -- Line movement in normal and visual mode
  map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
  map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
  map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
  
  -- Better indenting - stay in visual mode
  map("v", "<", "<gv", { desc = "Unindent and stay in visual mode" })
  map("v", ">", ">gv", { desc = "Indent and stay in visual mode" })
  
  -- Clear highlighting
  map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting" })
  
  -- Yank to system clipboard
  map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
  map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
  
  -- Delete without yanking
  map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
  
  -- Replace currently selected text without changing register
  map("v", "p", '"_dP', { desc = "Replace without yanking" })
  
  -- Center screen when using G and gg
  map("n", "G", "Gzz", { desc = "Go to end of file and center" })
  map("n", "gg", "ggzz", { desc = "Go to start of file and center" })
  
  -- Diagnostic navigation
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  map("n", "<leader>xx", function()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    vim.notify("Diagnostics " .. (vim.diagnostic.config().virtual_text and "enabled" or "disabled"))
  end, { desc = "Toggle diagnostics" })
  map("n", "<leader>xf", vim.diagnostic.open_float, { desc = "Show diagnostic in float" })
  map("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Diagnostics in loclist" })
  
  -- Reload config
  map("n", "<leader><leader>r", function()
    -- Save all modified buffers
    vim.cmd("silent! wall")
    -- Source init.lua
    vim.cmd("source $MYVIMRC")
    -- Notify user
    vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
  end, { desc = "Reload config" })
end

local function setup_telescope_mappings()
  if not has_plugin("telescope") then
    vim.notify("Telescope not available, file search mappings disabled", vim.log.levels.DEBUG)
    return
  end
  
  -- File operations
  map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
  map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
  map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
  map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks" })
  map("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Colorschemes" })
  map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
  map("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in buffer" })
  
  -- Project management (if telescope-project is available)
  if has_plugin("telescope").extensions and has_plugin("telescope").extensions.project then
    map("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Projects" })
  end
  
  -- Session management (if auto-session and session-lens are available)
  if has_plugin("session-lens") then
    map("n", "<leader>fs", "<cmd>SearchSession<CR>", { desc = "Find sessions" })
  end
  
  -- Advanced searches
  if has_plugin("telescope").builtin then
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    
    -- Define telescope-specific functions
    local function live_grep_in_folder()
      builtin.live_grep({
        prompt_title = "Live Grep in Folder",
        cwd = vim.fn.input("Folder: ", vim.fn.getcwd(), "dir"),
      })
    end
    
    local function find_files_in_folder()
      builtin.find_files({
        prompt_title = "Find Files in Folder",
        cwd = vim.fn.input("Folder: ", vim.fn.getcwd(), "dir"),
      })
    end
    
    -- Register these more advanced functions
    map("n", "<leader>fG", live_grep_in_folder, { desc = "Grep in folder" })
    map("n", "<leader>fF", find_files_in_folder, { desc = "Files in folder" })
    map("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })
  end
end

local function setup_git_mappings()
  -- Basic git mappings using vim-fugitive (if available)
  if has_plugin("fugitive") then
    map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })
    map("n", "<leader>gB", "<cmd>Git blame<CR>", { desc = "Git blame" })
    map("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })
    map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
    map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
    map("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "Git pull" })
    map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })
  else
    vim.notify("vim-fugitive not available, basic git mappings disabled", vim.log.levels.DEBUG)
  end
  
  -- Advanced git mappings are set in git.lua's setup
  -- These registrations are just for which-key
  
  -- Git hunks with gitsigns.nvim
  map("n", "<leader>ghr", "", { desc = "Reset hunk" })
  map("n", "<leader>ghs", "", { desc = "Stage hunk" })
  map("n", "<leader>ghp", "", { desc = "Preview hunk" })
  map("n", "<leader>ghb", "", { desc = "Blame line" })
  map("n", "<leader>ghd", "", { desc = "Diff this" })
  
  -- Git conflicts with git-conflict.nvim
  map("n", "<leader>gco", "", { desc = "Choose ours" })
  map("n", "<leader>gct", "", { desc = "Choose theirs" })
  map("n", "<leader>gcb", "", { desc = "Choose both" })
  map("n", "<leader>gc0", "", { desc = "Choose none" })
  map("n", "<leader>gcl", "", { desc = "List conflicts" })
end

local function setup_lsp_mappings()
  -- These will be applied by an autocmd when LSP attaches to a buffer
  -- Stored here for organization and which-key registration
  
  M.lsp_mappings = {
    -- LSP actions
    ["<leader>lR"] = { function() vim.lsp.buf.references() end, "Find references", mode = "n" },
    ["<leader>lr"] = { function() vim.lsp.buf.rename() end, "Rename symbol", mode = "n" },
    ["<leader>lh"] = { function() vim.lsp.buf.hover() end, "Hover documentation", mode = "n" },
    ["<leader>la"] = { function() vim.lsp.buf.code_action() end, "Code action", mode = "n" },
    ["<leader>ld"] = { function() vim.lsp.buf.definition() end, "Go to definition", mode = "n" },
    ["<leader>lD"] = { function() vim.lsp.buf.declaration() end, "Go to declaration", mode = "n" },
    ["<leader>lt"] = { function() vim.lsp.buf.type_definition() end, "Go to type definition", mode = "n" },
    ["<leader>li"] = { function() vim.lsp.buf.implementation() end, "Go to implementation", mode = "n" },
    ["<leader>ls"] = { function() vim.lsp.buf.signature_help() end, "Signature help", mode = "n" },
    ["<leader>lf"] = { function() vim.lsp.buf.format { async = true } end, "Format buffer", mode = "n" },
    ["<leader>lF"] = { function() vim.lsp.buf.format { async = true, range = { ["start"] = vim.api.nvim_buf_get_mark(0, "<"), ["end"] = vim.api.nvim_buf_get_mark(0, ">") } } end, "Format selection", mode = "v" }
  }
  
  -- We don't directly set these here since they'll be applied on LSP attach
  -- But we do register them for which-key
  
  for key, mapping in pairs(M.lsp_mappings) do
    map(mapping.mode, key, "", { desc = mapping[2] })
  end
  
  -- Workspace mappings
  map("n", "<leader>lwa", function() vim.lsp.buf.add_workspace_folder() end, { desc = "Add workspace folder" })
  map("n", "<leader>lwr", function() vim.lsp.buf.remove_workspace_folder() end, { desc = "Remove workspace folder" })
  map("n", "<leader>lwl", function() 
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List workspace folders" })
end

local function setup_ide_mappings()
  -- IDE-like features with graceful fallbacks
  
  -- File explorer
  -- Use a function to ensure on-demand loading
  map("n", "<leader>ef", function()
    if has_plugin("nvim-tree") then
      vim.cmd("NvimTreeFindFile")
    elseif has_plugin("neo-tree") then
      vim.cmd("Neotree reveal")
    else
      vim.cmd("Explore")
    end
  end, { desc = "Find in file explorer" })
  
  map("n", "<leader>er", function()
    if has_plugin("nvim-tree") then
      vim.cmd("NvimTreeRefresh")
    elseif has_plugin("neo-tree") then
      vim.cmd("Neotree refresh")
    else
      vim.cmd("Explore")
    end
  end, { desc = "Refresh file explorer" })
  
  map("n", "<leader>e", function()
    if has_plugin("nvim-tree") then
      vim.cmd("NvimTreeToggle")
    elseif has_plugin("neo-tree") then
      vim.cmd("Neotree toggle")
    else
      vim.cmd("Explore")
    end
  end, { desc = "Toggle file explorer" })
  
  -- Terminal
  map("n", "<leader>tf", function()
    if has_plugin("toggleterm") then
      local toggleterm = require("toggleterm")
      toggleterm.toggle(0, nil, nil, "float")
    else
      vim.cmd("vsplit | terminal")
    end
  end, { desc = "Floating terminal" })
  
  map("n", "<leader>th", function()
    if has_plugin("toggleterm") then
      local toggleterm = require("toggleterm")
      toggleterm.toggle(0, nil, nil, "horizontal")
    else
      vim.cmd("split | terminal")
    end
  end, { desc = "Horizontal terminal" })
  
  map("n", "<leader>tv", function()
    if has_plugin("toggleterm") then
      local toggleterm = require("toggleterm")
      toggleterm.toggle(0, nil, nil, "vertical")
    else
      vim.cmd("vsplit | terminal")
    end
  end, { desc = "Vertical terminal" })
  
  -- Trouble.nvim (or quickfix fallback)
  map("n", "<leader>xx", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle")
    else
      vim.cmd("copen")
    end
  end, { desc = "Toggle diagnostics" })
  
  map("n", "<leader>xw", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle workspace_diagnostics")
    else
      vim.diagnostic.setqflist()
    end
  end, { desc = "Workspace diagnostics" })
  
  map("n", "<leader>xd", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle document_diagnostics")
    else
      vim.diagnostic.setloclist()
    end
  end, { desc = "Document diagnostics" })
  
  map("n", "<leader>xq", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle quickfix")
    else
      vim.cmd("copen")
    end
  end, { desc = "Quickfix list" })
  
  map("n", "<leader>xl", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle loclist")
    else
      vim.cmd("lopen")
    end
  end, { desc = "Location list" })
  
  -- Zen mode / Distraction free
  map("n", "<leader>z", function()
    if has_plugin("zen-mode") then
      vim.cmd("ZenMode")
    else
      -- Fallback to a simple distraction-free mode
      vim.cmd("set laststatus=0 | set showtabline=0 | set nonumber | set norelativenumber")
    end
  end, { desc = "Zen mode" })
  
  -- AI features
  map("n", "<leader>ac", function()
    if has_plugin("copilot.lua") then
      vim.cmd("Copilot panel")
    else
      vim.notify("Copilot not available", vim.log.levels.WARN)
    end
  end, { desc = "Copilot panel" })
  
  map("n", "<leader>ae", function()
    if has_plugin("copilot.lua") then
      vim.cmd("Copilot enable")
    else
      vim.notify("Copilot not available", vim.log.levels.WARN)
    end
  end, { desc = "Enable Copilot" })
  
  map("n", "<leader>ad", function()
    if has_plugin("copilot.lua") then
      vim.cmd("Copilot disable")
    else
      vim.notify("Copilot not available", vim.log.levels.WARN)
    end
  end, { desc = "Disable Copilot" })
  
  -- Chat interface
  map("n", "<leader>ai", function()
    if has_plugin("CopilotChat") then
      vim.cmd("CopilotChatOpen")
    elseif has_plugin("chatgpt") then
      vim.cmd("ChatGPT")
    else
      vim.notify("No AI chat interface available", vim.log.levels.WARN)
    end
  end, { desc = "Open AI chat" })
  
  -- Code runtime
  map("n", "<leader>r", function()
    -- Get filetype and choose action based on that
    local ft = vim.bo.filetype
    if ft == "python" then
      run_in_terminal("python " .. vim.fn.expand("%"))
    elseif ft == "javascript" or ft == "typescript" then
      run_in_terminal("node " .. vim.fn.expand("%"))
    elseif ft == "go" then
      run_in_terminal("go run " .. vim.fn.expand("%"))
    elseif ft == "rust" then
      run_in_terminal("cargo run")
    elseif ft == "lua" then
      -- Special case for Lua: if it looks like a Neovim plugin, source it
      if vim.fn.expand("%"):match("%.lua$") and (
        vim.fn.expand("%"):match("^lua/") or
        vim.fn.expand("%"):match("^plugin/") or
        vim.fn.expand("%"):match("^after/")
      ) then
        vim.cmd("source " .. vim.fn.expand("%"))
        vim.notify("Sourced " .. vim.fn.expand("%"), vim.log.levels.INFO)
      else
        run_in_terminal("lua " .. vim.fn.expand("%"))
      end
    else
      vim.notify("No run command defined for filetype: " .. ft, vim.log.levels.WARN)
    end
  end, { desc = "Run file" })
end

function M.setup()
  -- Set up basic keybindings without plugin dependencies
  setup_core_mappings()
  
  -- Set up keybindings with plugin dependencies
  setup_telescope_mappings()
  setup_git_mappings()
  setup_lsp_mappings()
  setup_ide_mappings()
  
  -- Register which-key groups
  local which_key_ok, which_key = pcall(require, "which-key")
  if which_key_ok then
    -- Define groups using the new format
    local groups = {
      { "<leader>b", group = " Buffers" },
      { "<leader>f", group = " Find/Files" },
      { "<leader>w", group = " Windows" },
      { "<leader>t", group = " Terminal/Tabs" },
      { "<leader>g", group = " Git" },
      { "<leader>gh", group = "Hunks" },
      { "<leader>gc", group = "Conflicts" },
      { "<leader>l", group = " LSP" },
      { "<leader>lw", group = "Workspace" },
      { "<leader>e", group = " Explorer" },
      { "<leader>x", group = " Diagnostics" },
      { "<leader>a", group = " AI" },
    }
    
    -- Register all keymappings with which-key
    which_key.register(groups)
    which_key.register(all_mappings)
  else
    vim.notify("which-key.nvim not found, keybinding hints will be limited", vim.log.levels.DEBUG)
  end
end

-- Autocmd for applying LSP keybindings when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Apply LSP keybindings to the buffer
    for lhs, mapping in pairs(M.lsp_mappings) do
      local opts = {
        buffer = ev.buf,
        desc = mapping[2]
      }
      
      -- Extract the handler function
      local rhs = mapping[1]
      
      -- Set the buffer-specific mapping
      local mode = mapping.mode or "n"  -- Default to normal mode if not specified
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end,
})

return M
