-- UI related plugins
return {
  -- Modern looking theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = { light = "latte", dark = "mocha" },
        transparent_background = false,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          which_key = true,
          lsp_saga = true,
          mason = true,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd.colorscheme "catppuccin"
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
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus NvimTree" },
    },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = {
        adaptive_size = false,
        side = "left",
        width = 30,
      },
      git = { enable = true, ignore = false },
      renderer = {
        highlight_git = true,
        indent_markers = { enable = true },
      },
    },
  },
  
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  
  -- Mini.icons for better icon support
  {
    "echasnovski/mini.icons",
    version = false,
    event = "VeryLazy",
  },
  
  -- Better UI components
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = { 
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
      },
    },
  },
  
  -- Better notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
  },

  -- Which-key for better keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Register key groups
      wk.register({
        ["<leader>f"] = { name = "Find/Files" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>b"] = { name = "Buffers" },
        ["<leader>d"] = { name = "Debug/Diagnostics" },
        ["<leader>t"] = { name = "Terminal/Tests" },
        ["<leader>c"] = { name = "Code" },
      })
    end,
  },
}
