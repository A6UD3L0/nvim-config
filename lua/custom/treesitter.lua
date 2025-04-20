-- treesitter.lua: Auto-install and configure parsers for all relevant languages, with safe loading
do
  local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'nvim-treesitter.configs'. Treesitter will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  ts_configs.setup {
    ensure_installed = {
      'python', 'c', 'cpp', 'go', 'sql', 'dockerfile', 'json', 'yaml', 'bash', 'lua', 'vim'
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  }
end
