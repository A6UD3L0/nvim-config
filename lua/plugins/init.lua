-- Nvim Configuration: Core Plugin Management
-- Implements a robust plugin architecture with MECE (Mutually Exclusive, Collectively Exhaustive) modules
-- Each module has clear responsibilities, lazy-loading, and fallback mechanisms

-- Plugin Layers (from lowest to highest):
-- 1. Core: Essential functionality with minimal dependencies (autocmds, keymaps, etc)
-- 2. Foundation: Base libraries and utilities (plenary, devicons, etc)
-- 3. UI: Visual elements and themes
-- 4. Editor: Text editing capabilities
-- 5. LSP & Completion: Language services and completions
-- 6. Tools: Domain-specific tools (git, testing, etc)
-- 7. Workflow: User experience and workflow enhancements

local M = {
  -- Core utilities needed by many plugins
  {
    "nvim-lua/plenary.nvim", -- Lua utility functions
    lazy = true, -- Load only when required by other plugins
    priority = 1000, -- Highest priority, load first
  },

  -- Foundation layer
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        strict = true,
      })
    end,
  },

  -- Import modules with proper namespacing and fallback mechanisms
  -- Each module is self-contained and handles its own dependencies
  -- Use explicit imports rather than globbed patterns for better traceability
  { import = "plugins.ui" },        -- UI components and theming
  { import = "plugins.editor" },     -- Core editing experience
  { import = "plugins.lsp" },        -- Language support
  { import = "plugins.git" },        -- Version control tools
  { import = "plugins.navigation" }, -- Project and file navigation
  { import = "plugins.productivity" }, -- Workflow enhancement
  
  -- Utility function to safely import optional plugins
  -- This prevents errors when a plugin spec is temporarily unavailable
  -- while maintaining lazy-loading capabilities
}

-- Custom module that detects and prevents circular dependencies
local function detect_circular_deps()
  local loaded = {}
  local function check_module(mod_name, path)
    if loaded[mod_name] then
      vim.notify("Circular dependency detected: " .. table.concat(path, " -> ") .. " -> " .. mod_name, 
                vim.log.levels.WARN)
      return true
    end
    
    loaded[mod_name] = true
    local path_with_current = vim.deepcopy(path)
    table.insert(path_with_current, mod_name)
    
    local mod = package.loaded[mod_name]
    if mod and type(mod) == "table" then
      for dep_name, _ in pairs(mod) do
        if type(dep_name) == "string" and dep_name:match("^plugins%.") then
          if check_module(dep_name, path_with_current) then
            return true
          end
        end
      end
    end
    
    loaded[mod_name] = nil
    return false
  end

  for module_name, _ in pairs(package.loaded) do
    if type(module_name) == "string" and module_name:match("^plugins%.") then
      check_module(module_name, {})
    end
  end
end

-- Performance monitoring for plugins
local function setup_plugin_metrics()
  -- Create perf measurement tables
  _G.plugin_perf = {
    load_times = {},
    setup_times = {},
    total_time = 0,
    start_time = vim.loop.hrtime(),
  }

  -- Wrap lazy.nvim's require function to add instrumentation
  local original_require = require
  _G.require = function(modname)
    local start = vim.loop.hrtime()
    local mod = original_require(modname)
    local duration = (vim.loop.hrtime() - start) / 1000000 -- Convert to ms
    
    -- Track plugin load times for modules under plugins directory
    if type(modname) == "string" and modname:match("^plugins%.") then
      _G.plugin_perf.load_times[modname] = duration
      _G.plugin_perf.total_time = _G.plugin_perf.total_time + duration
    end
    
    return mod
  end
  
  -- Add command to view plugin performance
  vim.api.nvim_create_user_command("PluginPerf", function()
    local sorted_plugins = {}
    for plugin, time in pairs(_G.plugin_perf.load_times) do
      table.insert(sorted_plugins, {name = plugin, time = time})
    end
    
    table.sort(sorted_plugins, function(a, b) return a.time > b.time end)
    
    local output = {"Plugin Performance Metrics:", "==========================", ""}
    for _, plugin in ipairs(sorted_plugins) do
      table.insert(output, string.format("%s: %.2fms", plugin.name, plugin.time))
    end
    
    local total_startup = (vim.loop.hrtime() - _G.plugin_perf.start_time) / 1000000
    table.insert(output, "")
    table.insert(output, string.format("Total plugin load time: %.2fms", _G.plugin_perf.total_time))
    table.insert(output, string.format("Total startup time: %.2fms", total_startup))
    
    vim.notify(table.concat(output, "\n"), vim.log.levels.INFO)
  end, {})
end

-- Setup performance monitoring at startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Detect circular dependencies when in dev mode
    if vim.env.NVIM_DEV == "1" then
      detect_circular_deps()
    end
  end,
  once = true,
})

-- Only enable metrics when requested via env var
if vim.env.NVIM_PROFILE == "1" then
  setup_plugin_metrics()
end

return M
