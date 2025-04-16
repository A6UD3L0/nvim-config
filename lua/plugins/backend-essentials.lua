-- Essential plugins for backend development and data science
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim",
      "b0o/schemastore.nvim", -- Add SchemaStore for JSON schemas
    },
    config = function()
      -- Setup Mason first to ensure package manager is ready
      require("mason").setup({
        ui = { 
          border = "rounded",
          icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
          },
          keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            update_package = "u",
            check_package_version = "c",
            update_all_packages = "U",
            check_outdated_packages = "C",
            uninstall_package = "X",
            cancel_installation = "<C-c>",
          },
        },
        max_concurrent_installers = 10,
        registries = {
          "github:mason-org/mason-registry",
        },
        log_level = vim.log.levels.INFO,
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
      })
      
      -- Setup Neodev for Lua development
      require("neodev").setup({
        library = { 
          plugins = { "nvim-dap-ui" },
          types = true,
        },
      })
      
      -- Install and configure LSP servers
      require("mason-lspconfig").setup({
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
      })
      
      -- Install additional tools with mason-tool-installer
      require("mason-tool-installer").setup({
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
        start_delay = 3000, -- 3 second delay
        debounce_hours = 24, -- Only run once a day
      })
      
      -- Configure LSP capabilities with nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Configure individual LSP servers
      local lspconfig = require("lspconfig")
      
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticMode = "workspace",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
              },
            },
          },
        },
      })

      -- Go
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
      })

      -- JSON with schema support
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML with schema support
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
            validate = true,
            completion = true,
            hover = true,
            schemaStore = {
              enable = false, -- We're using schemastore.nvim instead
              url = "", -- Not required when enable=false
            },
          },
        },
      })

      -- C/C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      
      -- SQL
      lspconfig.sqlls.setup({
        capabilities = capabilities,
      })
      
      -- Docker
      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })
      
      -- YAML
      -- lspconfig.yamlls.setup({
      --   capabilities = capabilities,
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      --         ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
      --       },
      --     },
      --   },
      -- })
      
      -- JSON
      -- lspconfig.jsonls.setup({
      --   capabilities = capabilities,
      --   settings = {
      --     json = {
      --       schemas = require('schemastore').json.schemas(),
      --       validate = { enable = true },
      --     },
      --   },
      -- })
      
      -- Bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })
      
      -- Lua
      -- lspconfig.lua_ls.setup({
      --   capabilities = capabilities,
      --   settings = {
      --     Lua = {
      --       runtime = {
      --         version = 'LuaJIT',
      --       },
      --       diagnostics = {
      --         globals = { 'vim' },
      --       },
      --       workspace = {
      --         library = vim.api.nvim_get_runtime_file("", true),
      --         checkThirdParty = false,
      --       },
      --       telemetry = {
      --         enable = false,
      --       },
      --     },
      --   },
      -- })
      
      -- Global LSP keymappings (will be mapped by which-key later)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          
          -- Load all LSP-related keymappings from the central mappings file
          require("mappings").setup_lsp_mappings(bufnr)
        end,
      })
      
      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      
      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Use stable version to avoid deprecated warnings
        dependencies = {
          "rafamadriz/friendly-snippets",
          "saadparwaiz1/cmp_luasnip",
          {
            "benfowler/telescope-luasnip.nvim",
          },
        },
        build = (not jit.os:find("Windows")) and 
          "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,
        event = "InsertEnter",
        config = function()
          -- Silence the deprecated vim.validate warnings - these come from LuaSnip and will be fixed in future versions
          local orig_validate = vim.validate
          local silent_validate = function(...)
            local suppress_warning = true
            if suppress_warning then
              local orig_notify = vim.notify
              vim.notify = function(msg, level, opts)
                if level == vim.log.levels.WARN and msg:match("vim.validate") then
                  return
                end
                return orig_notify(msg, level, opts)
              end
              local result = orig_validate(...)
              vim.notify = orig_notify
              return result
            else
              return orig_validate(...)
            end
          end
          
          -- Temporarily replace vim.validate with our silent version while loading snippets
          vim.validate = silent_validate
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip").filetype_extend("python", { "django", "pydoc" })
          require("luasnip").filetype_extend("javascript", { "html", "css" })
          require("luasnip").filetype_extend("typescript", { "javascript", "html", "css" })
          require("luasnip").filetype_extend("go", { "godoc" })
          -- Restore original vim.validate
          vim.validate = orig_validate
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
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
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Set maximum width for completion menu items
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, 40)
            if truncated_label ~= label then
              vim_item.abbr = truncated_label .. "..."
            end
            return vim_item
          end,
        },
        window = {
          completion = { 
            border = "rounded",
            scrollbar = true,
          },
          documentation = { 
            border = "rounded" 
          },
        },
      })
    end,
  },
  
  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "go", "lua", "python", "rust", "sql",
          "vim", "vimdoc", "yaml", "json", "toml", "dockerfile",
          "html", "css", "javascript", "typescript", "tsx",
          "markdown", "markdown_inline", "regex", "query",
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
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
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  
  -- Git integration
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
      signcolumn = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        -- Use centralized git mappings
        require("mappings").setup_git_mappings(gs)
      end,
    },
  },
  
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in current buffer" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".pytest_cache/",
            "__pycache__/",
            "venv/",
            ".venv/",
            "%.pyc",
            "%.pyo",
            "%.obj",
            "%.o",
            "%.a",
            "%.bin",
            "%.tar.gz",
            "%.zip",
            "%.7z",
            "%.so",
          },
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        },
        pickers = {
          find_files = {
            hidden = true, -- Show hidden files
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      
      telescope.load_extension("fzf")
    end,
  },
  
  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = { 
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal" },
      { "<C-t>", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal with Ctrl+t" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = function()
        return math.floor(vim.o.lines * 0.3)
      end,
      autochdir = true,
      shade_terminals = true,
      start_in_insert = true,
    },
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "Explorer find file" },
      { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Explorer refresh" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          adaptive_size = false,
          side = "right",  -- Position tree on the right side
          width = 35,      -- Wider tree for better file visibility
          preserve_window_proportions = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = true,
            window_picker = {
              enable = true,
            },
          },
        },
        renderer = {
          root_folder_label = false,
          highlight_git = true,
          highlight_opened_files = "icon",
          indent_markers = {
            enable = true,       -- Show indent markers for better structure
            icons = {
              corner = "└ ",
              edge = "│ ",
              none = "  ",
            },
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
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
            },
          },
        },
        filters = {
          dotfiles = false,      -- Show dotfiles by default
          custom = { 
            "^\\.git$", 
            "^node_modules$",
            "^__pycache__$",
            "^\\.pytest_cache$",
            "^\\.venv$",
            "^\\.DS_Store$"
          },
        },
        git = {
          enable = true,
          ignore = false,        -- Don't ignore git files
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
      })
    end,
  },
  
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      { "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon add file" },
      { "<leader>h", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
    },
  },
  
  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio", -- Required by nvim-dap-ui
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dt", function() require("dapui").toggle() end, desc = "Toggle UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
    },
    config = function()
      require("nvim-dap-virtual-text").setup()
      
      -- DAP UI setup
      local dapui = require("dapui")
      dapui.setup()
      
      -- Automatically open UI when debugging starts
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Go debugging
      require("dap-go").setup()
      
      -- Python debugging
      require("dap-python").setup()
    end,
  },
  
  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,      -- shows marks when pressing '
          registers = true,  -- shows registers when pressing "
          spelling = {
            enabled = true,  -- enables whichkey for spell suggestions
            suggestions = 20,
          },
        },
        window = {
          border = "rounded", -- none, single, double, shadow, rounded
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- top, right, bottom, left
          padding = { 1, 2, 1, 2 }, -- top, right, bottom, left
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3,                    -- spacing between columns
          align = "center",               -- align columns left, center or right
        },
        icons = {
          breadcrumb = "»",  -- Symbol in the command line area
          separator = "➜",   -- Symbol between a key and its label
          group = "+",       -- Symbol prepended to a group
        },
      })
      
      -- Register label namespaces only (all actual keybindings are in mappings.lua)
      wk.register({
        ["<leader>"] = {
          ["<leader>"] = { name = "Show all keybindings" },
          ["b"] = { name = " Buffers" },
          ["c"] = { name = " Code Actions" },
          ["cd"] = { name = " Change Directory" },
          ["cf"] = { name = "Format code" },
          ["d"] = { name = " Debug/Delete" },
          ["do"] = { name = " Documentation" },
          ["e"] = { name = " Explorer" },
          ["f"] = { name = " Find/Files" },
          ["g"] = { name = " Git" },
          ["h"] = { name = " Harpoon" },
          ["l"] = { name = " LSP" },
          ["o"] = { name = " Poetry" },
          ["p"] = { name = " Paste/Project" },
          ["pv"] = { name = "Open Netrw" },
          ["q"] = { name = " Quickfix" },
          ["r"] = { name = " Requirements" },
          ["s"] = { name = "Search and replace" },
          ["t"] = { name = " Terminal" },
          ["u"] = { name = "Toggle Undotree" },
          ["v"] = { name = "󱎫 Python Tools" },
          ["w"] = { name = " Window" },
          ["x"] = { name = "Make executable" },
          ["y"] = { name = " Python" },
        },
        ["w"] = { name = "Window/Write" },
        ["g"] = { name = "Go to" },
      })
    end,
  },
  
  -- Database explorer
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
      { "<leader>da", "<cmd>DBUIAddConnection<CR>", desc = "Add DB Connection" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  
  -- Python environment management with improved regexp search
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",  -- Use the latest 2024 version with regexp support
    cmd = "VenvSelect",
    keys = {
      { "<leader>yv", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
      { "<leader>yd", "<cmd>VenvSelectCached<CR>", desc = "Select cached venv" },
    },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true,
      search_venv_managers = true,
      search_workspace = true,
      search_patterns = {
        -- Custom search patterns
        { "venv", "env", ".venv", ".env" },                       -- Common venv folder names
        { "*/venv", "*/env", "*/.venv", "*/.env" },               -- Search for venvs one level down
        { "**/venv", "**/env", "**/.venv", "**/.env" },           -- Search for venvs anywhere below
        { "global", "**/*venv*", "**/*env*" },                   -- Match any path with venv/env in the name
      },
      dap_enabled = true,  -- Enable DAP support
      parents = 2,         -- Search 2 levels up for venvs
      path_to_python = "bin/python",  -- Path to the python executable
      change_venv_hooks = {
        function(venv_path)
          -- Update python3_host_prog
          vim.g.python3_host_prog = venv_path .. "/bin/python"
          -- Notify the user
          vim.notify("Activated venv: " .. venv_path, vim.log.levels.INFO, { title = "Python Environment" })
        end,
      },
    },
    init = function()
      -- Setup quick access shortcuts, mapped already in mappings.lua
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
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  
  -- Github Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  
  {
    "zbirenbaum/copilot-cmp",
    version = "*", -- Use latest release version to fix deprecation warnings
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup({
        -- Fix deprecated API warnings by using a custom source filter function
        fix_mode = true, -- Use the fixed version of source.is_stopped
      })
    end,
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "rose-pine",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- Show relative path
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  
  -- Enhanced command-line UI with wilder.nvim
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "romgrk/fzy-lua-native",
        build = "make",
      },
    },
    config = function()
      local wilder = require("wilder")
      wilder.setup({
        modes = { ":", "/", "?" },
        next_key = "<Tab>",
        previous_key = "<S-Tab>",
        accept_key = "<Down>",
        reject_key = "<Up>",
      })

      -- Use only Lua-based functionality to avoid Python errors
      -- Create file finder function using Lua
      local file_finder = function(prefix, check_dirname)
        return function(path)
          local base = vim.fn.fnamemodify(path.."x", ":h:r")  -- add a dummy 'x' to handle empty paths
          base = base == "." and "" or base
          base = base..(base == "" and "" or "/")
          
          local cmd = "find "..vim.fn.shellescape(base).." -maxdepth 1 -type f,l"
          if prefix then
            cmd = cmd.." -name "..vim.fn.shellescape(prefix.."*")
          end
          cmd = cmd.." 2>/dev/null"
          
          local handle = io.popen(cmd)
          if not handle then return {} end
          
          local result = handle:read("*a")
          handle:close()
          
          local names = {}
          for name in string.gmatch(result, "[^\n]+") do
            table.insert(names, name)
          end
          
          return names
        end
      end
      
      -- Create custom file completion using Lua only
      local file_completion = {
        expand = function(arg)
          if arg == nil then
            return ""
          end
          return vim.fn.fnamemodify(arg, ":p")
        end,
        
        dict = file_finder(),
      }

      -- Use native Lua-based fuzzy search and completion
      wilder.set_option("pipeline", {
        wilder.branch(
          -- Use cmdline engine for command completion
          wilder.cmdline_pipeline({
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
            file_completion = function(_, arg)
              return wilder.vim_filepath_completion(arg)
            end,
            language = "lua",
          }),
          
          -- Use vim search for / and ? mode
          wilder.vim_search_pipeline()
        ),
      })

      -- Rose Pine color scheme for wilder.nvim
      local rose_pine_colors = {
        bg = "#1a1d23",
        fg = "#aeaebf",
        accent = "#dca561",
        selected = "#2a2b33",
        border = "#3b3f4e",
        gray = "#565f89",
        error = "#f7768e",
        warning = "#e0af68",
        info = "#7dcfff",
        hint = "#9ece6a",
      }

      -- Create highlight groups for wilder
      local popupmenu_renderer = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlights = {
            default = "Pmenu",
            border = "WilderBorder",
            accent = "WilderAccent",
            selected = "PmenuSel",
            error = "WilderError",
          },
          border = "rounded",
          left = {
            " ",
            wilder.popupmenu_devicons(),
            wilder.popupmenu_buffer_flags({
              flags = " a + ",
              icons = { ["+"] = "", ["a"] = "", ["h"] = "" },
            }),
          },
          right = {
            " ",
            wilder.popupmenu_scrollbar({
              thumb_char = '┃',
              minheight = 1,
            }),
          },
          empty_message = wilder.popupmenu_empty_message({
            message = " No matches ",
          }),
          min_width = "15%",
          min_height = "10%",
          max_height = "30%",
          reverse = 0,
        })
      )

      -- Create highlight commands for wilder
      vim.cmd(string.format("hi WilderBorder guifg=%s guibg=%s", rose_pine_colors.border, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderAccent guifg=%s guibg=%s", rose_pine_colors.accent, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderError guifg=%s guibg=%s", rose_pine_colors.error, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderScrollbar guifg=%s", rose_pine_colors.accent))
     
      -- Set the renderer
      wilder.set_option('renderer', popupmenu_renderer)
    end,
  },
  
  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = true,
  },
  
  -- Colors for color codes
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = true,
  },
  
  -- Undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 3  -- Layout 3 puts tree on the right, diff on the bottom
      vim.g.undotree_SplitWidth = 25   -- Reduced from 30 to 25
      vim.g.undotree_DiffpanelHeight = 8  -- Reduced from 10 to 8
      vim.g.undotree_SetFocusWhenToggle = 0  -- Don't focus undotree when opened (stay in the file)
      vim.g.undotree_ShortIndicators = 1  -- Use short indicators
      vim.g.undotree_TreeNodeShape = '●'  -- Use a smaller icon for nodes
      vim.g.undotree_TreeVertShape = '│'  -- Use simpler vertical lines
      vim.g.undotree_TreeSplitShape = '╱'  -- Use simpler split shapes
      vim.g.undotree_TreeReturnShape = '╲'  -- Use simpler return shapes
      vim.g.undotree_DiffCommand = "diff"  -- Use standard diff command
      vim.g.undotree_RelativeTimestamp = 1  -- Use relative timestamps
      vim.g.undotree_HighlightChangedText = 1  -- Highlight changed text
      vim.g.undotree_HighlightChangedWithSign = 1  -- Show signs for changed text
    end,
  },
  
  -- DevDocs integration for programming language documentation
  {
    "luckasRanarison/nvim-devdocs",
    lazy = false,  -- Load on startup instead of lazy loading
    priority = 100,  -- Higher priority for loading
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      -- Force installation of required documentation on initial setup
      -- Don't call vim.cmd here as the plugin may not be loaded yet
      vim.defer_fn(function()
        local py_doc_path = vim.fn.stdpath("data") .. "/devdocs/docs/python~3.11"
        if not vim.loop.fs_stat(py_doc_path) then
          pcall(vim.cmd, "DevdocsFetch")
          pcall(vim.cmd, "DevdocsInstall python~3.11")
        end
      end, 3000)  -- Delay to ensure plugin is loaded
    end,
    config = function()
      local status_ok, devdocs = pcall(require, "nvim-devdocs")
      if not status_ok then
        vim.notify("Could not load nvim-devdocs plugin", vim.log.levels.ERROR)
        return
      end
      
      -- Force installation for Python
      local function install_python_docs()
        -- Create a temporary buffer for output
        local buf = vim.api.nvim_create_buf(false, true)
        
        -- Set up job to fetch documentation registry
        vim.fn.jobstart("curl -s https://devdocs.io/docs.json", {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and data[1] ~= "" then
              local success, json_data = pcall(vim.fn.json_decode, table.concat(data, "\n"))
              if success then
                -- Find Python documentation versions
                local python_docs = {}
                for _, doc in ipairs(json_data) do
                  if doc.name:match("^Python") or doc.slug:match("^python") then
                    table.insert(python_docs, doc.slug)
                  end
                end
                
                -- Install docs
                if #python_docs > 0 then
                  vim.defer_fn(function()
                    pcall(vim.cmd, "DevdocsInstall " .. python_docs[1])
                    vim.notify("Installing Python documentation: " .. python_docs[1], vim.log.levels.INFO)
                  end, 500)
                end
              end
            end
          end,
          on_exit = function()
            -- Clean up
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        })
      end
      
      -- Setup DevDocs
      devdocs.setup({
        dir_path = vim.fn.stdpath("data") .. "/devdocs", -- documentation storage path
        telescope = {
          width = 0.85, -- 85% of the screen width
          height = 0.75, -- 75% of the screen height
          previewer_width = 0.6, -- 60% of the telescope width for the document previewer
        },
        float_win = {
          relative = "editor",
          height = 0.9, -- 90% of the screen height
          width = 0.9, -- 90% of the screen width
          border = "rounded",
        },
        wrap = true, -- Wrap content in devdocs buffer
        after_open = function(bufnr)
          -- Set buffer options for better reading experience
          vim.api.nvim_buf_set_option(bufnr, "foldenable", false)
          vim.api.nvim_buf_set_option(bufnr, "spell", false)
          
          -- Add keymappings specific to documentation buffer
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':DevdocsOpenFloat<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '/', '/', { noremap = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'n', 'n', { noremap = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'N', 'N', { noremap = true })
          
          -- Notify user about search capabilities
          vim.notify("Use '/' to search within documentation. Press 'q' to close.", vim.log.levels.INFO)
        end,
        ensure_installed = {
          -- Automatically install these documentations on startup
          "python~3.11",  -- Specific Python version
          "javascript",
          "typescript",
          "go",
          "bash",
          "css",
          "html",
          "http",
          "git",
          "docker",
          "sql",
          "postgresql",
          "rust",
        },
        mappings = {
          open_in_split = "<C-s>",  -- Open in horizontal split
          open_in_vsplit = "<C-v>", -- Open in vertical split
          open_in_tab = "<C-t>",    -- Open in new tab
        },
      })
      
      -- Register commands manually to ensure they're available
      vim.api.nvim_create_user_command("DevdocsFetch", function()
        vim.cmd("lua require('nvim-devdocs.fetch').fetch_all_docs()")
      end, {})
      
      vim.api.nvim_create_user_command("DevdocsInstall", function(opts)
        vim.cmd("lua require('nvim-devdocs.install').install('" .. opts.args .. "')")
      end, { nargs = 1 })
      
      vim.api.nvim_create_user_command("DevdocsUninstall", function(opts)
        vim.cmd("lua require('nvim-devdocs.install').uninstall('" .. opts.args .. "')")
      end, { nargs = 1 })
      
      vim.api.nvim_create_user_command("DevdocsOpen", function(opts)
        if opts.args and opts.args ~= "" then
          vim.cmd("lua require('nvim-devdocs').open('" .. opts.args .. "')")
        else
          vim.cmd("lua require('nvim-devdocs').open()")
        end
      end, { nargs = "?" })
      
      vim.api.nvim_create_user_command("DevdocsOpenFloat", function(opts)
        if opts.args and opts.args ~= "" then
          vim.cmd("lua require('nvim-devdocs').open_float('" .. opts.args .. "')")
        else
          vim.cmd("lua require('nvim-devdocs').open_float()")
        end
      end, { nargs = "?" })
      
      vim.api.nvim_create_user_command("DevdocsUpdate", function(opts)
        vim.cmd("lua require('nvim-devdocs.update').update('" .. opts.args .. "')")
      end, { nargs = 1 })
      
      vim.api.nvim_create_user_command("DevdocsUpdateAll", function()
        vim.cmd("lua require('nvim-devdocs.update').update_all()")
      end, {})
      
      vim.api.nvim_create_user_command("DevdocsSearch", function()
        vim.cmd("lua require('telescope').extensions.devdocs.search()")
      end, {})
      
      -- Check and install Python documentation
      vim.defer_fn(function()
        local py_doc_path = vim.fn.stdpath("data") .. "/devdocs/docs/python~3.11"
        if not vim.loop.fs_stat(py_doc_path) then
          install_python_docs()
        end
      end, 5000)
    end,
  },
  
  -- Alpha dashboard for a beautiful welcome screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup()
    end,
  },
  
  -- Hardtime.nvim: Break bad Vim habits by forcing efficient movement
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      max_time = 1000,
      max_count = 3,
      disable_mouse = false,
      hint = true,
      notification = true,
      allow_different_key = false,
      enabled = true,
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n", "x" },
        ["k"] = { "n", "x" },
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<CR>"] = { "n", "x" },
        ["<C-M>"] = { "n", "x" },
        ["<C-N>"] = { "n", "x" },
        ["<C-P>"] = { "n", "x" },
      },
      disabled_keys = {},
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
    config = function(_, opts)
      require("hardtime").setup(opts)
      
      -- Add toggle keybinding
      vim.keymap.set("n", "<leader>ht", function()
        require("hardtime").toggle()
        local state = require("hardtime").is_enabled() and "enabled" or "disabled"
        vim.notify("Hardtime " .. state, vim.log.levels.INFO)
      end, { desc = "Toggle Hardtime" })
    end,
  },
  
  -- Zen Mode for distraction-free coding sessions
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" }
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 0.85,
        height = 0.95,
        options = {
          signcolumn = "no",       -- disable signcolumn
          number = false,          -- disable number column
          relativenumber = false,  -- disable relative numbers
          cursorline = false,      -- disable cursorline
          cursorcolumn = false,    -- disable cursor column
          foldcolumn = "0",        -- disable fold column
          list = false,            -- disable whitespace characters
        },
      },
      plugins = {
        -- Disable tmux status line while in zen mode
        tmux = { enabled = true },
        -- Keep your current colorscheme for a consistent experience
        kitty = { enabled = false, font = "+4" },
        -- Disable gitsigns in zen mode
        gitsigns = { enabled = false },
        -- Keep twilight enabled for an even more focused experience
        twilight = { enabled = true },
      },
      -- Don't hide the statusline in zen mode for a better UX
      on_open = function()
        vim.g.zen_mode_active = true
        -- Set transparent background when in zen mode
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) * 0.4)
      end,
      on_close = function()
        vim.g.zen_mode_active = false
        -- Restore scrolloff to dynamic setting
        local win_height = vim.api.nvim_win_get_height(0)
        vim.opt.scrolloff = math.floor(win_height * 0.75)
      end,
    },
  },
  
  -- Rose Pine theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  
  -- Tokyo Night theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        -- Configure Tokyo Night with transparent backgrounds
        style = "night", -- The theme comes in four styles: storm, moon, night, day
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer", "NvimTree" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        
        -- Enhance contrast for better readability
        on_colors = function(colors)
          colors.border = "#565f89"
          colors.bg_highlight = "#292e42"
        end,
        
        on_highlights = function(highlights, colors)
          -- Enhanced cursor line for better visibility
          highlights.CursorLine = { bg = "#292e42" }
          -- Better visibility for search results
          highlights.Search = { fg = "#c0caf5", bg = "#3d59a1" }
          highlights.IncSearch = { fg = "#c0caf5", bg = "#9d7cd8" }
          -- Improve line number contrast
          highlights.LineNr = { fg = "#565f89" }
          highlights.CursorLineNr = { fg = "#7aa2f7", bold = true }
        end,
      })
    end,
  },
}
