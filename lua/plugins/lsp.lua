return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      -- Setup neodev before lspconfig
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })

      -- Setup mason so it can manage external tooling
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      -- Enable the following language servers
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- tsserver = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
        end,
      }

      -- Turn on lsp status information
      require('fidget').setup()

      -- nvim-cmp setup
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end,
  },

  -- UI Improvements
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      }
    end
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      }
    end,
  },

  -- Better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash', 'c', 'cpp', 'css', 'dockerfile', 'go', 'html', 'javascript',
          'json', 'lua', 'markdown', 'markdown_inline', 'python', 'rust',
          'toml', 'tsx', 'typescript', 'vim', 'yaml'
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      }
    end,
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },

  -- Better comments
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  -- Auto close tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- Color highlighting
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end,
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  },

  -- Better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },

  -- Better UI for messages, cmdline and the popupmenu
  {
    'folke/noice.nvim',
    event = 'VimEnter',
    config = function()
      require('noice').setup()
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- Better notifications
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  },

  -- Better terminal integration
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
  },

  -- Better quickfix list
  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup()
    end,
  },

  -- Better wildmenu
  {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })
      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
            fuzzy_filter = wilder.vim_fuzzy_filter(),
          }),
          wilder.vim_search_pipeline()
        ),
      })
      wilder.set_option('renderer', wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      }))
    end,
  },

  -- Better quickfix list
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },

  -- Better search and replace
  {
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup()
    end,
  },

  -- Better fold
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup()
    end,
  },

  -- Better match-up
  {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },

  -- Better surround
  {
    'kylechui/nvim-surround',
    version = '*',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  -- Better comments
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup()
    end,
  },

  -- Better motion
  {
    'folke/flash.nvim',
    event = 'VimEnter',
    config = function()
      require('flash').setup()
    end,
  },
}
