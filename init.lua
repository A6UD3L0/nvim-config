-- Streamlined Neovim Configuration for Backend Development and Data Science
-- Based on ThePrimeagen's style with NvChad simplicity

-- Set leader key to space (must be before lazy bootstrap)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap and configure lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- UI Settings
vim.opt.termguicolors = true    -- True color support
vim.opt.background = "dark"     -- Dark background
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.showmode = false        -- Don't show mode, as it's in the statusline
vim.opt.title = true            -- Show file title in terminal title
vim.opt.splitbelow = true       -- Horizontal splits go below
vim.opt.splitright = true       -- Vertical splits go right
vim.opt.scrolloff = 10          -- Keep cursor 10 lines from screen edge
vim.opt.sidescrolloff = 8       -- Keep cursor 8 columns from screen edge
vim.opt.pumheight = 15          -- Maximum number of items to show in popup menu
vim.opt.pumblend = 10           -- Make popup menu semi-transparent
vim.opt.winblend = 10           -- Make floating windows semi-transparent

-- Editor settings
vim.opt.tabstop = 4             -- Number of spaces tabs count for
vim.opt.softtabstop = 4         -- Number of spaces in tab when editing
vim.opt.shiftwidth = 4          -- Number of spaces to use for autoindent
vim.opt.expandtab = true        -- Tabs are spaces
vim.opt.smartindent = true      -- Insert indents automatically
vim.opt.wrap = false            -- Disable line wrap
vim.opt.swapfile = false        -- Don't use swapfile
vim.opt.backup = false          -- Don't create backup files
vim.opt.undofile = true         -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Where to store undo history
vim.opt.updatetime = 50         -- Faster completion
vim.opt.colorcolumn = "80"      -- Show column marker at 80 characters
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Command line UI improvements
vim.opt.wildmenu = true         -- Command-line completion
vim.opt.wildmode = "longest:full,full" -- Complete till longest common string, then start wildmenu
vim.opt.cmdheight = 1           -- Command-line height
vim.opt.laststatus = 3          -- Global statusline
vim.opt.showmatch = true        -- Jump to matching bracket briefly

-- Better display of invisibles
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}

-- Better search experience
vim.opt.ignorecase = true       -- Ignore case in search
vim.opt.smartcase = true        -- Unless search has uppercase
vim.opt.incsearch = true        -- Show matches as you type
vim.opt.hlsearch = true         -- Highlight search results

-- Buffer settings
vim.opt.hidden = true           -- Allow switching from unsaved buffers
vim.opt.confirm = true          -- Confirm changes when exiting buffers
vim.opt.completeopt = "menuone,noselect" -- Better completion experience

-- Disable unused providers to remove health check warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Configure Python provider
if vim.fn.has('macunix') == 1 then
  -- macOS Python path
  vim.g.python3_host_prog = vim.fn.expand('~/.venvs/neovim/bin/python3')
elseif vim.fn.has('unix') == 1 then
  -- Linux Python path - adjust if needed
  vim.g.python3_host_prog = vim.fn.expand('~/.venvs/neovim/bin/python3')
elseif vim.fn.has('win32') == 1 then
  -- Windows Python path - adjust if needed
  vim.g.python3_host_prog = vim.fn.expand('~/AppData/Local/Programs/Python/Python39/python.exe')
end

-- Unset VIRTUAL_ENV to prevent the Python virtualenv warning
if vim.env.VIRTUAL_ENV then
  -- Store the original value in case we need it later
  vim.g.original_virtual_env = vim.env.VIRTUAL_ENV
  -- Unset it to avoid the warning
  vim.env.VIRTUAL_ENV = nil
end

-- Ensure data directories exist
local function ensure_dir(path)
  local stat = vim.loop.fs_stat(path)
  if not stat then
    vim.fn.mkdir(path, "p")
  end
end

-- Create necessary data directories
ensure_dir(vim.fn.stdpath("data") .. "/undodir")
ensure_dir(vim.fn.stdpath("data") .. "/backup")
ensure_dir(vim.fn.stdpath("data") .. "/swap")
ensure_dir(vim.fn.stdpath("data") .. "/shada")

-- Load mappings
require("mappings")

-- Load backend-essential configurations
local backend = require("backend-essentials")

-- Set up plugin management with Lazy
require("lazy").setup({
  -- Core plugins
  { import = "plugins" },
  
  -- Colorscheme with high priority to load first
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}, {
  -- Lazy.nvim configuration
  ui = {
    border = "rounded",  -- Make UI elements consistent
    size = { width = 0.8, height = 0.8 },
  },
  install = {
    colorscheme = { "catppuccin" },  -- Set fallback colorscheme
    missing = true,  -- Auto-install missing plugins
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  checker = {
    enabled = true,  -- Auto-check for plugin updates
    frequency = 86400,  -- Check once a day
  },
  change_detection = {
    notify = false,  -- Don't notify on config changes
  },
  spec = {
    { "luarocks", enabled = false },  -- Disable luarocks support
  },
})

-- Initialize backend development tools after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    -- Setup backend development features
    backend.setup_lsp()
    backend.setup_tools()
    backend.setup_debugging()
    
    -- Show message on first installation
    if vim.fn.filereadable(vim.fn.stdpath("config") .. "/.installed") == 0 then
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.defer_fn(function()
            vim.cmd([[
              echohl WarningMsg
              echo "Installation complete! Backend Development environment is ready."
              echohl None
            ]])
            vim.fn.writefile({}, vim.fn.stdpath("config") .. "/.installed")
          end, 1000)
        end,
        once = true,
      })
    end
  end,
})

-- Set up auto commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go", "c", "cpp", "sql", "dockerfile", "yaml", "json" },
  callback = function()
    -- Set appropriate indent for backend languages
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    
    -- Special settings for specific filetypes
    if vim.bo.filetype == "go" then
      vim.opt_local.expandtab = false
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
    elseif vim.bo.filetype == "python" then
      vim.opt_local.colorcolumn = "88" -- Black formatter uses 88 characters
    end
  end,
})

-- Ensure terminal opens in the bottom center
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})
