-- UI Module for KeyTrainer
-- Handles the visual presentation of the keybinding training game

local M = {}

-- Store windows and buffers
local state = {
  bufnr = nil,
  winnr = nil,
  timer = nil,
  time_left = 0,
}

-- Create the UI elements
function M.create_window(config)
  -- Calculate window positioning
  local width = config.popup_width
  local height = config.popup_height
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "filetype", "keytrainer")

  -- Set window options
  local winnr = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 🎮 KeyTrainer - Learn Your Keybindings ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_option(winnr, "cursorline", true)
  vim.api.nvim_win_set_option(winnr, "wrap", true)
  vim.api.nvim_win_set_option(winnr, "conceallevel", 2)
  vim.api.nvim_win_set_option(winnr, "foldenable", false)

  -- Save state
  state.bufnr = bufnr
  state.winnr = winnr

  return bufnr, winnr
end

-- Close the UI
function M.close_window()
  if state.timer then
    state.timer:stop()
    state.timer = nil
  end

  if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
    vim.api.nvim_win_close(state.winnr, true)
  end

  state.winnr = nil
  state.bufnr = nil
end

-- Display content in the window
function M.set_content(lines, highlight_groups)
  if not state.bufnr or not vim.api.nvim_buf_is_valid(state.bufnr) then
    return
  end

  -- Clear existing highlights
  vim.api.nvim_buf_clear_namespace(state.bufnr, 0, 0, -1)

  -- Set buffer lines
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)

  -- Apply highlighting if provided
  if highlight_groups then
    for _, hl in ipairs(highlight_groups) do
      vim.api.nvim_buf_add_highlight(
        state.bufnr,
        0,
        hl.group,
        hl.line,
        hl.col_start,
        hl.col_end
      )
    end
  end
end

-- Start a timer for the game
function M.start_timer(duration, on_tick, on_complete)
  state.time_left = duration
  
  if state.timer then
    state.timer:stop()
  end
  
  state.timer = vim.loop.new_timer()
  state.timer:start(0, 1000, vim.schedule_wrap(function()
    state.time_left = state.time_left - 1
    
    if state.time_left <= 0 then
      state.timer:stop()
      state.timer = nil
      on_complete()
    else
      on_tick(state.time_left)
    end
  end))
end

-- Display the game over screen
function M.show_game_over(stats)
  if not state.bufnr or not vim.api.nvim_buf_is_valid(state.bufnr) then
    return
  end
  
  local lines = {
    "",
    "  🎮 Game Over! 🎮",
    "",
    "  Your Stats:",
    "  -----------------------------",
    string.format("  ✅ Correct answers: %d", stats.correct),
    string.format("  ❌ Wrong answers: %d", stats.wrong),
    string.format("  ⏱️  Total time: %d seconds", stats.total_time),
    string.format("  🏆 Final score: %d", stats.score),
    "",
    "  Press any key to close...",
    "",
  }
  
  M.set_content(lines)
  
  -- Add keymapping to close window
  vim.api.nvim_buf_set_keymap(state.bufnr, "n", "<Space>", "<cmd>lua require('keytrainer').stop_game()<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(state.bufnr, "n", "q", "<cmd>lua require('keytrainer').stop_game()<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(state.bufnr, "n", "<Esc>", "<cmd>lua require('keytrainer').stop_game()<CR>", { noremap = true, silent = true })
end

-- Define highlight groups with vibrant colors
local function setup_highlights()
  vim.api.nvim_command('highlight KeyTrainerTitle guifg=#c6a0f6 gui=bold')
  vim.api.nvim_command('highlight KeyTrainerDescription guifg=#8bd5ca gui=italic')
  vim.api.nvim_command('highlight KeyTrainerHint guifg=#f5a97f')
  vim.api.nvim_command('highlight KeyTrainerCorrect guifg=#a6da95 gui=bold')
  vim.api.nvim_command('highlight KeyTrainerIncorrect guifg=#ed8796 gui=bold')
  vim.api.nvim_command('highlight KeyTrainerStats guifg=#b7bdf8')
  vim.api.nvim_command('highlight KeyTrainerButton guifg=#c6a0f6 gui=bold')
  vim.api.nvim_command('highlight KeyTrainerCategory guifg=#f0c6c6 gui=bold')
end

-- KeyTrainer state
local state = {
  correct_count = 0,
  incorrect_count = 0,
  challenge_index = 1,
  current_challenges = {},
  category = "beginner",
  streak = 0,
  best_streak = 0,
  last_result = nil,  -- nil, "correct", or "incorrect"
  start_time = nil,
  timer_running = false,
  session_seconds = 0,
}

-- Timer for tracking practice time
local function start_timer()
  if state.timer_running then return end
  
  state.start_time = os.time()
  state.timer_running = true
  
  -- Create timer that updates every second
  local timer = vim.loop.new_timer()
  timer:start(0, 1000, vim.schedule_wrap(function()
    if not state.timer_running then
      timer:stop()
      return
    end
    
    state.session_seconds = os.time() - state.start_time
    -- Redraw if buffer is open
    if vim.fn.bufexists("KeyTrainer") == 1 then
      M.redraw_ui()
    else
      state.timer_running = false
      timer:stop()
    end
  end))
end

-- Format time as MM:SS
local function format_time(seconds)
  local minutes = math.floor(seconds / 60)
  local secs = seconds % 60
  return string.format("%02d:%02d", minutes, secs)
end

-- Create the UI buffer
function M.create_ui()
  setup_highlights()
  
  -- Create a new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "KeyTrainer")
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  
  -- Open the buffer in a split
  vim.api.nvim_command("botright split")
  vim.api.nvim_command("resize 20")
  vim.api.nvim_win_set_buf(0, bufnr)
  
  -- Set local keymaps for the buffer
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Select different categories
  vim.api.nvim_set_keymap("n", "1", ":lua require('keytrainer').set_category('beginner')<CR>", opts)
  vim.api.nvim_set_keymap("n", "2", ":lua require('keytrainer').set_category('intermediate')<CR>", opts)
  vim.api.nvim_set_keymap("n", "3", ":lua require('keytrainer').set_category('advanced')<CR>", opts)
  vim.api.nvim_set_keymap("n", "4", ":lua require('keytrainer').set_category('harpoon')<CR>", opts)
  vim.api.nvim_set_keymap("n", "5", ":lua require('keytrainer').set_category('vim_motions')<CR>", opts)
  vim.api.nvim_set_keymap("n", "6", ":lua require('keytrainer').set_category('text_objects')<CR>", opts)
  vim.api.nvim_set_keymap("n", "7", ":lua require('keytrainer').set_category('backend_focus')<CR>", opts)
  vim.api.nvim_set_keymap("n", "8", ":lua require('keytrainer').set_category('workflow')<CR>", opts)
  vim.api.nvim_set_keymap("n", "9", ":lua require('keytrainer').set_category('git_tools')<CR>", opts)
  vim.api.nvim_set_keymap("n", "0", ":lua require('keytrainer').set_category('history_management')<CR>", opts)
  
  -- Navigation
  vim.api.nvim_set_keymap("n", "n", ":lua require('keytrainer').next_challenge()<CR>", opts)
  vim.api.nvim_set_keymap("n", "p", ":lua require('keytrainer').prev_challenge()<CR>", opts)
  vim.api.nvim_set_keymap("n", "r", ":lua require('keytrainer').reset_stats()<CR>", opts)
  vim.api.nvim_set_keymap("n", "q", ":bd<CR>", opts)
  vim.api.nvim_set_keymap("n", "?", ":lua require('keytrainer').toggle_hint()<CR>", opts)
  
  start_timer()
  
  return bufnr
end

-- Toggle hint visibility
local show_hint = true
function M.toggle_hint()
  show_hint = not show_hint
  M.redraw_ui()
end

-- Display content in the UI buffer
function M.redraw_ui()
  local bufnr = vim.fn.bufnr("KeyTrainer")
  if bufnr == -1 then
    return
  end
  
  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  
  local lines = {}
  
  -- ASCII Art Header
  table.insert(lines, "")
  table.insert(lines, "  ██╗  ██╗███████╗██╗   ██╗████████╗██████╗  █████╗ ██╗███╗   ██╗███████╗██████╗ ")
  table.insert(lines, "  ██║ ██╔╝██╔════╝╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██╔══██╗")
  table.insert(lines, "  █████╔╝ █████╗   ╚████╔╝    ██║   ██████╔╝███████║██║██╔██╗ ██║█████╗  ██████╔╝")
  table.insert(lines, "  ██╔═██╗ ██╔══╝    ╚██╔╝     ██║   ██╔══██╗██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗")
  table.insert(lines, "  ██║  ██╗███████╗   ██║      ██║   ██║  ██║██║  ██║██║██║ ╚████║███████╗██║  ██║")
  table.insert(lines, "  ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝")
  table.insert(lines, "")
  
  -- Categories
  table.insert(lines, "  Categories: ")
  table.insert(lines, "    [1] Beginner   [2] Intermediate   [3] Advanced   [4] Harpoon")
  table.insert(lines, "    [5] Vim Motions   [6] Text Objects   [7] Backend Focus   [8] Workflow")
  table.insert(lines, "    [9] Git Tools   [0] Undo History")
  table.insert(lines, "")
  
  -- Current category
  table.insert(lines, "  Current: " .. state.category:gsub("^%l", string.upper):gsub("_", " "))
  table.insert(lines, "")
  
  -- Current challenge
  local current = state.current_challenges[state.challenge_index]
  if current then
    table.insert(lines, "  Challenge " .. state.challenge_index .. "/" .. #state.current_challenges)
    table.insert(lines, "")
    table.insert(lines, "  " .. current.description)
    table.insert(lines, "")
    
    if show_hint then
      table.insert(lines, "  Hint: " .. current.hint)
      table.insert(lines, "")
    end
    
    -- Last result feedback
    if state.last_result == "correct" then
      table.insert(lines, "  ✓ Correct! The key binding is: " .. current.keybinding)
    elseif state.last_result == "incorrect" then
      table.insert(lines, "  ✗ Incorrect. The key binding is: " .. current.keybinding)
    else
      table.insert(lines, "  Press the key binding to complete this challenge...")
    end
    
    table.insert(lines, "")
  end
  
  -- Stats
  local accuracy = 0
  local total = state.correct_count + state.incorrect_count
  if total > 0 then
    accuracy = math.floor((state.correct_count / total) * 100)
  end
  
  table.insert(lines, "  Stats:")
  table.insert(lines, "    Correct: " .. state.correct_count)
  table.insert(lines, "    Incorrect: " .. state.incorrect_count)
  table.insert(lines, "    Accuracy: " .. accuracy .. "%")
  table.insert(lines, "    Current Streak: " .. state.streak)
  table.insert(lines, "    Best Streak: " .. state.best_streak)
  table.insert(lines, "    Time: " .. format_time(state.session_seconds))
  table.insert(lines, "")
  
  -- Help
  table.insert(lines, "  [n]ext  [p]rev  [r]eset  [?] toggle hint  [q]uit")
  
  -- Set the lines in the buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  
  -- Apply highlights
  local ns_id = vim.api.nvim_create_namespace("KeyTrainer")
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  
  -- Title highlights
  for i=1,7 do
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerTitle", i, 0, -1)
  end
  
  -- Categories highlight
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerCategory", 9, 2, -1)
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerCategory", 10, 0, -1)
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerCategory", 11, 0, -1)
  
  -- Current category highlight
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerButton", 13, 0, -1)
  
  if current then
    -- Challenge number highlight
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerTitle", 15, 0, -1)
    
    -- Description highlight
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerDescription", 17, 0, -1)
    
    -- Hint highlight
    if show_hint then
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerHint", 19, 0, -1)
    end
    
    -- Result highlight
    local result_line = show_hint and 21 or 19
    if state.last_result == "correct" then
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerCorrect", result_line, 0, -1)
    elseif state.last_result == "incorrect" then
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerIncorrect", result_line, 0, -1)
    else
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerStats", result_line, 0, -1)
    end
  end
  
  -- Stats highlights
  local stats_start = current and (show_hint and 24 or 22) or 16
  for i=0,6 do
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerStats", stats_start + i, 0, -1)
  end
  
  -- Help highlight
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "KeyTrainerButton", stats_start + 8, 0, -1)
  
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

-- Update the state based on the challenge result
function M.update_state(correct)
  if correct then
    state.correct_count = state.correct_count + 1
    state.streak = state.streak + 1
    state.last_result = "correct"
    
    -- Update best streak
    if state.streak > state.best_streak then
      state.best_streak = state.streak
    end
  else
    state.incorrect_count = state.incorrect_count + 1
    state.streak = 0
    state.last_result = "incorrect"
  end
  
  M.redraw_ui()
end

-- Set the current challenge category
function M.set_category(category)
  state.category = category
  state.challenge_index = 1
  state.last_result = nil
  
  -- Load challenges for this category
  local challenges = require("keytrainer.challenges")[category]
  if challenges then
    state.current_challenges = challenges
  else
    state.current_challenges = {}
  end
  
  M.redraw_ui()
end

-- Move to the next challenge
function M.next_challenge()
  if #state.current_challenges > 0 then
    state.challenge_index = (state.challenge_index % #state.current_challenges) + 1
    state.last_result = nil
    M.redraw_ui()
  end
end

-- Move to the previous challenge
function M.prev_challenge()
  if #state.current_challenges > 0 then
    state.challenge_index = ((state.challenge_index - 2) % #state.current_challenges) + 1
    state.last_result = nil
    M.redraw_ui()
  end
end

-- Reset statistics
function M.reset_stats()
  state.correct_count = 0
  state.incorrect_count = 0
  state.streak = 0
  state.best_streak = 0
  state.last_result = nil
  state.start_time = os.time()
  state.session_seconds = 0
  M.redraw_ui()
end

-- Get the current challenge
function M.get_current_challenge()
  return state.current_challenges[state.challenge_index]
end

-- Get KeyTrainer bufnr if exists
function M.get_bufnr()
  return vim.fn.bufnr("KeyTrainer")
end

return M
