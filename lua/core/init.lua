-- Core Integration Module
-- Provides the entry point for the refactored configuration
-- Manages initialization sequence and component dependencies

local M = {}

-- Core components in load order
M.components = {
  "utils",      -- Utility functions
  "events",     -- Event system
  "settings",   -- Settings manager
  "schema",     -- Schema validation
  "keybindings", -- Keybinding system
  "lsp",        -- LSP integration
  "plugin_system", -- Plugin architecture
}

-- Component modules
M.modules = {}

-- Initialize a single component
function M.init_component(name)
  if M.modules[name] then
    -- Already loaded
    return true
  end
  
  local ok, module = pcall(require, "core." .. name)
  if not ok then
    vim.notify("Failed to load core component '" .. name .. "': " .. module, vim.log.levels.ERROR)
    return false
  end
  
  -- Store the module
  M.modules[name] = module
  
  -- Initialize the module if it has a setup function
  if type(module.setup) == "function" then
    local init_ok, err = pcall(module.setup)
    if not init_ok then
      vim.notify("Failed to initialize core component '" .. name .. "': " .. err, vim.log.levels.ERROR)
      return false
    end
  end
  
  vim.notify("Initialized core component: " .. name, vim.log.levels.DEBUG)
  return true
end

-- Initialize all core components
function M.init()
  vim.notify("Initializing core configuration system...", vim.log.levels.INFO)
  
  -- Load components in order
  for _, name in ipairs(M.components) do
    if not M.init_component(name) then
      vim.notify("Core initialization failed at component: " .. name, vim.log.levels.ERROR)
      return false
    end
  end
  
  -- Emit core ready event if events system is initialized
  if M.modules.events then
    M.modules.events.emit("core:ready")
  end
  
  vim.notify("Core configuration system initialized", vim.log.levels.INFO)
  return true
end

-- Get a core module
function M.get(name)
  if M.modules[name] then
    return M.modules[name]
  end
  
  -- Try to load it if it's not loaded yet
  if not M.init_component(name) then
    return nil
  end
  
  return M.modules[name]
end

-- Check if a component is loaded
function M.is_loaded(name)
  return M.modules[name] ~= nil
end

-- Reload a component (for development)
function M.reload(name)
  if not M.modules[name] then
    return M.init_component(name)
  end
  
  -- Unload the module
  package.loaded["core." .. name] = nil
  M.modules[name] = nil
  
  -- Reload it
  return M.init_component(name)
end

-- Reload all components (for development)
function M.reload_all()
  for _, name in ipairs(M.components) do
    M.reload(name)
  end
  
  return true
end

return M
