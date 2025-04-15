return {
  -- UI/Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", config = true },
  { "rcarriga/nvim-notify", config = function()
    require("notify").setup({
      background_colour = "#000000",
      stages = "fade",
      timeout = 3000,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      on_open = function() pcall(vim.api.nvim_set_hl, 0, "NotifyBackground", { bg = "#000000" }) end,
      silent = true,
    })
    vim.notify = require("notify")
  end
  },
  { "folke/which-key.nvim", event = "VeryLazy", config = true },
}
