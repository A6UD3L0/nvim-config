-- Unified Keybinding System
-- Consolidates all key mappings into a single, consistent interface
-- Integrates with which-key for enhanced discoverability

local utils = require("core.utils")
local M = {}

-- Store all mappings for registration with which-key
M.all_mappings = {}

-- Default options for key mappings
local default_opts = {
  noremap = true,
  silent = true,
}

--- Enhanced mapping function that stores mappings for which-key
-- @param mode string|table The mode(s) for the mapping (e.g., "n", "v", {"n", "v"})
-- @param lhs string The left-hand side of the mapping (the key sequence)
-- @param rhs string|function The right-hand side of the mapping (command or function)
-- @param opts table|nil Optional settings for the mapping
-- @return boolean True if mapping was successful
function M.map(mode, lhs, rhs, opts)
  -- Handle options with defaults
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  
  -- Set the mapping
  local status_ok, _ = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not status_ok then
    -- Skip this mapping if it fails (may be due to missing function)
    return false
  end
  
  -- Track leader mappings for which-key using the new format
  if lhs:match("^<leader>") and opts.desc then
    -- Extract the key sequence after <leader>
    local suffix = lhs:match("^<leader>(.+)")
    if suffix and suffix ~= "" then
      -- Create mapping entry in the format expected by newer which-key versions
      table.insert(M.all_mappings, {
        "<leader>" .. suffix,
        desc = opts.desc,
        mode = type(mode) == "table" and mode or { mode },
        nowait = opts.nowait,
        remap = not (opts.noremap == true),
        silent = opts.silent
      })
    end
  end
  
  return true
end

--- Run a terminal command with proper toggleterm integration
-- @param cmd string The command to run
-- @param direction string The terminal direction (horizontal, vertical, float, tab)
function M.run_in_terminal(cmd, direction)
  direction = direction or "horizontal"

  -- Check that toggleterm is available
  local has_toggleterm, toggleterm = utils.has_plugin("toggleterm.terminal")
  if not has_toggleterm then
    vim.notify("ToggleTerm plugin not found. Please install akinsho/toggleterm.nvim", vim.log.levels.ERROR)
    return
  end

  local term = toggleterm.Terminal:new({
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
  })
  term:toggle()
end

--- Register a group of related mappings with which-key
-- @param prefix string The key prefix for this group
-- @param group_name string The name of the group to display
-- @param icon string|nil Optional icon to display with the group
-- @param color string|nil Optional color for the group name
function M.register_group(prefix, group_name, icon, color)
  local has_which_key, which_key = utils.has_plugin("which-key")
  if not has_which_key then
    return
  end
  
  local display_name = group_name
  if icon then
    display_name = icon .. " " .. group_name
  end
  
  which_key.register({
    [prefix] = { name = display_name }
  })
  
  -- Set color if provided and group-specific highlight exists
  if color and vim.fn.hlexists("WhichKeyGroup" .. group_name) == 0 then
    vim.api.nvim_set_hl(0, "WhichKeyGroup" .. group_name, { fg = color, bold = true })
  end
end

-- Function to initialize all keybinding modules
function M.setup()
  -- Set leader key
  vim.g.mapleader = " "
  
  -- Load all keybinding modules
  M.load_core_mappings()
  M.load_lsp_mappings()
  M.load_navigation_mappings()
  M.load_terminal_mappings()
  M.load_ui_mappings()
  M.load_window_mappings()
  M.load_file_mappings()
  M.load_edit_mappings()
  M.load_project_mappings()
  M.load_git_mappings()
  M.load_python_mappings()
  
  -- Initialize which-key with our mappings if available
  M.initialize_which_key()
end

-- Load core mappings that don't require plugins
function M.load_core_mappings()
  local core = require("core.keybindings.core")
  core.setup()
end

-- Load LSP-specific mappings
function M.load_lsp_mappings()
  local lsp = require("core.keybindings.lsp")
  lsp.setup()
end

-- Load navigation mappings (telescope, file browsing, etc.)
function M.load_navigation_mappings()
  local navigation = require("core.keybindings.navigation")
  navigation.setup()
end

-- Load terminal-related mappings
function M.load_terminal_mappings()
  local terminal = require("core.keybindings.terminal")
  terminal.setup()
end

-- Load UI-related mappings
function M.load_ui_mappings()
  local ui = require("core.keybindings.ui")
  ui.setup()
end

-- Load window management mappings
function M.load_window_mappings()
  local window = require("core.keybindings.window")
  window.setup()
end

-- Load file operation mappings
function M.load_file_mappings()
  local file = require("core.keybindings.file")
  file.setup()
end

-- Load text editing mappings
function M.load_edit_mappings()
  local edit = require("core.keybindings.edit")
  edit.setup()
end

-- Load project management mappings
function M.load_project_mappings()
  local project = require("core.keybindings.project")
  project.setup()
end

-- Load git mappings
function M.load_git_mappings()
  local git = require("core.keybindings.git")
  git.setup()
end

-- Load Python-specific mappings
function M.load_python_mappings()
  local python = require("core.keybindings.python")
  python.setup()
end

-- Initialize which-key with our collected mappings
function M.initialize_which_key()
  local has_which_key, which_key = utils.has_plugin("which-key")
  if not has_which_key then
    vim.notify("which-key not found. Key guide will not be available.", vim.log.levels.WARN)
    return
  end
  
  which_key.register(M.all_mappings)
end

-- Apply LSP keybindings when an LSP attaches to a buffer
function M.on_lsp_attach(client, bufnr)
  local lsp = require("core.keybindings.lsp")
  lsp.apply_buffer_mappings(client, bufnr)
end

return M
