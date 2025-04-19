-- Nvim Configuration: Core Plugin Management
-- Implements a robust plugin architecture with MECE (Mutually Exclusive, Collectively Exhaustive) modules
-- Each module has clear responsibilities, lazy-loading, and fallback mechanisms

-- Plugin Layers (from lowest to highest):
-- 1. Core: Essential functionality with minimal dependencies (autocmds, keymaps, etc)
-- 2. Foundation: Base libraries and utilities (plenary, devicons, etc)
-- 3. UI: Visual elements and themes
-- 4. Editor: Text editing capabilities
-- 5. LSP & Completion: Language services and completions
-- 6. Tools: Domain-specific tools (git, testing, etc)
-- 7. Workflow: User experience and workflow enhancements

local M = {
  -- Core utilities needed by many plugins
  {
    "nvim-lua/plenary.nvim", -- Lua utility functions
    lazy = true, -- Load only when required by other plugins
    priority = 1000, -- Highest priority, load first
  },

  -- Foundation layer
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        strict = true,
      })
    end,
  },
  
  -- WhichKey for better keybinding visualization
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("core.keybindings") -- Load our new unified keybinding system
    end,
  },
  
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
  
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  },
  
  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
  },
  
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("core.lsp").setup() -- Use our new centralized LSP system
    end,
  },
  
  -- Mason for managing external tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
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
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
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
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Source indication
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
  
  -- Terminal Integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { [[<C-\>]] },
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end,
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },
  
  -- Comments
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "javascript", "typescript", 
          "html", "css", "json", "bash", "markdown", "markdown_inline"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  
  -- Python uv.nvim Integration
  {
    "benomahony/uv.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "python",
    config = function()
      -- The setup happens in our plugins/python.lua module
      require("plugins.python").setup()
    end,
  },
  
  -- Python environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = "python",
    config = function()
      require("venv-selector").setup({
        auto_refresh = true,
        search_venv_managers = true,
        search_workspace = true,
      })
    end,
  },
  
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    config = function()
      require("harpoon"):setup()
    end,
  }
}

return M
