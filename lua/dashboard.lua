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
  
  -- Directory finder function - allows selecting a directory to switch to
  local function find_directory_and_cd()
    local telescope = require('telescope.builtin')
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')
    
    telescope.find_files({
      find_command = {'find', '.', '-type', 'd', '-not', '-path', '*/\\.*'},
      prompt_title = 'Find Directory',
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local selection = state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          
          -- Change directory to the selected path
          if selection and selection.path then
            vim.cmd('cd ' .. selection.path)
            -- Provide visual feedback to user
            vim.notify('Working directory changed to: ' .. selection.path, 
                      vim.log.levels.INFO, 
                      {title = "Directory Changed"})
          end
        end)
        return true
      end
    })
  end
  
  -- Define the menu buttons
  dashboard.section.buttons.val = {
    dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", "  Find word", ":Telescope live_grep <CR>"),
    dashboard.button("d", "  Find directory", ":lua require('dashboard').find_directory_and_cd()<CR>"),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("p", "  Plugins", ":e ~/nvim-config/lua/plugins/backend-essentials.lua <CR>"),
    dashboard.button("t", "  Terminal", ":ToggleTerm direction=float<CR>"),
    dashboard.button("y", "  Python Environment", ":VenvSelect<CR>"),
    dashboard.button("m", "  Key Mappings", ":e ~/nvim-config/lua/mappings.lua <CR>"),
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
end

-- Add helper functions to the module
M.find_directory_and_cd = function()
  local telescope = require('telescope.builtin')
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  
  -- Use a more reliable method to find directories
  local find_command = {'find', '.', '-type', 'd', '-not', '-path', '*/\\.git/*', '-not', '-path', '*/\\node_modules/*', '-not', '-path', '*/__pycache__/*'}
  
  pickers.new({}, {
    prompt_title = 'Find Directory',
    finder = finders.new_oneshot_job(find_command, { entry_maker = function(entry)
      return {
        value = entry,
        display = entry,
        ordinal = entry,
        path = entry,
      }
    end}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        
        -- Change directory to the selected path
        if selection and selection.path then
          vim.cmd('cd ' .. vim.fn.fnameescape(selection.path))
          -- Provide visual feedback to user
          vim.notify('Working directory changed to: ' .. selection.path, 
                    vim.log.levels.INFO, 
                    {title = "Directory Changed"})
        end
      end)
      return true
    end,
  }):find()
end

return M
