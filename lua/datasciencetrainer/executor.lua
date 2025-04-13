-- DataScienceTrainer code executor
-- Safely runs data science code snippets and returns results

local M = {}

-- Configuration
local config = {
  python_path = vim.fn.exepath("python3") or "python3",
  execution_timeout = 10, -- seconds
  max_output_length = 2000,
}

-- Set up the executor with configuration
function M.setup(user_config)
  if user_config then
    config.python_path = user_config.python_path or config.python_path
  end
  
  -- Create necessary directories
  local temp_dir = vim.fn.stdpath("cache") .. "/datasciencetrainer"
  vim.fn.mkdir(temp_dir, "p")
end

-- Cleanup resources
function M.cleanup()
  -- Could clean up temporary files or processes here
end

-- Run Python code and return output
function M.run_python_code(code)
  -- Create a temporary file
  local temp_dir = vim.fn.stdpath("cache") .. "/datasciencetrainer"
  local temp_file = temp_dir .. "/run_" .. os.time() .. ".py"
  
  -- Write code to file
  local file = io.open(temp_file, "w")
  if not file then
    return "Error: Could not create temporary file"
  end
  
  file:write(code)
  file:close()
  
  -- Create command
  local cmd = string.format("%s %s", config.python_path, vim.fn.shellescape(temp_file))
  
  -- Use jobstart for async execution
  local output = ""
  local error_output = ""
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data)
      if data then
        error_output = error_output .. table.concat(data, "\n")
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  
  -- Wait for job to complete
  vim.fn.jobwait({job_id}, config.execution_timeout * 1000)
  
  -- Clean up
  vim.fn.delete(temp_file)
  
  -- Return combined output (errors first, then standard output)
  local result = ""
  if error_output and error_output ~= "" then
    result = "Errors:\n" .. error_output .. "\n\n"
  end
  
  if output and output ~= "" then
    result = result .. "Output:\n" .. output
  end
  
  -- Trim if too long
  if #result > config.max_output_length then
    result = string.sub(result, 1, config.max_output_length) .. "\n... (output truncated)"
  end
  
  return result
end

-- Run code in the specified language (currently only supports Python)
function M.run_code(code, language)
  if language == "python" then
    return M.run_python_code(code)
  else
    return "Error: Unsupported language: " .. (language or "nil")
  end
end

-- Check if a Python package is installed
function M.check_package(package_name)
  local cmd = string.format("%s -c \"import %s; print('Package found')\"", 
                            config.python_path, package_name)
  
  local output = vim.fn.system(cmd)
  return output:find("Package found") ~= nil
end

-- Install a Python package
function M.install_package(package_name)
  local cmd = string.format("%s -m pip install %s", 
                            config.python_path, package_name)
  
  local output = vim.fn.system(cmd)
  return output
end

return M
