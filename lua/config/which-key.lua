-- Enhanced which-key configuration for improved keybinding discoverability
-- Follows MECE principles (Mutually Exclusive, Collectively Exhaustive)
-- Features colored key groups, custom icons, and integrated help text

local M = {}

-- Color definitions for different command groups - each has its own distinct highlight
local group_colors = {
  Find        = "#9ECE6A", -- Find/Search operations (green)
  Git         = "#F7768E", -- Git operations (red)
  LSP         = "#2AC3DE", -- LSP interactions (cyan)
  Buffer      = "#E0AF68", -- Buffer management (orange)
  Terminal    = "#B4F9F8", -- Terminal commands (turquoise)
  Window      = "#41A6B5", -- Window management (teal)
  Explorer    = "#7DCFFF", -- File explorer (light blue)
  Diagnostic  = "#FF9E64", -- Diagnostics & debug (peach)
  AI          = "#BB9AF7", -- AI assistance (purple)
  Navigation  = "#C678DD", -- Navigation & marks (magenta)
  Zen         = "#ABB2BF", -- Zen & focus (light gray)
  Utility     = "#56B6C2", -- Utility & tools (blue-green)
  Keymaps     = "#E06C75", -- Keybinding & help (red-pink)
  Project     = "#98C379", -- Project management (bright green)
  Run         = "#D19A66", -- Run & test (amber)
  Code        = "#61AFEF", -- Code actions (bright blue)
  Substitute  = "#E5C07B", -- Substitute & replace (yellow)
  Quickfix    = "#E06C75", -- Quickfix & lists (red)
  Markdown    = "#66D9EF", -- Markdown & docs (light blue-green)
  Data        = "#8BE9FD", -- Data science & DB (light blue)
  Yank        = "#F7DC6F", -- Yank & clipboard (yellow)
  Venv        = "#8F0A1A", -- Python Venv (dark red)
}

-- Descriptive icons for better visual clarity and categorization
local key_icons = {
  f = "", -- Find/Search
  g = "", -- Git
  l = "", -- LSP
  b = "", -- Buffer
  t = "", -- Terminal
  w = "", -- Window
  e = "", -- Explorer
  x = "", -- Diagnostics 
  a = "", -- AI/Assist
  h = "", -- Marks
  z = "", -- Zen/Focus
  u = "", -- Undo/Utility
  k = "", -- Keymaps
  p = "", -- Project
  r = "", -- Run/Test
  c = "", -- Code Actions
  s = "", -- Substitute
  q = "", -- Quickfix
  m = "", -- Markdown
  d = "", -- Data
  y = "", -- Yank
  v = "", -- Venv
}

function M.setup()
  -- Set timeoutlen for responsive which-key appearance
  vim.opt.timeout = true
  vim.opt.timeoutlen = 250  -- Faster which-key response (250ms)
  
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("which-key not found. Key guide will not be available.", vim.log.levels.WARN)
    return
  end

  -- Create highlights for each group
  for group_name, color in pairs(group_colors) do
    vim.api.nvim_set_hl(0, "WhichKeyGroup" .. group_name, { fg = color, bold = true })
  end

  -- Configure which-key
  which_key.setup({
    plugins = {
      marks = true,       -- Displays a list of your marks on ' and `
      registers = true,   -- Displays your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,   -- Enabling this will show which-key when pressing z= to select spelling suggestions
        suggestions = 20, -- How many suggestions to show
      },
      -- The presets plugin provides help text for motions, registers, operators, text objects, etc.
      presets = {
        operators = true,    -- Adds help for operators like d, y, ...
        motions = true,      -- Adds help for motions
        text_objects = true, -- Adds help for text objects triggered after entering an operator
        windows = true,      -- Adds help for default bindings on <c-w>
        nav = true,          -- Adds help for navigation (C-f/b, C-d/u, etc)
        z = true,            -- Adds help for folds, spelling, and marks
        g = true,            -- Adds help for g prefixed commands
      },
    },
    icons = {
      breadcrumb = "", -- Symbol used for the hierarchy display
      separator = "", -- Symbol used between key and command
      group = "+",     -- Symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    window = {
      border = "rounded",        -- Border style for the which-key window
      position = "bottom",       -- Window position
      margin = { 1, 0, 1, 0 },   -- Extra window margin
      padding = { 1, 2, 1, 2 },  -- Extra window padding
      winblend = 0,              -- No transparency for better readability
    },
    layout = {
      height = { min = 4, max = 25 },  -- Min and max height of the columns
      width = { min = 20, max = 50 },  -- Min and max width of the columns
      spacing = 3,                     -- Spacing between columns
      align = "center",                -- Alignment of columns
    },
    ignore_missing = false,          -- Show mappings even without labels
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- Hide from the popup
    show_help = true,                -- Show help message on the command line when the popup is visible
    show_keys = true,                -- Show keys in the help line
    triggers = "auto",               -- Automatically setup triggers
    triggers_blacklist = {
      i = { "j", "k" },             -- List of prefixes to ignore
      v = { "j", "k" },
    },
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  })

  -- ==== MECE KEY GROUP ORGANIZATION ====
  -- Primary namespaces with consistent and intuitive naming
  which_key.register({
    ["<leader>f"] = { name = key_icons.f .. "%{WhichKeyGroupFind}Find & Search%*" },
    ["<leader>g"] = { name = key_icons.g .. "%{WhichKeyGroupGit}Git & VCS%*" },
    ["<leader>l"] = { name = key_icons.l .. "%{WhichKeyGroupLSP}LSP & Lang%*" },
    ["<leader>b"] = { name = key_icons.b .. "%{WhichKeyGroupBuffer}Buffers & Tabs%*" },
    ["<leader>t"] = { name = key_icons.t .. "%{WhichKeyGroupTerminal}Terminal & Shell%*" },
    ["<leader>w"] = { name = key_icons.w .. "%{WhichKeyGroupWindow}Windows & Splits%*" },
    ["<leader>e"] = { name = key_icons.e .. "%{WhichKeyGroupExplorer}Explorer & Files%*" },
    ["<leader>x"] = { name = key_icons.x .. "%{WhichKeyGroupDiagnostic}Diagnostics & Trouble%*" },
    ["<leader>a"] = { name = key_icons.a .. "%{WhichKeyGroupAI}AI & Assist%*" },
    ["<leader>h"] = { name = key_icons.h .. "%{WhichKeyGroupNavigation}Marks & Harpoon%*" },
    ["<leader>z"] = { name = key_icons.z .. "%{WhichKeyGroupZen}Zen & Focus%*" },
    ["<leader>u"] = { name = key_icons.u .. "%{WhichKeyGroupUtility}Utilities & Undo%*" },
    ["<leader>k"] = { name = key_icons.k .. "%{WhichKeyGroupKeymaps}Keymaps & Help%*" },
    ["<leader>p"] = { name = key_icons.p .. "%{WhichKeyGroupProject}Project & Session%*" },
    ["<leader>pu"] = { name = key_icons.p .. "UV: Install Python deps" },
    ["<leader>pv"] = { name = key_icons.p .. "UV: Create venv" },
    ["<leader>pa"] = { name = key_icons.p .. "UV: Add package under cursor" },
    ["<leader>pr"] = { name = key_icons.p .. "UV: Remove package under cursor" },
    ["<leader>ps"] = { name = key_icons.p .. "UV: Sync environment" },
    ["<leader>pt"] = { name = key_icons.p .. "UV: List packages" },
    ["<leader>pl"] = { name = key_icons.p .. "UV: List venvs" },
    ["<leader>pd"] = { name = key_icons.p .. "UV: Destroy current venv" },
    ["<leader>r"] = { name = key_icons.r .. "%{WhichKeyGroupRun}Run, Test & REPL%*" },
    ["<leader>c"] = { name = key_icons.c .. "%{WhichKeyGroupCode}Code Actions & Refactor%*" },
    ["<leader>s"] = { name = key_icons.s .. "%{WhichKeyGroupSubstitute}Substitute, Sort & Stats%*" },
    ["<leader>q"] = { name = key_icons.q .. "%{WhichKeyGroupQuickfix}Quickfix & Quit%*" },
    ["<leader>m"] = { name = key_icons.m .. "%{WhichKeyGroupMarkdown}Markdown & Docs%*" },
    ["<leader>d"] = { name = key_icons.d .. "%{WhichKeyGroupData}Data Science & DB%*" },
    ["<leader>y"] = { name = key_icons.y .. "%{WhichKeyGroupYank}Yank & Clipboard%*" },
    ["<leader>v"] = { name = key_icons.v .. "%{WhichKeyGroupVenv}Python Venv%*" },
    ["<leader>?"] = { name = "Show All Keymaps" },
  }, { mode = "n", prefix = "<leader>" })

  -- Sub-group definitions for better organization
  which_key.register({
    ["<leader>gh"] = { name = key_icons.g .. "Git Hunks" },
    ["<leader>gc"] = { name = key_icons.g .. "Git Conflicts" },
    ["<leader>lw"] = { name = key_icons.l .. "Workspace" },
  }, { mode = "n" })

  -- Manually register essential commands that might have conflicts
  local special_mappings = {
    -- Git commands (avoiding duplicate gs/gr)
    { "<leader>gs", desc = "Stage hunk", nowait = true, silent = true },
    { "<leader>gr", desc = "Reset hunk", nowait = true, silent = true },
    { "<leader>gl", desc = "Git log/blame", nowait = true, silent = true },
    { "<leader>gd", desc = "Git diff", nowait = true, silent = true },

    -- Explorer (avoiding e vs er/ef confusion)
    { "<leader>ef", desc = "Find in file explorer", nowait = true, silent = true },
    { "<leader>er", desc = "Refresh file explorer", nowait = true, silent = true },
    { "<leader>e", desc = "Toggle file explorer", nowait = true, silent = true },

    -- Diagnostic commands
    { "<leader>xx", desc = "Toggle diagnostics", nowait = true, silent = true },
    { "<leader>xd", desc = "Document diagnostics", nowait = true, silent = true },
    { "<leader>xw", desc = "Workspace diagnostics", nowait = true, silent = true },

    -- File commands
    { "<leader>ff", desc = "Find files", nowait = true, silent = true },
    { "<leader>fg", desc = "Live grep", nowait = true, silent = true },
    { "<leader>fr", desc = "Recent files", nowait = true, silent = true },

    -- AI commands
    { "<leader>ac", desc = "Copilot panel", nowait = true, silent = true },
    { "<leader>ae", desc = "Enable AI", nowait = true, silent = true },
    { "<leader>ai", desc = "AI chat", nowait = true, silent = true },

    -- Show all keymaps with leader ?
    { "<leader>?", desc = "Show all keymaps (cheatsheet)", nowait = true, silent = true },
  }

  -- Register individual mappings
  which_key.register(special_mappings)

  -- Show all keymaps with <leader>?
  vim.keymap.set("n", "<leader>?", function()
    which_key.show("", {mode = "n", auto = true})
  end, { desc = "Show all keymaps (cheatsheet)" })

  -- Visual mode keymaps
  which_key.register({
    ["<leader>y"] = { '"+y', "Yank to system clipboard" },
    ["<leader>d"] = { '"_d', "Delete to void register" },
    ["<leader>p"] = { '"_dP', "Paste without overwriting register" },
    ["J"] = { ":m '>+1<CR>gv=gv", "Move selected lines down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move selected lines up" },
  }, { mode = "v" })

  -- Insert mode: escape with jk
  which_key.register({
    ["jk"] = { "<ESC>", "Exit insert mode" },
  }, { mode = "i" })

  -- Ensure leader key is always mapped (no accidental spacebar insert)
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
end

-- Helper function to apply which-key to buffer-specific LSP bindings
function M.apply_lsp_buffer_mappings(client, bufnr)
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then return end

  -- Get capabilities to determine available features
  local caps = client.server_capabilities

  -- LSP-specific keybindings for this buffer
  local mappings = {
    { "<leader>lf", desc = "Format document", buffer = bufnr, nowait = true, silent = true },
    { "<leader>lr", desc = "Rename symbol", buffer = bufnr, nowait = true, silent = true },
    { "<leader>la", desc = "Code action", buffer = bufnr, nowait = true, silent = true },
    { "<leader>ld", desc = "Go to definition", buffer = bufnr, nowait = true, silent = true },
    { "<leader>lh", desc = "Hover documentation", buffer = bufnr, nowait = true, silent = true },
    { "<leader>ls", desc = "Signature help", buffer = bufnr, nowait = true, silent = true },
    { "<leader>li", desc = "Go to implementation", buffer = bufnr, nowait = true, silent = true },
  }

  -- Only register what the server supports
  local filtered_mappings = {}

  for _, mapping in ipairs(mappings) do
    -- Skip registration based on missing capabilities
    if mapping[1] == "<leader>lf" and not caps.documentFormattingProvider then
      -- Skip format mapping
    elseif mapping[1] == "<leader>lr" and not caps.renameProvider then
      -- Skip rename mapping
    elseif mapping[1] == "<leader>la" and not caps.codeActionProvider then
      -- Skip code action mapping
    elseif mapping[1] == "<leader>ld" and not caps.definitionProvider then
      -- Skip definition mapping
    elseif mapping[1] == "<leader>li" and not caps.implementationProvider then
      -- Skip implementation mapping
    else
      -- This capability is supported, register the mapping
      table.insert(filtered_mappings, mapping)
    end
  end

  -- Register key mappings for this buffer
  which_key.register(filtered_mappings)
end

return M
