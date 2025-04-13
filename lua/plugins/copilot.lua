-- GitHub Copilot and AI assistant plugins
return {
  -- Github Copilot - AI code completion
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default tab mapping to avoid conflict with completion
      vim.g.copilot_no_tab_map = true
      
      -- Use <C-a> to accept suggestion
      vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
      
      -- Set acceptance behavior
      vim.g.copilot_assume_mapped = true
      
      -- Enable for specific filetypes
      vim.g.copilot_filetypes = {
        ["*"] = true,  -- Enable for all files
        help = false,  -- Disable for help files
        TelescopePrompt = false,  -- Disable for Telescope
      }
    end,
  },

  -- Copilot.lua - Alternative implementation with more features
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot-cmp",  -- Integration with completion engine
    },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          python = true,
          go = true,
          lua = true,
          rust = true,
          javascript = true,
          typescript = true,
          sql = true,
          c = true,
          cpp = true,
          sh = true,
        },
      })
    end,
  },
  
  -- Copilot CMP integration
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
