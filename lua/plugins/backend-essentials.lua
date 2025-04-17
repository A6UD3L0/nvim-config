-- Essential plugins for backend development
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
        },
        max_concurrent_installers = 10,
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
          -- Core backend languages
          "pyright",           -- Python
          "gopls",             -- Go
          "clangd",            -- C/C++
          "sqlls",             -- SQL
          "dockerls",          -- Docker
          "yamlls",            -- YAML
          "jsonls",            -- JSON
          "bashls",            -- Bash
          "lua_ls",            -- Lua
        },
        automatic_installation = true,
      })
      
      -- Install essential tools for core languages
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Core formatters
          "black",             -- Python formatter
          "isort",             -- Python import sorter
          "gofumpt",           -- Go formatter
          "goimports",         -- Go imports
          "clang-format",      -- C/C++ formatter
          "prettier",          -- JSON/YAML formatter
          "sqlfluff",          -- SQL formatter
          
          -- Core linters
          "flake8",            -- Python linter
          "mypy",              -- Python type checker
          "golangci-lint",     -- Go linter
          "hadolint",          -- Dockerfile linter
          
          -- Core debuggers
          "debugpy",           -- Python debugger
          "delve",             -- Go debugger
          "codelldb",          -- C/C++ debugger
        },
        auto_update = true,
        run_on_start = true,
      })
      
      -- Configure LSP capabilities with nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Configure individual LSP servers
      local lspconfig = require("lspconfig")
      
      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
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
      
      -- Bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })
      
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

      -- Configure shared LSP keymaps and handlers
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          
          -- Buffer local mappings.
          local opts = { buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "Add workspace folder" })
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "Remove workspace folder" })
          vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { buffer = bufnr, desc = "List workspace folders" })
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Type definition" })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { buffer = bufnr, desc = "Format" })
          
          -- Set up document highlight if the client supports it
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            
            vim.api.nvim_create_autocmd({ "CursorMoved" }, {
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
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
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
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
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', require("ui.icons").lsp_kinds[vim_item.kind] or "", vim_item.kind)
            -- Source
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
      })
      
      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      
      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  
  -- Git integration with Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" }
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,
          telescope = true,
        },
      })
    end,
  },
  
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
    },
    keys = {
      { "<leader>gl", "<cmd>LazyGit<CR>", desc = "Open LazyGit" }
    },
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
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
      { "<leader>ha", function() require("harpoon"):list():append() end, desc = "Harpoon add file" },
      { "<leader>ht", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon toggle menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
    },
  },
  
  -- Python virtual environment management
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "VenvSelect",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Venv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
    },
    config = function()
      require("venv-selector").setup({
        name = { "venv", ".venv", "env", ".env" },
        auto_refresh = true,
      })
    end,
    ft = "python",
  },
  
  -- Command line autocomplete
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ':', '/', '?' } })
      
      wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlighter = wilder.basic_highlighter(),
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() },
          border = 'rounded',
          max_height = '25%',
        })
      ))
    end,
  },
  
  -- Undotree for visualizing undo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },
  
  -- Developer documentation browser
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
    },
    keys = {
      { "<leader>dd", "<cmd>DevdocsOpenFloat<CR>", desc = "Open DevDocs" },
      { "<leader>df", "<cmd>DevdocsFetch<CR>", desc = "Fetch DevDocs" },
    },
    config = function()
      require("nvim-devdocs").setup({
        dir_path = vim.fn.stdpath("data") .. "/devdocs",
        previewer_cmd = "glow",
        cmd_args = { "-s", "dark", "-w", "80" },
        picker_cmd = true,
        picker_cmd_args = { "-p" },
        after_open = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", { noremap = true, silent = true })
        end,
      })
      
      -- Ensure core language docs are installed
      local docs = {
        "python~3.11", "go", "c", "cpp", "docker", "sql", "bash", "dockerfile",
        "kubernetes", "yaml", "json"
      }
      
      for _, doc in ipairs(docs) do
        local success, _ = pcall(function()
          require("nvim-devdocs.internal").is_doc_installed(doc)
        end)
        
        if not success then
          pcall(function()
            require("nvim-devdocs.internal").install_doc(doc)
          end)
        end
      end
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            width = 0.95,
            height = 0.85,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
          winblend = 10,
          color_devicons = true,
          results_title = false,
          preview_title = false,
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "dropdown",
          },
        },
      }
    end,
  },
}
