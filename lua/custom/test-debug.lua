-- test-debug.lua: Configure neotest and nvim-dap for Python and Go
require('neotest').setup {
  adapters = {
    require('neotest-python')({
      dap = { justMyCode = false },
    }),
    require('neotest-go'),
  },
}

local dap = require('dap')
local dapui = require('dapui')

-- Python debugpy
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

-- Go delve
require('dap-go').setup()

dapui.setup()

-- Optional: auto open/close dapui
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  callback = function() dapui.open() end,
})

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
