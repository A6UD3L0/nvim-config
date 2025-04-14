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
          
          -- Buffer local mappings
          local opts = { buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          
          -- Set some keybinds conditional on server capabilities
          if client.server_capabilities.documentFormattingProvider then
            vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
          end
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
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "" },
        change = { text = "" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "" },
        untracked = { text = "" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        
        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")
        
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Previous hunk")
        
        -- Actions
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage selected hunk")
        map("v", "<leader>gr", function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset selected hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line{full=true} end, "Blame line")
      end,
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
      { "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
    },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      git = { enable = true, ignore = false },
      renderer = {
        highlight_git = true,
        indent_markers = { enable = true },
      },
    },
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
          registers = true,  -- shows registers when pressing " in NORMAL or <C-r> in INSERT
          spelling = {
            enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          },
          presets = {
            operators = true,    -- adds help for operators like d, y, ...
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
          },
        },
        window = {
          border = "single",       -- "single", "double", "shadow"
          position = "bottom-right", -- "bottom", "top-right"
          margin = { 0, 0, 0, 0 },  -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,            -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
        layout = {
          height = { min = 5, max = 30 }, -- min and max height of the columns
          width = { min = 30, max = 50 }, -- min and max width of the columns
          spacing = 2,                    -- spacing between columns
          align = "center",               -- align columns left, center or right
        },
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "→",  -- symbol used between a key and its label
          group = "+",      -- symbol prepended to a group
        },
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        triggers_nowait = {
          -- marks
          "`",
          "'",
          "g`",
          "g'",
          -- registers
          '"',
          "<c-r>",
          -- spelling
          "z=",
        },
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          i = { "j", "k" },
          v = { "j", "k" },
        },
      })
      
      -- Register all keybinding groups
      wk.register({
        ["<leader>"] = {
          ["<leader>"] = { "<cmd>WhichKey<CR>", "Show all keybindings" },
          ["b"] = { name = "Buffers" },
          ["c"] = { name = "Code Actions" },
          ["cd"] = { name = "Change Directory" },
          ["cc"] = { name = "Comments" },
          ["d"] = { name = "Debug" },
          ["db"] = { name = "Database" },
          ["D"] = { name = "Docker" },
          ["f"] = { name = "Find" },
          ["g"] = { name = "Git" },
          ["h"] = { name = "Harpoon" },
          ["l"] = { name = "LSP" },
          ["p"] = { 
            name = "Python",
            ["v"] = { "<cmd>VenvSelect<CR>", "Select venv" },
            ["t"] = { "<cmd>Telescope python_tests<CR>", "Python tests" },
            ["d"] = { "<cmd>lua require('dap-python').debug_selection()<CR>", "Debug selection" },
            ["e"] = { "<cmd>lua vim.cmd('normal! gv'); require('mappings')._python_execute_selected()<CR>", "Execute selected" },
            ["i"] = { "<cmd>lua require('mappings')._python_install_requirements()<CR>", "Install requirements" },
            ["n"] = { "<cmd>lua require('mappings')._python_new_file()<CR>", "New Python file" },
            ["r"] = { "<cmd>lua require('mappings')._python_run_with_args()<CR>", "Run with args" },
            
            -- Poetry commands submenu
            ["p"] = { 
              name = "Poetry",
              ["a"] = { "<cmd>lua require('mappings')._poetry_add_package()<CR>", "Add package" },
              ["r"] = { "<cmd>lua require('mappings')._poetry_remove_package()<CR>", "Remove package" },
              ["u"] = { "<cmd>lua require('mappings')._poetry_update()<CR>", "Update packages" },
              ["o"] = { "<cmd>lua require('mappings')._poetry_show_outdated()<CR>", "Show outdated" },
              ["n"] = { "<cmd>TermExec cmd='poetry new'<CR>", "New project" },
              ["i"] = { "<cmd>TermExec cmd='poetry install'<CR>", "Install dependencies" },
              ["b"] = { "<cmd>TermExec cmd='poetry build'<CR>", "Build package" },
              ["s"] = { "<cmd>TermExec cmd='poetry shell'<CR>", "Poetry shell" },
              ["e"] = { "<cmd>edit pyproject.toml<CR>", "Edit pyproject.toml" },
              ["c"] = { "<cmd>lua require('mappings')._poetry_create_venv()<CR>", "Create .venv" },
            },
          },
        },
        ["w"] = { name = "Window/Write" },
        ["x"] = { "<cmd>!chmod +x %<CR>", "Make file executable" },
        ["y"] = { '"+y', "Yank to clipboard" },
        ["Y"] = { '"+Y', "Yank line to clipboard" },
        ["z"] = { name = "Folding" },
      })
      
      -- Register all specific keybindings from mappings.lua
      wk.register({
        -- Buffer mappings
        ["<leader>b"] = {
          ["n"] = { "<cmd>bnext<CR>", "Next buffer" },
          ["p"] = { "<cmd>bprevious<CR>", "Previous buffer" },
          ["d"] = { "<cmd>bdelete<CR>", "Delete buffer" },
          ["l"] = { "<cmd>buffers<CR>", "List buffers" },
        },
        
        -- LSP mappings
        ["<leader>l"] = {
          ["f"] = { vim.lsp.buf.format, "Format" },
          ["r"] = { vim.lsp.buf.rename, "Rename" },
          ["a"] = { vim.lsp.buf.code_action, "Code action" },
          ["d"] = { vim.lsp.buf.definition, "Go to definition" },
          ["i"] = { vim.lsp.buf.implementation, "Go to implementation" },
          ["k"] = { vim.lsp.buf.hover, "Show hover info" },
          ["t"] = { vim.lsp.buf.type_definition, "Go to type definition" },
          ["n"] = { vim.diagnostic.goto_next, "Next diagnostic" },
          ["p"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
        },
        
        -- Terminal mappings
        ["<leader>t"] = {
          ["t"] = { "<cmd>ToggleTerm direction=horizontal<CR>", "Toggle terminal" },
          ["f"] = { "<cmd>ToggleTerm direction=float<CR>", "Floating terminal" },
          ["v"] = { "<cmd>ToggleTerm direction=vertical<CR>", "Vertical terminal" },
          ["p"] = { "<cmd>lua _PYTHON_TOGGLE()<CR>", "Python terminal" },
          ["i"] = { "<cmd>lua _IPYTHON_TOGGLE()<CR>", "IPython terminal" },
          ["r"] = { "<cmd>lua _PYTHON_RUN_FILE()<CR>", "Run Python file" },
        },
        
        -- Window and pane management
        ["<leader>w"] = {
          ["w"] = { "<cmd>w<CR>", "Save" },
          ["v"] = { "<cmd>vsplit<CR>", "Split vertically" },
          ["h"] = { "<cmd>split<CR>", "Split horizontally" },
          ["e"] = { "<C-w>=", "Make splits equal" },
          ["c"] = { "<cmd>close<CR>", "Close window" },
          ["q"] = { "<cmd>q<CR>", "Quit" },
          ["Q"] = { "<cmd>qa<CR>", "Quit all" },
          ["L"] = { "<cmd>vertical resize +10<CR>", "Increase width" },
          ["H"] = { "<cmd>vertical resize -10<CR>", "Decrease width" },
          ["K"] = { "<cmd>resize +5<CR>", "Increase height" },
          ["J"] = { "<cmd>resize -5<CR>", "Decrease height" },
          ["="] = { "<C-w>=", "Equal size windows" },
        },
        
        -- Find mappings with Telescope
        ["<leader>f"] = {
          ["f"] = { "<cmd>Telescope find_files<CR>", "Find files" },
          ["g"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
          ["b"] = { "<cmd>Telescope buffers<CR>", "Buffers" },
          ["h"] = { "<cmd>Telescope help_tags<CR>", "Help tags" },
          ["r"] = { "<cmd>Telescope oldfiles<CR>", "Recent files" },
          ["m"] = { "<cmd>Telescope marks<CR>", "Marks" },
          ["s"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols" },
          ["S"] = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
        },
        
        -- Debug mappings
        ["<leader>d"] = {
          ["b"] = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
          ["c"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
          ["i"] = { "<cmd>lua require('dap').step_into()<CR>", "Step into" },
          ["o"] = { "<cmd>lua require('dap').step_over()<CR>", "Step over" },
          ["O"] = { "<cmd>lua require('dap').step_out()<CR>", "Step out" },
          ["t"] = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
          ["r"] = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL" },
        },
        
        -- Git mappings
        ["<leader>g"] = {
          ["g"] = { "<cmd>LazyGit<CR>", "LazyGit" },
          ["s"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
          ["u"] = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk" },
          ["p"] = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
          ["b"] = { "<cmd>Gitsigns blame_line<CR>", "Blame line" },
          ["d"] = { "<cmd>Gitsigns diffthis<CR>", "Diff this" },
          ["c"] = { "<cmd>Telescope git_commits<CR>", "Commits" },
          ["B"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
        },
        
        -- Python specific mappings
        ["<leader>p"] = {
          ["v"] = { "<cmd>VenvSelect<CR>", "Select venv" },
          ["t"] = { "<cmd>Telescope python_tests<CR>", "Python tests" },
          ["d"] = { "<cmd>lua require('dap-python').debug_selection()<CR>", "Debug selection" },
          ["e"] = { "<cmd>lua vim.cmd('normal! gv'); require('mappings')._python_execute_selected()<CR>", "Execute selected" },
          ["i"] = { "<cmd>lua require('mappings')._python_install_requirements()<CR>", "Install requirements" },
          ["n"] = { "<cmd>lua require('mappings')._python_new_file()<CR>", "New Python file" },
          ["r"] = { "<cmd>lua require('mappings')._python_run_with_args()<CR>", "Run with args" },
          
          -- Poetry commands submenu
          ["p"] = { 
            name = "Poetry",
            ["a"] = { "<cmd>lua require('mappings')._poetry_add_package()<CR>", "Add package" },
            ["r"] = { "<cmd>lua require('mappings')._poetry_remove_package()<CR>", "Remove package" },
            ["u"] = { "<cmd>lua require('mappings')._poetry_update()<CR>", "Update packages" },
            ["o"] = { "<cmd>lua require('mappings')._poetry_show_outdated()<CR>", "Show outdated" },
            ["n"] = { "<cmd>TermExec cmd='poetry new'<CR>", "New project" },
            ["i"] = { "<cmd>TermExec cmd='poetry install'<CR>", "Install dependencies" },
            ["b"] = { "<cmd>TermExec cmd='poetry build'<CR>", "Build package" },
            ["s"] = { "<cmd>TermExec cmd='poetry shell'<CR>", "Poetry shell" },
            ["e"] = { "<cmd>edit pyproject.toml<CR>", "Edit pyproject.toml" },
            ["c"] = { "<cmd>lua require('mappings')._poetry_create_venv()<CR>", "Create .venv" },
          },
        },
        
        -- Virtual Environment Diagnostics
        ["<leader>v"] = {
          name = "Python Venv",
          ["d"] = { "<cmd>VenvDiagnostics<CR>", "Run diagnostics" },
          ["t"] = { "<cmd>TestVenv<CR>", "Test current venv" },
          ["s"] = { "<cmd>VenvSelect<CR>", "Select venv" },
        },
        
        -- Code related commands
        ["<leader>c"] = {
          ["v"] = { "<cmd>lua require('mappings')._python_activate_venv()<CR>", "Activate Python venv" },
          ["a"] = { "<cmd>lua require('mappings')._python_activate_custom_venv()<CR>", "Activate custom venv" },
          ["c"] = { name = "Comments" },
          ["d"] = { name = "Change Directory" },
        },
        
        -- Database
        ["<leader>db"] = {
          ["u"] = { "<cmd>DBUIToggle<CR>", "Toggle UI" },
          ["a"] = { "<cmd>DBUIAddConnection<CR>", "Add connection" },
          ["f"] = { "<cmd>DBUIFindBuffer<CR>", "Find buffer" },
        },
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
  
  -- Python environment management
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
    },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true,
    },
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
        theme = "catppuccin",
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
              return wilder.wildcard_expansion(arg, file_completion)
            end,
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
      local highlight_colors = {
        ["bg"] = { background = rose_pine_colors.bg },
        ["fg"] = { foreground = rose_pine_colors.fg },
        ["accent"] = { foreground = rose_pine_colors.accent },
        ["accent_bg"] = { background = rose_pine_colors.accent, foreground = rose_pine_colors.bg },
        ["selected"] = { background = rose_pine_colors.selected },
        ["border"] = { foreground = rose_pine_colors.border },
        ["error"] = { foreground = rose_pine_colors.error },
      }

      -- Add Rose Pine inspired border and better visual appearance
      local popupmenu_renderer = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlights = {
            default = wilder.make_hl("WilderDefault", "Pmenu", highlight_colors.bg, highlight_colors.fg),
            border = wilder.make_hl("WilderBorder", "Pmenu", highlight_colors.bg, highlight_colors.border),
            accent = wilder.make_hl("WilderAccent", "Pmenu", highlight_colors.bg, highlight_colors.accent),
            selected = wilder.make_hl("WilderSelected", "PmenuSel", highlight_colors.selected),
            error = wilder.make_hl("WilderError", "Pmenu", highlight_colors.bg, highlight_colors.error),
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
              thumb_hl = wilder.make_hl("WilderScrollbar", "Pmenu", {}, rose_pine_colors.accent),
              track_hl = wilder.make_hl("WilderScrollbarTrack", "Pmenu", rose_pine_colors.bg),
            }),
          },
          empty_message = wilder.popupmenu_empty_message({
            message = " No matches ",
            hl = wilder.make_hl("WilderEmptyMessage", "Pmenu", highlight_colors.bg, highlight_colors.gray),
          }),
          min_width = "15%",
          min_height = "10%",
          max_height = "30%",
          reverse = false,
        })
      )

      local wildmenu_renderer = wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        highlights = {
          default = wilder.make_hl("WilderMenuDefault", "Pmenu", {}, highlight_colors.fg),
          accent = wilder.make_hl("WilderMenuAccent", "Pmenu", {}, highlight_colors.accent),
          selected = wilder.make_hl("WilderMenuSelected", "PmenuSel", highlight_colors.selected),
        },
        separator = " · ",
        left = { " ", wilder.wildmenu_spinner(), " " },
        right = { " ", wilder.wildmenu_index() },
      })

      wilder.set_option("renderer", wilder.renderer_mux({
        [":"] = popupmenu_renderer,
        ["/"] = wildmenu_renderer,
        ["?"] = wildmenu_renderer,
      }))
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
  
  -- Python Environment Diagnostics
  {
    "A6UD3L0/venv-diagnostics.nvim",
    dir = vim.fn.stdpath("config") .. "/lua/venv_diagnostics.lua",
    ft = { "python" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("venv_diagnostics")
    end,
  },
  
  -- Undotree
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 24
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_HighlightChanged = 1
      vim.g.undotree_HighlightDiff = 1
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
          registers = true,  -- shows registers when pressing " in NORMAL or <C-r> in INSERT
          spelling = {
            enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          },
          presets = {
            operators = true,    -- adds help for operators like d, y, ...
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
          },
        },
        window = {
          border = "single",       -- "single", "double", "shadow"
          position = "bottom-right", -- "bottom", "top-right"
          margin = { 0, 0, 0, 0 },  -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,            -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
        layout = {
          height = { min = 5, max = 30 }, -- min and max height of the columns
          width = { min = 30, max = 50 }, -- min and max width of the columns
          spacing = 2,                    -- spacing between columns
          align = "center",               -- align columns left, center or right
        },
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "→",  -- symbol used between a key and its label
          group = "+",      -- symbol prepended to a group
        },
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        triggers_nowait = {
          -- marks
          "`",
          "'",
          "g`",
          "g'",
          -- registers
          '"',
          "<c-r>",
          -- spelling
          "z=",
        },
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          i = { "j", "k" },
          v = { "j", "k" },
        },
      })
      
      -- Register all keybinding groups
      wk.register({
        ["<leader>"] = {
          ["<leader>"] = { "<cmd>WhichKey<CR>", "Show all keybindings" },
          ["b"] = { name = "Buffers" },
          ["c"] = { name = "Code Actions" },
          ["cd"] = { name = "Change Directory" },
          ["cc"] = { name = "Comments" },
          ["d"] = { name = "Debug" },
          ["db"] = { name = "Database" },
          ["D"] = { name = "Docker" },
          ["f"] = { name = "Find" },
          ["g"] = { name = "Git" },
          ["h"] = { name = "Harpoon" },
          ["l"] = { name = "LSP" },
          ["p"] = { 
            name = "Python",
            ["v"] = { "<cmd>VenvSelect<CR>", "Select venv" },
            ["t"] = { "<cmd>Telescope python_tests<CR>", "Python tests" },
            ["d"] = { "<cmd>lua require('dap-python').debug_selection()<CR>", "Debug selection" },
            ["e"] = { "<cmd>lua vim.cmd('normal! gv'); require('mappings')._python_execute_selected()<CR>", "Execute selected" },
            ["i"] = { "<cmd>lua require('mappings')._python_install_requirements()<CR>", "Install requirements" },
            ["n"] = { "<cmd>lua require('mappings')._python_new_file()<CR>", "New Python file" },
            ["r"] = { "<cmd>lua require('mappings')._python_run_with_args()<CR>", "Run with args" },
            
            -- Poetry commands submenu
            ["p"] = { 
              name = "Poetry",
              ["a"] = { "<cmd>lua require('mappings')._poetry_add_package()<CR>", "Add package" },
              ["r"] = { "<cmd>lua require('mappings')._poetry_remove_package()<CR>", "Remove package" },
              ["u"] = { "<cmd>lua require('mappings')._poetry_update()<CR>", "Update packages" },
              ["o"] = { "<cmd>lua require('mappings')._poetry_show_outdated()<CR>", "Show outdated" },
              ["n"] = { "<cmd>TermExec cmd='poetry new'<CR>", "New project" },
              ["i"] = { "<cmd>TermExec cmd='poetry install'<CR>", "Install dependencies" },
              ["b"] = { "<cmd>TermExec cmd='poetry build'<CR>", "Build package" },
              ["s"] = { "<cmd>TermExec cmd='poetry shell'<CR>", "Poetry shell" },
              ["e"] = { "<cmd>edit pyproject.toml<CR>", "Edit pyproject.toml" },
              ["c"] = { "<cmd>lua require('mappings')._poetry_create_venv()<CR>", "Create .venv" },
            },
          },
        },
        ["w"] = { name = "Window/Write" },
        ["x"] = { "<cmd>!chmod +x %<CR>", "Make file executable" },
        ["y"] = { '"+y', "Yank to clipboard" },
        ["Y"] = { '"+Y', "Yank line to clipboard" },
        ["z"] = { name = "Folding" },
      })
      
      -- Register all specific keybindings from mappings.lua
      wk.register({
        -- Buffer mappings
        ["<leader>b"] = {
          ["n"] = { "<cmd>bnext<CR>", "Next buffer" },
          ["p"] = { "<cmd>bprevious<CR>", "Previous buffer" },
          ["d"] = { "<cmd>bdelete<CR>", "Delete buffer" },
          ["l"] = { "<cmd>buffers<CR>", "List buffers" },
        },
        
        -- LSP mappings
        ["<leader>l"] = {
          ["f"] = { vim.lsp.buf.format, "Format" },
          ["r"] = { vim.lsp.buf.rename, "Rename" },
          ["a"] = { vim.lsp.buf.code_action, "Code action" },
          ["d"] = { vim.lsp.buf.definition, "Go to definition" },
          ["i"] = { vim.lsp.buf.implementation, "Go to implementation" },
          ["k"] = { vim.lsp.buf.hover, "Show hover info" },
          ["t"] = { vim.lsp.buf.type_definition, "Go to type definition" },
          ["n"] = { vim.diagnostic.goto_next, "Next diagnostic" },
          ["p"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
        },
        
        -- Terminal mappings
        ["<leader>t"] = {
          ["t"] = { "<cmd>ToggleTerm direction=horizontal<CR>", "Toggle terminal" },
          ["f"] = { "<cmd>ToggleTerm direction=float<CR>", "Floating terminal" },
          ["v"] = { "<cmd>ToggleTerm direction=vertical<CR>", "Vertical terminal" },
          ["p"] = { "<cmd>lua _PYTHON_TOGGLE()<CR>", "Python terminal" },
          ["i"] = { "<cmd>lua _IPYTHON_TOGGLE()<CR>", "IPython terminal" },
          ["r"] = { "<cmd>lua _PYTHON_RUN_FILE()<CR>", "Run Python file" },
        },
        
        -- Window and pane management
        ["<leader>w"] = {
          ["w"] = { "<cmd>w<CR>", "Save" },
          ["v"] = { "<cmd>vsplit<CR>", "Split vertically" },
          ["h"] = { "<cmd>split<CR>", "Split horizontally" },
          ["e"] = { "<C-w>=", "Make splits equal" },
          ["c"] = { "<cmd>close<CR>", "Close window" },
          ["q"] = { "<cmd>q<CR>", "Quit" },
          ["Q"] = { "<cmd>qa<CR>", "Quit all" },
          ["L"] = { "<cmd>vertical resize +10<CR>", "Increase width" },
          ["H"] = { "<cmd>vertical resize -10<CR>", "Decrease width" },
          ["K"] = { "<cmd>resize +5<CR>", "Increase height" },
          ["J"] = { "<cmd>resize -5<CR>", "Decrease height" },
          ["="] = { "<C-w>=", "Equal size windows" },
        },
        
        -- Find mappings with Telescope
        ["<leader>f"] = {
          ["f"] = { "<cmd>Telescope find_files<CR>", "Find files" },
          ["g"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
          ["b"] = { "<cmd>Telescope buffers<CR>", "Buffers" },
          ["h"] = { "<cmd>Telescope help_tags<CR>", "Help tags" },
          ["r"] = { "<cmd>Telescope oldfiles<CR>", "Recent files" },
          ["m"] = { "<cmd>Telescope marks<CR>", "Marks" },
          ["s"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols" },
          ["S"] = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
        },
        
        -- Debug mappings
        ["<leader>d"] = {
          ["b"] = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
          ["c"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
          ["i"] = { "<cmd>lua require('dap').step_into()<CR>", "Step into" },
          ["o"] = { "<cmd>lua require('dap').step_over()<CR>", "Step over" },
          ["O"] = { "<cmd>lua require('dap').step_out()<CR>", "Step out" },
          ["t"] = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
          ["r"] = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL" },
        },
        
        -- Git mappings
        ["<leader>g"] = {
          ["g"] = { "<cmd>LazyGit<CR>", "LazyGit" },
          ["s"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
          ["u"] = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk" },
          ["p"] = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
          ["b"] = { "<cmd>Gitsigns blame_line<CR>", "Blame line" },
          ["d"] = { "<cmd>Gitsigns diffthis<CR>", "Diff this" },
          ["c"] = { "<cmd>Telescope git_commits<CR>", "Commits" },
          ["B"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
        },
        
        -- Python specific mappings
        ["<leader>p"] = {
          ["v"] = { "<cmd>VenvSelect<CR>", "Select venv" },
          ["t"] = { "<cmd>Telescope python_tests<CR>", "Python tests" },
          ["d"] = { "<cmd>lua require('dap-python').debug_selection()<CR>", "Debug selection" },
          ["e"] = { "<cmd>lua vim.cmd('normal! gv'); require('mappings')._python_execute_selected()<CR>", "Execute selected" },
          ["i"] = { "<cmd>lua require('mappings')._python_install_requirements()<CR>", "Install requirements" },
          ["n"] = { "<cmd>lua require('mappings')._python_new_file()<CR>", "New Python file" },
          ["r"] = { "<cmd>lua require('mappings')._python_run_with_args()<CR>", "Run with args" },
          
          -- Poetry commands submenu
          ["p"] = { 
            name = "Poetry",
            ["a"] = { "<cmd>lua require('mappings')._poetry_add_package()<CR>", "Add package" },
            ["r"] = { "<cmd>lua require('mappings')._poetry_remove_package()<CR>", "Remove package" },
            ["u"] = { "<cmd>lua require('mappings')._poetry_update()<CR>", "Update packages" },
            ["o"] = { "<cmd>lua require('mappings')._poetry_show_outdated()<CR>", "Show outdated" },
            ["n"] = { "<cmd>TermExec cmd='poetry new'<CR>", "New project" },
            ["i"] = { "<cmd>TermExec cmd='poetry install'<CR>", "Install dependencies" },
            ["b"] = { "<cmd>TermExec cmd='poetry build'<CR>", "Build package" },
            ["s"] = { "<cmd>TermExec cmd='poetry shell'<CR>", "Poetry shell" },
            ["e"] = { "<cmd>edit pyproject.toml<CR>", "Edit pyproject.toml" },
            ["c"] = { "<cmd>lua require('mappings')._poetry_create_venv()<CR>", "Create .venv" },
          },
        },
        
        -- Virtual Environment Diagnostics
        ["<leader>v"] = {
          name = "Python Venv",
          ["d"] = { "<cmd>VenvDiagnostics<CR>", "Run diagnostics" },
          ["t"] = { "<cmd>TestVenv<CR>", "Test current venv" },
          ["s"] = { "<cmd>VenvSelect<CR>", "Select venv" },
        },
        
        -- Code related commands
        ["<leader>c"] = {
          ["v"] = { "<cmd>lua require('mappings')._python_activate_venv()<CR>", "Activate Python venv" },
          ["a"] = { "<cmd>lua require('mappings')._python_activate_custom_venv()<CR>", "Activate custom venv" },
          ["c"] = { name = "Comments" },
          ["d"] = { name = "Change Directory" },
        },
        
        -- Database
        ["<leader>db"] = {
          ["u"] = { "<cmd>DBUIToggle<CR>", "Toggle UI" },
          ["a"] = { "<cmd>DBUIAddConnection<CR>", "Add connection" },
          ["f"] = { "<cmd>DBUIFindBuffer<CR>", "Find buffer" },
        },
      })
    end,
  },
}
