-- Core Settings Module
-- Implements robust Neovim configuration with fallbacks and optimizations
-- Following MECE (Mutually Exclusive, Collectively Exhaustive) principles

local M = {}

-- ╭──────────────────────────────────────────────────────────╮
-- │                   Performance Tuning                      │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_performance()
  -- Use JIT compilation for LuaJIT when available
  if jit and jit.version then
    jit.on()
  end
  
  -- Reduce expensive operations frequency for a more responsive experience
  vim.opt.updatetime = 250        -- Faster completion and highlighting
  vim.opt.timeoutlen = 300        -- Faster key sequence completion
  vim.opt.ttimeoutlen = 10        -- Very fast timeout for terminal key codes
  vim.opt.redrawtime = 1500       -- Max time spent redrawing syntax highlighting
  vim.opt.ttyfast = true          -- Smoother redrawing
  
  -- Buffer-specific performance optimizations
  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(args)
      -- Skip syntax highlighting for very large files
      local max_filesize = 10 * 1024 * 1024 -- 10MB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
      if ok and stats and stats.size > max_filesize then
        vim.notify("Large file detected, reducing features for better performance", vim.log.levels.INFO)
        vim.cmd("syntax off")
        vim.bo[args.buf].foldmethod = "manual"
        vim.bo[args.buf].swapfile = false
        vim.bo[args.buf].undolevels = -1
        vim.opt_local.spell = false
        vim.opt_local.list = false
      end
    end
  })
  
  -- Smarter gitsigns handling for large files
  vim.g.gitsigns_timeout = 5000              -- 5 seconds instead of default 400ms
  vim.g.gitsigns_max_file_length = 100000    -- Increased max file size
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                      Editor Behavior                      │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_editor()
  -- Line numbers and cursor
  vim.opt.number = true           -- Show line numbers
  vim.opt.relativenumber = true   -- Show relative line numbers
  vim.opt.cursorline = true       -- Highlight current line
  
  -- Input handling
  vim.opt.mouse = "a"             -- Enable mouse support in all modes
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
  
  -- Text handling
  vim.opt.smartcase = true        -- Smart case searching
  vim.opt.ignorecase = true       -- Ignore case in searches
  vim.opt.smartindent = true      -- Smart autoindenting
  vim.opt.autoindent = true       -- Continue indentation from previous line
  vim.opt.expandtab = true        -- Use spaces instead of tabs
  vim.opt.shiftwidth = 2          -- Number of spaces for indentation
  vim.opt.tabstop = 2             -- Number of spaces for tab
  vim.opt.shiftround = true       -- Round indent to multiples of shiftwidth
  
  -- Session/history management
  vim.opt.undofile = true         -- Persistent undo
  vim.opt.undolevels = 10000      -- More undo levels
  vim.opt.backup = false          -- No backup files
  vim.opt.writebackup = false     -- No backup files
  
  -- Completion settings
  vim.opt.completeopt = { "menuone", "noselect" } -- Better completion experience
  vim.opt.pumheight = 10          -- Maximum popup menu height
  vim.opt.pumblend = 10           -- Make popup menu semi-transparent
  
  -- Search behavior
  vim.opt.hlsearch = true         -- Highlight search results
  vim.opt.incsearch = true        -- Show matches as you type
  vim.opt.inccommand = "split"    -- Preview substitutions in a split
  
  -- Backend dev optimizations
  vim.opt.fileformats = "unix,mac,dos" -- Order of EOL format detection
  vim.opt.hidden = true           -- Allow unsaved buffers in background
  
  -- Terminal
  vim.opt.title = true            -- Show filename in terminal title
  vim.opt.titlestring = "%<%F - nvim" -- Format of title
  
  -- Ensure no unintended keys break out of insert mode
  vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        UI Settings                        │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_ui()
  -- Colors and visuals
  vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
  vim.opt.background = "dark"     -- Set dark mode
  vim.opt.syntax = "on"           -- Enable syntax highlighting
  
  -- Text display
  vim.opt.wrap = false            -- Don't wrap lines
  vim.opt.breakindent = true      -- When wrapping is enabled, indent wrapped lines
  vim.opt.showbreak = "↪ "        -- Show indicator for wrapped lines
  vim.opt.linebreak = true        -- Break lines at word boundaries
  
  -- Editor UI
  vim.opt.scrolloff = 10          -- Minimum lines to keep above/below cursor
  vim.opt.sidescrolloff = 8       -- Minimum columns to keep left/right of cursor
  vim.opt.showmode = false        -- Don't show mode in cmdline (use statusline)
  vim.opt.showcmd = true          -- Show partial command in last line
  vim.opt.cmdheight = 1           -- Height of command line
  vim.opt.laststatus = 3          -- Global statusline
  vim.opt.signcolumn = "yes"      -- Always show sign column
  vim.opt.colorcolumn = "100"     -- Highlight column 100 for code width guideline
  vim.opt.splitbelow = true       -- Horizontal splits go below
  vim.opt.splitright = true       -- Vertical splits go right
  
  -- List chars for whitespace visualization
  vim.opt.list = true
  vim.opt.listchars = {
    tab = "» ",
    lead = "·",
    trail = "·",
    extends = "⟩",
    precedes = "⟨",
    nbsp = "␣",
  }
  
  -- Folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldlevelstart = 99     -- Open all folds by default
  
  -- Enhanced window borders
  vim.opt.fillchars = {
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vert = "│",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
    fold = "·",
    eob = " ", -- No ~ for empty lines
    diff = "╱",
    msgsep = "‾",
    foldsep = "│",
    foldopen = "▾",
    foldclose = "▸",
  }
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                    System Integration                     │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_system()
  -- Support macOS specific features
  if vim.fn.has("mac") == 1 then
    -- Exclude macOS system directories that often cause issues
    vim.opt.wildignore:append {
      "*/Library/Calendars/*",
      "*/Library/Reminders/*",
      "*/Library/CloudStorage/*",
      "*/node_modules/*",
      "*/.git/*",
      "*/vendor/*",
      "*/.DS_Store",
    }
    
    -- Fix shell issues on macOS
    if vim.fn.executable("zsh") == 1 then
      vim.opt.shell = "zsh"
    end
  end
  
  -- Shell command enhancements
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellredir = ">%s 2>&1"
  
  -- Python provider - prioritize virtual environment if active
  if vim.env.VIRTUAL_ENV then
    vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. "/bin/python"
  elseif vim.fn.executable("python3") == 1 then
    vim.g.python3_host_prog = vim.fn.exepath("python3")
  end
  
  -- Disable providers not used for backend development
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                     Error Protection                      │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_protection()
  -- Create important directories if missing
  local function ensure_dir(dir)
    local is_dir = vim.fn.isdirectory(dir)
    if is_dir == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end
  
  -- Set up backup, swap, and undo history storage
  local data_path = vim.fn.stdpath("data")
  
  local backup_dir = data_path .. "/backup"
  local swap_dir = data_path .. "/swap"
  local undo_dir = data_path .. "/undo"
  
  ensure_dir(backup_dir)
  ensure_dir(swap_dir)
  ensure_dir(undo_dir)
  
  -- Set directory locations
  vim.opt.backupdir = backup_dir
  vim.opt.directory = swap_dir 
  vim.opt.undodir = undo_dir
  
  -- Disable shada for sensitive files
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = {
      "*.gpg",
      "*.kdbx",
      "*/.ssh/config",
      "*/credentials.*",
      "*/.aws/credentials",
      "*/id_rsa",
      "*/id_rsa.pub",
      "*/.htpasswd",
      "*/.env",
      "*/.npmrc",
      "*/authorized_keys",
    },
    callback = function()
      vim.opt_local.swapfile = false
      vim.opt_local.backup = false
      vim.opt_local.writebackup = false 
      vim.opt_local.undofile = false
      vim.opt_local.shada = ""
    end
  })
  
  -- Auto-save before losing focus
  vim.api.nvim_create_autocmd("FocusLost", {
    command = "silent! wall",
    pattern = "*"
  })
  
  -- Automatically return to last edit position
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local line_count = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                 Backend Development Setup                 │
-- ╰──────────────────────────────────────────────────────────╯
local function setup_dev_environment()
  -- Create autocmd group for development settings
  local dev_group = vim.api.nvim_create_augroup("BackendDevelopment", { clear = true })
  
  -- Language-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    group = dev_group,
    pattern = { "python", "go", "c", "cpp", "sql", "dockerfile", "yaml", "json" },
    callback = function()
      -- Common settings for backend languages
      vim.opt_local.expandtab = true
      
      -- Language-specific settings
      if vim.bo.filetype == "go" then
        vim.opt_local.expandtab = false 
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
      elseif vim.bo.filetype == "python" then
        vim.opt_local.colorcolumn = "88" -- Black formatter uses 88 characters
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
      elseif vim.bo.filetype == "json" or vim.bo.filetype == "yaml" then
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
      end
    end
  })
  
  -- Auto-formatting settings
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = dev_group,
    callback = function()
      -- Check if formatter exists before trying to format
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = false, lsp_fallback = true, timeout_ms = 500 })
      end
    end
  })
  
  -- Terminal settings
  vim.api.nvim_create_autocmd("TermOpen", {
    group = dev_group,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.cursorline = false
      vim.cmd("startinsert")
    end
  })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                   Settings Initialization                 │
-- ╰──────────────────────────────────────────────────────────╯
function M.setup()
  -- Apply settings in a specific order
  setup_performance()
  setup_editor()
  setup_ui()
  setup_system()
  setup_protection()
  setup_dev_environment()
  
  -- Global variables
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  
  -- Create global command to reload settings
  vim.api.nvim_create_user_command("ReloadSettings", function()
    -- Reload this module
    package.loaded["settings"] = nil
    require("settings").setup()
    vim.notify("Settings reloaded!", vim.log.levels.INFO)
  end, {})
  
  return true
end

-- Initialize settings
M.setup()

return M
