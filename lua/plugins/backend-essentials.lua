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
        if vim.fn.has("nvim-0.10") == 1 and vim.fn.sign_define then
          vim.api.nvim_set_hl(0, hl, { default = true })
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        else
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
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
    init = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = {'╭','─','╮','│','╯','─','╰','│'}
      vim.g.lazygit_use_neovim_remote = 0
    end,
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
    end,
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 
        "nvim-telescope/telescope-fzf-native.nvim", 
        build = "make",
        cond = function() return vim.fn.executable "make" == 1 end,
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>f", desc = "Telescope" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
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
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".cache",
            "%.o",
            "%.a",
            "%.out",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
      
      -- Load extensions
      pcall(telescope.load_extension, "fzf")
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
      { "<leader>ef", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
    },
    config = function()
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        git = { enable = true, ignore = false },
        view = {
          width = 30, -- Match the width of undotree
          side = "left", -- Position on the left side
          preserve_window_proportions = true, -- Keep editing window large
          signcolumn = "yes",
        },
        actions = {
          open_file = {
            resize_window = true, -- Resize the window upon file open
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            },
          },
          change_dir = {
            enable = true,             -- Change directory when changing root
            global = true,             -- Change the working directory globally
            restrict_above_cwd = false, -- No restrictions on changing directory
          },
        },
        renderer = {
          root_folder_label = ":~:s?$?/..?", -- Show parent directory
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
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
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
        update_focused_file = {
          enable = true,       -- Update the focused file on cursor hold
          update_root = true,  -- Update the root directory if top level changes
          ignore_list = {},    -- Don't ignore any files
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
  
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
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
    branch = "regexp",  -- Use the 2024 version with regexp support
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python", -- For debugging integration
    },
    event = "VeryLazy",
    keys = {
      { "<leader>pa", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
      { "<leader>pc", "<cmd>VenvSelectCached<CR>", desc = "Use cached venv" },
    },
    config = function()
      require("venv-selector").setup({
        -- Common venv names to look for
        name = { 
          "venv", ".venv", "env", ".env", 
          "virtualenv", ".virtualenv", 
          "pyenv", ".python-venv",
        },
        
        -- Enhanced search settings for 2024 regexp version
        auto_refresh = true,
        search_venv_managers = true,
        search_workspace = true,
        
        -- Improved regexp search patterns
        search_patterns = {
          -- Basic patterns
          { "venv", "env", ".venv", ".env" },
          
          -- One level deep patterns
          { "*/venv", "*/env", "*/.venv", "*/.env" },
          { "*/virtualenv", "*/.virtualenv" },
          
          -- Project-specific patterns for common Python project structures
          { "*/python/*venv*", "*/python*/*env*" },
          { "*/projects/**/venv", "*/dev/**/venv" },
          
          -- Deep search with regular expressions
          { "global", "**/*venv*", "**/*env*" },
        },
        
        -- Search up to 3 levels up for virtual environments
        parents = 3,
        
        -- Cross-platform path to Python executable
        path_to_python = vim.fn.has("win32") == 1 
          and "Scripts\\python.exe" 
          or "bin/python",
        
        -- Debugging integration
        dap_enabled = true,
        
        -- Notification and hooks
        notify_user_on_activate = true,
        
        -- Callback when changing environments
        changed_venv_hook = function(venv)
          if venv then
            -- Update Python path for diagnostics tools
            if vim.fn.executable(venv .. "/bin/python") == 1 then
              vim.g.python3_host_prog = venv .. "/bin/python"
            end
            
            -- Notification with more details about the environment
            local python_version = vim.fn.system(venv .. "/bin/python --version"):gsub("\n", "")
            vim.notify(
              "Activated: " .. venv .. "\n" .. python_version,
              vim.log.levels.INFO, 
              { title = "Python Environment" }
            )
          end
        end,
      })
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
      "romgrk/fzy-lua-native", -- For better fuzzy finding
    },
    config = function()
      -- Only load if Neovim has Python support
      local has_python = vim.fn.has('python3') == 1
      
      -- Check for Python and provide graceful fallback if not available
      if not has_python then
        vim.notify("Wilder.nvim requires Python 3 support. Some command line features will be disabled.", vim.log.levels.WARN)
        -- Use basic setup with no Python features
        local wilder = require("wilder")
        wilder.setup({
          modes = {':', '/', '?'},
          enable_cmdline_enter = 1,
          enable_python = false,  -- Disable Python features
          use_python_remote_plugin = false,  -- Don't use Python remote plugin
        })
        return
      end
      
      -- Full setup with Python features
      local wilder = require("wilder")
      wilder.setup({
        modes = {':', '/', '?'},
        enable_cmdline_enter = 1,
      })
      
      -- Get Rose Pine colors for a consistent theme
      local rose_pine_colors = {
        base = "#191724",
        surface = "#1f1d2e",
        overlay = "#26233a",
        muted = "#6e6a86",
        subtle = "#908caa",
        text = "#e0def4",
        love = "#eb6f92",
        gold = "#f6c177",
        rose = "#ebbcba",
        pine = "#31748f",
        foam = "#9ccfd8",
        iris = "#c4a7e7",
        highlight_low = "#21202e",
        highlight_med = "#403d52",
        highlight_high = "#524f67",
        accent = "#524f67",
        error = "#eb6f92",
        warning = "#f6c177",
        info = "#9ccfd8",
        hint = "#31748f",
        
        -- UI elements
        bg = "#191724",
        fg = "#e0def4",
        border = "#1f1d2e",
      }
      
      -- Use a simple pipeline to avoid potential Python issues
      wilder.set_option('pipeline', {
        wilder.branch(
          -- Use cmdline pipeline for command mode
          {
            wilder.check(function(_, x) return vim.fn.getcmdtype() == ':' end),
            wilder.cmdline_pipeline(),
          },
          -- Use search pipeline for search mode
          wilder.search_pipeline()
        ),
      })
      
      -- Create highlight groups for wilder
      local popupmenu_renderer = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlights = {
            default = "WilderMenu",
            border = "WilderBorder",
            accent = "WilderAccent",
            selected = "WilderSelected",
            error = "WilderError",
          },
          -- Add border for better visibility
          border = 'rounded',
          -- No complex renderer components to avoid Python dependencies
          pumblend = 0,
        })
      )
      
      -- Create highlight commands for wilder
      vim.cmd(string.format("hi WilderBorder guifg=%s guibg=%s", rose_pine_colors.border, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderAccent guifg=%s guibg=%s", rose_pine_colors.accent, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderError guifg=%s guibg=%s", rose_pine_colors.error, rose_pine_colors.bg))
      vim.cmd(string.format("hi WilderSelected guifg=%s guibg=%s gui=bold", rose_pine_colors.text, rose_pine_colors.highlight_med))
      vim.cmd(string.format("hi WilderMenu guifg=%s guibg=%s", rose_pine_colors.text, rose_pine_colors.bg))
      
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
    event = "VeryLazy", 
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local status_ok, devdocs = pcall(require, "nvim-devdocs")
      if not status_ok then
        vim.notify("Could not load nvim-devdocs plugin", vim.log.levels.ERROR)
        return
      end
      
      -- Setup DevDocs
      devdocs.setup({
        dir_path = vim.fn.stdpath("data") .. "/devdocs", -- documentation storage path
        telescope = {
          width = 0.7, -- Simpler, more focused UI
          height = 0.5, -- Less intrusive
          previewer_width = 0.5, -- More balanced preview
        },
        float_win = {
          relative = "editor",
          height = 0.7, -- More compact floating window
          width = 0.7,
          border = "rounded",
          title = "DevDocs",
          title_pos = "center",
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
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', ':DevdocsOpen<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-v>', ':DevdocsOpen<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-t>', ':DevdocsOpen<CR>', { noremap = true, silent = true })
          -- Notify user about search capabilities
          vim.notify("[DevDocs] '/' to search, <C-s>/<C-v>/<C-t> to open, 'q' to close.", vim.log.levels.INFO)
        end,
        ensure_installed = {
          -- Automatically install these documentations on startup
          "python~3.11",  -- Specific Python version
          "javascript",
          "typescript",
          "bash",
          "git",
          "docker",
          "sql",
          "scikit_learn",  -- Machine learning library
          "numpy~1.24",    -- Data manipulation
          "pandas~1",      -- Data analysis
        },
        mappings = {
          open_in_split = "<C-s>",
          open_in_vsplit = "<C-v>",
          open_in_tab = "<C-t>",
        },
      })
      
      -- Create command aliases for DevDocs to ensure compatibility with latest version
      vim.api.nvim_create_user_command("DevdocsFetch", function()
        vim.notify("Fetching documentation index...", vim.log.levels.INFO)
        -- Call the plugin's fetch method directly
        local success, err = pcall(function()
          -- Modern version uses M.fetch_registery()
          devdocs.fetch_registery()
        end)
        
        if not success then
          vim.notify("DevDocs metadata fetch failed: " .. tostring(err), vim.log.levels.WARN)
          -- Try fallback to command
          pcall(vim.cmd, "DevdocsFetch")
        end
      end, {})
      
      vim.api.nvim_create_user_command("DevdocsInstall", function(opts)
        if opts.args and opts.args ~= "" then
          vim.notify("Installing documentation for " .. opts.args, vim.log.levels.INFO)
          -- Use the virtual args object to pass to the plugin's install_doc method
          local args = { fargs = { opts.args } }
          devdocs.install_doc(args)
        else
          vim.notify("Please specify a documentation to install or run without arguments to see picker", vim.log.levels.INFO)
          -- Call with empty args to open picker
          devdocs.install_doc({ fargs = {} })
        end
      end, { nargs = "?" })
      
      -- Fix DevdocsOpen: Don't create a circular reference
      vim.api.nvim_create_user_command("DevdocsOpenCmd", function(opts)
        local success, err = pcall(function()
          if opts.args and opts.args ~= "" then
            -- Create proper args object
            local args = { fargs = { opts.args } }
            -- Use the plugin's API directly
            devdocs.open_doc(args)
          else
            -- Open picker for all docs
            devdocs.open_doc({ fargs = {} })
          end
        end)
        
        if not success then
          vim.notify("DevDocs error: " .. tostring(err), vim.log.levels.ERROR)
        end
      end, { nargs = "?" })
      
      -- Fix DevdocsOpenFloat: Don't create a circular reference
      vim.api.nvim_create_user_command("DevdocsOpenFloatCmd", function(opts)
        local success, err = pcall(function()
          if opts.args and opts.args ~= "" then
            -- Create proper args object
            local args = { fargs = { opts.args } }
            -- Use the plugin's API directly
            devdocs.open_doc_float(args)
          else
            -- Open picker for all docs in float window
            devdocs.open_doc_float({ fargs = {} })
          end
        end)
        
        if not success then
          vim.notify("DevDocs error: " .. tostring(err), vim.log.levels.ERROR)
        end
      end, { nargs = "?" })
      
      vim.api.nvim_create_user_command("DevdocsSearch", function()
        -- Open picker with all docs - the modern version's equivalent of search
        devdocs.open_doc({ fargs = {} })
      end, {})
      
      -- Add current filetype doc opener
      vim.api.nvim_create_user_command("DevdocsFiletype", function()
        devdocs.open_doc_current_file()
      end, {})
      
      -- Add current filetype doc opener in float window
      vim.api.nvim_create_user_command("DevdocsFiletypeFloat", function()
        devdocs.open_doc_current_file(true)
      end, {})
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
}
