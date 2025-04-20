-- test-debug.lua: Configure neotest and nvim-dap for Python and Go, with safe loading
do
  local ok_neotest, neotest = pcall(require, 'neotest')
  if not ok_neotest then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'neotest'. Test integration will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  local ok_py, neotest_python = pcall(require, 'neotest-python')
  local ok_go, neotest_go = pcall(require, 'neotest-go')
  local adapters = {}
  if ok_py then
    table.insert(adapters, neotest_python({ dap = { justMyCode = false } }))
  end
  if ok_go then
    table.insert(adapters, neotest_go)
  end
  neotest.setup { adapters = adapters }

  local ok_dap, dap = pcall(require, 'dap')
  local ok_dapui, dapui = pcall(require, 'dapui')
  if not ok_dapui then
    vim.schedule(function()
      vim.notify('dap-ui: missing dependency nvim-nio', vim.log.levels.WARN)
    end)
    return
  end
  if ok_dap then
    local ok_dap_py, dap_python = pcall(require, 'dap-python')
    if ok_dap_py then
      dap_python.setup('~/.virtualenvs/debugpy/bin/python')
    end
    local ok_dap_go, dap_go = pcall(require, 'dap-go')
    if ok_dap_go then
      dap_go.setup()
    end
    dapui.setup()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dap-repl',
      callback = function() dapui.open() end,
    })
    vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
  end
end
