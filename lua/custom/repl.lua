-- repl.lua: Configure iron.nvim for IPython REPL integration, with safe loading
do
  local ok_iron, iron = pcall(require, 'iron.core')
  if not ok_iron then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'iron.core'. REPL integration will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  local ok_view, view = pcall(require, 'iron.view')
  if not ok_view then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'iron.view'. REPL integration will be incomplete.", vim.log.levels.WARN)
    end)
    return
  end
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
end

-- Show Python venv in statusline is handled in lualine.lua
