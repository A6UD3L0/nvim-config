-- DataScienceTrainer - Learn data science workflows in Neovim
-- Progressive learning from basic to advanced data science workflows

local M = {}

-- Get module dependencies
local ui = require("datasciencetrainer.ui")
local challenges = require("datasciencetrainer.challenges")
local commands = require("datasciencetrainer.commands")
local executor = require("datasciencetrainer.executor")

-- Configuration with defaults
local config = {
  -- Default category to start with
  default_category = "basics",
  
  -- Time between challenges in ms
  challenge_delay = 1000,
  
  -- Automatically advance to the next challenge after success
  auto_advance = true,
  
  -- Feedback sounds
  sound_feedback = false,
  play_success_sound = function()
    vim.fn.jobstart('afplay /System/Library/Sounds/Tink.aiff')
  end,
  play_error_sound = function()
    vim.fn.jobstart('afplay /System/Library/Sounds/Basso.aiff')
  end,
  
  -- Python interpreter to use
  python_path = vim.fn.exepath("python3") or "python3",
  
  -- Jupyter kernel settings
  jupyter = {
    enabled = true,
    auto_connect = true,
  },
  
  -- Plugin dependencies to check
  required_plugins = {
    "nvim-dap-python",  -- For debugging
    "magma-nvim",       -- For Jupyter integration (if available)
    "jupytext.vim",     -- For Jupyter notebook integration
  },
}

-- Game state
local game_active = false
local current_challenge = nil
local current_category = nil
local current_level = 1
local temp_files = {}

-- Setup the plugin with user configuration
function M.setup(user_config)
  if user_config then
    for k, v in pairs(user_config) do
      config[k] = v
    end
  end
  
  -- Register commands
  commands.setup()
  
  -- Check for required plugins
  M.check_dependencies()
end

-- Check if dependencies are available
function M.check_dependencies()
  local missing_deps = {}
  
  -- Check Python
  local python_ok = vim.fn.executable(config.python_path) == 1
  if not python_ok then
    table.insert(missing_deps, "Python interpreter not found at: " .. config.python_path)
  end
  
  -- Check plugins
  for _, plugin in ipairs(config.required_plugins) do
    local ok = pcall(require, plugin)
    if not ok then
      -- It's not a critical error, just note it
      vim.notify("DataScienceTrainer: Optional plugin '" .. plugin .. "' not found.", vim.log.levels.INFO)
    end
  end
  
  return #missing_deps == 0, missing_deps
end

-- Start the DataScienceTrainer game
function M.start_game(category)
  -- If game is already active, do nothing
  if game_active then
    return
  end
  
  -- Check dependencies before starting
  local deps_ok, missing = M.check_dependencies()
  if not deps_ok then
    vim.notify("DataScienceTrainer cannot start due to missing dependencies:\n" .. table.concat(missing, "\n"), vim.log.levels.ERROR)
    return false
  end
  
  -- Create the UI
  ui.create_ui()
  ui.set_category(category or config.default_category)
  
  -- Mark game as active
  game_active = true
  
  -- Setup executor
  executor.setup(config)
  
  return true
end

-- Stop the DataScienceTrainer game and clean up
function M.stop_game()
  -- Close the window if it exists
  ui.close()
  
  -- Clean up temporary files
  for _, file in ipairs(temp_files) do
    vim.fn.delete(file)
  end
  temp_files = {}
  
  -- Cleanup executor
  executor.cleanup()
  
  -- Mark game as inactive
  game_active = false
end

-- Create a temporary file for a challenge
function M.create_temp_file(content, extension)
  extension = extension or "py"
  local temp_dir = vim.fn.stdpath("cache") .. "/datasciencetrainer"
  
  -- Create directory if it doesn't exist
  vim.fn.mkdir(temp_dir, "p")
  
  -- Create unique filename
  local filename = temp_dir .. "/ds_challenge_" .. os.time() .. "." .. extension
  
  -- Write content to file
  local file = io.open(filename, "w")
  if file then
    file:write(content)
    file:close()
    
    -- Add to list of temp files to clean up later
    table.insert(temp_files, filename)
    
    return filename
  end
  
  return nil
end

-- Execute code for a challenge
function M.execute_challenge_code(code, language)
  return executor.run_code(code, language)
end

-- Check if the solution matches the expected output
function M.check_solution(output, expected)
  -- Basic string comparison for now
  -- In a real implementation, this could use regex or more complex validation
  return output:find(expected) ~= nil
end

-- Handle user action for current challenge
function M.handle_action(action_type, data)
  if not game_active or not current_challenge then
    return false
  end
  
  -- Different action types: run_code, answer_question, complete_task
  if action_type == "run_code" then
    local result = M.execute_challenge_code(data.code, data.language)
    local success = M.check_solution(result, current_challenge.expected_output)
    
    ui.update_state(success, result)
    
    if success and config.auto_advance then
      vim.defer_fn(function()
        if game_active then
          ui.next_challenge()
        end
      end, config.challenge_delay)
    end
    
    return success
  elseif action_type == "answer_question" then
    local success = data.answer == current_challenge.answer
    ui.update_state(success)
    
    if success and config.auto_advance then
      vim.defer_fn(function()
        if game_active then
          ui.next_challenge()
        end
      end, config.challenge_delay)
    end
    
    return success
  end
  
  return false
end

-- Initialize the module
M.setup()

return M
