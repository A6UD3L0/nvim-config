-- UI Keybindings Module
-- Controls themes, colors, and visual settings
-- Provides consistent interface for UI adjustments

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Theme Controls                       │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Register UI/theme group
  keybindings.register_group("<leader>u", "UI", "", "#BB9AF7") -- UI (purple)
  keybindings.register_group("<leader>ut", "Theme", "", "#BB9AF7")
  
  -- Toggle themes between light and dark
  map("n", "<leader>ut", function()
    if vim.o.background == "dark" then
      vim.o.background = "light"
      vim.notify("Theme: Light mode", vim.log.levels.INFO)
    else
      vim.o.background = "dark"
      vim.notify("Theme: Dark mode", vim.log.levels.INFO)
    end
  end, { desc = "Toggle light/dark theme" })
  
  -- Cycle through colorschemes
  map("n", "<leader>uc", function()
    -- Get list of installed colorschemes
    local colors = vim.fn.getcompletion("", "color")
    
    -- If we have a reasonable number of themes, offer to choose
    if #colors > 0 and #colors < 50 then
      vim.ui.select(colors, {
        prompt = "Select colorscheme:",
        format_item = function(item)
          return item
        end,
      }, function(choice)
        if choice then
          vim.cmd("colorscheme " .. choice)
          vim.notify("Colorscheme: " .. choice, vim.log.levels.INFO)
        end
      end)
    else
      -- Ask for colorscheme name if too many options
      vim.ui.input({ prompt = "Colorscheme name: " }, function(input)
        if input and input ~= "" then
          local ok, _ = pcall(vim.cmd, "colorscheme " .. input)
          if ok then
            vim.notify("Colorscheme: " .. input, vim.log.levels.INFO)
          else
            vim.notify("Invalid colorscheme: " .. input, vim.log.levels.ERROR)
          end
        end
      end)
    end
  end, { desc = "Change colorscheme" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     UI Toggles                            │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Toggle relative line numbers
  map("n", "<leader>ur", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.notify("Relative line numbers: " .. (vim.wo.relativenumber and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle relative numbers" })
  
  -- Toggle line wrap
  map("n", "<leader>uw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify("Line wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle line wrap" })
  
  -- Toggle cursor line highlight
  map("n", "<leader>ul", function()
    vim.wo.cursorline = not vim.wo.cursorline
    vim.notify("Cursor line: " .. (vim.wo.cursorline and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle cursor line" })
  
  -- Toggle cursor column highlight
  map("n", "<leader>uc", function()
    vim.wo.cursorcolumn = not vim.wo.cursorcolumn
    vim.notify("Cursor column: " .. (vim.wo.cursorcolumn and "ON" or "OFF"), vim.log.levels.INFO)
  end, { desc = "Toggle cursor column" })
  
  -- Toggle signcolumn
  map("n", "<leader>us", function()
    if vim.wo.signcolumn == "yes" then
      vim.wo.signcolumn = "no"
      vim.notify("Sign column: OFF", vim.log.levels.INFO)
    else
      vim.wo.signcolumn = "yes"
      vim.notify("Sign column: ON", vim.log.levels.INFO)
    end
  end, { desc = "Toggle sign column" })
  
  -- Toggle indent guides
  map("n", "<leader>ui", function()
    -- Check if indent-blankline is available
    local has_ibl, ibl = utils.has_plugin("ibl")
    if has_ibl then
      -- For indent-blankline.nvim v3+
      ibl.setup_buffer(0, { enabled = not ibl.get_config(0).enabled })
      vim.notify("Indent guides: " .. (ibl.get_config(0).enabled and "ON" or "OFF"), vim.log.levels.INFO)
    else
      -- Fallback to listchars
      vim.wo.list = not vim.wo.list
      vim.notify("Indent guides (listchars): " .. (vim.wo.list and "ON" or "OFF"), vim.log.levels.INFO)
    end
  end, { desc = "Toggle indent guides" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Focus Modes                           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Zen mode toggle
  map("n", "<leader>uz", function()
    -- Check for zen-mode plugins
    local has_zen_mode, zen_mode = utils.has_plugin("zen-mode")
    if has_zen_mode then
      zen_mode.toggle()
      return
    end
    
    -- Fallback implementation if zen-mode is not available
    if vim.g.zen_mode_active then
      -- Restore previous settings
      vim.o.number = vim.g.zen_mode_prev_number
      vim.o.relativenumber = vim.g.zen_mode_prev_relativenumber
      vim.o.signcolumn = vim.g.zen_mode_prev_signcolumn
      vim.o.showcmd = vim.g.zen_mode_prev_showcmd
      vim.o.ruler = vim.g.zen_mode_prev_ruler
      vim.o.laststatus = vim.g.zen_mode_prev_laststatus
      vim.g.zen_mode_active = false
      vim.notify("Zen mode: OFF", vim.log.levels.INFO)
    else
      -- Save current settings
      vim.g.zen_mode_prev_number = vim.o.number
      vim.g.zen_mode_prev_relativenumber = vim.o.relativenumber
      vim.g.zen_mode_prev_signcolumn = vim.o.signcolumn
      vim.g.zen_mode_prev_showcmd = vim.o.showcmd
      vim.g.zen_mode_prev_ruler = vim.o.ruler
      vim.g.zen_mode_prev_laststatus = vim.o.laststatus
      
      -- Apply zen mode settings
      vim.o.number = false
      vim.o.relativenumber = false
      vim.o.signcolumn = "no"
      vim.o.showcmd = false
      vim.o.ruler = false
      vim.o.laststatus = 0
      vim.g.zen_mode_active = true
      vim.notify("Zen mode: ON", vim.log.levels.INFO)
    end
  end, { desc = "Toggle zen mode" })
  
  -- Toggle transparency
  map("n", "<leader>ub", function()
    if vim.g.transparent_enabled then
      -- If using transparent.nvim
      local has_transparent, transparent = utils.has_plugin("transparent")
      if has_transparent then
        transparent.toggle()
        return
      end
      
      -- Manual fallback
      vim.g.transparent_enabled = false
      vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
      vim.notify("Background transparency: ON", vim.log.levels.INFO)
    else
      vim.g.transparent_enabled = true
      vim.cmd("colorscheme " .. (vim.g.colors_name or "default"))
      vim.notify("Background transparency: OFF", vim.log.levels.INFO)
    end
  end, { desc = "Toggle background transparency" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Status Line                           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Toggle statusline visibility
  map("n", "<leader>us", function()
    if vim.o.laststatus == 0 then
      vim.o.laststatus = 2
      vim.notify("Status line: ON", vim.log.levels.INFO)
    else
      vim.o.laststatus = 0
      vim.notify("Status line: OFF", vim.log.levels.INFO)
    end
  end, { desc = "Toggle status line" })
  
  -- Toggle tabline visibility
  map("n", "<leader>ut", function()
    if vim.o.showtabline == 0 then
      vim.o.showtabline = 2
      vim.notify("Tab line: ALWAYS", vim.log.levels.INFO)
    elseif vim.o.showtabline == 2 then
      vim.o.showtabline = 1
      vim.notify("Tab line: AUTO", vim.log.levels.INFO)
    else
      vim.o.showtabline = 0
      vim.notify("Tab line: NEVER", vim.log.levels.INFO)
    end
  end, { desc = "Cycle tab line visibility" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Dashboard                             │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Show dashboard
  map("n", "<leader>ud", function()
    -- Check for various dashboard plugins
    local has_alpha, alpha = utils.has_plugin("alpha")
    if has_alpha then
      vim.cmd("Alpha")
      return
    end
    
    local has_dashboard, _ = utils.has_plugin("dashboard-nvim")
    if has_dashboard then
      vim.cmd("Dashboard")
      return
    end
    
    local has_startup, _ = utils.has_plugin("startup")
    if has_startup then
      vim.cmd("Startup")
      return
    end
    
    -- Fallback to built-in startify if available
    if vim.fn.exists(":Startify") == 2 then
      vim.cmd("Startify")
      return
    end
    
    vim.notify("No dashboard plugin found", vim.log.levels.WARN)
  end, { desc = "Open dashboard" })
end

return M
