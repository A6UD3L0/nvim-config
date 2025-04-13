return {
  -- Core plugins and configurations
  { import = "plugins.dev_tools" },  -- LSP, Mason, and development tools
  { import = "plugins.copilot" },    -- GitHub Copilot integration
  { import = "plugins.datascience" }, -- Data science specific plugins

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- Format on save 
    opts = require "configs.conform",
  },

  -- TreeSitter for better syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "go", "html", "javascript",
        "json", "lua", "markdown", "python", "rust", "tsx",
        "typescript", "yaml", "vim", "vimdoc", "query", "sql",
        "dockerfile", "gitignore", "make", "r", "toml", "julia",
      },
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
  },

  -- UI Enhancements
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Mini.icons for better icon support
  {
    "echasnovski/mini.icons",
    version = false,
    event = "VeryLazy",
  },

  -- Modern looking theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other start plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { 
          light = "latte", 
          dark = "mocha", 
        },
        transparent_background = false,
        term_colors = true,
        dim_inactive = {
          enabled = false, 
          shade = "dark",
          percentage = 0.15,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          which_key = true,
          lsp_saga = true,
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          -- For more plugins integrations see https://github.com/catppuccin/nvim#integrations
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus NvimTree" },
    },
    opts = {
      filters = {
        dotfiles = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = "left",
        width = 30,
        preserve_window_proportions = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
    },
  },

  -- ThePrimeagen's Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup({})
    end,
    keys = {
      { "<leader>ha", function() require("harpoon"):list():append() end, desc = "Harpoon Add File" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
    },
  },

  -- UndoTree visualizes your vim undo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    event = "VeryLazy", -- Ensure plugin is loaded early
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1 -- Auto focus when opened
      vim.g.undotree_WindowLayout = 2 -- Set layout (2 is usually best)
    end,
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff" },
    },
  },
  
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        
        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})
        
        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
        
        -- Actions
        map('n', '<leader>gh', gs.preview_hunk, { desc = "Preview Hunk" })
        map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
        map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset Buffer" })
        map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage Buffer" })
        map('n', '<leader>gB', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
        map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
        map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })
      end,
    },
  },
  
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "DiffView Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
  
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
  
  -- Fast navigation with Leap
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  
  -- Telescope for improved file and text searching
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find Text" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
      { "<leader>fc", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Find in Current Buffer" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "node_modules", "__pycache__", "%.git/", "%.ds_store" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
          },
        },
      })
      
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
  
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("configs.dap")
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", config = true },
      { "LiadOz/nvim-dap-repl-highlights", config = true },
    },
    keys = {
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Conditional Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
    },
  },
  
  -- Which key for keybinding discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    keys = {
      { "<leader><leader>", "<cmd>WhichKey<cr>", desc = "Show all keybindings" },
    },
    opts = {
      plugins = { spelling = true },
      replace = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      win = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      filter = function(key)
        -- Filter out undefined mappings
        return key.mapping ~= nil
      end,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- Do not register defaults here, they're handled in mappings.lua
    end,
  },
  
  -- Additional Utilities
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },
  
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = true,
  },
  
  -- Terminal integration with toggleterm
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical Terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy"
  },
}
