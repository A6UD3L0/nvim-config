-- Dashboard configuration with beautiful welcome screen
local M = {}

-- Configure the dashboard startup screen
function M.setup()
  -- Define the dashboard options
  local dashboard = require("alpha.themes.dashboard")
  
  -- Custom header with Neovim ASCII art
  dashboard.section.header.val = {
    [[                                                       ]],
    [[                                                       ]],
    [[   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
    [[   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
    [[   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
    [[   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
    [[   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
    [[   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
    [[                                                       ]],
    [[      ⟦ Ultimate ALL Development Environment ⟧          ]],
    [[                                                       ]],
  }
  
  -- Define the menu buttons
  dashboard.section.buttons.val = {
    dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", "  Find word", ":Telescope live_grep <CR>"),
    dashboard.button("p", "  Find project", ":lua require('dashboard').find_project() <CR>"),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("b", "  Plugins", ":e ~/nvim-config/lua/plugins/backend-essentials.lua <CR>"),
    dashboard.button("t", "  Terminal", ":ToggleTerm direction=float<CR>"),
    dashboard.button("m", "  Key Mappings", ":e ~/nvim-config/lua/mappings.lua <CR>"),
    dashboard.button("l", "  LazyGit", ":LazyGit<CR>"),
    dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
  }
  
  -- Footer with quote
  local function footer()
    local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
    local version = vim.version()
    local nvim_version = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch
  
    return datetime .. " " .. nvim_version
  end
  
  dashboard.section.footer.val = footer()
  
  -- Customize colors and layout
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"
  
  -- Configure layout
  dashboard.config.layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
  }
  
  -- Set the dashboard as the startup screen
  require("alpha").setup(dashboard.config)
  
  -- Make find_directory_and_cd accessible to the package/module
  package.loaded['dashboard'] = M
end

-- Add helper functions to the module
M.find_directory_and_cd = function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')
  
  -- Use a more reliable method to find directories with better filtering
  local find_command = {
    'find', '.', '-type', 'd', 
    '-not', '-path', '*/\\.git/*', 
    '-not', '-path', '*/\\node_modules/*', 
    '-not', '-path', '*/__pycache__/*',
    '-not', '-path', '*/\\.pytest_cache/*',
    '-not', '-path', '*/\\venv/*',
    '-not', '-path', '*/\\.venv/*'
  }
  
  -- Create custom previewer to show directory contents
  local dir_previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      return { 'ls', '-la', '--color=always', entry[1] }
    end
  })
  
  pickers.new({}, {
    prompt_title = 'Find Directory',
    finder = finders.new_oneshot_job(find_command, {}),
    sorter = conf.generic_sorter({}),
    previewer = dir_previewer,
    attach_mappings = function(prompt_bufnr, map)
      -- Override default action to change directory and show feedback
      actions.select_default:replace(function()
        local selection = state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        
        -- Change directory to the selected path if it exists and is a directory
        if selection and selection[1] then
          local path = selection[1]
          
          -- Validate that the path exists and is a directory
          if vim.fn.isdirectory(path) == 1 then
            vim.cmd('cd ' .. vim.fn.fnameescape(path))
            
            -- Provide visual feedback to user
            vim.notify('Working directory changed to: ' .. path, 
                      vim.log.levels.INFO, 
                      {title = "Directory Changed"})
            
            -- Show files in new directory with Telescope
            vim.defer_fn(function()
              require('telescope.builtin').find_files({
                cwd = path,
                prompt_title = 'Files in ' .. path
              })
            end, 300) -- Small delay to ensure notification is visible
          else
            vim.notify('Invalid directory: ' .. path, 
                      vim.log.levels.ERROR, 
                      {title = "Directory Error"})
          end
        end
      end)
      return true
    end,
  }):find()
end

-- Enhanced project finder with better UI
M.find_project = function()
  local telescope_ok, telescope = pcall(require, "telescope")
  if not telescope_ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end
  
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local sorters = require("telescope.sorters")
  local dropdown = require("telescope.themes").get_dropdown({
    borderchars = {
      { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    width = 0.8,
    previewer = false,
    prompt_title = "Find Project"
  })
  
  -- Define project directories to search
  local project_dirs = {
    "~/projects",
    "~/Documents",
    "~/work",
    "~/github",
    "~/repos",
    "~/dev",
    "~/personal"
  }
  
  -- Filter out non-existent directories
  local valid_dirs = {}
  for _, dir in ipairs(project_dirs) do
    local expanded = vim.fn.expand(dir)
    if vim.fn.isdirectory(expanded) == 1 then
      table.insert(valid_dirs, expanded)
    end
  end
  
  -- Find all git directories (projects) recursively within the project directories
  local project_list = {}
  for _, dir in ipairs(valid_dirs) do
    -- Use find to locate .git directories (indicating projects)
    local handle = io.popen("find " .. dir .. " -type d -name .git -maxdepth 3 2>/dev/null | xargs -n 1 dirname")
    if handle then
      for project in handle:lines() do
        table.insert(project_list, project)
      end
      handle:close()
    end
  end
  
  -- Show message if no projects found
  if #project_list == 0 then
    vim.notify("No projects found in: " .. table.concat(valid_dirs, ", "), vim.log.levels.WARN)
    return
  end
  
  -- Sort projects by last modified time (most recent first)
  table.sort(project_list, function(a, b)
    local a_time = vim.fn.getftime(a)
    local b_time = vim.fn.getftime(b)
    return a_time > b_time
  end)
  
  -- Create the picker with beautiful styling
  pickers.new(dropdown, {
    finder = finders.new_table({
      results = project_list,
      entry_maker = function(entry)
        local project_name = vim.fn.fnamemodify(entry, ":t")
        local path = entry
        return {
          value = path,
          display = project_name,
          ordinal = project_name,
          path = path,
        }
      end,
    }),
    sorter = sorters.get_fuzzy_file(),
    attach_mappings = function(prompt_bufnr, map)
      -- Define what happens when a project is selected
      actions.select_default:replace(function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Change to project directory
          vim.cmd("cd " .. vim.fn.fnameescape(selection.path))
          
          -- Notify user of directory change
          vim.notify("Project: " .. selection.display, vim.log.levels.INFO, {
            title = "Changed to project",
            icon = "📂",
          })
          
          -- Open project files with Telescope
          vim.defer_fn(function()
            require("telescope.builtin").find_files({
              cwd = selection.path,
              prompt_title = "Files in " .. selection.display,
            })
          end, 100)
        end
      end)
      
      -- Add extra mappings
      map("i", "<C-b>", function()
        local selection = actions_state.get_selected_entry()
        if selection then
          -- Open project in file browser
          vim.cmd("NvimTreeToggle " .. vim.fn.fnameescape(selection.path))
          actions.close(prompt_bufnr)
        end
      end)
      
      -- Add git commands
      map("i", "<C-g>", function()
        local selection = actions_state.get_selected_entry()
        if selection then
          -- Open LazyGit for this project
          vim.cmd("cd " .. vim.fn.fnameescape(selection.path))
          vim.cmd("LazyGit")
          actions.close(prompt_bufnr)
        end
      end)
      
      return true
    end,
  }):find()
end

return M
