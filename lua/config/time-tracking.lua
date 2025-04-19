-- Code time tracking configuration
-- Tracks coding time, file types, and projects

local M = {}

function M.setup()
  -- Use utility for directory and file creation
  local utils = require('utils')

  -- Check if wakatime plugin is available
  if not pcall(function() vim.cmd("WakaTimeApiKey") end) then
    vim.notify("WakaTime plugin not found. Code time tracking will be limited.", vim.log.levels.INFO)
  end
  
  -- Set up for the code stats dashboard creation
  -- Create directory for reports if it doesn't exist
  local stats_dir = vim.fn.stdpath("data") .. "/codestats"
  utils.ensure_dir_exists(stats_dir)
  
  -- Track which filetypes we're spending time in
  local filetype_times = {}
  local session_start_time = os.time()
  local current_file = ""
  local current_filetype = ""
  local stats_file = stats_dir .. "/stats.json"
  utils.ensure_file_exists(stats_file)
  
  -- Initialize or load existing stats
  local function load_stats()
    if vim.fn.filereadable(stats_file) == 1 then
      local content = vim.fn.readfile(stats_file)
      if #content > 0 then
        local json_str = table.concat(content, "\n")
        local ok, stats = pcall(vim.fn.json_decode, json_str)
        if ok and stats then
          return stats
        end
      end
    end
    -- Default stats structure
    return {
      total_time = 0,
      filetypes = {},
      projects = {},
      days = {},
    }
  end
  
  -- Save stats to disk
  local function save_stats(stats)
    local json_str = vim.fn.json_encode(stats)
    vim.fn.writefile({json_str}, stats_file)
  end
  
  -- Update filetype timing
  local function update_filetype_time()
    if current_filetype ~= "" then
      local now = os.time()
      local elapsed = now - (filetype_times[current_filetype] or session_start_time)
      filetype_times[current_filetype] = now
      
      -- Update stats file
      local stats = load_stats()
      
      -- Update total time
      stats.total_time = stats.total_time + elapsed
      
      -- Update filetype stats
      stats.filetypes[current_filetype] = (stats.filetypes[current_filetype] or 0) + elapsed
      
      -- Update project stats (use git for project detection)
      local project = "unknown"
      local git_dir = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")
      if vim.v.shell_error == 0 then
        project = vim.fn.fnamemodify(git_dir:gsub("\n", ""), ":t")
      else
        project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
      stats.projects[project] = (stats.projects[project] or 0) + elapsed
      
      -- Update daily stats
      local day = os.date("%Y-%m-%d")
      stats.days[day] = (stats.days[day] or 0) + elapsed
      
      -- Save updated stats
      save_stats(stats)
    end
  end
  
  -- Set up autocommands for tracking
  local tracking_group = vim.api.nvim_create_augroup("CodeTimeTracking", { clear = true })
  
  -- Track filetype changes
  vim.api.nvim_create_autocmd({"BufEnter"}, {
    group = tracking_group,
    callback = function()
      local ft = vim.bo.filetype
      if ft == "" then ft = "unknown" end
      
      -- Update previous filetype time first
      update_filetype_time()
      
      -- Update current file info
      current_file = vim.api.nvim_buf_get_name(0)
      current_filetype = ft
      filetype_times[current_filetype] = os.time()
    end
  })
  
  -- Track BufLeave to save stats on buffer leave
  vim.api.nvim_create_autocmd({"BufLeave"}, {
    group = tracking_group,
    callback = function()
      update_filetype_time()
    end
  })
  
  -- Track CursorHold and CursorHoldI to save stats periodically
  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    group = tracking_group,
    callback = function()
      update_filetype_time()
    end
  })
  
  -- Track VimLeave to save stats on exit
  vim.api.nvim_create_autocmd({"VimLeavePre"}, {
    group = tracking_group,
    callback = function()
      update_filetype_time()
    end
  })
  
  -- Show time tracking dashboard
  M.show_dashboard = function()
    local stats = load_stats()
    
    -- Create a temporary buffer for the dashboard
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Format time as hours:minutes
    local function format_time(seconds)
      local hours = math.floor(seconds / 3600)
      local minutes = math.floor((seconds % 3600) / 60)
      return string.format("%dh %dm", hours, minutes)
    end
    
    -- Create dashboard content
    local lines = {
      "# Coding Statistics Dashboard",
      "",
      "## Total Coding Time",
      format_time(stats.total_time),
      "",
      "## Time By Language",
      "```",
    }
    
    -- Sort filetypes by time spent
    local filetypes = {}
    for ft, time in pairs(stats.filetypes) do
      table.insert(filetypes, {ft = ft, time = time})
    end
    table.sort(filetypes, function(a, b) return a.time > b.time end)
    
    -- Add filetype stats
    for _, item in ipairs(filetypes) do
      if item.time > 60 then -- Only show if more than a minute
        table.insert(lines, string.format("%-15s %s", item.ft, format_time(item.time)))
      end
    end
    
    table.insert(lines, "```")
    table.insert(lines, "")
    table.insert(lines, "## Time By Project")
    table.insert(lines, "```")
    
    -- Sort projects by time spent
    local projects = {}
    for proj, time in pairs(stats.projects) do
      table.insert(projects, {proj = proj, time = time})
    end
    table.sort(projects, function(a, b) return a.time > b.time end)
    
    -- Add project stats
    for _, item in ipairs(projects) do
      if item.time > 60 then -- Only show if more than a minute
        table.insert(lines, string.format("%-20s %s", item.proj, format_time(item.time)))
      end
    end
    
    table.insert(lines, "```")
    table.insert(lines, "")
    table.insert(lines, "## Recent Activity")
    table.insert(lines, "```")
    
    -- Sort days
    local days = {}
    for day, time in pairs(stats.days) do
      table.insert(days, {day = day, time = time})
    end
    table.sort(days, function(a, b) return a.day > b.day end)
    
    -- Show recent days (up to 7)
    local count = 0
    for _, item in ipairs(days) do
      if count < 7 then
        table.insert(lines, string.format("%-12s %s", item.day, format_time(item.time)))
        count = count + 1
      end
    end
    
    table.insert(lines, "```")
    
    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    -- Open in a floating window
    local width = math.min(80, vim.o.columns - 4)
    local height = math.min(#lines, vim.o.lines - 4)
    
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded"
    })
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    
    -- Close with 'q'
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", {noremap = true, silent = true})
    
    -- Set window options
    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.api.nvim_win_set_option(win, "winblend", 10)
    
    return buf, win
  end
  
  -- Global keymaps
  local keymap = vim.keymap.set
  
  -- Show time tracking dashboard
  keymap("n", "<leader>sd", M.show_dashboard, { desc = "Show coding stats dashboard" })
  
  -- Register with which-key if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>s"] = { name = "+stats" },
    })
  end
end

return M
