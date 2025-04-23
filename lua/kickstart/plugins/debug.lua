-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well.

local plugin = {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for dap-ui
    'nvim-neotest/nvim-nio',
    -- Adapter installer
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    -- Language-specific adapters
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end,            desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end,           desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end,           desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end,            desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end,           desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
  },
  config = function()
    local dap = require 'dap'

    -- Protected load of dap-ui
    local ok_ui, dapui = pcall(require, 'dapui')
    if ok_ui then
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause      = '⏸',
            play       = '▶',
            step_into  = '⏎',
            step_over  = '⏭',
            step_out   = '⏮',
            step_back  = 'b',
            run_last   = '▶▶',
            terminate  = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Open/close listeners
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated ['dapui_config'] = dapui.close
      dap.listeners.before.event_exited     ['dapui_config'] = dapui.close

      -- Guard against nil element in controls
      if dapui.controls and type(dapui.controls.enable_controls) == "function" then
        local orig_enable = dapui.controls.enable_controls
        dapui.controls.enable_controls = function(element, ...)
          if element == nil then return end
          return orig_enable(element, ...)
        end
      end
    else
      vim.notify("nvim-dap-ui failed to load", vim.log.levels.ERROR)
      -- We bail early so keymaps don’t error out when toggling UI
      return
    end

    -- Go adapter
    require('dap-go').setup {
      delve = { detached = vim.fn.has 'win32' == 0 },
    }

    -- Python adapter (uses UV)
    require('dap-python').setup(vim.fn.exepath("python3"))

  end,
}

-- Safe toggle command for DAP UI
vim.api.nvim_create_user_command('DapUIToggle', function()
  local ok, dapui = pcall(require, 'dapui')
  if ok then pcall(dapui.toggle) end
end, { desc = 'Toggle nvim-dap-ui safely' })

return plugin
