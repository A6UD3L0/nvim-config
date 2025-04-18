-- Enhanced which-key configuration for improved keybinding discoverability
-- Features colored key groups, custom icons, and integrated help text

local M = {}

-- Color definitions for different command groups
local group_colors = {
  FileOps     = "#7DCFFF", -- File operations (light blue)
  Navigation  = "#BB9AF7", -- Navigation commands (purple)
  Search      = "#9ECE6A", -- Search commands (green)
  Buffer      = "#E0AF68", -- Buffer management (orange)
  Git         = "#F7768E", -- Git operations (red)
  LSP         = "#2AC3DE", -- LSP interactions (cyan)
  Terminal    = "#B4F9F8", -- Terminal commands (turquoise)
  Window      = "#41A6B5", -- Window management (teal)
  Debug       = "#FF9E64", -- Debugging operations (peach)
  Misc        = "#A9B1D6", -- Miscellaneous (light purple)
}

-- Icons for different command types to improve visual clarity
local key_icons = {
  f = " ", -- Files
  g = " ", -- Git
  l = " ", -- LSP/Code
  s = " ", -- Search
  t = " ", -- Terminal
  b = "󰓩 ", -- Buffer
  w = " ", -- Window
  r = " ", -- Run
  d = " ", -- Debug
  p = "󱧮 ", -- Project 
  u = " ", -- UI/Undo
  e = " ", -- Explorer
  x = " ", -- Diagnostics
  z = "󰔱 ", -- System
  a = "󰚩 ", -- AI
}

function M.setup()
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
      breadcrumb = "»", -- Symbol used for the hierarchy display
      separator = "➜", -- Symbol used between key and command
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
      winblend = 0,              -- Transparency
    },
    layout = {
      height = { min = 4, max = 25 },  -- Min and max height of the columns
      width = { min = 20, max = 50 },  -- Min and max width of the columns
      spacing = 3,                     -- Spacing between columns
      align = "center",                -- Alignment of columns
    },
    ignore_missing = true,           -- Hide mappings without labels
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

  -- Define key group highlights and symbols using the new format
  local keymap_groups = {
    -- Group definitions with consistent formatting
    { "<leader>f", group = key_icons.f .. "%{WhichKeyGroupFileOps}Files%*", nowait = true, silent = true },
    { "<leader>g", group = key_icons.g .. "%{WhichKeyGroupGit}Git%*", nowait = true, silent = true },
    { "<leader>gh", group = key_icons.g .. "Hunks", nowait = true, silent = true },
    { "<leader>gc", group = key_icons.g .. "Conflicts", nowait = true, silent = true },
    { "<leader>l", group = key_icons.l .. "%{WhichKeyGroupLSP}LSP%*", nowait = true, silent = true },
    { "<leader>lw", group = key_icons.l .. "Workspace", nowait = true, silent = true },
    { "<leader>b", group = key_icons.b .. "%{WhichKeyGroupBuffer}Buffers%*", nowait = true, silent = true },
    { "<leader>t", group = key_icons.t .. "%{WhichKeyGroupTerminal}Terminal%*", nowait = true, silent = true },
    { "<leader>w", group = key_icons.w .. "%{WhichKeyGroupWindow}Windows%*", nowait = true, silent = true },
    { "<leader>e", group = key_icons.e .. "%{WhichKeyGroupFileOps}Explorer%*", nowait = true, silent = true },
    { "<leader>x", group = key_icons.x .. "%{WhichKeyGroupDebug}Diagnostics%*", nowait = true, silent = true },
    { "<leader>a", group = key_icons.a .. "%{WhichKeyGroupMisc}AI%*", nowait = true, silent = true },
  }

  -- Register groups first to ensure proper categorization
  which_key.register(keymap_groups)
  
  -- Manually register some essential commands that might have conflicts
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
  }
  
  -- Register individual mappings
  which_key.register(special_mappings)
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
