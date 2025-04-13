-- DataScienceTrainer UI module
-- Manages the user interface for the data science training game

local M = {}

-- UI state
local bufnr = -1
local winnr = -1
local current_challenge = nil
local current_category = nil
local current_level = nil
local challenge_result = nil
local challenge_output = ""

-- Create the game UI window
function M.create_ui()
  -- Calculate dimensions (80% of window size)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  
  -- Calculate position (centered)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Create buffer
  bufnr = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
  
  -- Window options
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " DataScienceTrainer ",
    title_pos = "center",
  }
  
  -- Create window
  winnr = vim.api.nvim_open_win(bufnr, true, opts)
  
  -- Set window options
  vim.api.nvim_win_set_option(winnr, "wrap", true)
  vim.api.nvim_win_set_option(winnr, "winhl", "Normal:DataScienceTrainerWindow")
  
  -- Set mappings in the buffer
  M.set_keymaps()
  
  -- Return buffer number
  return bufnr
end

-- Set keymaps for the game window
function M.set_keymaps()
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- Navigation
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua require('datasciencetrainer').stop_game()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":lua require('datasciencetrainer').stop_game()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "n", ":lua require('datasciencetrainer.ui').next_challenge()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "p", ":lua require('datasciencetrainer.ui').prev_challenge()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "h", ":lua require('datasciencetrainer.ui').show_hint()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "r", ":lua require('datasciencetrainer.ui').run_challenge()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "s", ":lua require('datasciencetrainer.ui').show_solution()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "c", ":lua require('datasciencetrainer.ui').select_category()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "l", ":lua require('datasciencetrainer.ui').select_level()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "o", ":lua require('datasciencetrainer.ui').open_in_editor()<CR>", opts)
end

-- Close UI and clean up
function M.close()
  if winnr > 0 and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_win_close(winnr, true)
  end
  
  if bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
  
  bufnr = -1
  winnr = -1
  current_challenge = nil
end

-- Get buffer number (for reference)
function M.get_bufnr()
  return bufnr
end

-- Set the current category and load first challenge
function M.set_category(category)
  local challenges = require("datasciencetrainer.challenges")
  
  if not category or not challenges[category] then
    category = "basics"
  end
  
  current_category = category
  current_level = nil -- Reset level filter when changing category
  
  -- Load first challenge
  if challenges[category] and #challenges[category] > 0 then
    current_challenge = challenges[category][1]
    M.display_challenge(current_challenge)
  else
    M.display_text("No challenges found for category: " .. category)
  end
end

-- Set the difficulty level filter
function M.set_level(level)
  local challenges = require("datasciencetrainer.challenges")
  
  current_level = level
  
  -- Get challenges for current category and level
  local filtered_challenges = challenges.get_challenges(current_category, current_level)
  
  if #filtered_challenges > 0 then
    current_challenge = filtered_challenges[1]
    M.display_challenge(current_challenge)
  else
    M.display_text("No challenges found for category: " .. current_category .. " and level: " .. level)
  end
end

-- Display the current challenge in the UI
function M.display_challenge(challenge)
  if not challenge or not bufnr or not winnr then
    return
  end
  
  current_challenge = challenge
  challenge_result = nil
  challenge_output = ""
  
  -- Format the challenge information
  local lines = {}
  table.insert(lines, "# " .. challenge.title)
  table.insert(lines, "")
  table.insert(lines, "*Category: " .. challenge.category .. " | Level: " .. challenge.level .. "*")
  table.insert(lines, "")
  table.insert(lines, "## Description")
  table.insert(lines, challenge.description)
  table.insert(lines, "")
  table.insert(lines, "## Task")
  table.insert(lines, challenge.task)
  table.insert(lines, "")
  
  -- Show dependencies if any
  if challenge.dependencies and #challenge.dependencies > 0 then
    table.insert(lines, "## Dependencies")
    table.insert(lines, "```")
    table.insert(lines, table.concat(challenge.dependencies, ", "))
    table.insert(lines, "```")
    table.insert(lines, "")
  end
  
  -- Add controls help
  table.insert(lines, "## Controls")
  table.insert(lines, "- [n] Next challenge | [p] Previous challenge")
  table.insert(lines, "- [h] Show hint | [s] Show solution")
  table.insert(lines, "- [r] Run challenge | [o] Open in editor")
  table.insert(lines, "- [c] Change category | [l] Change level")
  table.insert(lines, "- [q]/[Esc] Quit game")
  
  -- Insert text into buffer
  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

-- Update state after challenge attempt
function M.update_state(success, output)
  challenge_result = success
  
  if output then
    challenge_output = output
  end
  
  -- Update the display to show result
  if current_challenge then
    local lines = {}
    
    table.insert(lines, "# " .. current_challenge.title)
    table.insert(lines, "")
    table.insert(lines, "*Category: " .. current_challenge.category .. " | Level: " .. current_challenge.level .. "*")
    table.insert(lines, "")
    
    if success then
      table.insert(lines, "## ✅ Success!")
      table.insert(lines, "")
      table.insert(lines, "Great job! You've completed this challenge successfully.")
    else
      table.insert(lines, "## ❌ Try Again")
      table.insert(lines, "")
      table.insert(lines, "Your solution didn't quite match the expected output. Check the hints or solution for guidance.")
    end
    
    table.insert(lines, "")
    table.insert(lines, "## Description")
    table.insert(lines, current_challenge.description)
    table.insert(lines, "")
    table.insert(lines, "## Task")
    table.insert(lines, current_challenge.task)
    table.insert(lines, "")
    
    if challenge_output and challenge_output ~= "" then
      table.insert(lines, "## Output")
      table.insert(lines, "```")
      table.insert(lines, challenge_output)
      table.insert(lines, "```")
      table.insert(lines, "")
    end
    
    -- Add controls help
    table.insert(lines, "## Controls")
    table.insert(lines, "- [n] Next challenge | [p] Previous challenge")
    table.insert(lines, "- [h] Show hint | [s] Show solution")
    table.insert(lines, "- [r] Run challenge | [o] Open in editor")
    table.insert(lines, "- [c] Change category | [l] Change level")
    table.insert(lines, "- [q]/[Esc] Quit game")
    
    -- Insert text into buffer
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  end
end

-- Show a hint for the current challenge
function M.show_hint()
  if not current_challenge or not current_challenge.hints or #current_challenge.hints == 0 then
    vim.notify("No hints available for this challenge", vim.log.levels.INFO)
    return
  end
  
  -- Get random hint
  local hint_index = math.random(1, #current_challenge.hints)
  local hint = current_challenge.hints[hint_index]
  
  -- Show floating window with hint
  local width = math.min(80, vim.o.columns - 4)
  local height = 3
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Calculate position (centered)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Buffer content
  local hint_lines = {
    "Hint " .. hint_index .. "/" .. #current_challenge.hints .. ":",
    hint,
    "Press any key to close"
  }
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, hint_lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  
  -- Create window
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " Hint ",
    title_pos = "center",
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Close on any keypress
  local close_keys = {"n", "q", "<Esc>", "<CR>", "<Space>"}
  
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_win_close(win, true)
      end
    })
  end
end

-- Show the solution for the current challenge
function M.show_solution()
  if not current_challenge or not current_challenge.solution then
    vim.notify("No solution available for this challenge", vim.log.levels.INFO)
    return
  end
  
  -- Show floating window with solution
  local width = math.min(80, vim.o.columns - 4)
  local height = 20 -- Taller to fit code
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Calculate position (centered)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Buffer content: split solution into lines
  local solution_lines = vim.split(current_challenge.solution, "\n")
  table.insert(solution_lines, "")
  table.insert(solution_lines, "Press any key to close")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, solution_lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "python") -- Assuming Python for syntax highlighting
  
  -- Create window
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " Solution ",
    title_pos = "center",
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Close on any keypress
  local close_keys = {"n", "q", "<Esc>", "<CR>", "<Space>"}
  
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_win_close(win, true)
      end
    })
  end
end

-- Move to the next challenge
function M.next_challenge()
  if not current_challenge or not current_category then
    return
  end
  
  local challenges = require("datasciencetrainer.challenges")
  local all_challenges
  
  if current_level then
    all_challenges = challenges.get_challenges(current_category, current_level)
  else
    all_challenges = challenges[current_category]
  end
  
  if not all_challenges or #all_challenges == 0 then
    return
  end
  
  -- Find current challenge index
  local current_index = 0
  for i, challenge in ipairs(all_challenges) do
    if challenge.id == current_challenge.id then
      current_index = i
      break
    end
  end
  
  -- Move to next challenge or wrap around
  local next_index = (current_index % #all_challenges) + 1
  current_challenge = all_challenges[next_index]
  M.display_challenge(current_challenge)
end

-- Move to the previous challenge
function M.prev_challenge()
  if not current_challenge or not current_category then
    return
  end
  
  local challenges = require("datasciencetrainer.challenges")
  local all_challenges
  
  if current_level then
    all_challenges = challenges.get_challenges(current_category, current_level)
  else
    all_challenges = challenges[current_category]
  end
  
  if not all_challenges or #all_challenges == 0 then
    return
  end
  
  -- Find current challenge index
  local current_index = 0
  for i, challenge in ipairs(all_challenges) do
    if challenge.id == current_challenge.id then
      current_index = i
      break
    end
  end
  
  -- Move to previous challenge or wrap around
  local prev_index = ((current_index - 2) % #all_challenges) + 1
  current_challenge = all_challenges[prev_index]
  M.display_challenge(current_challenge)
end

-- Run the current challenge
function M.run_challenge()
  if not current_challenge then
    return
  end
  
  -- Create a temporary file for editing
  local file_content = current_challenge.solution or "# Write your solution here\n\n"
  local dst = require("datasciencetrainer")
  local temp_file = dst.create_temp_file(file_content, "py")
  
  if not temp_file then
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end
  
  -- Remember previous window and set up autocmd to return
  local prev_win = vim.api.nvim_get_current_win()
  
  -- Create scratch buffer
  vim.cmd("split " .. temp_file)
  
  -- Setup autocmd to run code when saving
  local augroup = vim.api.nvim_create_augroup("DataScienceTrainer", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = temp_file,
    callback = function()
      -- Get file content and run it
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local code = table.concat(lines, "\n")
      
      -- Run the code
      local dst = require("datasciencetrainer")
      local executor = require("datasciencetrainer.executor")
      local result = executor.run_code(code, "python")
      
      -- Check if solution matches expected output
      local success = dst.check_solution(result, current_challenge.expected_output)
      
      -- Update UI
      dst.handle_action("run_code", { code = code, language = "python" })
      
      -- Show result notification
      if success then
        vim.notify("Challenge completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("Challenge not yet complete. Keep trying!", vim.log.levels.WARN)
      end
    end
  })
end

-- Open the current challenge in a proper editor window
function M.open_in_editor()
  if not current_challenge then
    return
  end
  
  -- Create a structured file with the challenge instructions and starter code
  local content = {
    "# " .. current_challenge.title,
    "# Category: " .. current_challenge.category .. " | Level: " .. current_challenge.level,
    "#",
    "# Description:",
    "# " .. current_challenge.description,
    "#",
    "# Task:",
    "# " .. current_challenge.task,
    "#",
    "# Dependencies:",
  }
  
  -- Add dependencies
  if current_challenge.dependencies and #current_challenge.dependencies > 0 then
    for _, dep in ipairs(current_challenge.dependencies) do
      table.insert(content, "# - " .. dep)
    end
  else
    table.insert(content, "# None")
  end
  
  table.insert(content, "#")
  table.insert(content, "# Expected Output:")
  table.insert(content, "# " .. current_challenge.expected_output)
  table.insert(content, "#")
  table.insert(content, "# Write your solution below:")
  table.insert(content, "")
  
  -- Add starter code or solution if available
  if current_challenge.solution then
    local solution_lines = vim.split(current_challenge.solution, "\n")
    for _, line in ipairs(solution_lines) do
      table.insert(content, line)
    end
  else
    table.insert(content, "# Your code here")
  end
  
  -- Create temp file
  local dst = require("datasciencetrainer")
  local temp_file = dst.create_temp_file(table.concat(content, "\n"), "py")
  
  if not temp_file then
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end
  
  -- Open in new buffer/window
  vim.cmd("tabnew " .. temp_file)
  
  -- Setup autocmd for evaluation
  local augroup = vim.api.nvim_create_augroup("DataScienceTrainerEditor", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = temp_file,
    callback = function()
      -- Get file content and run it
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      
      -- Extract just the code (skip comments at top)
      local code_start = 0
      for i, line in ipairs(lines) do
        if not line:match("^#") and line:match("%S") then
          code_start = i
          break
        end
      end
      
      -- If no code found, use all lines
      if code_start == 0 then
        code_start = 1
      end
      
      local code_lines = {}
      for i = code_start, #lines do
        table.insert(code_lines, lines[i])
      end
      
      local code = table.concat(code_lines, "\n")
      
      -- Run the code
      local dst = require("datasciencetrainer")
      local executor = require("datasciencetrainer.executor")
      local result = executor.run_code(code, "python")
      
      -- Check if solution matches expected output
      local success = dst.check_solution(result, current_challenge.expected_output)
      
      -- Open results in split window
      vim.cmd("split")
      local results_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(0, results_buf)
      
      local result_lines = {
        "# Execution Results",
        "#" .. string.rep("-", 40),
        "",
        result,
        "",
        "#" .. string.rep("-", 40),
        "# Expected Output:",
        "# " .. current_challenge.expected_output,
        "",
        success and "# ✅ Challenge completed successfully!" or "# ❌ Output does not match expected result. Keep trying!",
      }
      
      vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, result_lines)
      vim.api.nvim_buf_set_option(results_buf, "modifiable", false)
      vim.api.nvim_buf_set_option(results_buf, "filetype", "markdown")
      
      -- Update UI in the game window if it exists
      dst.handle_action("run_code", { code = code, language = "python" })
    end
  })
end

-- Select category from a menu
function M.select_category()
  local challenges = require("datasciencetrainer.challenges")
  
  -- Create menu items
  local items = {}
  for _, category in ipairs(challenges.categories) do
    table.insert(items, {
      text = category:gsub("^%l", string.upper), -- Capitalize first letter
      value = category
    })
  end
  
  -- Display menu
  vim.ui.select(items, {
    prompt = "Select Category:",
    format_item = function(item) return item.text end
  }, function(choice)
    if choice then
      M.set_category(choice.value)
    end
  end)
end

-- Select level from a menu
function M.select_level()
  local challenges = require("datasciencetrainer.challenges")
  
  -- Create menu items
  local items = {}
  for _, level in ipairs(challenges.levels) do
    table.insert(items, {
      text = level:gsub("^%l", string.upper), -- Capitalize first letter
      value = level
    })
  end
  
  -- Add "all levels" option
  table.insert(items, 1, {
    text = "All Levels",
    value = nil
  })
  
  -- Display menu
  vim.ui.select(items, {
    prompt = "Select Level:",
    format_item = function(item) return item.text end
  }, function(choice)
    if choice then
      M.set_level(choice.value)
    end
  end)
end

-- Display text in the UI window
function M.display_text(text)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  
  -- Insert text into buffer
  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {text})
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

return M
