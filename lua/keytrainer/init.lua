-- Key Trainer Plugin for Neovim
-- This plugin helps users practice and learn their custom keybindings

local M = {}

-- Default configuration
M.config = {
  popup_width = 80,
  popup_height = 20,
  timeout = 60, -- seconds
  challenges_file = vim.fn.stdpath("config") .. "/lua/keytrainer/challenges.lua",
  game_modes = {
    "beginner",
    "intermediate",
    "advanced",
    "backend_focus"
  },
  default_mode = "beginner",
}

local ui -- Will hold the UI components
local current_game = nil -- Current game state

-- Initialize the plugin
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Load UI module
  ui = require("keytrainer.ui")
  
  -- Create user command to start the trainer
  vim.api.nvim_create_user_command("KeyTrainer", function(args)
    local mode = args.args ~= "" and args.args or M.config.default_mode
    M.start_game(mode)
  end, {
    nargs = "?",
    complete = function()
      return M.config.game_modes
    end,
    desc = "Start the key binding trainer",
  })
end

-- Start a new game session
function M.start_game(mode)
  if current_game and current_game.is_running then
    vim.notify("Game already in progress", vim.log.levels.WARN)
    return
  end
  
  local challenges = require("keytrainer.challenges")
  local game_module = require("keytrainer.game")
  
  -- Get challenges for the selected mode
  local selected_challenges = challenges[mode] or challenges.beginner
  if not selected_challenges or #selected_challenges == 0 then
    vim.notify("No challenges found for mode: " .. mode, vim.log.levels.ERROR)
    return
  end
  
  -- Create new game instance
  current_game = game_module.new_game(selected_challenges, M.config, ui)
  current_game:start()
end

-- Stop the current game
function M.stop_game()
  if current_game and current_game.is_running then
    current_game:stop()
    current_game = nil
  end
end

-- Get current score
function M.get_score()
  if current_game then
    return current_game.score
  end
  return 0
end

return M
