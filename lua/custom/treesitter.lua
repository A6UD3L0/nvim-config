-- treesitter.lua: Auto-install and configure parsers for all relevant languages
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'python', 'c', 'cpp', 'go', 'sql', 'dockerfile', 'json', 'yaml', 'bash', 'lua', 'vim'
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}
