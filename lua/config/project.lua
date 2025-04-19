-- Advanced project management with Telescope integration
-- Provides project navigation, quick directory switching, and session management

local M = {}

function M.setup()
  -- Use utility for plugin existence check
  local utils = require('utils')
  local telescope_ok, telescope = utils.require_safe("telescope", "Telescope")
  if not telescope_ok then
    vim.notify("Telescope not found. Project management will be limited.", vim.log.levels.WARN)
    return
  end

  -- Setup project.nvim for better project management
  local project_ok, project = pcall(require, "project_nvim")
  if project_ok then
    project.setup({
      -- Detection methods - look for specific files to identify projects
      detection_methods = { "pattern", "lsp" },
      
      -- Follow where nvim-tree or neotree takes you
      update_focused_file = {
        enable = true,
        update_root = true
      },
      
      -- Patterns to identify projects (specific to backend development)
      patterns = { 
        ".git", -- Git repositories
        "Makefile", -- Make-based projects
        "package.json", -- Node.js projects
        "pyproject.toml", "setup.py", "requirements.txt", -- Python projects
        "go.mod", -- Go projects
        "Cargo.toml", -- Rust projects
        "Dockerfile", "docker-compose.yml", -- Docker projects
        "CMakeLists.txt", -- C/C++ projects
      },
      
      -- Exclude certain directories
      exclude_dirs = {
        "~/.cargo/*",
        "*/node_modules/*",
        "*/venv/*",
        "*/.venv/*",
      },
      
      -- Skip certain directories when searching for projects
      skip_project_dirs = { "/tmp", "~/.cargo" },
      
      -- Enable telescope integration
      enable_telescope_integration = true,
      
      -- Show hidden files in telescope
      show_hidden = true,
      
      -- Silent mode
      silent_chdir = false,
    })

    -- Load telescope extension
    pcall(telescope.load_extension, "projects")
  end

  -- Setup session management with auto-session
  local auto_session_ok, auto_session = pcall(require, "auto-session")
  if auto_session_ok then
    -- Configure auto-session for persistent workspace states
    auto_session.setup({
      log_level = "error",
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents" },
      auto_session_use_git_branch = true,
      -- Customize session names based on directory
      session_lens = {
        theme_conf = { border = true },
        previewer = false,
      },
    })
  end

  -- Load telescope-file-browser for enhanced file navigation
  pcall(telescope.load_extension, "file_browser")
  
  -- Setup project-specific keybindings
  local keymap = vim.keymap.set
  
  -- Project navigation (telescope integration)
  keymap("n", "<leader>pp", function()
    if telescope.extensions.projects then
      telescope.extensions.projects.projects({})
    else
      vim.notify("Telescope projects extension not available", vim.log.levels.WARN)
    end
  end, { desc = "List projects" })
  
  -- File browser with project awareness
  keymap("n", "<leader>pf", function()
    if telescope.extensions.file_browser then
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.getcwd(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 40 },
      })
    else
      vim.notify("Telescope file browser extension not available", vim.log.levels.WARN)
      -- Fallback to regular find_files
      require("telescope.builtin").find_files()
    end
  end, { desc = "Browse project files" })
  
  -- Recent projects
  keymap("n", "<leader>pr", function()
    if telescope.extensions.projects then
      telescope.extensions.projects.projects({})
    else
      -- Fallback to oldfiles
      require("telescope.builtin").oldfiles()
    end
  end, { desc = "Recent projects" })
  
  -- Session management keybindings
  if auto_session_ok then
    keymap("n", "<leader>ps", "<cmd>SaveSession<CR>", { desc = "Save session" })
    keymap("n", "<leader>pl", "<cmd>RestoreSession<CR>", { desc = "Load session" })
    keymap("n", "<leader>pd", "<cmd>DeleteSession<CR>", { desc = "Delete session" })
  end
  
  -- Quick directory change
  keymap("n", "<leader>cd", function()
    vim.ui.input({ prompt = "Change directory: ", default = vim.fn.getcwd() }, function(input)
      if input then
        vim.cmd("cd " .. input)
        vim.notify("Changed directory to: " .. input, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Change directory" })
  
  -- Find files in project
  keymap("n", "<leader>pF", function()
    require("telescope.builtin").find_files({
      hidden = true,
      no_ignore = true,
    })
  end, { desc = "Find all files" })
  
  -- Find in project
  keymap("n", "<leader>pg", function()
    require("telescope.builtin").live_grep()
  end, { desc = "Grep in project" })
  
  -- Create a work diary entry (documentation)
  keymap("n", "<leader>pw", function()
    -- Format the current date as YYYY-MM-DD
    local date = os.date("%Y-%m-%d")
    local diary_dir = vim.fn.expand("~/work-diary")
    
    -- Create the diary directory if it doesn't exist
    if vim.fn.isdirectory(diary_dir) == 0 then
      vim.fn.mkdir(diary_dir, "p")
    end
    
    -- Create and open the diary file for today
    local diary_file = string.format("%s/%s.md", diary_dir, date)
    vim.cmd("edit " .. diary_file)
    
    -- If the file is empty, add a template
    if vim.fn.getfsize(diary_file) <= 0 then
      local lines = {
        "# Work Diary - " .. date,
        "",
        "## Goals for Today",
        "",
        "- [ ] ",
        "",
        "## Notes",
        "",
        "## Completed",
        "",
        "## Blockers",
        "",
        "## Tomorrow",
        "",
      }
      vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
      -- Position cursor at the first goal
      vim.api.nvim_win_set_cursor(0, {5, 6})
    end
  end, { desc = "Work diary entry" })
  
  -- Register with which-key if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>p"] = { name = "+project" },
    })
  end
end

return M
