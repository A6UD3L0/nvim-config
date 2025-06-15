local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure LazyVim
require("lazy").setup({
  spec = {
    -- Import LazyVim and its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Import your custom plugins
    { import = "plugins" },
    
    -- Additional plugins
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"L3MON4D3/LuaSnip"},
    {"saadparwaiz1/cmp_luasnip"},
    {"rafamadriz/friendly-snippets"},
    {"windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup {} end},
    {"numToStr/Comment.nvim", config = true},
    {"lewis6991/gitsigns.nvim", config = true},
    {"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }},
    {"akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons"},
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", config = true},
    {"folke/which-key.nvim", config = true},
    {"folke/tokyonight.nvim", lazy = false, priority = 1000, config = function()
      vim.cmd[[colorscheme tokyonight]]
    end},
    
    -- Utility plugins
    {"mbbill/undotree"},
    {"ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" }},
    {"kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" }},
    {"akinsho/toggleterm.nvim", version = "*"},
    
    -- Custom utilities
    {
      dir = "lua/plugins/utilities.lua",
      name = "utilities",
      dependencies = {
        "mbbill/undotree",
        "ThePrimeagen/harpoon",
        "kdheepak/lazygit.nvim",
        "akinsho/toggleterm.nvim",
      },
      config = function()
        require("utilities").config()
      end,
    },
  },
  
  defaults = {
    lazy = false,
    version = false,
  },
  
  install = { 
    colorscheme = { "tokyonight" },
  },
  
  checker = {
    enabled = true,
    notify = false,
  },
  
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
    
    cache = {
      enabled = true,
    },
  },
  
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙️",
      keys = "🗝️",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  
  change_detection = {
    notify = false,
  },
  
  debug = false,
})
