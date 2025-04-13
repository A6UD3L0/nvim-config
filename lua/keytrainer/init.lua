-- KeyTrainer - Master your Neovim key mappings
-- Enhanced for Harpoon and Vim Motions mastery

local M = {}

-- Get module dependencies
local ui = require("keytrainer.ui")
local challenges = require("keytrainer.challenges")

-- Configuration with defaults
local config = {
  -- Default category to start with
  default_category = "beginner",
  
  -- Sound feedback (if enabled)
  sound_feedback = false,
  
  -- Time between challenges in ms
  challenge_delay = 800,
  
  -- Automatically advance to the next challenge after success
  auto_advance = true,
  
  -- Play success sound on macOS
  play_success_sound = function()
    vim.fn.jobstart('afplay /System/Library/Sounds/Tink.aiff')
  end,
  
  -- Play error sound on macOS
  play_error_sound = function()
    vim.fn.jobstart('afplay /System/Library/Sounds/Basso.aiff')
  end,
}

-- Setup the plugin with user configuration
function M.setup(user_config)
  if user_config then
    for k, v in pairs(user_config) do
      config[k] = v
    end
  end
end

-- Active state of the game
local game_active = false
local keymap_tracker = {}

-- Start the KeyTrainer game
function M.start_game()
  -- If game is already active, do nothing
  if game_active then
    return
  end
  
  -- Create the UI
  ui.create_ui()
  ui.set_category(config.default_category)
  
  -- Mark game as active
  game_active = true
  
  -- Set up key mapping listeners
  M.setup_keymap_listeners()
end

-- Stop the KeyTrainer game
function M.stop_game()
  -- Clear any tracked keymaps
  M.clear_keymap_listeners()
  
  -- Close the window if it exists
  local bufnr = ui.get_bufnr()
  if bufnr > 0 then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
  
  -- Mark game as inactive
  game_active = false
end

-- Clear and restore keymappings
function M.clear_keymap_listeners()
  for _, restore_fn in ipairs(keymap_tracker) do
    restore_fn()
  end
  keymap_tracker = {}
end

-- Setup listeners for user input to compare with expected keybindings
function M.setup_keymap_listeners()
  -- Clear previous listeners
  M.clear_keymap_listeners()
  
  -- Create a local variable to store keypress state
  local current_input = ""
  local input_timeout = nil
  
  -- Process inputs by appending to current_input with timeout
  local function process_input(char)
    -- Append the new character
    current_input = current_input .. char
    
    -- Check if this matches the current challenge
    local current_challenge = ui.get_current_challenge()
    if not current_challenge then
      return
    end
    
    -- Expand special key notation
    local expanded_binding = current_challenge.keybinding
      :gsub("<leader>", vim.g.mapleader or "\\")
      :gsub("<CR>", "\r")
      :gsub("<Esc>", "\27")
    
    -- Check if the input so far matches the beginning of the expected binding
    if expanded_binding:sub(1, #current_input) == current_input then
      -- If exact match, correct!
      if #current_input == #expanded_binding then
        -- Play sound feedback if enabled
        if config.sound_feedback then
          config.play_success_sound()
        end
        
        -- Update UI
        ui.update_state(true)
        
        -- Reset current input
        current_input = ""
        
        -- Clear any pending timeout
        if input_timeout then
          vim.fn.timer_stop(input_timeout)
          input_timeout = nil
        end
        
        -- Advance to next challenge after a short delay if auto_advance is enabled
        if config.auto_advance then
          vim.defer_fn(function()
            if game_active then
              ui.next_challenge()
            end
          end, config.challenge_delay)
        end
      else
        -- Still partial match, wait for more input
        -- Reset timeout
        if input_timeout then
          vim.fn.timer_stop(input_timeout)
        end
        
        -- Set new timeout to clear input if no more keystrokes come in
        input_timeout = vim.fn.timer_start(1000, function()
          current_input = ""
          input_timeout = nil
        end)
      end
    else
      -- Play sound feedback if enabled
      if config.sound_feedback then
        config.play_error_sound()
      end
      
      -- Wrong input, mark as incorrect
      ui.update_state(false)
      
      -- Reset current input
      current_input = ""
      
      -- Clear any pending timeout
      if input_timeout then
        vim.fn.timer_stop(input_timeout)
        input_timeout = nil
      end
    end
  end
  
  -- Handle normal mode key presses
  local on_key = vim.on_key or vim.register_keystroke_callback
  
  -- Use appropriate API based on Neovim version
  if on_key then
    local restore = on_key(function(char)
      if not game_active then
        return
      end
      
      -- Only process if in normal mode and KeyTrainer buffer is visible
      if vim.fn.mode() == 'n' and ui.get_bufnr() > 0 then
        process_input(char)
      end
    end)
    
    -- Add to tracker for cleanup
    table.insert(keymap_tracker, restore)
  end
end

-- Toggle hint visibility
function M.toggle_hint()
  ui.toggle_hint()
end

-- Set the current challenge category
function M.set_category(category)
  ui.set_category(category)
end

-- Move to the next challenge
function M.next_challenge()
  ui.next_challenge()
end

-- Move to the previous challenge
function M.prev_challenge()
  ui.prev_challenge()
end

-- Reset statistics
function M.reset_stats()
  ui.reset_stats()
end

-- List available challenge categories
function M.list_categories()
  local category_list = {}
  for category, _ in pairs(challenges) do
    table.insert(category_list, category)
  end
  
  return category_list
end

-- Command to start the KeyTrainer
vim.api.nvim_create_user_command("KeyTrainer", function()
  M.start_game()
end, {})

-- Command to toggle hint visibility
vim.api.nvim_create_user_command("KeyTrainerToggleHint", function()
  M.toggle_hint()
end, {})

-- Command to select category
vim.api.nvim_create_user_command("KeyTrainerCategory", function(opts)
  if opts.args and opts.args ~= "" then
    M.set_category(opts.args)
  else
    local categories = table.concat(M.list_categories(), ", ")
    print("Available categories: " .. categories)
  end
end, {
  nargs = "?",
  complete = function()
    return M.list_categories()
  end,
})

-- Create a shorter command alias for convenience
vim.api.nvim_create_user_command("KeyMap", function()
  M.start_game()
end, {})

-- Also add easier way to open Harpoon-focused training
vim.api.nvim_create_user_command("HarpoonTrainer", function()
  M.start_game()
  M.set_category("harpoon")
end, {})

-- Add vim motions focused training
vim.api.nvim_create_user_command("MotionsTrainer", function()
  M.start_game()
  M.set_category("vim_motions")
end, {})

-- Add text objects focused training
vim.api.nvim_create_user_command("TextObjectsTrainer", function()
  M.start_game()
  M.set_category("text_objects")
end, {})

-- Add git tools focused training
vim.api.nvim_create_user_command("GitTrainer", function()
  M.start_game()
  M.set_category("git_tools")
end, {})

-- Add undotree and history management focused training
vim.api.nvim_create_user_command("UndoTrainer", function()
  M.start_game()
  M.set_category("history_management")
end, {})

return M
