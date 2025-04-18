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

  -- Structured keybinding documentation
  -- Note: the actual keybindings are defined in keybindings.lua
  -- This only provides documentation groups
  local opts = {
    mode = "n",        -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,      -- Global mappings
    silent = true,     -- Do not show command in command line
    noremap = true,    -- Non-recursive mappings
    nowait = true,     -- Do not wait for additional keys
  }

  -- Define top-level groups with colors and icons
  local groups = {
    -- File operations
    f = {
      name = key_icons.f .. "%{WhichKeyGroupFileOps}Files%*",
      f = { "Find file" },
      r = { "Recent files" },
      g = { "Live grep" },
      n = { "Neovim config" },
      e = { "File explorer" },
    },

    -- Git operations
    g = {
      name = key_icons.g .. "%{WhichKeyGroupGit}Git%*",
      g = { "Status" },
      b = { "Branches" },
      c = { "Commits" },
      s = { "Stage hunk" },
      u = { "Unstage hunk" },
      d = { "Diff" },
      j = { "Next hunk" },
      k = { "Prev hunk" },
      p = { "Preview hunk" },
      r = { "Reset hunk" },
      R = { "Reset buffer" },
      l = { "Blame line" },
      f = { "Git files" },
      t = { "Conflicts" },
    },

    -- LSP operations
    l = {
      name = key_icons.l .. "%{WhichKeyGroupLSP}LSP%*",
      a = { "Code action" },
      r = { "Rename symbol" },
      s = { "Document symbols" },
      d = { "Line diagnostics" },
      w = { "Workspace symbols" },
      f = { "Format document" },
      i = { "Incoming calls" },
      o = { "Outgoing calls" },
      R = { "References" },
      q = { "Diagnostics list" },
    },

    -- Search operations
    s = {
      name = key_icons.s .. "%{WhichKeyGroupSearch}Search%*",
      s = { "In buffer" },
      w = { "Word under cursor" },
      c = { "Command history" },
      k = { "Keymaps" },
      d = { "Diagnostics" },
    },

    -- Terminal operations
    t = {
      name = key_icons.t .. "%{WhichKeyGroupTerminal}Terminal%*",
      h = { "Horizontal terminal" },
      v = { "Vertical terminal" },
      f = { "Floating terminal" },
    },

    -- Buffer operations
    b = {
      name = key_icons.b .. "%{WhichKeyGroupBuffer}Buffers%*",
      n = { "Next buffer" },
      p = { "Previous buffer" },
      d = { "Delete buffer" },
      b = { "Switch buffer" },
    },

    -- Window operations
    w = {
      name = key_icons.w .. "%{WhichKeyGroupWindow}Windows%*",
      h = { "Go left" },
      j = { "Go down" },
      k = { "Go up" },
      l = { "Go right" },
      v = { "Split vertical" },
      s = { "Split horizontal" },
      q = { "Close window" },
      o = { "Close others" },
      ["="] = { "Equal size" },
      t = { "To new tab" },
    },

    -- Project operations
    p = {
      name = key_icons.p .. "%{WhichKeyGroupMisc}Project%*",
      p = { "Project list" },
      r = { "Run file" },
    },

    -- Tab operations
    ["t"] = {
      name = key_icons.w .. "%{WhichKeyGroupWindow}Tabs%*",
      n = { "Next tab" },
      p = { "Previous tab" },
      c = { "Close tab" },
      t = { "New tab" },
    },

    -- UI operations
    u = { key_icons.u .. "%{WhichKeyGroupMisc}Toggle undotree%*" },
    e = { key_icons.e .. "%{WhichKeyGroupFileOps}Toggle explorer%*" },
    o = { key_icons.e .. "%{WhichKeyGroupLSP}Toggle outline%*" },

    -- Diagnostics
    x = {
      name = key_icons.x .. "%{WhichKeyGroupMisc}Diagnostics%*",
      x = { "Toggle diagnostics" },
    },

    -- Database
    d = {
      name = key_icons.d .. "%{WhichKeyGroupMisc}Dev Tools%*",
      b = { "Database client" },
      c = { "Docker containers" },
    },

    -- HTTP client
    h = {
      name = key_icons.z .. "%{WhichKeyGroupMisc}HTTP%*",
      r = { "Run request" },
    },

    -- Quick commands
    q = { key_icons.z .. "%{WhichKeyGroupMisc}Quit all%*" },
    w = { key_icons.z .. "%{WhichKeyGroupFileOps}Save file%*" },
    h = { key_icons.z .. "%{WhichKeyGroupMisc}Clear highlights%*" },
  }

  -- Register the keymap documentation
  which_key.register(groups, opts)

  -- Also register the <C-h/j/k/l> mappings with which-key
  local window_nav = {
    ["<C-h>"] = { "Move to left window" },
    ["<C-j>"] = { "Move to bottom window" },
    ["<C-k>"] = { "Move to top window" },
    ["<C-l>"] = { "Move to right window" },
  }
  which_key.register(window_nav, { mode = "n" })
  
  -- Diagnostic navigation
  local diag_nav = {
    ["[d"] = "Previous diagnostic",
    ["]d"] = "Next diagnostic",
  }
  which_key.register(diag_nav, { mode = "n" })
  
  -- LSP navigation
  local lsp_nav = {
    ["gd"] = "Go to definition",
    ["gD"] = "Go to declaration",
    ["gr"] = "Find references",
    ["gi"] = "Go to implementation",
    ["K"] = "Show hover info",
  }
  which_key.register(lsp_nav, { mode = "n" })
end

return M
