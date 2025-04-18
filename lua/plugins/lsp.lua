-- LSP plugins configuration for powerful language server integration
return {
  -- Base LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim", -- Better Lua development
      "b0o/schemastore.nvim", -- JSON schema integration
      "ray-x/lsp_signature.nvim", -- Function signature help
      "nvimdev/lspsaga.nvim", -- Enhanced UI for LSP
      "smjonas/inc-rename.nvim", -- Interactive rename
      "utilyre/barbecue.nvim", -- VS Code-like winbar symbols
      "nvim-navic", -- Symbol navigation for statusline
      {
        "j-hui/fidget.nvim", -- LSP progress UI
        tag = "legacy",
        config = true
      },
    },
    config = function()
      -- Initialize our custom LSP configuration
      require("config.lsp").setup()
    end
  },

  -- Mason package manager for LSP servers, DAP, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- Backend languages
        "pyright",           -- Python
        "gopls",             -- Go
        "clangd",            -- C/C++
        "sqlls",             -- SQL
        "dockerls",          -- Docker
        "yamlls",            -- YAML (Kubernetes, CI/CD)
        "jsonls",            -- JSON
        "bashls",            -- Bash
        "lua_ls",            -- Lua
      },
      automatic_installation = true,
    },
  },

  -- Tool installer for non-LSP tools (formatters, linters, debuggers)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Formatters
        "black",             -- Python formatter
        "isort",             -- Python import sorter
        "stylua",            -- Lua formatter
        "shfmt",             -- Shell formatter
        "gofumpt",           -- Go formatter
        "goimports",         -- Go imports
        "clang-format",      -- C/C++ formatter
        "prettier",          -- JSON/YAML formatter
        "sqlfluff",          -- SQL formatter
        
        -- Linters
        "flake8",            -- Python linter
        "mypy",              -- Python type checker
        "pylint",            -- Python linter
        "golangci-lint",     -- Go linter
        "hadolint",          -- Dockerfile linter
        "shellcheck",        -- Shell linter
        "luacheck",          -- Lua linter
        
        -- DAP (Debugging)
        "debugpy",           -- Python debugger
        "delve",             -- Go debugger
        "codelldb",          -- C/C++ debugger
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 1000, -- 1 second delay
      debounce_hours = 24, -- Only run once a day
    },
  },

  -- Neodev for Lua development
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    },
  },

  -- Schema store for JSON validation
  {
    "b0o/schemastore.nvim",
    lazy = true,
    config = function() end,
  },

  -- Lua development for Neovim
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    },
  },

  -- Signature help while typing
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      },
      hint_enable = true,
      hint_prefix = "🔍 ",
      hint_scheme = "String",
      hi_parameter = "Search",
      max_height = 12,
      max_width = 120,
      padding = " ",
      transparency = 10,
      toggle_key = "<C-k>", -- Toggle signature on and off with Ctrl+k
    },
  },

  -- Symbol navigation for code outline
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰠱 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰕘 ",
        Interface = "󰕘 ",
        Function = "󰊕 ",
        Variable = "󰆧 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰉋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰙅 ",
        Event = " ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
      },
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    }
  },

  -- Breadcrumbs navigation bar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", 
    },
    opts = {
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      theme = "auto",
      context_follow_cursor = true,
    },
  },

  -- Interactive rename UI
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      { "<leader>cr", ":IncRename ", desc = "Rename with preview" },
    },
    config = true,
  },

  -- Improved LSP UI
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      ui = {
        border = "rounded",
        code_action = "💡",
        colors = {
          normal_bg = "#1e2030",
        },
      },
      lightbulb = {
        enable = true,
        sign = true,
        virtual_text = false,
      },
      symbol_in_winbar = {
        enable = true,
        show_file = true,
      },
      hover = {
        max_width = 0.6,
        max_height = 0.6,
        open_link = 'gx',
        open_browser = 'browser',
      },
    },
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Completion sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lua",
      
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
          "rafamadriz/friendly-snippets",
          {
            "benfowler/telescope-luasnip.nvim",
          },
        },
      },
      
      -- Autopairs integration
      "windwp/nvim-autopairs",
    },
    config = function()
      -- Initialize our custom completion configuration
      require("config.completion").setup()
    end,
  },

  -- Autopairs for easier bracket/quote completion
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        python = { "string", "source" },
        go = { "string", "source" },
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

  -- Code action lightbulb
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      sign = {
        enabled = true,
        priority = 10,
      },
      float = {
        enabled = false,
        text = "💡",
        win_opts = {},
      },
      virtual_text = {
        enabled = false,
        text = "💡",
      },
      status_text = {
        enabled = false,
        text = "💡",
        text_unavailable = ""
      },
      autocmd = {
        enabled = true,
        pattern = {"*"},
        events = {"CursorHold", "CursorHoldI"}
      }
    },
  },
}
