-- Game Module for KeyTrainer
-- Handles the game mechanics for the keybinding training

local M = {}

-- Game class
local Game = {}
Game.__index = Game

-- Create a new game instance
function M.new_game(challenges, config, ui)
  local self = setmetatable({}, Game)
  
  -- Game state
  self.is_running = false
  self.challenges = challenges
  self.config = config
  self.ui = ui
  self.current_challenge_idx = 0
  self.current_challenge = nil
  self.score = 0
  self.correct = 0
  self.wrong = 0
  self.start_time = 0
  self.total_time = 0
  
  return self
end

-- Start the game
function Game:start()
  if self.is_running then
    return
  end
  
  self.is_running = true
  self.score = 0
  self.correct = 0
  self.wrong = 0
  self.current_challenge_idx = 0
  self.start_time = os.time()
  
  -- Create UI
  local bufnr = self.ui.create_window(self.config)
  
  -- Set up keymappings for answering
  self:_setup_keymaps(bufnr)
  
  -- Start timer
  self.ui.start_timer(
    self.config.timeout,
    function(time_left)
      -- Update timer display
      if self.current_challenge then
        local header = self:_get_header(time_left)
        local lines = vim.tbl_flatten({
          header,
          "",
          "  " .. self.current_challenge.description,
          "",
          "  Complete this action by pressing the correct keybinding sequence...",
          "",
          "  Hint: " .. self.current_challenge.hint,
        })
        self.ui.set_content(lines)
      end
    end,
    function()
      -- Timer completed
      self:_end_game()
    end
  )
  
  -- Show first challenge
  self:_next_challenge()
end

-- Stop the game
function Game:stop()
  if not self.is_running then
    return
  end
  
  self.is_running = false
  self.total_time = os.time() - self.start_time
  
  -- Close UI
  self.ui.close_window()
end

-- Process keypress to check if it matches the current challenge
function Game:_process_keypress(key)
  if not self.is_running or not self.current_challenge then
    return
  end
  
  local correct_answer = self.current_challenge.keybinding
  
  if key == correct_answer then
    -- Correct answer
    self.correct = self.correct + 1
    self.score = self.score + 10
    vim.api.nvim_echo({{"✅ Correct!", "DiagnosticOk"}}, false, {})
    vim.cmd("redraw")
    vim.fn.timer_start(500, function() self:_next_challenge() end)
  else
    -- Incorrect answer
    self.wrong = self.wrong + 1
    self.score = math.max(0, self.score - 2)
    vim.api.nvim_echo({{"❌ Incorrect! The correct keybinding is: " .. correct_answer, "DiagnosticError"}}, false, {})
    vim.cmd("redraw")
    vim.fn.timer_start(1000, function() self:_next_challenge() end)
  end
end

-- Move to the next challenge
function Game:_next_challenge()
  -- Increment challenge index or cycle back to beginning
  self.current_challenge_idx = (self.current_challenge_idx % #self.challenges) + 1
  self.current_challenge = self.challenges[self.current_challenge_idx]
  
  -- Update UI with new challenge
  local time_left = self.config.timeout - (os.time() - self.start_time)
  time_left = math.max(0, time_left)
  
  local header = self:_get_header(time_left)
  local lines = vim.tbl_flatten({
    header,
    "",
    "  " .. self.current_challenge.description,
    "",
    "  Complete this action by pressing the correct keybinding sequence...",
    "",
    "  Hint: " .. self.current_challenge.hint,
  })
  
  self.ui.set_content(lines)
end

-- Get the header display
function Game:_get_header(time_left)
  return {
    "",
    "  🎮 KeyTrainer - Learn Your Keybindings",
    "  ----------------------------------------",
    string.format("  ⏱️  Time left: %d seconds", time_left),
    string.format("  🏆 Score: %d", self.score),
    string.format("  ✅ Correct: %d | ❌ Wrong: %d", self.correct, self.wrong),
  }
end

-- Set up keymaps for answering challenges
function Game:_setup_keymaps(bufnr)
  -- Create a mapping to record keypresses
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>", "<cmd>lua require('keytrainer.game')._handle_space()<CR>", { noremap = true, silent = true })
  
  -- We'll set up specific keymaps for each challenge type
  -- This is a simplified version; in a real implementation, you would need more sophisticated key capture
  
  local game_instance = self -- Reference to this game instance
  
  -- Expose a global function to handle keypresses
  _G.keytrainer_handle_keypress = function(key)
    game_instance:_process_keypress(key)
  end
  
  -- General key handling function
  M._handle_space = function()
    _G.keytrainer_handle_keypress("<Space>")
  end
end

-- End the game and show results
function Game:_end_game()
  self.is_running = false
  self.total_time = os.time() - self.start_time
  
  -- Show game over screen
  self.ui.show_game_over({
    correct = self.correct,
    wrong = self.wrong,
    total_time = self.total_time,
    score = self.score,
  })
end

return M
