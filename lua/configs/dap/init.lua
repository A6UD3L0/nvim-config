-- Enhanced DAP (Debug Adapter Protocol) configuration for backend development
local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")
  local dap_vt = require("nvim-dap-virtual-text")
  
  -- Configure DAP UI
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
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "",
        terminate = "",
      },
    },
  })
  
  -- Enable virtual text (showing values in the editor during debugging)
  dap_vt.setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
  })
  
  -- Auto-open and close dapui
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  
  -- Load language specific configurations
  require("configs.dap.python").setup()
  require("configs.dap.go").setup()
  require("configs.dap.cpp").setup()

  -- Key mappings
  vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Conditional Breakpoint" })
  vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Logpoint" })
  vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
  vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step Into" })
  vim.keymap.set("n", "<leader>do", function() dap.step_over() end, { desc = "Step Over" })
  vim.keymap.set("n", "<leader>dO", function() dap.step_out() end, { desc = "Step Out" })
  vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
  vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle UI" })
  vim.keymap.set("n", "<leader>dx", function() dap.terminate() end, { desc = "Terminate" })
  
  vim.api.nvim_create_user_command("DapUIToggle", function() dapui.toggle() end, {})
  vim.api.nvim_create_user_command("DapContinue", function() dap.continue() end, {})
  vim.api.nvim_create_user_command("DapToggleBreakpoint", function() dap.toggle_breakpoint() end, {})
end

return M
