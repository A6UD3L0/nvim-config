-- Debug Adapter Protocol configuration for backend development
local dap = require("dap")
local dapui = require("dapui")

-- Load language-specific configurations
require("configs.dap.python")
require("configs.dap.go")
require("configs.dap.cpp")

-- UI configuration for a better debugging experience
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  expand_lines = true,
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
      disconnect = "⏏",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- Automatically open/close the UI when debugging starts/ends
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Keymaps for debugging (centralized here for easier reference)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { desc = "Logpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Toggle UI" })
vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dp", function()
  dap.set_exception_breakpoints({"all"})
end, { desc = "Break on All Exceptions" })

-- Function to run the current file with appropriate debugger
vim.keymap.set("n", "<leader>dR", function()
  local ft = vim.bo.filetype
  if ft == "python" then
    require('dap-python').test_method()
  elseif ft == "go" then
    require('dap-go').debug_test()
  else
    dap.continue()
  end
end, { desc = "Debug Current Test/Function" })

-- Add support for common backend languages
vim.api.nvim_create_user_command('DapRunFile', function()
  local ft = vim.bo.filetype
  if ft == "python" then
    require('dap-python').test_method()
  elseif ft == "go" then
    require('dap-go').debug_test()
  elseif ft == "c" or ft == "cpp" then
    dap.continue()
  else
    vim.notify("No debug configuration for filetype: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Debug current file" })

-- Add a better debugging status indicator
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '◉', texthl = 'DapLogPoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

return {
  dap = dap,
  dapui = dapui
}
