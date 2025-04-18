-- Enhanced Harpoon configuration for rapid file navigation (ThePrimeagen style)
local M = {}

function M.setup()
  local status_ok, harpoon = pcall(require, "harpoon")
  if not status_ok then
    vim.notify("Harpoon not found. Quick navigation may not work.", vim.log.levels.WARN)
    return
  end
  
  -- Configure with project-based mark lists and enhanced UI
  harpoon:setup({
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      save_on_change = true,
      -- Create a dedicated mark list per git branch
      mark_branch = true,
      -- Enhanced color for marked items
      mark_color = { fg = "#ff9e64" },
      -- Enhance UI appearance
      tabline = false,
      tabline_prefix = " ",
      tabline_suffix = " ",
      
      -- Controls for file navigation
      key_nav = {
        up = "<C-k>",
        down = "<C-j>",
        left = "<C-h>",
        right = "<C-l>",
      },
    },
    -- Files that shouldn't be marked by default
    excluded_filetypes = { "harpoon", "TelescopePrompt", "NvimTree", "neo-tree", "dashboard", "alpha" },
  })
  
  -- Set up key mappings in ThePrimeagen style
  local keymap = vim.keymap.set
  
  -- Main harpoon commands
  keymap("n", "<leader>ha", function() harpoon:list():add() end, 
    { desc = "Harpoon: Add file" })
  
  keymap("n", "<leader>hh", function() 
    harpoon.ui:toggle_quick_menu(harpoon:list()) 
  end, { desc = "Harpoon: Toggle menu" })
  
  -- Quick navigation to harpoon marks (ThePrimeagen style)
  keymap("n", "<C-h>", function() harpoon:list():select(1) end, 
    { desc = "Harpoon: Jump to file 1" })
  
  keymap("n", "<C-t>", function() harpoon:list():select(2) end, 
    { desc = "Harpoon: Jump to file 2" })
  
  keymap("n", "<C-n>", function() harpoon:list():select(3) end, 
    { desc = "Harpoon: Jump to file 3" })
  
  keymap("n", "<C-s>", function() harpoon:list():select(4) end, 
    { desc = "Harpoon: Jump to file 4" })
  
  -- Navigate through marks sequentially
  keymap("n", "<leader>hp", function() harpoon:list():prev() end, 
    { desc = "Harpoon: Previous mark" })
  
  keymap("n", "<leader>hn", function() harpoon:list():next() end, 
    { desc = "Harpoon: Next mark" })
  
  -- Clear all marks for current project
  keymap("n", "<leader>hc", function() 
    harpoon:list():clear()
    vim.notify("Harpoon marks cleared", vim.log.levels.INFO)
  end, { desc = "Harpoon: Clear all marks" })
  
  -- Show marks in Telescope for better visualization
  keymap("n", "<leader>hf", function()
    local conf = require("telescope.config").values
    local file_paths = {}
    
    for _, item in ipairs(harpoon:list():display()) do
      table.insert(file_paths, item.value)
    end
    
    require("telescope.pickers").new({}, {
      prompt_title = "Harpoon Marks",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    }):find()
  end, { desc = "Harpoon: Find marks with Telescope" })
end

return M
