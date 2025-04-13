-- LuaSnip configuration file to fix deprecation warnings
local M = {}

-- Fix for LuaSnip deprecated vim.validate warnings
M.setup = function()
  -- Only run if LuaSnip is available
  local luasnip_status, _ = pcall(require, "luasnip")
  if not luasnip_status then
    return
  end

  -- Override the deprecated vim.validate function
  _G._luasnip_validate = function(args, parent)
    -- Create a non-deprecated version of validation
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
  local luasnip_util = package.loaded["luasnip.util.util"]
  if luasnip_util and luasnip_util.validate then
    luasnip_util.validate = _G._luasnip_validate
  end

  local loaders_util = package.loaded["luasnip.loaders.util"]
  if loaders_util then
    loaders_util.validate = _G._luasnip_validate
  end
end

return M
