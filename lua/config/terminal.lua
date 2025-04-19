-- Enhanced terminal integration with Toggleterm
-- Provides floating, horizontal, vertical, and tab terminals with intelligent layouts

local M = {}

function M.setup()
  -- Use utility for plugin existence check
  local utils = require('utils')
  local status_ok, toggleterm = utils.require_safe("toggleterm", "toggleterm.nvim")
  if not status_ok then
    vim.notify("toggleterm.nvim not found. Terminal integration will be limited.", vim.log.levels.WARN)
    return
  end

  -- Configure Toggleterm for better UX and enhanced features
  toggleterm.setup({
    -- Terminal display behavior
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.3)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    
    -- Enhanced floating terminal appearance
    float_opts = {
      border = 'curved',
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
    },
  })

  -- Create specialized terminals for different workflows
  local terminal = require("toggleterm.terminal").Terminal

  -- LazyGit integration
  local lazygit = terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.9)
      end,
    },
  })

  -- Python REPL terminal
  local python = terminal:new({
    cmd = "python",
    hidden = true,
    direction = "horizontal",
    close_on_exit = false,
  })

  -- Node.js REPL terminal
  local node = terminal:new({
    cmd = "node",
    hidden = true,
    direction = "horizontal",
    close_on_exit = false,
  })

  -- Bottom terminal (main terminal)
  local bottom_term = terminal:new({
    direction = "horizontal",
    hidden = true,
  })

  -- Right terminal (for monitoring or logs)
  local right_term = terminal:new({
    direction = "vertical",
    hidden = true,
  })

  -- Floating terminal
  local float_term = terminal:new({
    direction = "float",
    hidden = true,
  })

  -- Set up keybindings
  local function set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    -- Hide the terminal with Escape plus another key to avoid exiting other terminal modes
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc><Esc>', [[<C-\><C-n>:ToggleTerm<CR>]], opts)
  end

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*", 
    callback = function() 
      set_terminal_keymaps() 
      -- Remove line numbers in terminal
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  })

  -- Terminal toggle functions
  M.toggle_bottom_term = function()
    bottom_term:toggle()
  end

  M.toggle_right_term = function()
    right_term:toggle()
  end

  M.toggle_float_term = function()
    float_term:toggle()
  end

  M.toggle_lazygit = function()
    lazygit:toggle()
  end

  M.toggle_python = function()
    python:toggle()
  end

  M.toggle_node = function()
    node:toggle()
  end

  -- Smart terminal: chooses layout based on screen space
  M.smart_toggle = function()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    
    if width > 120 then
      M.toggle_right_term()
    elseif height > 30 then
      M.toggle_bottom_term()
    else
      M.toggle_float_term()
    end
  end

  -- Run command in terminal
  M.run_command = function(cmd)
    local new_term = terminal:new({
      cmd = cmd,
      hidden = false,
      direction = "horizontal",
      close_on_exit = false,
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
    })
    new_term:toggle()
  end

  -- Execute current file based on filetype
  M.run_file = function()
    local file = vim.fn.expand("%:p")
    local filetype = vim.bo.filetype
    
    local commands = {
      python = "python " .. file,
      javascript = "node " .. file,
      typescript = "ts-node " .. file,
      go = "go run " .. file,
      rust = "cargo run",
      c = "gcc " .. file .. " -o /tmp/c_exec && /tmp/c_exec",
      cpp = "g++ " .. file .. " -o /tmp/cpp_exec && /tmp/cpp_exec",
      sh = "bash " .. file,
      lua = "lua " .. file,
    }
    
    local cmd = commands[filetype]
    if cmd then
      M.run_command(cmd)
    else
      vim.notify("No run command defined for filetype: " .. filetype, vim.log.levels.WARN)
    end
  end

  -- Global keymaps
  local keymap = vim.keymap.set
  
  -- Terminal toggles for different layouts
  keymap("n", "<leader>tt", M.toggle_bottom_term, { desc = "Toggle bottom terminal" })
  keymap("n", "<leader>tr", M.toggle_right_term, { desc = "Toggle right terminal" })
  keymap("n", "<leader>tf", M.toggle_float_term, { desc = "Toggle floating terminal" })
  
  -- Smart terminal that picks best layout
  keymap("n", "<C-t>", M.smart_toggle, { desc = "Smart terminal toggle" })
  
  -- Special terminals for specific tools
  keymap("n", "<leader>tg", M.toggle_lazygit, { desc = "Toggle LazyGit terminal" })
  keymap("n", "<leader>tp", M.toggle_python, { desc = "Toggle Python REPL" })
  keymap("n", "<leader>tn", M.toggle_node, { desc = "Toggle Node.js REPL" })
  
  -- Run current file
  keymap("n", "<leader>tr", M.run_file, { desc = "Run current file" })
  
  -- Terminal management
  keymap("n", "<leader>tk", "<cmd>ToggleTermToggleAll<CR>", { desc = "Kill all terminals" })
  
  -- Make terminals use ThePrimeagen's key style
  vim.cmd([[
    autocmd TermEnter term://*toggleterm#*
          \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
  ]])
  
  -- Register with which-key if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>t"] = { name = "+terminal" },
    })
  end
end

return M
