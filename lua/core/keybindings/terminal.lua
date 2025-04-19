-- Terminal Keybindings Module
-- Manages terminal creation, navigation, and integration
-- Provides consistent toggleable terminals for various tools

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register terminal group
  keybindings.register_group("<leader>t", "Terminal", "", "#B4F9F8") -- Terminal (turquoise)
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                 ToggleTerm Integration                    │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_toggleterm_mappings()
    local has_toggleterm, toggleterm = utils.has_plugin("toggleterm")
    if not has_toggleterm then
      vim.notify("ToggleTerm not available, terminal integration reduced", vim.log.levels.DEBUG)
      return false
    end
    
    -- Basic terminal toggle
    map("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
    
    -- Direction-specific toggles
    map("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
    map("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })
    map("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "Floating terminal" })
    map("n", "<leader>tb", ":ToggleTerm direction=tab<CR>", { desc = "Tab terminal" })
    
    -- Terminal navigation
    map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Navigate left from terminal" })
    map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Navigate down from terminal" })
    map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Navigate up from terminal" })
    map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Navigate right from terminal" })
    
    -- Terminal escape
    map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    
    -- Numbered terminals
    for i = 1, 9 do
      map("n", "<leader>t" .. i, function()
        toggleterm.toggle(i)
      end, { desc = "Terminal " .. i })
    end
    
    -- Terminal size adjustment
    map("n", "<leader>t+", function()
      local current_size = vim.api.nvim_buf_get_var(0, "toggle_number")
      toggleterm.toggle(current_size, 10) -- Increase size by 10
    end, { desc = "Increase terminal size" })
    
    map("n", "<leader>t-", function()
      local current_size = vim.api.nvim_buf_get_var(0, "toggle_number")
      toggleterm.toggle(current_size, -10) -- Decrease size by 10
    end, { desc = "Decrease terminal size" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                 Terminal Applications                     │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Run various applications in terminal
  map("n", "<leader>tg", function()
    keybindings.run_in_terminal("lazygit", "float")
  end, { desc = "LazyGit" })
  
  map("n", "<leader>tn", function()
    keybindings.run_in_terminal("node", "horizontal")
  end, { desc = "Node REPL" })
  
  map("n", "<leader>tp", function()
    local python_cmd = utils.command_exists("python3") and "python3" or "python"
    keybindings.run_in_terminal(python_cmd, "horizontal")
  end, { desc = "Python REPL" })
  
  map("n", "<leader>ti", function()
    if utils.command_exists("ipython") then
      keybindings.run_in_terminal("ipython", "horizontal")
    else
      vim.notify("IPython not found. Please install it with 'pip install ipython'", vim.log.levels.WARN)
    end
  end, { desc = "IPython REPL" })
  
  map("n", "<leader>th", function()
    keybindings.run_in_terminal("htop", "float")
  end, { desc = "Htop" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Command Execution                       │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Run the current file based on filetype
  map("n", "<leader>tr", function()
    local ft = vim.bo.filetype
    local filename = vim.fn.expand("%:p")
    
    if ft == "python" then
      keybindings.run_in_terminal("python " .. vim.fn.shellescape(filename))
    elseif ft == "javascript" or ft == "typescript" then
      keybindings.run_in_terminal("node " .. vim.fn.shellescape(filename))
    elseif ft == "sh" or ft == "bash" then
      keybindings.run_in_terminal("bash " .. vim.fn.shellescape(filename))
    elseif ft == "lua" then
      keybindings.run_in_terminal("lua " .. vim.fn.shellescape(filename))
    elseif ft == "go" then
      keybindings.run_in_terminal("go run " .. vim.fn.shellescape(filename))
    elseif ft == "rust" then
      keybindings.run_in_terminal("cargo run")
    elseif ft == "java" then
      keybindings.run_in_terminal("javac " .. vim.fn.shellescape(filename) .. " && java " .. vim.fn.expand("%:t:r"))
    else
      vim.ui.input({ prompt = "Command to run: " }, function(cmd)
        if cmd and cmd ~= "" then
          keybindings.run_in_terminal(cmd)
        end
      end)
    end
  end, { desc = "Run current file" })
  
  -- Execute a custom command
  map("n", "<leader>tc", function()
    vim.ui.input({ prompt = "Command to run: " }, function(cmd)
      if cmd and cmd ~= "" then
        keybindings.run_in_terminal(cmd)
      end
    end)
  end, { desc = "Run command in terminal" })
  
  -- Setup toggleterm mappings
  setup_toggleterm_mappings()
end

return M
