-- Patches for deprecated methods in copilot-cmp
local M = {}

-- Override the is_stopped function to avoid deprecation warnings
M.setup = function()
  -- Get the path to copilot-cmp source.lua
  local source_path = vim.fn.stdpath("data") .. "/lazy/copilot-cmp/lua/copilot_cmp/source.lua"
  
  -- Check if the file exists before trying to patch
  if vim.fn.filereadable(source_path) == 1 then
    -- Read the file content
    local lines = vim.fn.readfile(source_path)
    local needs_patch = false
    
    -- Look for deprecated client.is_stopped usage
    for i, line in ipairs(lines) do
      if line:match("client.is_stopped") then
        needs_patch = true
        break
      end
    end
    
    -- Only apply the patch if needed
    if needs_patch then
      -- Create a backup of the original file
      vim.fn.writefile(lines, source_path .. ".bak")
      
      -- Replace all instances of client.is_stopped with client:is_stopped()
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("client%.is_stopped", "client:is_stopped()")
      end
      
      -- Write the patched file
      vim.fn.writefile(lines, source_path)
      
      vim.notify("Applied patch to fix copilot-cmp deprecation warning", vim.log.levels.INFO)
    end
  end
end

return M
