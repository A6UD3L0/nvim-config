-- Editor Module: Core text editing capabilities
-- Part of the MECE plugin architecture
--
-- This module handles:
-- 1. Text manipulation and movement
-- 2. Code formatting and indentation
-- 3. Buffer management
-- 4. Core text objects and motions
-- 5. Text editing enhancements

return {
  -- Treesitter for better syntax understanding and text objects
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Use latest release
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "go",
        "gomod",
        "gosum",
        "dockerfile",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]l"] = "@loop.outer",
            ["]i"] = "@conditional.outer",
            ["]b"] = "@block.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]L"] = "@loop.outer",
            ["]I"] = "@conditional.outer",
            ["]B"] = "@block.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[l"] = "@loop.outer",
            ["[i"] = "@conditional.outer",
            ["[b"] = "@block.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[L"] = "@loop.outer",
            ["[I"] = "@conditional.outer",
            ["[B"] = "@block.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sa"] = "@parameter.inner",
            ["<leader>sf"] = "@function.outer",
            ["<leader>sc"] = "@class.outer",
          },
          swap_previous = {
            ["<leader>sA"] = "@parameter.inner",
            ["<leader>sF"] = "@function.outer",
            ["<leader>sC"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      -- Add fallbacks in case of installation failures
      pcall(function()
        require("nvim-treesitter.install").prefer_git = true
      end)
      
      -- Ensure tree-sitter CLI is properly configured
      if vim.fn.executable("tree-sitter") == 0 then
        vim.notify("tree-sitter CLI not found, some features may be limited", vim.log.levels.WARN)
      end
      
      -- Setup with error handling
      local success, err = pcall(function()
        require("nvim-treesitter.configs").setup(opts)
      end)
      
      if not success then
        vim.notify("Treesitter setup failed: " .. tostring(err), vim.log.levels.ERROR)
        -- Fallback to basic syntax highlighting
        vim.cmd("syntax on")
      end
    end,
  },
  
  -- Improved autopairs with treesitter awareness
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      enable_check_bracket_line = true,
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local npairs_ok, npairs = pcall(require, "nvim-autopairs")
      if not npairs_ok then
        vim.notify("nvim-autopairs not found", vim.log.levels.WARN)
        return
      end
      
      npairs.setup(opts)
      
      -- Integration with nvim-cmp if available
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  
  -- Code formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format() end, desc = "Format document" },
    },
    opts = {
      -- Use a table for formatters to gracefully handle missing binaries
      formatters_by_ft = {
        python = { "isort", "black" },
        go = { "gofmt", "goimports" },
        lua = { "stylua" },
        sql = { "sqlformat" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        dockerfile = { "hadolint" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      -- Fallback to LSP if formatter not found
      format_on_save = function(bufnr)
        -- Skip large files
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
  },
  
  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    lazy = false,
    dependencies = {
      -- Optional treesitter integration
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
      },
    },
    config = function()
      -- Load with error handling
      local status_ok, comment = pcall(require, "Comment")
      if not status_ok then
        vim.notify("Comment.nvim not properly loaded", vim.log.levels.WARN)
        return
      end
      
      -- Check for ts_context_commentstring integration
      local ts_context_ok, ts_context = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      
      -- Configure with or without treesitter integration
      comment.setup({
        pre_hook = ts_context_ok and ts_context.create_pre_hook() or nil,
      })
    end,
  },
  
  -- Enhanced text deletion with targets
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    config = function()
      -- Load with error handling
      local status_ok, mini_bracketed = pcall(require, "mini.bracketed")
      if not status_ok then
        return
      end
      
      mini_bracketed.setup({
        -- First-level elements of each table are parts of mappings
        buffer     = { suffix = 'b', options = {} },
        comment    = { suffix = 'c', options = {} },
        conflict   = { suffix = 'x', options = {} },
        diagnostic = { suffix = 'd', options = {} },
        file       = { suffix = 'f', options = {} },
        indent     = { suffix = 'i', options = {} },
        jump       = { suffix = 'j', options = {} },
        location   = { suffix = 'l', options = {} },
        oldfile    = { suffix = 'o', options = {} },
        quickfix   = { suffix = 'q', options = {} },
        treesitter = { suffix = 't', options = {} },
        undo       = { suffix = 'u', options = {} },
        window     = { suffix = 'w', options = {} },
        yank       = { suffix = 'y', options = {} },
      })
    end,
  },
  
  -- Highlight and search for TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs (Telescope)" },
      { "<leader>sT", "<cmd>TodoQuickFix<cr>", desc = "List all TODOs" },
    },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      -- Fallbacks if highlight groups don't exist
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
    },
  },
  
  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
    init = function()
      -- Default mapping leader is backslash
      vim.g.VM_leader = "\\"
      
      -- Preserve ThePrimeagen's key style
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
    end,
  },
  
  -- Surround selections with characters
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      local status_ok, surround = pcall(require, "nvim-surround")
      if not status_ok then
        return
      end
      
      surround.setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
      })
    end,
  },

  -- Advanced substitution and case conversion
  {
    "tpope/vim-abolish",
    event = "VeryLazy",
  },
  
  -- Guess indent settings
  {
    "tpope/vim-sleuth",
    event = "BufReadPre",
  },
  
  -- Color code highlighting
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      -- Safe loading with fallback
      pcall(function()
        require("colorizer").setup()
      end)
    end,
  },
  
  -- Better quickfix windows
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
      },
      func_map = {
        vsplit = "",
        ptogglemode = "z,",
        stoggleup = "",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },
  
  -- Register management with clipboard integration
  {
    "tversteeg/registers.nvim",
    config = true,
    cmd = "Registers",
    keys = {
      { "\"", mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
  },
  
  -- Code folding with treesitter integration
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    opts = {
      -- Use treesitter as primary provider, fallback to indent
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
      
      -- Open all folds when opening a file
      open_fold_hl_timeout = 0,
      
      -- Preview fold content
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
      },
      
      -- Ensure fold info is displayed correctly
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = endLnum - lnum
        local foldIndicator = " ⚡ " .. totalLines .. " lines "
        
        -- Keep treesitter fold info visible
        local sufWidth = vim.fn.strdisplaywidth(foldIndicator)
        local targetWidth = width - sufWidth
        local curWidth = 0
        
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            
            -- Check if already too long
            if curWidth + chunkWidth < targetWidth then
              table.insert(newVirtText, { foldIndicator, "UfoFoldedEllipsis" })
            end
            break
          end
          
          curWidth = curWidth + chunkWidth
        end
        
        -- If not added ellipsis yet, add it
        if curWidth <= targetWidth then
          table.insert(newVirtText, { foldIndicator, "UfoFoldedEllipsis" })
        end
        
        return newVirtText
      end,
    },
    init = function()
      -- Using Neovim's fold commands with UFO
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except kinds" })
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- If no fold, use default K behavior
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or hover" })
    end,
    config = function(_, opts)
      -- Configure folding options
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "0"
      
      -- Set up UFO with error handling
      local status_ok, ufo = pcall(require, "ufo")
      if not status_ok then
        vim.notify("UFO folding plugin not found, using default folding", vim.log.levels.WARN)
        return
      end
      
      ufo.setup(opts)
      
      -- Set custom highlight for fold indicators
      vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = "#3794FF", bg = "NONE" })
    end,
  },
}
