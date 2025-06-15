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
    
    -- Core plugins that aren't defined in separate files
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {"numToStr/Comment.nvim", config = true},
    {"lewis6991/gitsigns.nvim", config = true},
    {"folke/which-key.nvim", config = true},
    
    -- Utility plugins with their configurations
    {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
      config = function()
        vim.g.undotree_WindowLayout = 3
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_DiffpanelHeight = 10
        vim.g.undotree_SplitWidth = 40
      end,
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require('harpoon').setup({
          global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { 'harpoon' },
            mark_branch = false,
          },
        })
      end,
    },
    {
      "kdheepak/lazygit.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
        vim.g.lazygit_floating_window_use_plenary = 0
        vim.g.lazygit_use_neovim_remote = 1
      end,
      cmd = { "LazyGit", "LazyGitConfig" },
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require('toggleterm').setup({
          size = 20,
          open_mapping = [[<c-\\>]],
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 2,
          start_in_insert = true,
          insert_mappings = true,
          persist_size = true,
          direction = 'float',
          close_on_exit = true,
          shell = vim.o.shell,
          float_opts = {
            border = 'curved',
            winblend = 0,
            highlights = {
              border = 'Normal',
              background = 'Normal',
            },
          },
        })
      end,
    },
    
    -- Custom utilities keymaps
    {
      dir = "lua/plugins/utilities",
      name = "utilities",
      dependencies = {
        "mbbill/undotree",
        "ThePrimeagen/harpoon",
        "kdheepak/lazygit.nvim",
        "akinsho/toggleterm.nvim",
      },
      event = "VeryLazy",
      config = function()
        require("plugins.utilities").config()
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
