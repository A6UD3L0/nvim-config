-- Coding related plugins for backend development
return {
  -- TreeSitter for better syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 1000, -- Load before other plugins
    lazy = false,    -- Load at startup to avoid module not found errors
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Keep only languages needed for Boot.dev curriculum
          "bash",        -- Linux course
          "c",           -- Memory Management in C
          "python",      -- Multiple Python courses
          "go",          -- Go courses
          "sql",         -- SQL course
          "javascript",  -- Web dev basics
          "html",        -- Web basics
          "css",         -- Web basics
          "json",        -- Data formats
          "yaml",        -- Docker, CI/CD configs
          "dockerfile",  -- Docker course
          "lua",         -- Neovim config
          "markdown",    -- Documentation
          "make",        -- Build systems for C
          "gitignore",   -- Git courses
          "toml",        -- Go configs
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
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  
  -- TreeSitter TextObjects - additional text objects based on syntax trees
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false, -- Load at startup to avoid module not found errors
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "glepnir/lspsaga.nvim",
    },
    config = function()
      -- Setup LSP handlers
      local lsp_defaults = {
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end
      }
      
      local lspconfig = require('lspconfig')
      
      -- Configure language servers
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      
      -- Python
      lspconfig.pyright.setup({})
      
      -- Go
      lspconfig.gopls.setup({})
      
      -- C/C++
      lspconfig.clangd.setup({})
      
      -- SQL
      lspconfig.sqlls.setup({})
      
      -- Docker
      lspconfig.dockerls.setup({})
    end
  },
  
  -- Mason - Language server installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
    opts = {
      ensure_installed = {
        -- LSP servers for Boot.dev curriculum
        "lua-language-server",    -- For Neovim config
        "pyright",                -- Python
        "gopls",                  -- Go
        "clangd",                 -- C
        "sqlls",                  -- SQL
        "docker-langserver",      -- Docker
        "bash-language-server",   -- Bash/Linux
        "html-lsp",               -- Basic web
        "css-lsp",                -- Basic web
        "json-lsp",               -- Data formats
        
        -- Formatters
        "black",                  -- Python
        "isort",                  -- Python imports
        "stylua",                 -- Lua
        "gofumpt",                -- Go
        "shfmt",                  -- Shell/Bash
        "clang-format",           -- C
        
        -- Linters
        "flake8",                 -- Python
        "golangci-lint",          -- Go
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  
  -- Typescript enhancements
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
  
  -- Better LSP UI
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      ui = {
        border = "rounded",
      },
      lightbulb = {
        enable = true,
      },
      outline = {
        win_width = 50,
      },
    },
    keys = {
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to definition" },
      { "gr", "<cmd>Lspsaga finder<CR>", desc = "Find references" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover documentation" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code action" },
      { "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "Rename symbol" },
      { "<leader>D", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Type definition" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next diagnostic" },
      { "<leader>dl", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics list" },
    },
  },
  
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- Format on save 
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        go = { "gofumpt" },
        c = { "clang_format" },
        javascript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        sql = { "sqlfmt" },
      },
      format_on_save = function(bufnr)
        -- Don't format on save for certain filetypes
        local exclude_filetypes = { "markdown", "text" }
        if vim.tbl_contains(exclude_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        
        -- Only format if the buffer has autoformat enabled
        local autoformat = vim.b[bufnr].autoformat
        if autoformat == nil then
          autoformat = true -- Default to true
        end
        
        return { 
          timeout_ms = 3000, -- Increased timeout to 3 seconds
          lsp_fallback = true,
          async = true, -- Run formatters asynchronously
        }
      end,
      formatters = {
        black = {
          command = "black",
          args = { "--quiet", "-" },
          stdin = true,
          timeout = 3000, -- Specific timeout for black
        },
        isort = {
          command = "isort",
          args = { "--quiet", "-" },
          stdin = true,
          timeout = 3000, -- Specific timeout for isort
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      
      -- Add error handling for formatters
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          local bufnr = args.buf
          local filetype = vim.bo[bufnr].filetype
          
          -- Skip if autoformat is disabled
          if vim.b[bufnr].autoformat == false then
            return
          end
          
          -- Format the buffer
          require("conform").format({
            bufnr = bufnr,
            timeout_ms = 3000,
            lsp_fallback = true,
            async = true,
          })
        end,
      })
    end,
  },
  
  -- Completion system with LSP support
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Fix deprecated warnings in LuaSnip
      local validate_patch_applied = false
      
      if not validate_patch_applied then
        local luasnip_utils = require("luasnip.util.util")
        if luasnip_utils.get_snippet_filetypes then
          local old_get_snippet_filetypes = luasnip_utils.get_snippet_filetypes
          luasnip_utils.get_snippet_filetypes = function(ft)
            local old_warn = vim.fn.assert_fails
            vim.fn.assert_fails = function() return { 'Validation function is deprecated' } end
            local result = old_get_snippet_filetypes(ft)
            vim.fn.assert_fails = old_warn
            return result
          end
          validate_patch_applied = true
        end
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "copilot" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
      
      -- Cmdline completion setup
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })
      
      -- Search completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },
  
  -- Comments
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    opts = {},
  },
  
  -- Neogen for documentation generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
          lua = {
            template = {
              annotation_convention = "emmylua",
            },
          },
          typescript = {
            template = {
              annotation_convention = "tsdoc",
            },
          },
          javascript = {
            template = {
              annotation_convention = "jsdoc",
            },
          },
        },
        input_after_comment = true,
        snippet_engine = "luasnip",
      })
    end,
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Generate function documentation",
      },
      {
        "<leader>cC",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Generate class documentation",
      },
    },
  },
}
