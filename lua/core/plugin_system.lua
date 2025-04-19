-- Plugin System Module
-- Implements a plugin architecture for Neovim configuration
-- Allows features to be enabled/disabled and configured independently

local utils = require("core.utils")
local events = require("core.events")
local settings = require("core.settings")
local M = {}

-- Plugin registry
M.plugins = {}

-- Plugin states
M.enabled = {}

-- Define a plugin with its features and dependencies
function M.define_plugin(name, config)
  -- Validate config
  config = config or {}
  config.name = name
  config.description = config.description or ("Plugin: " .. name)
  config.version = config.version or "1.0.0"
  config.dependencies = config.dependencies or {}
  config.enabled = config.enabled ~= false -- Enabled by default
  config.load_after = config.load_after or {}
  config.config = config.config or {}
  
  -- Setup methods
  config.setup = config.setup or function() return true end
  config.teardown = config.teardown or function() return true end
  
  -- Register plugin
  M.plugins[name] = config
  M.enabled[name] = config.enabled
  
  return true
end

-- Check if a plugin's dependencies are satisfied
function M.check_dependencies(name)
  local plugin = M.plugins[name]
  if not plugin then
    return false, "Plugin not found: " .. name
  end
  
  local missing = {}
  
  -- Check Neovim dependencies
  if plugin.requires_neovim and vim.fn.has("nvim-" .. plugin.requires_neovim) ~= 1 then
    table.insert(missing, "Neovim " .. plugin.requires_neovim)
  end
  
  -- Check plugin dependencies
  for _, dep in ipairs(plugin.dependencies) do
    if not M.enabled[dep] then
      table.insert(missing, dep)
    end
  end
  
  -- Check external dependencies (commands)
  if plugin.requires_commands then
    for _, cmd in ipairs(plugin.requires_commands) do
      if not utils.command_exists(cmd) then
        table.insert(missing, "Command: " .. cmd)
      end
    end
  end
  
  if #missing > 0 then
    return false, "Missing dependencies: " .. table.concat(missing, ", ")
  end
  
  return true
end

-- Enable a plugin
function M.enable_plugin(name)
  local plugin = M.plugins[name]
  if not plugin then
    vim.notify("Plugin not found: " .. name, vim.log.levels.ERROR)
    return false
  end
  
  -- Check if already enabled
  if M.enabled[name] then
    return true
  end
  
  -- Check dependencies
  local deps_ok, missing = M.check_dependencies(name)
  if not deps_ok then
    vim.notify("Cannot enable " .. name .. ": " .. missing, vim.log.levels.ERROR)
    return false
  end
  
  -- Check if all plugins in load_after are enabled
  for _, dep in ipairs(plugin.load_after) do
    if not M.enabled[dep] then
      -- Enable dependency first
      if not M.enable_plugin(dep) then
        vim.notify("Cannot enable dependency " .. dep .. " for " .. name, vim.log.levels.ERROR)
        return false
      end
    end
  end
  
  -- Set up the plugin
  local ok, err = pcall(plugin.setup, plugin.config)
  if not ok then
    vim.notify("Failed to enable " .. name .. ": " .. err, vim.log.levels.ERROR)
    return false
  end
  
  -- Mark as enabled
  M.enabled[name] = true
  events.emit("plugin:enabled", name)
  
  return true
end

-- Disable a plugin
function M.disable_plugin(name)
  local plugin = M.plugins[name]
  if not plugin then
    vim.notify("Plugin not found: " .. name, vim.log.levels.ERROR)
    return false
  end
  
  -- Check if already disabled
  if not M.enabled[name] then
    return true
  end
  
  -- Check if any enabled plugins depend on this one
  local dependants = {}
  for pname, p in pairs(M.plugins) do
    if M.enabled[pname] then
      for _, dep in ipairs(p.dependencies) do
        if dep == name then
          table.insert(dependants, pname)
          break
        end
      end
    end
  end
  
  if #dependants > 0 then
    vim.notify("Cannot disable " .. name .. ": required by " .. table.concat(dependants, ", "), vim.log.levels.ERROR)
    return false
  end
  
  -- Tear down the plugin
  local ok, err = pcall(plugin.teardown)
  if not ok then
    vim.notify("Error during teardown of " .. name .. ": " .. err, vim.log.levels.WARN)
  end
  
  -- Mark as disabled
  M.enabled[name] = false
  events.emit("plugin:disabled", name)
  
  return true
end

-- Initialize all enabled plugins in the correct order
function M.initialize_plugins()
  -- Topological sort based on dependencies
  local visited = {}
  local result = {}
  
  local function visit(name)
    if visited[name] then
      return
    end
    
    visited[name] = true
    
    -- Visit dependencies first
    local plugin = M.plugins[name]
    if plugin then
      for _, dep in ipairs(plugin.dependencies) do
        visit(dep)
      end
      
      for _, dep in ipairs(plugin.load_after) do
        visit(dep)
      end
    end
    
    table.insert(result, name)
  end
  
  -- Visit all plugins
  for name, plugin in pairs(M.plugins) do
    if plugin.enabled then
      visit(name)
    end
  end
  
  -- Enable plugins in sorted order
  for _, name in ipairs(result) do
    if M.plugins[name].enabled and not M.enabled[name] then
      M.enable_plugin(name)
    end
  end
  
  return true
end

-- Get plugin status
function M.get_plugin_status(name)
  if not M.plugins[name] then
    return nil
  end
  
  return {
    name = name,
    enabled = M.enabled[name] or false,
    description = M.plugins[name].description,
    version = M.plugins[name].version,
    dependencies = M.plugins[name].dependencies,
  }
end

-- Get all plugin statuses
function M.get_all_plugin_statuses()
  local result = {}
  
  for name, _ in pairs(M.plugins) do
    table.insert(result, M.get_plugin_status(name))
  end
  
  return result
end

-- Configure a plugin
function M.configure_plugin(name, config)
  local plugin = M.plugins[name]
  if not plugin then
    vim.notify("Plugin not found: " .. name, vim.log.levels.ERROR)
    return false
  end
  
  -- Merge configs
  plugin.config = vim.tbl_deep_extend("force", plugin.config, config or {})
  
  -- Apply config if plugin is enabled
  if M.enabled[name] then
    -- Disable and re-enable to apply new config
    M.disable_plugin(name)
    M.enable_plugin(name)
  end
  
  return true
end

-- Load plugin definitions from a directory
function M.load_plugin_definitions()
  local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local plugin_files = vim.fn.glob(plugin_dir .. "/*.lua", false, true)
  
  for _, file in ipairs(plugin_files) do
    local module_name = vim.fn.fnamemodify(file, ":t:r")
    if module_name ~= "init" then
      local ok, plugin_def = pcall(require, "plugins." .. module_name)
      if ok and type(plugin_def) == "table" then
        -- Register the plugin
        if plugin_def.name then
          M.define_plugin(plugin_def.name, plugin_def)
        end
      end
    end
  end
  
  return true
end

-- Initialize the plugin system
function M.setup()
  -- Load plugin definitions
  M.load_plugin_definitions()
  
  -- Initialize enabled plugins
  M.initialize_plugins()
  
  -- Register commands
  vim.api.nvim_create_user_command("PluginEnable", function(opts)
    M.enable_plugin(opts.args)
  end, {
    nargs = 1,
    complete = function()
      local completions = {}
      for name, enabled in pairs(M.enabled) do
        if not enabled then
          table.insert(completions, name)
        end
      end
      return completions
    end,
  })
  
  vim.api.nvim_create_user_command("PluginDisable", function(opts)
    M.disable_plugin(opts.args)
  end, {
    nargs = 1,
    complete = function()
      local completions = {}
      for name, enabled in pairs(M.enabled) do
        if enabled then
          table.insert(completions, name)
        end
      end
      return completions
    end,
  })
  
  vim.api.nvim_create_user_command("PluginStatus", function()
    local statuses = M.get_all_plugin_statuses()
    
    -- Sort by name
    table.sort(statuses, function(a, b)
      return a.name < b.name
    end)
    
    -- Display in a float window
    local lines = {"Plugin Status", "-------------"}
    for _, status in ipairs(statuses) do
      local status_str = status.enabled and "✓ " or "✗ "
      table.insert(lines, status_str .. status.name .. " (" .. status.version .. ")")
      table.insert(lines, "  " .. status.description)
      
      if #status.dependencies > 0 then
        table.insert(lines, "  Dependencies: " .. table.concat(status.dependencies, ", "))
      end
      
      table.insert(lines, "")
    end
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    local width = 80
    local height = #lines
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded",
    })
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    
    -- Close on any keypress
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, noremap = true, silent = true })
    vim.keymap.set("n", "<ESC>", "<cmd>close<CR>", { buffer = buf, noremap = true, silent = true })
  end, {})
  
  return true
end

return M
