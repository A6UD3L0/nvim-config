-- Nvim Configuration: Robust Backend Development Environment
-- Implements a layered architecture with MECE (Mutually Exclusive, Collectively Exhaustive) modules
-- Optimized for performance, stability, and maintainability

-- ╭──────────────────────────────────────────────────────────╮
-- │                   Bootstrap Functions                     │
-- ╰──────────────────────────────────────────────────────────╯

-- Display startup errors in a user-friendly way
local function display_error(msg, level)
  level = level or vim.log.levels.ERROR
  local formatted_msg = string.format("Initialization Error: %s", msg)
  
  -- Use vanilla vim.notify during startup, as other notifiers might not be available
  if vim.notify then
    vim.notify(formatted_msg, level)
  else
    print(formatted_msg)
  end
end

-- Create necessary directories for configuration storage
local function ensure_dir(dir)
  local is_dir = vim.fn.isdirectory(dir)
  if is_dir == 0 then
    local success, err = pcall(vim.fn.mkdir, dir, "p")
    if not success then
      display_error(string.format("Failed to create directory %s: %s", dir, err))
      return false
    end
  end
  return true
end

-- Setup core directories for data persistence
local function setup_core_directories()
  -- Define critical paths
  local data_path = vim.fn.stdpath("data")
  local config_path = vim.fn.stdpath("config")
  local paths = {
    undo = data_path .. "/undo",
    swap = data_path .. "/swap",
    backup = data_path .. "/backup",
    shada = data_path .. "/shada",
    sessions = data_path .. "/sessions",
    state = data_path .. "/state",
    logs = config_path .. "/logs",
  }
  
  -- Create each directory
  for name, path in pairs(paths) do
    if not ensure_dir(path) then
      display_error("Failed to create " .. name .. " directory at " .. path)
    end
  end
end

-- Initialize core settings before plugins load
local function init_core_settings()
  -- Speed up loading
  if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then
    vim.loader.enable()
  end
  
  -- Essential vim options (others will be set by core.settings)
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  vim.opt.termguicolors = true
  vim.opt.mouse = "a"
  vim.opt.clipboard = "unnamedplus"
  
  -- Faster macros
  vim.opt.lazyredraw = true
  
  -- Set up directories
  vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
  vim.opt.directory = vim.fn.stdpath("data") .. "/swap"
  vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
  vim.opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"
  
  -- Enable persistent undo
  vim.opt.undofile = true
end

-- Setup lazy.nvim plugin manager
local function setup_plugins()
  -- Plugin loading options
  local lazy_opts = {
    defaults = {
      lazy = true,  -- Load most plugins on-demand
    },
    install = {
      colorscheme = { "tokyonight", "dracula", "habamax" },
    },
    checker = {
      enabled = true,  -- Auto-check for plugin updates
      notify = false,  -- Don't notify about updates
      frequency = 3600, -- Check once per hour
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      border = "rounded",
    },
  }
  
  -- Bootstrap lazy.nvim if not installed
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    display_error("lazy.nvim not found, installing...")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  
  -- Load plugins from modules using lazy.nvim
  local status_ok, lazy = pcall(require, "lazy")
  if not status_ok then
    display_error("Failed to load lazy.nvim. Plugin loading aborted.")
    return false
  end
  
  -- Load plugin specs from plugins.lua
  local plugin_specs_ok, plugin_specs = pcall(require, "plugins")
  if not plugin_specs_ok then
    display_error("Failed to load plugin specifications: " .. plugin_specs)
    return false
  end
  
  -- Initialize lazy.nvim
  lazy.setup(plugin_specs, lazy_opts)
  
  return true
end

-- Initialize the core configuration system
local function setup_core()
  local status_ok, core = pcall(require, "core")
  if not status_ok then
    display_error("Failed to load core configuration system: " .. core)
    return false
  end
  
  -- Initialize core components
  local init_ok, err = pcall(core.init)
  if not init_ok then
    display_error("Failed to initialize core configuration system: " .. err)
    return false
  end
  
  return true
end

-- Main initialization function
local function initialize()
  -- 1. Set up critical directories first
  setup_core_directories()
  
  -- 2. Initialize core settings
  init_core_settings()
  
  -- 3. Load plugins
  if not setup_plugins() then
    display_error("Plugin initialization failed. Continuing with limited functionality.")
  end
  
  -- 4. Initialize core configuration system
  if not setup_core() then
    display_error("Core configuration system initialization failed. Falling back to basic functionality.")
  end
  
  -- Log initialization success
  vim.notify("Initialization complete! 🚀", vim.log.levels.INFO)
end

-- Execute initialization with protected call
local ok, err = pcall(initialize)
if not ok then
  display_error("Initialization failed: " .. err)
end
