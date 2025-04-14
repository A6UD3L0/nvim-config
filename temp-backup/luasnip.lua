-- LuaSnip configuration file to fix deprecation warnings
local M = {}

-- Fix for LuaSnip deprecated vim.validate warnings
M.setup = function()
  -- Only run if LuaSnip is available
  local luasnip_status, luasnip = pcall(require, "luasnip")
  if not luasnip_status then
    return
  end

  -- Create a non-deprecated version of validation
  local function validate(args, parent)
    for k, v in pairs(args) do
      if type(v) == "table" then
        local val, spec = v[1], v[2]
        if type(spec) == "string" and type(val) ~= spec then
          error(string.format("bad argument %s: %s expected, got %s", k, spec, type(val)))
        elseif type(spec) == "function" then
          local valid, msg = spec(val)
          if not valid then
            error(string.format("bad argument %s: %s", k, msg or "invalid value"))
          end
        end
      end
    end
    return args
  end

  -- Apply monkey patch for LuaSnip's internal validation
  if luasnip.util then
    luasnip.util.validate = validate
  end

  if luasnip.loaders then
    luasnip.loaders.util.validate = validate
  end

  -- Initialize LuaSnip with proper configuration
  luasnip.config.setup({
    history = true,
    update_events = "TextChanged,TextChangedI",
    region_check_events = "InsertEnter",
    delete_check_events = "TextChanged,InsertLeave"
  })
end

return M
