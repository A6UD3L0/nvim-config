-- Core Settings Manager Module
-- Provides centralized configuration with validation and defaults
-- Modules can import this to access consistent settings

local M = {}

-- Default settings with documentation
M.defaults = {
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
    termguicolors = true,         -- Enable 24-bit RGB colors
    background = "dark",          -- Color scheme background
    colorscheme = "tokyonight",   -- Default color scheme
    
    -- Interface elements
    cmdheight = 1,                -- Command line height
    pumheight = 10,               -- Popup menu max height
    laststatus = 3,               -- Global statusline
    showtabline = 1,              -- Show tabline only if >1 tab
    signcolumn = "yes",           -- Always show sign column
    showmode = false,             -- Don't show mode in command line
    shortmess = "filnxtToOFc",    -- Shorten messages in command line
    
    -- Split behavior
    splitbelow = true,            -- Horizontal splits go below
    splitright = true,            -- Vertical splits go right
    
    -- Visual aids
    ruler = false,                -- Hide ruler (position info)
    showmatch = true,             -- Highlight matching brackets
    list = true,                  -- Show invisible characters
    listchars = "tab:› ,trail:•,extends:»,precedes:«,nbsp:␣",
    conceallevel = 0,             -- Text is shown normally
    concealcursor = "",           -- Never conceal cursor line
    
    -- Cursor customization
    guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
  },
  
  -- Performance settings
  performance = {
    -- Redraw and updates
    updatetime = 250,             -- Faster completion and highlighting
    timeoutlen = 300,             -- Faster key sequence completion
    ttimeoutlen = 10,             -- Very fast timeout for terminal codes
    redrawtime = 1500,            -- Max time for syntax highlighting
    ttyfast = true,               -- Smoother redrawing
    lazyredraw = true,            -- Don't redraw during macros
    
    -- File limits
    maxfile = 10 * 1024 * 1024,   -- Max file size before optimizations
  },
  
  -- LSP settings
  lsp = {
    -- General LSP behavior
    automatic_installation = true, -- Auto-install LSP servers
    format_on_save = true,         -- Format code on save
    virtual_text = true,           -- Show diagnostics as virtual text
    float_border = "rounded",      -- Border style for floating windows
    
    -- Python-specific settings
    python = {
      formatter = "black",         -- Default Python formatter
      linter = "ruff",             -- Default Python linter
      type_checker = "pyright",    -- Default Python type checker
    },
    
    -- Web development settings
    web = {
      formatter = "prettier",      -- Default web formatter
      linter = "eslint",           -- Default web linter
    },
  },
  
  -- Python tools settings
  python = {
    -- uv.nvim settings
    uv = {
      enabled = true,              -- Enable uv.nvim integration
      auto_venv_activation = true, -- Auto-activate virtual environments
      auto_install_requirements = false, -- Auto-install from requirements.txt
    },
    
    -- Virtual environment settings
    venv = {
      auto_create = false,         -- Auto-create venv for new projects
      path = ".venv",              -- Default venv directory name
      always_create_global = false, -- Create global venv if not found
    },
  },
  
  -- Keybinding settings
  keybindings = {
    leader = " ",                  -- Leader key
    localleader = ",",             -- Local leader key
    timeout = 300,                 -- Timeout for key sequences
    which_key_delay = 200,         -- Delay before showing which-key
    icons = true,                  -- Use icons in which-key
    
    -- Keybinding style
    use_traditional = false,       -- Use Vim traditional bindings
    enhanced_navigation = true,    -- Use enhanced navigation keys
  },
}

-- User settings (loaded from config)
M.user = {}

-- Merged settings (defaults + user)
M.current = vim.deepcopy(M.defaults)

-- Load user settings from a file
function M.load_user_settings()
  local config_path = vim.fn.stdpath("config") .. "/user_settings.lua"
  
  -- Check if user settings file exists
  if vim.fn.filereadable(config_path) == 1 then
    local status_ok, user_settings = pcall(dofile, config_path)
    if status_ok and type(user_settings) == "table" then
      M.user = user_settings
      -- Merge user settings into current settings
      M.current = vim.tbl_deep_extend("force", M.defaults, M.user)
      return true
    else
      vim.notify("Failed to load user settings from " .. config_path, vim.log.levels.ERROR)
    end
  end
  
  return false
end

-- Get a setting with validation
function M.get(path, default)
  -- Parse the path (e.g., "editor.tabstop")
  local parts = vim.split(path, ".", { plain = true })
  local current = M.current
  
  -- Traverse the settings table
  for i = 1, #parts - 1 do
    current = current[parts[i]]
    if current == nil then
      if default ~= nil then
        return default
      else
        -- Return the default from the defaults table if possible
        local default_value = M.defaults
        for j = 1, #parts do
          default_value = default_value[parts[j]]
          if default_value == nil then
            break
          end
          
          if j == #parts then
            return default_value
          end
        end
        
        return nil
      end
    end
  end
  
  -- Get the final value
  local value = current[parts[#parts]]
  if value == nil then
    if default ~= nil then
      return default
    else
      -- Try to get from defaults
      local default_value = M.defaults
      for j = 1, #parts do
        default_value = default_value[parts[j]]
        if default_value == nil then
          break
        end
      end
      
      return default_value
    end
  end
  
  return value
end

-- Set a setting with validation
function M.set(path, value)
  -- Parse the path (e.g., "editor.tabstop")
  local parts = vim.split(path, ".", { plain = true })
  local current = M.current
  
  -- Traverse and create tables as needed
  for i = 1, #parts - 1 do
    if current[parts[i]] == nil then
      current[parts[i]] = {}
    end
    current = current[parts[i]]
  end
  
  -- Set the value
  current[parts[#parts]] = value
  
  -- Update the vim option if it corresponds to one
  local vim_opt_map = {
    ["editor.number"] = "number",
    ["editor.relativenumber"] = "relativenumber",
    ["editor.cursorline"] = "cursorline",
    ["editor.cursorcolumn"] = "cursorcolumn",
    ["editor.wrap"] = "wrap",
    ["editor.tabstop"] = "tabstop",
    ["editor.shiftwidth"] = "shiftwidth",
    ["editor.expandtab"] = "expandtab",
    ["ui.background"] = "background",
    ["ui.signcolumn"] = "signcolumn",
    -- Add more mappings as needed
  }
  
  if vim_opt_map[path] then
    vim.opt[vim_opt_map[path]] = value
  end
  
  return true
end

-- Apply core settings from the settings manager
function M.apply_settings()
  -- Editor settings
  for name, value in pairs(M.current.editor) do
    -- Skip settings that shouldn't be directly applied
    if name ~= "clipboard" then -- Handle clipboard specially
      pcall(function() vim.opt[name] = value end)
    end
  end
  
  -- Handle clipboard specially due to different OS requirements
  if M.current.editor.clipboard == "unnamedplus" and vim.fn.has("unnamedplus") == 1 then
    vim.opt.clipboard = "unnamedplus"
  elseif M.current.editor.clipboard ~= "" then
    vim.opt.clipboard = "unnamed"
  end
  
  -- UI settings
  for name, value in pairs(M.current.ui) do
    -- Skip applying colorscheme directly
    if name ~= "colorscheme" then
      pcall(function() vim.opt[name] = value end)
    end
  end
  
  -- Apply colorscheme
  if M.current.ui.colorscheme and M.current.ui.colorscheme ~= "" then
    pcall(vim.cmd, "colorscheme " .. M.current.ui.colorscheme)
  end
  
  -- Performance settings
  for name, value in pairs(M.current.performance) do
    if name ~= "maxfile" then -- maxfile is not a vim option
      pcall(function() vim.opt[name] = value end)
    end
  end
  
  -- Apply keybinding settings
  vim.g.mapleader = M.current.keybindings.leader
  vim.g.maplocalleader = M.current.keybindings.localleader
  vim.opt.timeoutlen = M.current.keybindings.timeout
  
  -- Set up large file handling
  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(args)
      local max_filesize = M.current.performance.maxfile
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
  
  return true
end

-- Save user settings to a file
function M.save_user_settings()
  local config_path = vim.fn.stdpath("config") .. "/user_settings.lua"
  
  -- Serialize settings table to Lua code
  local lines = { "-- User Settings" }
  table.insert(lines, "-- This file is auto-generated. Modify settings through the API.")
  table.insert(lines, "return {")
  
  -- Helper function to serialize a table
  local function serialize_table(tbl, indent)
    indent = indent or 2
    local result = {}
    
    for k, v in pairs(tbl) do
      local key = type(k) == "number" and "[" .. k .. "]" or k
      
      if type(v) == "table" then
        table.insert(result, string.rep(" ", indent) .. key .. " = {")
        local nested = serialize_table(v, indent + 2)
        for _, line in ipairs(nested) do
          table.insert(result, line)
        end
        table.insert(result, string.rep(" ", indent) .. "},")
      elseif type(v) == "string" then
        table.insert(result, string.rep(" ", indent) .. key .. ' = "' .. v .. '",')
      elseif type(v) == "boolean" or type(v) == "number" or v == nil then
        table.insert(result, string.rep(" ", indent) .. key .. " = " .. tostring(v) .. ",")
      end
    end
    
    return result
  end
  
  -- Serialize user settings
  local serialized = serialize_table(M.user)
  for _, line in ipairs(serialized) do
    table.insert(lines, line)
  end
  
  table.insert(lines, "}")
  
  -- Write to file
  vim.fn.writefile(lines, config_path)
  
  return true
end

-- Initialize settings
function M.setup()
  -- Load user settings
  M.load_user_settings()
  
  -- Apply settings
  M.apply_settings()
  
  -- Set up autocmd to save settings on exit
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      M.save_user_settings()
    end,
    group = vim.api.nvim_create_augroup("SettingsSave", { clear = true }),
  })
  
  return true
end

return M
