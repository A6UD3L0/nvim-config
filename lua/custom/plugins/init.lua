-- plugins/init.lua: All plugin specs for lazy.nvim, optimized for minimal, on-demand loading
-- UI, LSP, Treesitter, REPL, Testing, Docker, SQL, Git, Python (uv), and utility plugins
return {
  -- Everforest theme
  { 'neanias/everforest-nvim', lazy = false, priority = 1000, config = function()
    vim.g.everforest_background = 'soft'
    vim.cmd('colorscheme everforest')
  end },

  -- UI/UX
  {
    'nvim-lualine/lualine.nvim',
    event = { 'UiEnter', 'CmdlineEnter' },
    cmd = { 'LualineToggle' },
    config = function()
      if pcall(require, 'custom.lualine') then require('custom.lualine') end
    end
  },
  -- { 'akinsho/bufferline.nvim', event = 'VeryLazy', config = function() require('custom.bufferline') end },
  -- { 'lukas-reineke/indent-blankline.nvim', event = 'VeryLazy', config = function() require('custom.indent_blankline') end },
  -- { 'petertriho/nvim-scrollbar', event = 'VeryLazy', config = function() require('custom.scrollbar') end },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Keymap/which-key
  { 'folke/which-key.nvim', event = 'VeryLazy', config = function() require('custom.whichkey_mece') end },

  -- File navigation & search
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' }, cmd = 'Telescope' },

  -- Git
  { 'kdheepak/lazygit.nvim', cmd = 'LazyGit', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'lewis6991/gitsigns.nvim', event = 'BufReadPre', config = true },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', event = { 'BufReadPost', 'BufNewFile' }, config = function() require('custom.treesitter') end },

  -- Mason & LSP
  { 'williamboman/mason.nvim', event = 'VeryLazy', config = function() require('custom.mason') end },
  { 'williamboman/mason-lspconfig.nvim', event = 'VeryLazy' },
  { 'neovim/nvim-lspconfig', event = { 'BufReadPre', 'BufNewFile' }, config = function() require('custom.lsp') end },
  { 'hrsh7th/nvim-cmp', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
  { 'L3MON4D3/LuaSnip', event = 'InsertEnter' },
  { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },

  -- null-ls
  { 'nvimtools/none-ls.nvim', event = 'VeryLazy', config = function() require('custom.null-ls') end },
  { 'jayp0521/mason-null-ls.nvim', event = 'VeryLazy' },

  -- REPL
  { 'Vigemus/iron.nvim', ft = { 'python', 'sh', 'bash' }, config = function() require('custom.repl') end },

  -- Test/Debug
  { 'nvim-neotest/neotest', event = 'VeryLazy', config = function() require('custom.test-debug') end },
  { 'nvim-neotest/neotest-python', ft = 'python' },
  { 'nvim-neotest/neotest-go', ft = 'go' },
  { 'mfussenegger/nvim-dap', event = 'VeryLazy', config = function()
    require('custom.test-debug')
  end },
  { 'rcarriga/nvim-dap-ui', event = 'VeryLazy', config = function()
    local ok, dapui = pcall(require, 'dapui')
    if ok then dapui.setup() end
  end },
  { 'leoluz/nvim-dap-go', ft = 'go' },
  { 'mfussenegger/nvim-dap-python', ft = 'python' },

  -- Docker
  { 'skanehira/docker.nvim', cmd = { 'DockerContainers', 'DockerImages', 'DockerCompose' }, config = function() require('custom.docker') end },
  { 'akinsho/toggleterm.nvim', event = 'VeryLazy' },

  -- SQL/DB
  { 'tpope/vim-dadbod', cmd = { 'DB', 'DBUI', 'DBExec' } },
  { 'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUI' } },
  { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },

  -- Python project management (uv.nvim)
  { 'benomahony/uv.nvim', event = 'VeryLazy', config = function() require('custom.uv_python') end },

  -- Utility
  { 'mbbill/undotree', cmd = 'UndotreeToggle' },
  { 'ThePrimeagen/harpoon', branch = 'harpoon2', dependencies = { 'nvim-lua/plenary.nvim' }, event = 'VeryLazy' },
  { 'wakatime/vim-wakatime', lazy = false },
}
