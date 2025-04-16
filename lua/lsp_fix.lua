-- LSP changetracking fix for the "prev_line" nil error
local M = {}

M.setup = function()
  -- Create a safe wrapper for the compute_diff function in vim.lsp.sync
  local orig_compute_diff = vim.lsp.sync.compute_diff
  vim.lsp.sync.compute_diff = function(old_lines, new_lines, start_line_idx, end_line_idx, new_start_line_idx, new_end_line_idx)
    -- Guard against nil values that cause errors
    if not old_lines or not new_lines then
      return { rangeLength = 0, range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 0 } }, text = "" }
    end
    
    -- If we're at the beginning or end of the file, handle it specially
    if start_line_idx <= 0 or end_line_idx <= 0 or new_start_line_idx <= 0 or new_end_line_idx <= 0 then
      return {
        rangeLength = 0,
        range = {
          start = { line = math.max(0, start_line_idx - 1), character = 0 },
          ["end"] = { line = math.max(0, end_line_idx - 1), character = 0 }
        },
        text = table.concat(new_lines, "\n")
      }
    end
    
    -- Call the original function with valid values
    return orig_compute_diff(old_lines, new_lines, start_line_idx, end_line_idx, new_start_line_idx, new_end_line_idx)
  end
  
  -- Override the compute_start_range function which is where the error happens
  local orig_compute_start_range = vim.lsp.sync.compute_start_range
  vim.lsp.sync.compute_start_range = function(prev_lines, prev_line, prev_line_ending, next_lines, next_line, next_line_ending, start_char)
    -- Handle nil values that cause errors
    if not prev_line then
      return { line = 0, character = 0 }
    end
    
    -- Call the original function with proper guarding
    return orig_compute_start_range(prev_lines, prev_line, prev_line_ending, next_lines, next_line, next_line_ending, start_char)
  end
end

return M
