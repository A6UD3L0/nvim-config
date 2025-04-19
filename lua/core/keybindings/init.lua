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

-- Map a set of keybindings for a specific domain with common prefixes
-- This helps avoid repetitive code in each keybinding module
-- @param domain_name string The name of the domain (e.g., "lsp", "git")
-- @param prefix string The leader prefix to use (e.g., "<leader>l")
-- @param mappings table A table of keybindings in the format { [key] = { action, description, [mode] } }
-- @param default_mode string The default mode for mappings if not specified (default: "n")
function M.map_domain(domain_name, prefix, mappings, default_mode)
  default_mode = default_mode or "n"
  
  -- Register the domain group with which-key
  M.register_group(prefix, domain_name:gsub("^%l", string.upper))
  
  -- Create all the mappings
  for key, mapping in pairs(mappings) do
    local action = mapping[1]
    local desc = mapping[2]
    local mode = mapping[3] or default_mode
    
    -- Construct the full key sequence
    local lhs = prefix .. key
    
    -- Create the mapping
    M.map(mode, lhs, action, { desc = desc })
  end
end

-- Create a set of LSP buffer-local mappings
-- Used by the LSP on_attach functions
-- @param client table The LSP client instance
-- @param bufnr number The buffer number to apply mappings to
function M.apply_lsp_buffer_mappings(client, bufnr)
  local function buf_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    M.map(mode, lhs, rhs, opts)
  end
  
  -- Standard LSP keymaps
  buf_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  buf_map("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
  buf_map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  buf_map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
  buf_map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  buf_map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
  buf_map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
  
  -- Diagnostics
  buf_map("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  buf_map("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  buf_map("n", "<leader>ll", vim.diagnostic.open_float, { desc = "Line diagnostics" })
  buf_map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set location list" })
  
  -- Workspace
  buf_map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
  buf_map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
  buf_map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List workspace folders" })
  
  -- Document formatting if supported
  if client.supports_method("textDocument/formatting") then
    buf_map("n", "<leader>lf", function() 
      vim.lsp.buf.format({ bufnr = bufnr }) 
    end, { desc = "Format document" })
  end
  
  -- Range formatting if supported
  if client.supports_method("textDocument/rangeFormatting") then
    buf_map("v", "<leader>lf", function() 
      vim.lsp.buf.format({ bufnr = bufnr }) 
    end, { desc = "Format selection" })
  end
  
  -- Setup buffer-local which-key mappings
  local has_which_key, which_key = utils.has_plugin("which-key")
  if has_which_key then
    which_key.register({
      ["<leader>l"] = { name = " LSP" },
      ["<leader>lw"] = { name = " Workspace" },
      ["<leader>lf"] = { name = " Find/Format" },
    }, { buffer = bufnr })
  end
end

-- Function to initialize all keybinding modules
function M.setup()
  -- Load global base mappings first
  require("core.keybindings.base")

  -- Initialize domain-specific keybinding modules
  M.load_core_mappings()
  M.load_window_mappings()
  M.load_lsp_mappings()
  M.load_navigation_mappings()
  M.load_git_mappings()
  M.load_file_mappings()
  M.load_terminal_mappings()
  M.load_ui_mappings()
  M.load_project_mappings()
  M.load_python_mappings()
  M.load_edit_mappings()
  
  -- Register all leader mappings with which-key if available
  local has_which_key, which_key = utils.has_plugin("which-key")
  if has_which_key then
    which_key.register(M.all_mappings)
  end
  
  return true
end

-- Hook for LSP on_attach
function M.on_lsp_attach(client, bufnr)
  -- Load LSP keybindings for this buffer
  local lsp = require("core.keybindings.lsp")
  lsp.apply_buffer_mappings(client, bufnr)
end

-- Load domain-specific keybinding modules

function M.load_core_mappings()
  local core = require("core.keybindings.core")
  core.setup()
end

function M.load_window_mappings()
  local window = require("core.keybindings.window")
  window.setup()
end

function M.load_lsp_mappings()
  local lsp = require("core.keybindings.lsp")
  lsp.setup()
end

function M.load_navigation_mappings()
  local navigation = require("core.keybindings.navigation")
  navigation.setup()
end

function M.load_python_mappings()
  local python = require("core.keybindings.python")
  python.setup()
end

function M.load_terminal_mappings()
  local terminal = require("core.keybindings.terminal")
  terminal.setup()
end

function M.load_git_mappings()
  local git = require("core.keybindings.git")
  git.setup()
end

function M.load_file_mappings()
  local file = require("core.keybindings.file")
  file.setup()
end

function M.load_edit_mappings()
  local edit = require("core.keybindings.edit")
  edit.setup()
end

function M.load_ui_mappings()
  local ui = require("core.keybindings.ui")
  ui.setup()
end

function M.load_project_mappings()
  local project = require("core.keybindings.project")
  project.setup()
end

return M
