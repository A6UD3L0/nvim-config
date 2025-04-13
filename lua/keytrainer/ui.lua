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

return M
