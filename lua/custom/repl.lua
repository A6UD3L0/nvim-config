-- repl.lua: Configure iron.nvim for IPython REPL integration
local iron = require('iron.core')
local view = require('iron.view')

iron.setup {
  config = {
    repl_definition = {
      python = {
        command = { 'ipython' },
      },
    },
    preferred = {
      python = 'ipython',
    },
    keymaps = {},
    repl_open_cmd = view.split.vertical.botright(60),
  },
}

-- Show Python venv in statusline is handled in lualine.lua
