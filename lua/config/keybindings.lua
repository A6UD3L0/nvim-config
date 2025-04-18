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
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  opts.silent = opts.silent == nil and true or opts.silent
  
  if type(rhs) == "string" then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  
  -- Track leader mappings for which-key
  if lhs:match("^<leader>") and opts.desc then
    local prefix = lhs:match("^<leader>(.)")
    local suffix = lhs:match("^<leader>.(.*)") or ""
    
    -- Create nested tables as needed
    if not all_mappings[prefix] then
      all_mappings[prefix] = {}
    end
    
    -- Store mapping for which-key
    if suffix == "" then
      all_mappings[prefix][suffix] = { mode = mode, desc = opts.desc }
    else
      all_mappings[prefix][suffix] = { mode = mode, desc = opts.desc }
    end
  end
end

-- Plugin availability checker
local function has_plugin(plugin_name)
  return pcall(require, plugin_name)
end

-- External tool availability checker
local function command_exists(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if not handle then return false end
  
  local result = handle:read("*a")
  handle:close()
  return result and #result > 0
end

-- Check if a module setup function exists
local function has_module(module_name)
  local ok, mod = pcall(require, module_name)
  return ok and mod and type(mod.setup) == "function"
end

-- Run command in terminal (if toggleterm is available)
local function run_in_terminal(cmd, direction)
  direction = direction or "horizontal"
  
  -- First try using our terminal module
  if has_module("config.terminal") then
    local term = require("config.terminal")
    if term.run_command then
      term.run_command(cmd)
      return true
    end
  end
  
  -- Fallback to direct toggleterm use
  local toggleterm_ok, toggleterm = has_plugin("toggleterm.terminal")
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
  
  -- Tab navigation
  map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
  map("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
  map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
  map("n", "<leader>tt", ":tabnew<CR>", { desc = "New tab" })
  
  -- ThePrimeagen's best remaps
  map("n", "<C-d>", "<C-d>zz", { desc = "Move down half-page and center" })
  map("n", "<C-u>", "<C-u>zz", { desc = "Move up half-page and center" })
  map("n", "n", "nzzzv", { desc = "Next search result and center" })
  map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
  
  -- Quick save
  map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
  
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
  
  -- Quick command mode
  map("n", ";", ":", { desc = "Enter command mode" })
  
  -- Quick quit
  map("n", "<leader>q", ":qa<CR>", { desc = "Quit all" })
end

local function setup_telescope_mappings()
  if not has_plugin("telescope") then
    vim.notify("Telescope not available, file search mappings disabled", vim.log.levels.WARN)
    return
  end

  -- Telescope file pickers
  map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
  map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
  map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
  map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
  map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })
  map("n", "<leader>fn", function() require("telescope.builtin").find_files({cwd = vim.fn.stdpath("config")}) end, { desc = "Find in Neovim config" })
  
  -- Telescope git pickers
  map("n", "<leader>gc", function() require("telescope.builtin").git_commits() end, { desc = "Git commits" })
  map("n", "<leader>gb", function() require("telescope.builtin").git_branches() end, { desc = "Git branches" })
  map("n", "<leader>gs", function() require("telescope.builtin").git_status() end, { desc = "Git status" })
  map("n", "<leader>gf", function() require("telescope.builtin").git_files() end, { desc = "Git files" })
  
  -- Telescope search pickers
  map("n", "<leader>sw", function() require("telescope.builtin").grep_string() end, { desc = "Search word under cursor" })
  map("n", "<leader>sc", function() require("telescope.builtin").command_history() end, { desc = "Command history" })
  map("n", "<leader>sk", function() require("telescope.builtin").keymaps() end, { desc = "Keymaps" })
  map("n", "<leader>ss", function() require("telescope.builtin").current_buffer_fuzzy_find() end, { desc = "Search in current buffer" })
  map("n", "<leader>sd", function() require("telescope.builtin").diagnostics() end, { desc = "Diagnostics" })
  
  -- File browser if available
  local has_file_browser = has_plugin("telescope") and require("telescope").extensions.file_browser ~= nil
  if has_file_browser then
    map("n", "<leader>fe", function() require("telescope").extensions.file_browser.file_browser() end, { desc = "File browser" })
  end
end

local function setup_git_mappings()
  -- Git keybindings that gracefully fallback
  
  -- Try fugitive first, then lazygit, then fallback to git command
  map("n", "<leader>gg", function()
    if has_plugin("vim-fugitive") then
      vim.cmd("Git")
    elseif has_plugin("lazygit.nvim") then
      vim.cmd("LazyGit")
    elseif command_exists("lazygit") then
      run_in_terminal("lazygit")
    else
      vim.notify("No Git UI available. Install vim-fugitive, lazygit.nvim, or lazygit CLI", vim.log.levels.WARN)
    end
  end, { desc = "Git status" })
  
  -- Gitsigns mappings (with fallbacks)
  local function setup_gitsigns_mappings()
    map("n", "<leader>gj", function()
      if has_plugin("gitsigns") then
        require("gitsigns").next_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Next git hunk" })
    
    map("n", "<leader>gk", function()
      if has_plugin("gitsigns") then
        require("gitsigns").prev_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Previous git hunk" })
    
    map("n", "<leader>gl", function()
      if has_plugin("gitsigns") then
        require("gitsigns").blame_line()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Git blame line" })
    
    map("n", "<leader>gp", function()
      if has_plugin("gitsigns") then
        require("gitsigns").preview_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Preview git hunk" })
    
    map("n", "<leader>gr", function()
      if has_plugin("gitsigns") then
        require("gitsigns").reset_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Reset git hunk" })
    
    map("n", "<leader>gR", function()
      if has_plugin("gitsigns") then
        require("gitsigns").reset_buffer()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Reset git buffer" })
    
    map("n", "<leader>gs", function()
      if has_plugin("gitsigns") then
        require("gitsigns").stage_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Stage git hunk" })
    
    map("n", "<leader>gu", function()
      if has_plugin("gitsigns") then
        require("gitsigns").undo_stage_hunk()
      else
        vim.notify("Gitsigns not available", vim.log.levels.WARN)
      end
    end, { desc = "Undo stage git hunk" })
  end
  
  setup_gitsigns_mappings()
  
  -- Git diff view
  map("n", "<leader>gd", function()
    if has_plugin("diffview") then
      vim.cmd("DiffviewOpen")
    elseif has_plugin("vim-fugitive") then
      vim.cmd("Gdiff")
    else
      vim.notify("No diff view plugin available", vim.log.levels.WARN)
    end
  end, { desc = "Git diff" })
  
  -- Git conflict resolution
  map("n", "<leader>gt", function()
    if has_plugin("git-conflict") then
      vim.cmd("GitConflictListQf")
    else
      vim.notify("Git-conflict plugin not available", vim.log.levels.WARN)
    end
  end, { desc = "List git conflicts" })
end

local function setup_lsp_mappings()
  -- These will be applied by an autocmd when LSP attaches to a buffer
  -- Stored here for organization and which-key registration
  
  M.lsp_mappings = {
    normal = {
      ["gD"] = { function() vim.lsp.buf.declaration() end, "Go to declaration" },
      ["gd"] = { function() vim.lsp.buf.definition() end, "Go to definition" },
      ["K"] = { function() vim.lsp.buf.hover() end, "Show hover info" },
      ["gi"] = { function() vim.lsp.buf.implementation() end, "Go to implementation" },
      ["<C-k>"] = { function() vim.lsp.buf.signature_help() end, "Show signature help" },
      ["<leader>la"] = { function() vim.lsp.buf.code_action() end, "Code actions" },
      ["<leader>lr"] = { function() vim.lsp.buf.rename() end, "Rename symbol" },
      ["<leader>lf"] = { function() vim.lsp.buf.format() end, "Format document" },
      ["<leader>li"] = { function() vim.lsp.buf.incoming_calls() end, "Incoming calls" },
      ["<leader>lo"] = { function() vim.lsp.buf.outgoing_calls() end, "Outgoing calls" },
      ["<leader>ls"] = { function() vim.lsp.buf.document_symbol() end, "Document symbols" },
      ["<leader>lw"] = { function() vim.lsp.buf.workspace_symbol() end, "Workspace symbols" },
      ["<leader>ld"] = { function() vim.diagnostic.open_float() end, "Line diagnostics" },
      ["[d"] = { function() vim.diagnostic.goto_prev() end, "Previous diagnostic" },
      ["]d"] = { function() vim.diagnostic.goto_next() end, "Next diagnostic" },
      ["<leader>lq"] = { function() vim.diagnostic.setloclist() end, "Set loc list" },
      ["<leader>lR"] = { function() vim.lsp.buf.references() end, "Find references" },
    },
  }
  
  -- Register with which-key (if available)
  for mode, mode_mappings in pairs(M.lsp_mappings) do
    for key, mapping in pairs(mode_mappings) do
      -- Don't set these now - they'll be set on LSP attach
      -- But do register them with which-key
      if key:match("^<leader>") and mapping[2] then
        local prefix = key:match("^<leader>(.)")
        local suffix = key:match("^<leader>.(.*)") or ""
        
        if prefix and not all_mappings[prefix] then
          all_mappings[prefix] = {}
        end
        
        if prefix then
          all_mappings[prefix][suffix] = { mode = mode, desc = mapping[2] }
        end
      end
    end
  end
end

local function setup_terminal_mappings()
  -- Defer to terminal module if available
  if has_module("config.terminal") then
    -- Let the terminal module set up its own keybindings
    return
  end
  
  -- Terminal keybindings with function checks
  -- Toggle a horizontal terminal
  map("n", "<leader>th", function()
    if has_plugin("toggleterm") then
      local term = require("toggleterm.terminal").Terminal:new({ direction = "horizontal" })
      term:toggle()
    else
      -- Fallback to basic terminal
      vim.cmd("split | terminal")
      vim.cmd("startinsert")
    end
  end, { desc = "Toggle horizontal terminal" })
  
  -- Toggle a vertical terminal
  map("n", "<leader>tv", function()
    if has_plugin("toggleterm") then
      local term = require("toggleterm.terminal").Terminal:new({ direction = "vertical" })
      term:toggle()
    else
      -- Fallback to basic terminal
      vim.cmd("vsplit | terminal")
      vim.cmd("startinsert")
    end
  end, { desc = "Toggle vertical terminal" })
  
  -- Toggle a floating terminal
  map("n", "<leader>tf", function()
    if has_plugin("toggleterm") then
      local term = require("toggleterm.terminal").Terminal:new({ direction = "float" })
      term:toggle()
    else
      -- Fallback to basic terminal
      vim.cmd("terminal")
      vim.cmd("startinsert")
    end
  end, { desc = "Toggle floating terminal" })
  
  -- Terminal navigation
  map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal" })
  map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window from terminal" })
  map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window from terminal" })
  map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window from terminal" })
end

local function setup_ide_mappings()
  -- IDE-like features with graceful fallbacks
  
  -- File explorer
  map("n", "<leader>e", function()
    if has_plugin("nvim-tree") then
      vim.cmd("NvimTreeToggle")
    elseif has_plugin("neo-tree") then
      vim.cmd("Neotree toggle")
    elseif vim.fn.exists(":Lexplore") == 2 then
      vim.cmd("Lexplore")
    else
      vim.cmd("Explore")
    end
  end, { desc = "Toggle file explorer" })
  
  -- Document outline/symbols
  map("n", "<leader>o", function()
    if has_plugin("aerial") then
      vim.cmd("AerialToggle")
    elseif has_plugin("symbols-outline") then
      vim.cmd("SymbolsOutline")
    elseif has_plugin("vista") then
      vim.cmd("Vista!!")
    elseif has_plugin("telescope") then
      require("telescope.builtin").lsp_document_symbols()
    else
      vim.notify("No outline plugin available", vim.log.levels.WARN)
    end
  end, { desc = "Toggle document outline" })
  
  -- Diagnostics
  map("n", "<leader>xx", function()
    if has_plugin("trouble") then
      vim.cmd("TroubleToggle")
    else
      vim.diagnostic.setloclist()
    end
  end, { desc = "Toggle diagnostics panel" })
  
  -- UndoTree - defer to module if available
  if not has_module("config.undotree") then
    map("n", "<leader>u", function()
      if vim.fn.exists(":UndotreeToggle") == 2 then
        vim.cmd("UndotreeToggle")
      else
        vim.notify("UndoTree not available", vim.log.levels.WARN)
      end
    end, { desc = "Toggle undo tree" })
  end
  
  -- Project view - defer to module if available
  if not has_module("config.project") then
    map("n", "<leader>pp", function()
      if has_plugin("telescope") and require("telescope").extensions.projects then
        require("telescope").extensions.projects.projects({})
      else
        vim.notify("Projects plugin not available", vim.log.levels.WARN)
      end
    end, { desc = "Project list" })
  end
end

local function setup_backend_dev_mappings()
  -- Backend development specific keybindings
  
  -- Python specific mappings - defer to module if available
  if not has_module("config.python") then
    map("n", "<leader>pr", function()
      local file = vim.fn.expand("%:p")
      if vim.bo.filetype ~= "python" then
        vim.notify("Not a Python file", vim.log.levels.WARN)
        return
      end
      
      local cmd = "python " .. file
      run_in_terminal(cmd)
    end, { desc = "Run Python file" })
  end
  
  -- Database client
  map("n", "<leader>db", function()
    local clients = {
      { name = "PostgreSQL", cmd = "psql" },
      { name = "MySQL", cmd = "mysql" },
      { name = "SQLite", cmd = "sqlite3" },
      { name = "MongoDB", cmd = "mongosh" },
    }
    
    local available = {}
    for _, client in ipairs(clients) do
      if command_exists(client.cmd) then
        table.insert(available, client)
      end
    end
    
    if #available == 0 then
      vim.notify("No database clients available", vim.log.levels.WARN)
      return
    elseif #available == 1 then
      run_in_terminal(available[1].cmd)
    else
      vim.ui.select(
        vim.tbl_map(function(c) return c.name end, available),
        { prompt = "Select database client:" },
        function(choice, idx)
          if not choice then return end
          run_in_terminal(available[idx].cmd)
        end
      )
    end
  end, { desc = "Database client" })
  
  -- Docker
  map("n", "<leader>dc", function()
    if command_exists("docker") then
      run_in_terminal("docker ps")
    else
      vim.notify("Docker not available", vim.log.levels.WARN)
    end
  end, { desc = "Docker containers" })
  
  -- HTTP client
  map("n", "<leader>hr", function()
    if has_plugin("rest.nvim") then
      vim.cmd("RestRun")
    else
      vim.notify("REST client not available", vim.log.levels.WARN)
    end
  end, { desc = "Run HTTP request" })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                 Main Setup Function                       │
-- ╰──────────────────────────────────────────────────────────╯

function M.setup()
  -- Set up basic keybindings without plugin dependencies
  setup_core_mappings()
  
  -- Set up keybindings with plugin dependencies
  setup_telescope_mappings()
  setup_git_mappings()
  setup_lsp_mappings()
  setup_terminal_mappings()
  setup_ide_mappings()
  setup_backend_dev_mappings()
  
  -- Set up which-key integration
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    -- Merge all collected mappings into which-key format
    local wk_mappings = {}
    
    for prefix, mappings in pairs(all_mappings) do
      -- Create group name for the prefix
      wk_mappings["<leader>" .. prefix] = { 
        name = "+" .. prefix:upper() .. "-commands",
      }
      
      -- Register individual mappings
      for key, mapping in pairs(mappings) do
        if key ~= "" then -- Skip the group itself
          wk_mappings["<leader>" .. prefix .. key] = { 
            mapping.desc,
            mode = mapping.mode 
          }
        end
      end
    end
    
    -- Register with which-key
    wk.register(wk_mappings)
  end
  
  -- LSP on_attach setup
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      
      -- Apply LSP mappings to this buffer
      if M.lsp_mappings and M.lsp_mappings.normal then
        for key, mapping in pairs(M.lsp_mappings.normal) do
          vim.keymap.set("n", key, mapping[1], { buffer = bufnr, desc = mapping[2] })
        end
      end
    end,
  })
  
  return true
end

-- Store LSP keymaps for on_attach
M.get_lsp_mappings = function()
  return M.lsp_mappings
end

return M
