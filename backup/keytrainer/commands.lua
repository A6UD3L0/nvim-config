-- KeyTrainer commands setup
-- This ensures all commands are properly registered
local M = {}

-- The main module
local keytrainer = require("keytrainer")

-- Register all commands for training
function M.setup()
  -- Main KeyTrainer command
  vim.api.nvim_create_user_command("KeyTrainer", function()
    keytrainer.start_game()
  end, {
    desc = "Start the KeyTrainer in default mode"
  })

  -- KeyMap alias (common shorthand)
  vim.api.nvim_create_user_command("KeyMap", function()
    keytrainer.start_game()
  end, {
    desc = "Alias for KeyTrainer command"
  })

  -- Harpoon-focused training 
  vim.api.nvim_create_user_command("HarpoonTrainer", function()
    keytrainer.start_game()
    keytrainer.set_category("harpoon")
  end, {
    desc = "Train Harpoon key mappings"
  })

  -- Vim motions focused training
  vim.api.nvim_create_user_command("MotionsTrainer", function()
    keytrainer.start_game()
    keytrainer.set_category("vim_motions")
  end, {
    desc = "Train Vim motions"
  })

  -- Text objects focused training
  vim.api.nvim_create_user_command("TextObjectsTrainer", function()
    keytrainer.start_game()
    keytrainer.set_category("text_objects")
  end, {
    desc = "Train text object manipulations"
  })

  -- Git tools focused training
  vim.api.nvim_create_user_command("GitTrainer", function()
    keytrainer.start_game()
    keytrainer.set_category("git_tools")
  end, {
    desc = "Train Git workflow commands"
  })

  -- Undotree and history management focused training
  vim.api.nvim_create_user_command("UndoTrainer", function()
    keytrainer.start_game()
    keytrainer.set_category("history_management")
  end, {
    desc = "Train Undotree and history management commands"
  })

  -- Return true to indicate command registration was successful
  return true
end

return M
