-- Git Keybindings Module
-- Integrates Git functionality with consistent mappings
-- Supports multiple Git plugins with graceful fallbacks

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register git groups
  keybindings.register_group("<leader>g", "Git", "", "#F7768E") -- Git (red)
  keybindings.register_group("<leader>gh", "Git Hunks", "", "#F7768E")
  keybindings.register_group("<leader>gc", "Git Conflicts", "", "#F7768E")
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    Gitsigns Integration                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_gitsigns_mappings()
    local has_gitsigns, gitsigns = utils.has_plugin("gitsigns")
    if not has_gitsigns then
      return false
    end
    
    -- Navigation between hunks
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function() gitsigns.next_hunk() end)
      return "<Ignore>"
    end, { desc = "Next git hunk", expr = true })
    
    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function() gitsigns.prev_hunk() end)
      return "<Ignore>"
    end, { desc = "Previous git hunk", expr = true })
    
    -- Actions on hunks
    map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>ghs", function() gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Stage selected hunk" })
    map("v", "<leader>ghr", function() gitsigns.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Reset selected hunk" })
    map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
    map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>ghb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
    map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
    map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Diff this" })
    map("n", "<leader>ghD", function() gitsigns.diffthis("~") end, { desc = "Diff this ~" })
    map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                  Fugitive/Telescope Integration           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_fugitive_mappings()
    local has_fugitive, _ = utils.has_plugin("fugitive")
    
    if has_fugitive then
      -- Fugitive commands
      map("n", "<leader>gg", ":Git<CR>", { desc = "Git status" })
      map("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
      map("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
      map("n", "<leader>gP", ":Git pull<CR>", { desc = "Git pull" })
      map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
      map("n", "<leader>gB", ":GBrowse<CR>", { desc = "Open in browser" })
      map("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
      map("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
    else
      -- Terminal fallbacks when fugitive is not available
      map("n", "<leader>gg", function() keybindings.run_in_terminal("git status") end, { desc = "Git status" })
      map("n", "<leader>gc", function() keybindings.run_in_terminal("git commit") end, { desc = "Git commit" })
      map("n", "<leader>gp", function() keybindings.run_in_terminal("git push") end, { desc = "Git push" })
      map("n", "<leader>gP", function() keybindings.run_in_terminal("git pull") end, { desc = "Git pull" })
      map("n", "<leader>gb", function() keybindings.run_in_terminal("git blame " .. vim.fn.expand("%")) end, { desc = "Git blame" })
      map("n", "<leader>gd", function() keybindings.run_in_terminal("git diff") end, { desc = "Git diff" })
      map("n", "<leader>gl", function() keybindings.run_in_terminal("git log") end, { desc = "Git log" })
    end
    
    -- Check for Telescope integration
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if has_telescope then
      map("n", "<leader>gC", telescope.git_commits, { desc = "Git commits (telescope)" })
      map("n", "<leader>gS", telescope.git_status, { desc = "Git status (telescope)" })
      map("n", "<leader>gf", telescope.git_files, { desc = "Git files (telescope)" })
      map("n", "<leader>gB", telescope.git_branches, { desc = "Git branches (telescope)" })
    end
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     LazyGit Integration                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_lazygit_mappings()
    -- Check if lazygit is installed on the system
    if utils.command_exists("lazygit") then
      map("n", "<leader>gl", function() 
        keybindings.run_in_terminal("lazygit", "float")
      end, { desc = "LazyGit" })
      return true
    end
    return false
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Diffview Integration                    │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_diffview_mappings()
    local has_diffview, _ = utils.has_plugin("diffview")
    if not has_diffview then
      return false
    end
    
    map("n", "<leader>gdo", ":DiffviewOpen<CR>", { desc = "Diffview open" })
    map("n", "<leader>gdc", ":DiffviewClose<CR>", { desc = "Diffview close" })
    map("n", "<leader>gdf", ":DiffviewFocusFiles<CR>", { desc = "Diffview focus files" })
    map("n", "<leader>gdh", ":DiffviewFileHistory<CR>", { desc = "Diffview file history" })
    map("n", "<leader>gdt", ":DiffviewToggleFiles<CR>", { desc = "Diffview toggle files" })
    map("n", "<leader>gdr", ":DiffviewRefresh<CR>", { desc = "Diffview refresh" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Neogit Integration                      │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_neogit_mappings()
    local has_neogit, neogit = utils.has_plugin("neogit")
    if not has_neogit then
      return false
    end
    
    map("n", "<leader>gn", function() neogit.open() end, { desc = "Open Neogit" })
    map("n", "<leader>gns", function() neogit.open({ kind = "split" }) end, { desc = "Open Neogit (split)" })
    map("n", "<leader>gnc", function() neogit.open({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Open Neogit (current dir)" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Conflict Resolution                     │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_conflict_mappings()
    -- Check if git-conflict is available
    local has_git_conflict, git_conflict = utils.has_plugin("git-conflict")
    
    if has_git_conflict then
      map("n", "<leader>gco", git_conflict.choose_ours, { desc = "Choose ours" })
      map("n", "<leader>gct", git_conflict.choose_theirs, { desc = "Choose theirs" })
      map("n", "<leader>gcb", git_conflict.choose_both, { desc = "Choose both" })
      map("n", "<leader>gc0", git_conflict.choose_none, { desc = "Choose none" })
      map("n", "<leader>gcn", git_conflict.next_conflict, { desc = "Next conflict" })
      map("n", "<leader>gcp", git_conflict.prev_conflict, { desc = "Previous conflict" })
      map("n", "<leader>gcl", git_conflict.list_conflicts, { desc = "List conflicts" })
    else
      -- Fallback to simple mappings using search
      map("n", "<leader>gcn", "/<<<<<<\\|=======\\|>>>>>>><CR>", { desc = "Next conflict marker" })
      map("n", "<leader>gcp", "?<<<<<<\\|=======\\|>>>>>>><CR>", { desc = "Previous conflict marker" })
    end
    
    return true
  end
  
  -- Setup all Git mappings
  setup_gitsigns_mappings()
  setup_fugitive_mappings()
  setup_lazygit_mappings()
  setup_diffview_mappings()
  setup_neogit_mappings()
  setup_conflict_mappings()
end

return M
