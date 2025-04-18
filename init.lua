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
  local paths = {
    undo = data_path .. "/undo",
    swap = data_path .. "/swap",
    backup = data_path .. "/backup",
    shada = data_path .. "/shada",
    sessions = data_path .. "/sessions",
    state = data_path .. "/state",
  }
  
  -- Create each directory
  for name, path in pairs(paths) do
    if not ensure_dir(path) then
      display_error(string.format("Failed to create %s directory at %s", name, path))
    end
  end
end

-- Initialize core system settings before plugins
local function init_core_settings()
  -- Load settings module with error handling
  local ok, settings = pcall(require, "settings")
  if not ok then
    display_error("Failed to load settings module. Using minimal defaults.")
    -- Apply critical settings as a fallback
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    vim.opt.termguicolors = true
    vim.opt.number = true
  end
end

-- Bootstrap the plugin manager
local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  
  -- Check if lazy.nvim exists and install if not
  if not vim.loop.fs_stat(lazypath) then
    display_error("Lazy.nvim not found. Installing...", vim.log.levels.INFO)
    
    local success, res = pcall(vim.fn.system, {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
    
    if not success then
      display_error("Failed to install lazy.nvim: " .. vim.inspect(res))
      return false
    end
  end
  
  -- Add lazy.nvim to runtime path
  vim.opt.rtp:prepend(lazypath)
  return true
end

-- Configure plugin loading with layered approach
local function setup_plugins()
  -- Plugin loading options
  local lazy_opts = {
    defaults = {
      lazy = true,  -- Load most plugins on-demand
    },
    performance = {
      cache = {
        enabled = true,
      },
      reset_packpath = true, -- Improves plugin load time
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
    ui = {
      border = "rounded",
      icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🔑",
        plugin = "🔌",
        runtime = "💻",
        require = "🌙",
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤 ",
      },
    },
    install = {
      missing = true,
      colorscheme = { "tokyonight", "rose-pine", "habamax" },
    },
    change_detection = {
      notify = false, -- Don't notify on config changes
    },
  }

  -- Load plugins with error handling
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    display_error("Failed to load lazy.nvim. Operating in minimal mode.")
    return false
  end

  -- Try to load plugins with graceful fallbacks
  local setup_success = pcall(function()
    lazy.setup({
      { import = "plugins" },          -- Core plugins
    }, lazy_opts)
  end)

  -- If the full plugin setup fails, try loading essentials
  if not setup_success then
    display_error("Main plugin loading failed. Attempting to load UI plugins only.", vim.log.levels.WARN)
    
    pcall(function()
      lazy.setup({
        { import = "plugins.ui" },     -- Try to at least get a nice UI
      }, lazy_opts)
    end)
    
    -- Apply a default colorscheme as a last resort
    if not pcall(vim.cmd, "colorscheme tokyonight") then
      vim.cmd("colorscheme habamax")   -- Habamax is built into Neovim
    end
    
    return false
  end
  
  return true
end

-- Initialize configurations for core components
local function setup_modules()
  -- Define all config modules in one place
  local modules = {
    -- Core modules
    { name = "config.keybindings", desc = "Keybinding manager" },
    { name = "config.which-key", desc = "Which-key UI" },
    { name = "config.lsp", desc = "LSP and completion" },
    { name = "config.search", desc = "Search functionality" },
    
    -- Tool modules
    { name = "config.git", desc = "Git integration" },
    { name = "config.terminal", desc = "Terminal integration" },
    { name = "config.undotree", desc = "Change visualization" },
    { name = "config.project", desc = "Project management" },
    { name = "config.time-tracking", desc = "Time tracking features" },
  }
  
  -- Track failed modules for reporting
  local failed_modules = {}
  
  -- Load each module with proper error handling
  for _, module in ipairs(modules) do
    pcall(function()
      local mod_ok, mod = pcall(require, module.name)
      if mod_ok and mod.setup then
        local setup_ok, err = pcall(mod.setup)
        if not setup_ok then
          table.insert(failed_modules, { name = module.name, desc = module.desc, error = err })
        end
      else
        table.insert(failed_modules, { name = module.name, desc = module.desc, error = "Module not found or no setup function" })
      end
    end)
  end
  
  -- Report any failures after startup is complete
  if #failed_modules > 0 then
    vim.defer_fn(function()
      local failed_list = ""
      for _, fail in ipairs(failed_modules) do
        failed_list = failed_list .. "\n- " .. fail.desc .. " (" .. fail.name .. "): " .. tostring(fail.error)
      end
      
      display_error("Some features failed to initialize:" .. failed_list, vim.log.levels.WARN)
    end, 1000) -- Delay error display to avoid interrupting startup
  end
end

-- Function to check and install missing dependencies
local function check_dependencies()
  -- Check for critical external dependencies
  local dependencies = {
    git = "Git is required for plugin management",
    rg = "Ripgrep is recommended for faster searching",
  }
  
  local missing = {}
  for cmd, message in pairs(dependencies) do
    if vim.fn.executable(cmd) == 0 then
      table.insert(missing, cmd .. ": " .. message)
    end
  end
  
  if #missing > 0 then
    vim.defer_fn(function()
      display_error("Missing dependencies:\n- " .. table.concat(missing, "\n- "), vim.log.levels.WARN)
    end, 2000)
  end
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                  Main Initialization                      │
-- ╰──────────────────────────────────────────────────────────╯

-- Record startup time
local startup_time = vim.loop.hrtime()

-- 1. Set up critical directories first
setup_core_directories()

-- 2. Initialize core settings
init_core_settings()

-- 3. Bootstrap plugin manager and setup plugins
if bootstrap_lazy() then
  setup_plugins()
  
  -- Apply colorscheme
  pcall(vim.cmd, "colorscheme tokyonight")
end

-- 4. Set up all modules (config and functionality)
setup_modules()

-- 5. Check for external dependencies
check_dependencies()

-- 6. Report startup time (when profiling enabled)
vim.defer_fn(function()
  local elapsed = (vim.loop.hrtime() - startup_time) / 1000000
  if vim.env.NVIM_PROFILE == "1" then
    vim.notify(string.format("Nvim started in %.2f ms", elapsed), vim.log.levels.INFO)
  end
end, 3000)

-- Create a command to reinitialize settings
vim.api.nvim_create_user_command("Reinit", function()
  init_core_settings()
  setup_modules()
  vim.notify("Configuration reinitialized", vim.log.levels.INFO)
end, {})
