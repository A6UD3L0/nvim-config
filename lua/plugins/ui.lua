return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in three styles: `storm`, `moon`, and `night`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal`
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
        hide_inactive_statusline = false, -- Enabling this option will hide inactive statuslines
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
        on_colors = function(colors) end, -- You can override specific color groups to use other groups or a hex color
        on_highlights = function(highlights, colors) end, -- You can override specific highlights to use other groups or a hex color
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = true,
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
      })
    end
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Set termguicolors to enable highlight groups
      vim.opt.termguicolors = true

      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
          mappings = {
            list = {
              { key = "<C-e>", action = "edit_in_place" },
            },
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        actions = {
          open_file = {
            window_picker = {
              enable = false,
            },
          },
        },
      })

      -- Keymaps for nvim-tree
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>E', ':NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = 'Find current file in explorer' })
    end,
  },

  -- Buffer line
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
          close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          indicator = {
            style = 'icon',
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
          },
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          tab_size = 18,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          },
          color_icons = true, -- whether or not to add the filetype icon highlights
          show_buffer_icons = true, -- disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          separator_style = "thin", -- can be one of 'thick', 'thin', or nil
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = 'insert_after_current',
        },
      }
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = {
          'help',
          'packer',
          'NvimTree',
          'Trouble',
          'TelescopePrompt',
          'TelescopeResults',
          'lsp-installer',
          'lspinfo',
          'checkhealth',
          'man',
          'gitcommit',
          'txt',
          'text',
          'dashboard',
          'NvimTree',
          'help',
          'TelescopePrompt',
          'TelescopeResults',
          'lsp-installer',
          'lspinfo',
          'checkhealth',
          'man',
          'gitcommit',
          'txt',
          'text',
          'dashboard',
        },
        buftype_exclude = { 'terminal', 'nofile' },
      }
    end,
  },

  -- Dashboard
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      
      -- Set header
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }
      
      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button('e', '📄  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('f', '🔍  Find file', ':Telescope find_files<CR>'),
        dashboard.button('r', '🔄  Recent files', ':Telescope oldfiles<CR>'),
        dashboard.button('g', '📚  Find text', ':Telescope live_grep<CR>'),
        dashboard.button('c', '⚙️  Configuration', ':e ~/.config/nvim/init.lua<CR>'),
        dashboard.button('q', '❌  Quit NVIM', ':qa<CR>'),
      }
      
      -- Set footer
      local function footer()
        local datetime = os.date('  %Y-%m-%d   %H:%M:%S')
        local plugins_text = '⚡ Neovim loaded in ' .. tostring(vim.fn.stdpath('data') .. '/site/pack/packer/start')
        return datetime .. '  |  ' .. plugins_text
      end
      
      dashboard.section.footer.val = footer()
      
      -- Send config to alpha
      alpha.setup(dashboard.opts)
      
      -- Disable folding on alpha buffer
      vim.cmd([[
        autocmd FileType alpha setlocal nofoldenable
      ]])
    end,
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,        -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
        performance_mode = false,    -- Disable the "Performance Mode" on all buffers
      })
    end,
  },

  -- Color highlighting
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        '*'; -- Highlight all files, but customize some others.
        css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
        html = { names = false; } -- Disable parsing "names" like Blue or Gray
      }, { mode = 'background' })
    end,
  },

  -- Better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
        },
        func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = '',
        },
        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
          },
        },
      })
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
      require('todo-comments').setup({
        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        keywords = {
          FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
          TODO = { icon = ' ', color = 'info' },
          HACK = { icon = ' ', color = 'warning' },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
          PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        },
        colors = {
          error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
          warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
          info = { 'DiagnosticInfo', '#2563EB' },
          hint = { 'DiagnosticHint', '#10B981' },
          default = { 'Identifier', '#7C3AED' },
        },
      })
    end,
  },

  -- Better motion
  {
    'folke/flash.nvim',
    event = 'VimEnter',
    config = function()
      require('flash').setup({
        labels = 'asdfghjklqwertyuiopzxcvbnm',
        search = {
          -- search/jump in all windows
          multi_window = true,
          -- search direction
          forward = true,
          -- when `false`, find only matches in the given direction
          wrap = true,
          -- Each mode will take ignorecase and smartcase into account.
          -- * exact: exact match
          -- * search: regular search
          -- * fuzzy: fuzzy search
          -- * fun(str): custom function that returns a pattern
          --   For example, to only match at the beginning of a word:
          --   pattern = function(str)
          --     return '\<' .. str
          --   end,
          pattern = '\\v<\\w*\\w*\\w*>',
        },
        jump = {
          -- save location in the jumplist
          jumplist = true,
          -- jump position
          pos = 'start', ---@type 'start' | 'end' | 'range'
          -- add pattern to search history
          history = false,
          -- add pattern to search register
          register = false,
          -- clear highlight after jump
          nohlsearch = false,
          -- automatically jump when there is only one match
          autojump = false,
        },
        modes = {
          -- options used when flash is activated through
          -- `f`, `F`, `t`, `T`, `;` and `,` motions
          char = {
            -- jump labels for character motions
            jump_labels = true,
            -- set to `false` to use the current line only
            multi_line = true,
            -- If `false`, use the current line only
            -- If `true`, always enter a new line when in the middle of a word
            -- If `'always'`, always add a line
            force_hl = false,
          },
        },
      })
    end,
  },
}
