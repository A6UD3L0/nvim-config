-- Core Settings Manager Module
-- Provides centralized configuration with validation and defaults
-- Modules can import this to access consistent settings

local M = {}

-- Default settings with documentation
M.defaults = {
  -- Performance tuning
  performance = {
    updatetime = 250,             -- Faster completion and highlighting
    timeoutlen = 300,             -- Faster key sequence completion
    ttimeoutlen = 10,             -- Very fast timeout for terminal key codes
    redrawtime = 1500,            -- Max time spent redrawing syntax highlighting
    ttyfast = true,               -- Smoother redrawing
    lazyredraw = true,            -- Don't redraw during macros
    showcmd = true,               -- Show partial command in last line
    hidden = true,                -- Allow switching buffers without saving
  },
  
  -- Editor behavior
  editor = {
    -- Line numbers and cursor
    number = true,                -- Show line numbers
    relativenumber = true,        -- Show relative line numbers
    cursorline = true,            -- Highlight current line
    cursorcolumn = false,         -- Highlight current column
    scrolloff = 8,                -- Keep 8 lines above/below cursor
    sidescrolloff = 8,            -- Keep 8 columns left/right of cursor
    
    -- Line wrapping and indentation
    wrap = false,                 -- Don't wrap lines by default
    breakindent = true,           -- Wrapped lines preserve indentation
    linebreak = true,             -- Break lines at word boundaries
    smartindent = true,           -- Auto indent new lines
    expandtab = true,             -- Use spaces instead of tabs
    tabstop = 2,                  -- Tab width in spaces
    shiftwidth = 2,               -- Indentation width in spaces
    softtabstop = 2,              -- Tab width when editing
    
    -- Search behavior
    ignorecase = true,            -- Case-insensitive search
    smartcase = true,             -- Case-sensitive if uppercase present
    hlsearch = true,              -- Highlight search results
    incsearch = true,             -- Highlight matches while typing
    
    -- File handling
    autoread = true,              -- Auto reload changed files
    autowrite = true,             -- Auto save before commands like :next
    hidden = true,                -- Keep modified buffers in background
    confirm = true,               -- Ask confirmation for unsaved changes
    
    -- History and sessions
    history = 1000,               -- Number of commands to remember
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal",
    
    -- Clipboard integration
    clipboard = "unnamedplus",    -- Use system clipboard
  },
  
  -- UI settings
  ui = {
    -- Colors and visuals
    termguicolors = true,         -- Use GUI colors in terminal
    background = "dark",          -- Dark background
    showmode = false,             -- Don't show mode in command line
    showtabline = 2,              -- Always show the tab line
    laststatus = 3,               -- Global status line
    signcolumn = "yes",           -- Always show sign column
    
    -- Visual cues
    list = true,                  -- Show whitespace characters
    listchars = "tab:» ,trail:·,extends:›,precedes:‹,nbsp:␣",
    
    -- UI elements
    cmdheight = 1,                -- Command line height
    pumheight = 10,               -- Max items in completion menu
    showmatch = true,             -- Highlight matching brackets
    matchtime = 2,                -- Blink time for matching brackets
    
    -- File backups
    backup = false,               -- Don't keep backup files
    writebackup = false,          -- Don't make backup before overwriting
    swapfile = false,             -- Don't use swap files
    undofile = true,              -- Persistent undo history
    
    -- Theme preferences
    transparency = false,         -- Window transparency
    theme = "tokyonight",         -- Default theme
  },
  
  -- System directories
  directories = {
    undo_dir = "~/.local/share/nvim/undo",  -- Persistent undo history
    backup_dir = "~/.local/share/nvim/backup", -- Backup files
    swap_dir = "~/.local/share/nvim/swap",  -- Swap files
  },
  
  -- LSP settings
  lsp = {
    -- Diagnostics display
    diagnostics = {
      virtual_text = true,        -- Show diagnostics as virtual text
      underline = true,           -- Underline code with issues
      update_in_insert = false,   -- Don't update diagnostics in insert mode
      severity_sort = true,       -- Sort by severity
      float = {
        border = "rounded",       -- Bordered floating windows
        source = "always",        -- Always show source
      },
    },
    
    -- Completion settings
    completion = {
      enabled = true,             -- Enable LSP completion
      autocomplete = true,        -- Automatically show completion menu
      keyword_length = 2,         -- Min chars to trigger completion
    },
    
    -- Formatting
    format_on_save = true,        -- Format on save
    format_timeout = 1000,        -- Formatting timeout in ms
    
    -- Navigation
    code_lens = true,             -- Enable code lens refreshing
    signature_help = true,        -- Show signature help
    inlay_hints = false,          -- Show inlay hints
  },
  
  -- Python settings
  python = {
    -- uv.nvim settings
    uv = {
      enabled = true,              -- Enable uv.nvim integration
      auto_venv_activation = true, -- Auto-activate virtual environments
      default_venv_path = ".venv", -- Default venv path
      auto_pip_install = true,     -- Auto install Python dependencies
    },
    
    -- Linting and formatting
    linting = {
      enabled = true,              -- Enable linting
      tool = "ruff",               -- Default linter: ruff
    },
    
    formatting = {
      enabled = true,              -- Enable formatting
      tool = "black",              -- Default formatter: black
    },
    
    -- Testing
    testing = {
      enabled = true,              -- Enable test running
      framework = "pytest",        -- Default test framework
      auto_discovery = true,       -- Auto-discover tests
    },
  },
  
  -- Keybinding preferences
  keybindings = {
    leader = " ",                 -- Space as leader key
    timeout = 300,                -- Timeout for key sequences
    which_key = {
      popup_mappings = {
        scroll_down = "<c-d>",    -- Scroll down in which-key popup
        scroll_up = "<c-u>",      -- Scroll up in which-key popup
      },
      window = {
        border = "rounded",       -- Border style
        padding = { 1, 1, 1, 1 }, -- Window padding
      },
      layout = {
        spacing = 6,              -- Spacing between columns
      },
    },
  },
}

-- User settings (loaded from config)
M.user = {}

-- Current settings (merged defaults and user settings)
M.current = {}

-- Merge user settings with defaults
function M.merge_settings()
  -- Create a deep copy of defaults
  M.current = vim.deepcopy(M.defaults)
  
  -- Merge with user settings
  local schema = require("core.schema")
  for section, values in pairs(M.user) do
    if type(values) == "table" and type(M.defaults[section]) == "table" then
      -- Validate section against schema if available
      if schema.schemas[section] then
        local valid, err = schema.validate(values, schema.schemas[section])
        if not valid then
          vim.notify("Invalid settings in section '" .. section .. "': " .. err, vim.log.levels.WARN)
        end
      end
      
      -- Merge valid sections
      M.current[section] = vim.tbl_deep_extend("force", M.current[section] or {}, values)
    else
      -- For non-table values, just overwrite
      M.current[section] = values
    end
  end
  
  -- Call any post-processing functions after merge
  M.post_process_settings()
  
  return M.current
end

-- Post-process merged settings
function M.post_process_settings()
  -- Example: Convert relative paths to absolute
  if M.current.directories then
    for name, path in pairs(M.current.directories) do
      if type(path) == "string" and path:sub(1, 1) == "~" then
        M.current.directories[name] = vim.fn.expand(path)
      end
    end
  end
end

-- Load user settings from user configuration
function M.load_user_settings()
  -- Try to load user configuration
  local ok, user_config = pcall(require, "user.settings")
  if ok and type(user_config) == "table" then
    M.user = user_config
    vim.notify("Loaded user settings", vim.log.levels.DEBUG)
  else
    vim.notify("No user settings found, using defaults", vim.log.levels.DEBUG)
  end
  
  -- Merge with defaults
  return M.merge_settings()
end

-- Apply settings to Neovim
function M.apply_settings()
  -- Performance settings
  for name, value in pairs(M.current.performance) do
    vim.opt[name] = value
  end
  
  -- Editor settings
  for name, value in pairs(M.current.editor) do
    -- Skip settings that shouldn't be directly applied
    if name ~= "clipboard" then -- Handle clipboard specially
      vim.opt[name] = value
    end
  end
  
  -- Clipboard integration requires special handling
  if M.current.editor.clipboard then
    vim.opt.clipboard = M.current.editor.clipboard
  end
  
  -- UI settings
  for name, value in pairs(M.current.ui) do
    -- Skip special values like theme
    if name ~= "theme" and name ~= "transparency" then
      vim.opt[name] = value
    end
  end
  
  -- Apply theme if specified
  if M.current.ui.theme and M.current.ui.theme ~= "" then
    -- Will be applied by the theme plugin later
    vim.g.theme = M.current.ui.theme
  end
  
  -- Create and set directories
  for name, path in pairs(M.current.directories) do
    -- Ensure directory exists
    local dir_exists = vim.fn.isdirectory(path)
    if dir_exists == 0 then
      local success = vim.fn.mkdir(path, "p")
      if success == 0 then
        vim.notify("Failed to create directory: " .. path, vim.log.levels.WARN)
      end
    end
    
    -- Set corresponding Vim option if applicable
    if name == "undo_dir" then
      vim.opt.undodir = path
    elseif name == "backup_dir" then
      vim.opt.backupdir = path
    elseif name == "swap_dir" then
      vim.opt.directory = path
    end
  end
  
  -- Set leader key
  if M.current.keybindings and M.current.keybindings.leader then
    vim.g.mapleader = M.current.keybindings.leader
    vim.g.maplocalleader = M.current.keybindings.leader
  end
  
  -- Apply LSP diagnostic settings
  if M.current.lsp and M.current.lsp.diagnostics then
    vim.diagnostic.config(M.current.lsp.diagnostics)
  end
  
  -- Enable JIT compilation for LuaJIT when available
  if jit and jit.version then
    jit.on()
  end
  
  vim.notify("Applied settings", vim.log.levels.DEBUG)
  return true
end

-- Initialize settings
function M.setup()
  M.load_user_settings()
  M.apply_settings()
  
  -- Return settings for other modules to use
  return M.current
end

return M
