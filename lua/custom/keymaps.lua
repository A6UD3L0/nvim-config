-- Consolidated keymaps for REPL, Test, Debug, Docker, SQL
-- DRY: Helper to register a group with which-key
local function register_group(prefix, name, mappings)
  require('which-key').register({ [prefix] = vim.tbl_extend('force', { name = name }, mappings) }, { prefix = '<leader>' })
end

register_group('r', 'REPL', {
  s = { '<cmd>IronRepl<CR>', 'Start REPL' },
  l = { '<cmd>IronSendLine<CR>', 'Send Line' },
  f = { '<cmd>IronSendFile<CR>', 'Send File' },
})

register_group('t', 'Test', {
  n = { function() require('neotest').run.run() end, 'Nearest Test' },
  f = { function() require('neotest').run.run(vim.fn.expand('%')) end, 'Test File' },
})

register_group('d', 'Debug', {
  b = { function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint' },
  c = { function() require('dap').continue() end, 'Continue' },
  o = { function() require('dap').step_over() end, 'Step Over' },
  i = { function() require('dap').step_into() end, 'Step Into' },
  O = { function() require('dap').step_out() end, 'Step Out' },
  r = { function() require('dap').repl.open() end, 'Open REPL' },
  u = { function() require('dapui').toggle() end, 'Toggle UI' },
})

register_group('D', 'Docker', {
  c = { ":TermExec cmd='docker compose up' direction=horizontal<CR>", 'Compose Up' },
  b = { ":TermExec cmd='docker build .' direction=horizontal<CR>", 'Build' },
  r = { ":TermExec cmd='docker run -it --rm' direction=horizontal<CR>", 'Run' },
})

register_group('s', 'SQL', {
  q = { ':DBUI<CR>', 'Open DB UI' },
  e = { ':DB<CR>', 'Execute SQL' },
})
