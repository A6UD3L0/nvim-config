-- Configuration Schema Validation Module
-- Provides schema validation for configuration options
-- Helps catch typos and invalid values early

local M = {}

-- Schema definition registry
M.schemas = {}

-- Validation result type
-- { valid = boolean, errors = {string} }

-- Register a schema for a configuration path
function M.register_schema(path, schema)
  M.schemas[path] = schema
  return true
end

-- Basic type validators
local validators = {
  string = function(value, schema)
    if type(value) ~= "string" then
      return false, string.format("Expected string, got %s", type(value))
    end
    
    -- Check pattern if specified
    if schema.pattern and not string.match(value, schema.pattern) then
      return false, string.format("String doesn't match pattern '%s'", schema.pattern)
    end
    
    -- Check enum if specified
    if schema.enum then
      local valid = false
      for _, v in ipairs(schema.enum) do
        if value == v then
          valid = true
          break
        end
      end
      
      if not valid then
        return false, string.format("Value must be one of: %s", table.concat(schema.enum, ", "))
      end
    end
    
    -- Check min/max length
    if schema.minLength and #value < schema.minLength then
      return false, string.format("String length must be at least %d", schema.minLength)
    end
    
    if schema.maxLength and #value > schema.maxLength then
      return false, string.format("String length must be at most %d", schema.maxLength)
    end
    
    return true
  end,
  
  number = function(value, schema)
    if type(value) ~= "number" then
      return false, string.format("Expected number, got %s", type(value))
    end
    
    -- Check minimum
    if schema.minimum and value < schema.minimum then
      return false, string.format("Value must be >= %s", schema.minimum)
    end
    
    -- Check maximum
    if schema.maximum and value > schema.maximum then
      return false, string.format("Value must be <= %s", schema.maximum)
    end
    
    -- Check if integer
    if schema.integer and math.floor(value) ~= value then
      return false, "Value must be an integer"
    end
    
    -- Check multipleOf
    if schema.multipleOf and value % schema.multipleOf ~= 0 then
      return false, string.format("Value must be a multiple of %s", schema.multipleOf)
    end
    
    return true
  end,
  
  boolean = function(value, _)
    if type(value) ~= "boolean" then
      return false, string.format("Expected boolean, got %s", type(value))
    end
    
    return true
  end,
  
  array = function(value, schema)
    if type(value) ~= "table" then
      return false, string.format("Expected array, got %s", type(value))
    end
    
    -- Check if it's a proper array (no gaps in indices)
    local count = 0
    for _ in pairs(value) do
      count = count + 1
    end
    
    if count ~= #value then
      return false, "Table is not an array (has non-integer keys)"
    end
    
    -- Check min/max items
    if schema.minItems and #value < schema.minItems then
      return false, string.format("Array must have at least %d items", schema.minItems)
    end
    
    if schema.maxItems and #value > schema.maxItems then
      return false, string.format("Array must have at most %d items", schema.maxItems)
    end
    
    -- Validate items
    if schema.items then
      for i, item in ipairs(value) do
        local valid, err = M.validate_value(item, schema.items)
        if not valid then
          return false, string.format("Item %d: %s", i, err)
        end
      end
    end
    
    return true
  end,
  
  object = function(value, schema)
    if type(value) ~= "table" then
      return false, string.format("Expected object, got %s", type(value))
    end
    
    local errors = {}
    
    -- Check required properties
    if schema.required then
      for _, prop in ipairs(schema.required) do
        if value[prop] == nil then
          table.insert(errors, string.format("Missing required property '%s'", prop))
        end
      end
    end
    
    -- Validate properties
    if schema.properties then
      for prop_name, prop_schema in pairs(schema.properties) do
        if value[prop_name] ~= nil then
          local valid, err = M.validate_value(value[prop_name], prop_schema)
          if not valid then
            table.insert(errors, string.format("Property '%s': %s", prop_name, err))
          end
        end
      end
    end
    
    -- Check for additional properties
    if schema.additionalProperties == false then
      for prop_name, _ in pairs(value) do
        if not schema.properties or not schema.properties[prop_name] then
          table.insert(errors, string.format("Additional property '%s' not allowed", prop_name))
        end
      end
    end
    
    if #errors > 0 then
      return false, table.concat(errors, "; ")
    end
    
    return true
  end,
  
  -- Special compound validators
  oneOf = function(value, schema)
    if not schema.oneOf then
      return false, "Schema error: oneOf requires options"
    end
    
    local match_count = 0
    local last_error = nil
    
    for _, option in ipairs(schema.oneOf) do
      local valid, err = M.validate_value(value, option)
      if valid then
        match_count = match_count + 1
      else
        last_error = err
      end
    end
    
    if match_count == 1 then
      return true
    elseif match_count == 0 then
      return false, "Value doesn't match any of the options: " .. last_error
    else
      return false, "Value matches multiple options, but must match exactly one"
    end
  end,
  
  anyOf = function(value, schema)
    if not schema.anyOf then
      return false, "Schema error: anyOf requires options"
    end
    
    for _, option in ipairs(schema.anyOf) do
      local valid, _ = M.validate_value(value, option)
      if valid then
        return true
      end
    end
    
    return false, "Value doesn't match any of the options"
  end,
  
  allOf = function(value, schema)
    if not schema.allOf then
      return false, "Schema error: allOf requires options"
    end
    
    for _, option in ipairs(schema.allOf) do
      local valid, err = M.validate_value(value, option)
      if not valid then
        return false, err
      end
    end
    
    return true
  end,
  
  -- Conditional validation
  if_then_else = function(value, schema)
    if not schema.if then
      return false, "Schema error: conditional requires 'if'"
    end
    
    local matches_if, _ = M.validate_value(value, schema.if)
    
    if matches_if and schema.then then
      return M.validate_value(value, schema.then)
    elseif not matches_if and schema.else then
      return M.validate_value(value, schema.else)
    end
    
    return true
  end,
}

-- Validate a value against a schema
function M.validate_value(value, schema)
  -- Handle null value
  if value == nil then
    if schema.nullable then
      return true
    end
    return false, "Value is required"
  end
  
  -- Handle oneOf, anyOf, allOf
  if schema.oneOf then
    return validators.oneOf(value, schema)
  elseif schema.anyOf then
    return validators.anyOf(value, schema)
  elseif schema.allOf then
    return validators.allOf(value, schema)
  elseif schema.if then
    return validators.if_then_else(value, schema)
  end
  
  -- Validate based on type
  if schema.type then
    local validator = validators[schema.type]
    if validator then
      return validator(value, schema)
    else
      return false, "Unknown schema type: " .. schema.type
    end
  end
  
  -- If no type specified, assume any type is valid
  return true
end

-- Validate a configuration value against the registered schema
function M.validate_config(path, value)
  local schema = M.schemas[path]
  if not schema then
    -- No schema registered, assume valid
    return { valid = true, errors = {} }
  end
  
  local valid, err = M.validate_value(value, schema)
  
  if valid then
    return { valid = true, errors = {} }
  else
    return { valid = false, errors = { err } }
  end
end

-- Define standard schemas for configuration options
function M.define_standard_schemas()
  -- Editor settings
  M.register_schema("editor.tabstop", {
    type = "number",
    integer = true,
    minimum = 1,
    maximum = 8,
    description = "Number of spaces that a tab counts for",
  })
  
  M.register_schema("editor.shiftwidth", {
    type = "number",
    integer = true,
    minimum = 1,
    maximum = 8,
    description = "Number of spaces to use for each step of (auto)indent",
  })
  
  M.register_schema("editor.expandtab", {
    type = "boolean",
    description = "Use spaces instead of tabs",
  })
  
  M.register_schema("editor.wrap", {
    type = "boolean",
    description = "Line wrapping",
  })
  
  -- UI settings
  M.register_schema("ui.colorscheme", {
    type = "string",
    description = "Color scheme to use",
  })
  
  M.register_schema("ui.background", {
    type = "string",
    enum = { "dark", "light" },
    description = "Background color mode",
  })
  
  M.register_schema("ui.transparency", {
    type = "number",
    minimum = 0,
    maximum = 1,
    description = "Background transparency (0.0-1.0)",
  })
  
  -- LSP settings
  M.register_schema("lsp.format_on_save", {
    type = "boolean",
    description = "Format buffer on save using LSP",
  })
  
  M.register_schema("lsp.servers", {
    type = "object",
    additionalProperties = {
      type = "object",
      properties = {
        enabled = { type = "boolean" },
        settings = { type = "object" },
      },
    },
    description = "LSP server configurations",
  })
  
  -- Python-specific settings
  M.register_schema("python.formatter", {
    type = "string",
    enum = { "black", "yapf", "autopep8", "ruff" },
    description = "Python formatter to use",
  })
  
  M.register_schema("python.linter", {
    type = "string",
    enum = { "flake8", "pylint", "ruff" },
    description = "Python linter to use",
  })
  
  M.register_schema("python.uv.enabled", {
    type = "boolean",
    description = "Enable uv.nvim integration",
  })
  
  -- Keybinding settings
  M.register_schema("keybindings.leader", {
    type = "string",
    maxLength = 1,
    description = "Leader key",
  })
  
  M.register_schema("keybindings.timeout", {
    type = "number",
    integer = true,
    minimum = 100,
    maximum = 5000,
    description = "Timeout for key sequences (ms)",
  })
end

-- Initialize schema validation
function M.setup()
  M.define_standard_schemas()
  return true
end

return M
