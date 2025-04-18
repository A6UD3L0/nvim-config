-- Enhanced Telescope configuration with project awareness and ThePrimeagen-style navigation
local M = {}

function M.setup()
  local status_ok, telescope = pcall(require, "telescope")
  if not status_ok then
    vim.notify("telescope.nvim not found. Navigation features may be limited.", vim.log.levels.WARN)
    return
  end

  local actions = require("telescope.actions")
  local action_layout = require("telescope.actions.layout")
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")

  -- Default dropdown theme with better aesthetics
  local dropdown_theme = themes.get_dropdown({
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    width = 0.8,
    previewer = false,
    prompt_title = false,
    results_title = false,
    preview_title = false,
  })

  -- Larger layout with preview for grep and similar operations
  local ivy_theme = themes.get_ivy({
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    width = 0.95,
    height = 0.85,
    preview_cutoff = 120,
    prompt_title = false,
    results_title = false,
    preview_title = false,
  })

  -- Project awareness utilities
  local function find_git_root()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    
    if current_file == "" then
      current_dir = vim.fn.getcwd()
    else
      current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- Find the Git root directory from the current file's directory
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
      return current_dir
    end
    return git_root
  end

  -- Setup telescope with enhanced configuration
  telescope.setup({
    defaults = {
      prompt_prefix = "🔍 ",
      selection_caret = "❯ ",
      entry_prefix = "  ",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      path_display = { "truncate" },
      dynamic_preview_title = true,
      
      -- Center results after jumping to a file
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-p>"] = action_layout.toggle_preview,
          ["<C-s>"] = actions.toggle_selection,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<C-a>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-h>"] = "which_key",
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-u>"] = false, -- Clear the prompt (default)
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<C-f>"] = actions.preview_scrolling_up,
          ["<esc>"] = actions.close,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        },
        n = {
          ["q"] = actions.close,
          ["<C-c>"] = actions.close,
          ["<CR>"] = actions.select_default + actions.center,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,
          ["<C-p>"] = action_layout.toggle_preview,
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,
          
          -- Center search results on navigation
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<C-f>"] = actions.preview_scrolling_down,
          ["<C-b>"] = actions.preview_scrolling_up,
          
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        },
      },
      
      -- Better file filtering with ripgrep
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- Trim whitespace
        "--hidden", -- Include hidden files
        "--glob=!{.git,node_modules,vendor}/*", -- Exclude common directories
      },
      
      -- Improve performance by ignoring unnecessary files
      file_ignore_patterns = {
        "%.git/",
        "node_modules/",
        "%.cache/",
        "%.DS_Store",
        "vendor/",
        "%.o",
        "%.obj",
        "%.a",
        "%.lib",
        "%.so",
        "%.dylib",
        "%.ncb",
        "%.sdf",
        "%.suo",
        "%.pdb",
        "%.idb",
        "%.class",
        "%.pyo",
        "%.pyc",
        "__pycache__/",
        "%.map",
        "%.zip",
        "%.tar.gz",
        "%.rar",
      },
      set_env = { ["COLORTERM"] = "truecolor" },
      color_devicons = true,
      cache_picker = {
        num_pickers = 10,
        limit_entries = 500,
      },
    },
    
    pickers = {
      -- Optimize individual pickers
      find_files = {
        theme = "dropdown",
        previewer = false,
        hidden = true,
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" },
        file_ignore_patterns = { "node_modules/", ".git/" },
      },
      
      git_files = {
        theme = "dropdown",
        previewer = false,
      },
      
      buffers = {
        theme = "dropdown",
        previewer = false,
        sort_lastused = true,
        sort_mru = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      
      live_grep = {
        debounce = 300,
        layout_strategy = "vertical",
      },
      
      lsp_references = {
        show_line = true,
        include_declaration = false,
        layout_strategy = "vertical",
      },
      
      diagnostics = {
        layout_strategy = "vertical",
        line_width = 120,
      },
    },
    
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      ["ui-select"] = {
        themes.get_dropdown({
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          width = 0.8,
          previewer = false,
        }),
      },
      file_browser = {
        theme = "ivy",
        hijack_netrw = true,
      },
      project = {
        base_dirs = {
          { path = "~/Projects", max_depth = 3 },
          { path = "~/Desktop", max_depth = 2 },
          { path = "~/Code", max_depth = 2 },
        },
        hidden_files = true,
        sync_with_nvim_tree = true,
      },
    },
  })

  -- Load extensions if available
  local extensions = {
    "fzf",
    "ui-select",
    "file_browser",
    "project",
    "notify",
    "frecency",
  }

  for _, ext in ipairs(extensions) do
    pcall(telescope.load_extension, ext)
  end

  -- ThePrimeagen-style navigation functions
  M.project_files = function()
    local opts = dropdown_theme
    
    local git_root = find_git_root()
    if git_root then
      opts.cwd = git_root
      builtin.git_files(opts)
    else
      builtin.find_files(opts)
    end
  end

  -- Smart project search with ripgrep
  M.project_grep = function()
    local opts = ivy_theme
    local git_root = find_git_root()
    if git_root then
      opts.cwd = git_root
    end
    builtin.live_grep(opts)
  end

  -- Quick Harpoon-like mark switching
  M.marks = function()
    builtin.marks(dropdown_theme)
  end

  -- Enhanced oldfiles with project awareness
  M.recent_files = function()
    local opts = dropdown_theme
    opts.only_cwd = true
    builtin.oldfiles(opts)
  end

  -- Better buffer management
  M.buffers = function()
    builtin.buffers(dropdown_theme)
  end

  -- Project finder with better UI
  M.projects = function()
    local ok = pcall(telescope.extensions.project.project, dropdown_theme)
    if not ok then
      vim.notify("Project extension not available. Using find_files instead.", vim.log.levels.INFO)
      builtin.find_files(dropdown_theme)
    end
  end

  return M
end

return M
