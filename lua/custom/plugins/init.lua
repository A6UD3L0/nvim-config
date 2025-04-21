-- You can add your own plugins here or in other files in this directory!
-- I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- hardtime.nvim for enforcing time constraints on key sequences
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
  -- UV.nvim for project management
  {
    'benomahony/uv.nvim',
    config = function()
      require('uv').setup()
    end,
  },

  { 'wakatime/vim-wakatime', lazy = false },
  -- Harpoon for quick file navigation
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- LazyGit integration
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  -- UV Python project management integration
  {
    dir = vim.fn.stdpath('config') .. '/lua/custom',
    config = function()
      require('uv_python')
    end,
    event = 'VeryLazy',
  },

  -- MECE WhichKey registration
  {
    dir = vim.fn.stdpath('config') .. '/lua/custom',
    config = function()
      require('custom.whichkey_mece')
    end,
    event = 'VeryLazy',
    dependencies = { 'folke/which-key.nvim' },
  },

  -- ToggleTerm for integrated terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    opts = {},
    event = 'VeryLazy',
  },

  -- null-ls for formatting and diagnostics
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      -- Ensure formatters & linters are installed
      require('mason-null-ls').setup {
        ensure_installed = {
          'checkmake',
          'prettier',
          'stylua',
          'eslint_d',
          'shfmt',
          'ruff',
        },
        automatic_installation = true,
      }

      -- Configure sources
      local sources = {
        diagnostics.checkmake,
        formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
        formatting.stylua,
        formatting.shfmt.with { args = { '-i', '4' } },
        formatting.terraform_fmt,
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        require 'none-ls.formatting.ruff_format',
      }

      -- Auto-format on save
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
          end
        end,
      }
    end,
  },
  -- UndoTree plugin
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<leader>u', ':UndotreeToggle<CR>', desc = 'Toggle UndoTree' },
    },
    config = function()
      vim.g.undotree_WindowLayout = 2 -- vertical split
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
