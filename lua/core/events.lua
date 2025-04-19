-- Core Event System Module
-- Provides a centralized event management system
-- Enables communication between modules without tight coupling

local M = {}

-- Store for event callbacks
M.events = {}

-- Store for event metadata
M.metadata = {}

-- Create an event with optional metadata
function M.create_event(event_name, metadata)
  if not M.events[event_name] then
    M.events[event_name] = {}
    M.metadata[event_name] = metadata or {
      description = "Event: " .. event_name,
      parameters = {},
    }
  end
end

-- Register a callback for an event
function M.on(event_name, callback, priority)
  priority = priority or 50  -- Default priority (lower runs first)
  
  -- Create event if it doesn't exist yet
  if not M.events[event_name] then
    M.create_event(event_name)
  end
  
  -- Add callback with priority
  table.insert(M.events[event_name], {
    callback = callback,
    priority = priority,
  })
  
  -- Sort by priority
  table.sort(M.events[event_name], function(a, b)
    return a.priority < b.priority
  end)
  
  return #M.events[event_name]  -- Return position for potential removal
end

-- Unregister a callback by reference
function M.off(event_name, callback)
  if not M.events[event_name] then
    return false
  end
  
  for i, handler in ipairs(M.events[event_name]) do
    if handler.callback == callback then
      table.remove(M.events[event_name], i)
      return true
    end
  end
  
  return false
end

-- Trigger an event with optional arguments
function M.emit(event_name, ...)
  if not M.events[event_name] then
    return false
  end
  
  local args = {...}
  local results = {}
  
  for _, handler in ipairs(M.events[event_name]) do
    -- Call handler and collect results
    local success, result = pcall(handler.callback, unpack(args))
    if success then
      table.insert(results, result)
    else
      vim.notify("Error in event handler for '" .. event_name .. "': " .. result, vim.log.levels.ERROR)
    end
  end
  
  return results
end

-- Check if an event has any handlers
function M.has_listeners(event_name)
  return M.events[event_name] and #M.events[event_name] > 0 or false
end

-- Get event metadata for documentation
function M.get_metadata(event_name)
  return M.metadata[event_name]
end

-- List all registered events
function M.list_events()
  local result = {}
  for event_name, handlers in pairs(M.events) do
    table.insert(result, {
      name = event_name,
      handlers = #handlers,
      metadata = M.metadata[event_name],
    })
  end
  return result
end

-- Define standard system events
function M.define_standard_events()
  -- Core lifecycle events
  M.create_event("core:initialize", {
    description = "Called during core initialization before plugins load",
    parameters = {},
  })
  
  M.create_event("core:ready", {
    description = "Called when Neovim is fully initialized and ready",
    parameters = {},
  })
  
  -- Plugin events
  M.create_event("plugins:pre_load", {
    description = "Called before plugins are loaded",
    parameters = {},
  })
  
  M.create_event("plugins:post_load", {
    description = "Called after all plugins are loaded",
    parameters = {},
  })
  
  -- Buffer events
  M.create_event("buffer:enter", {
    description = "Called when entering a buffer",
    parameters = { "bufnr" },
  })
  
  M.create_event("buffer:leave", {
    description = "Called when leaving a buffer",
    parameters = { "bufnr" },
  })
  
  M.create_event("buffer:write_pre", {
    description = "Called before saving a buffer",
    parameters = { "bufnr" },
  })
  
  M.create_event("buffer:write_post", {
    description = "Called after saving a buffer",
    parameters = { "bufnr" },
  })
  
  -- LSP events
  M.create_event("lsp:server_attach", {
    description = "Called when an LSP server attaches to a buffer",
    parameters = { "client", "bufnr" },
  })
  
  M.create_event("lsp:server_detach", {
    description = "Called when an LSP server detaches from a buffer",
    parameters = { "client", "bufnr" },
  })
  
  -- Settings events
  M.create_event("settings:changed", {
    description = "Called when settings are changed",
    parameters = { "setting_path", "old_value", "new_value" },
  })
  
  -- Python-specific events
  M.create_event("python:venv_activated", {
    description = "Called when a Python virtual environment is activated",
    parameters = { "venv_path" },
  })
  
  M.create_event("python:install_package", {
    description = "Called when a Python package is installed",
    parameters = { "package_name" },
  })
  
  -- Theme events
  M.create_event("theme:changed", {
    description = "Called when the colorscheme changes",
    parameters = { "colorscheme_name" },
  })
}

-- Setup autocommands to bridge Neovim events to our event system
function M.setup_event_bridges()
  local augroup = vim.api.nvim_create_augroup("CoreEvents", { clear = true })
  
  -- BufEnter -> buffer:enter
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function(args)
      M.emit("buffer:enter", args.buf)
    end,
  })
  
  -- BufLeave -> buffer:leave
  vim.api.nvim_create_autocmd("BufLeave", {
    group = augroup,
    callback = function(args)
      M.emit("buffer:leave", args.buf)
    end,
  })
  
  -- BufWritePre -> buffer:write_pre
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function(args)
      M.emit("buffer:write_pre", args.buf)
    end,
  })
  
  -- BufWritePost -> buffer:write_post
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    callback = function(args)
      M.emit("buffer:write_post", args.buf)
    end,
  })
  
  -- ColorScheme -> theme:changed
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
      M.emit("theme:changed", vim.g.colors_name)
    end,
  })
  
  -- LspAttach -> lsp:server_attach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      M.emit("lsp:server_attach", client, bufnr)
    end,
  })
  
  -- LspDetach -> lsp:server_detach
  vim.api.nvim_create_autocmd("LspDetach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      M.emit("lsp:server_detach", client, bufnr)
    end,
  })
end

-- Initialize the event system
function M.setup()
  M.define_standard_events()
  M.setup_event_bridges()
  
  return true
end

return M
