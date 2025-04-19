-- Navigation Keybindings Module
-- Handles file finding, searching, and browsing functionality
-- Integrates with telescope, file explorers, and fuzzy finders

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register navigation groups
  keybindings.register_group("<leader>f", "Find", "", "#9ECE6A") -- Find/Search operations (green)
  keybindings.register_group("<leader>e", "Explorer", "", "#7DCFFF") -- File explorer (light blue)
  keybindings.register_group("<leader>s", "Search", "", "#E5C07B") -- Search (yellow)
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Telescope Integration                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_telescope_mappings()
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if not has_telescope then
      vim.notify("Telescope not available, advanced search mappings disabled", vim.log.levels.DEBUG)
      return false
    end
    
    -- File navigation
    map("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
    map("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
    map("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
    map("n", "<leader>fh", telescope.help_tags, { desc = "Help tags" })
    map("n", "<leader>fr", telescope.oldfiles, { desc = "Recent files" })
    map("n", "<leader>fk", telescope.keymaps, { desc = "Find keymaps" })
    map("n", "<leader>fm", telescope.marks, { desc = "Find marks" })
    
    -- Project navigation
    map("n", "<leader>pf", telescope.find_files, { desc = "Project find files" }) -- ThePrimeagen style
    map("n", "<leader>ps", telescope.live_grep, { desc = "Project search" })      -- ThePrimeagen style
    
    -- More advanced searches
    map("n", "<leader>ss", telescope.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
    map("n", "<leader>sc", telescope.command_history, { desc = "Command history" })
    map("n", "<leader>sg", telescope.git_files, { desc = "Git files" })
    map("n", "<leader>sw", telescope.grep_string, { desc = "Search word under cursor" })
    
    -- Register project group
    keybindings.register_group("<leader>p", "Project", "", "#98C379") -- Project (bright green)
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                 File Explorer Integration                 │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_explorer_mappings()
    -- First try nvim-tree
    local has_nvim_tree, _ = utils.has_plugin("nvim-tree")
    if has_nvim_tree then
      map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      map("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find in explorer" })
      map("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh explorer" })
      return true
    end
    
    -- Fall back to netrw
    map("n", "<leader>e", ":Lexplore<CR>", { desc = "Toggle file explorer" })
    map("n", "<leader>ef", ":Lexplore %:p:h<CR>", { desc = "Find in explorer" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Project Navigation                    │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_project_mappings()
    -- Project-wide navigation
    map("n", "<leader>pd", ":cd %:p:h<CR>", { desc = "Change to file directory" })
    
    -- Add project.nvim mappings if available
    local has_project, _ = utils.has_plugin("project_nvim")
    if has_project then
      local has_telescope, telescope = utils.has_plugin("telescope")
      if has_telescope then
        map("n", "<leader>pp", function()
          telescope.extensions.projects.projects()
        end, { desc = "Open projects" })
      end
    end
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                       Buffer Navigation                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_buffer_mappings()
    -- Enhanced buffer navigation with telescope
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if has_telescope then
      map("n", "<leader>bb", telescope.buffers, { desc = "Find buffers" })
    end
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Navigation Utilities                    │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Harpoon for quick file navigation (ThePrimeagen)
  local function setup_harpoon_mappings()
    local has_harpoon, _ = utils.has_plugin("harpoon")
    if not has_harpoon then
      return false
    end
    
    -- Try to load v2 API first, fall back to v1
    local function setup_harpoon_v2()
      local harpoon = require("harpoon")
      
      map("n", "<leader>a", function() harpoon:list():append() end, 
        { desc = "Add file to harpoon" })
      
      map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 
        { desc = "Harpoon quick menu" })
      
      map("n", "<leader>1", function() harpoon:list():select(1) end, 
        { desc = "Harpoon file 1" })
      
      map("n", "<leader>2", function() harpoon:list():select(2) end, 
        { desc = "Harpoon file 2" })
      
      map("n", "<leader>3", function() harpoon:list():select(3) end, 
        { desc = "Harpoon file 3" })
      
      map("n", "<leader>4", function() harpoon:list():select(4) end, 
        { desc = "Harpoon file 4" })
      
      return true
    end
    
    local function setup_harpoon_v1()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      
      map("n", "<leader>a", mark.add_file, { desc = "Add file to harpoon" })
      map("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon quick menu" })
      
      map("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
      map("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
      map("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
      map("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })
      
      return true
    end
    
    -- Try v2 first, fall back to v1
    local ok = pcall(setup_harpoon_v2)
    if not ok then
      pcall(setup_harpoon_v1)
    end
    
    return true
  end
  
  -- Setup all navigation mappings
  setup_telescope_mappings()
  setup_explorer_mappings()
  setup_project_mappings()
  setup_buffer_mappings()
  setup_harpoon_mappings()
end

return M
