return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    defer = { gc = "Comments" },
    replace = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    win = {
      border = "single",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- Register key mappings using the new format
    wk.register({
      {
        mode = { "n", "v" },
        { "<leader>f", group = "Find/Files" },
        { "<leader>g", group = "Git" },
        { "<leader>b", group = "Buffers" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Terminal/Toggle" },
        { "<leader>h", group = "Help/Harpoon" },
        { "<leader>c", group = "Code" },
        { "<leader>w", group = "Window" },
        { "<leader>p", group = "Project" },
        { "<leader>s", group = "Search" },
        { "<leader>e", group = "Explorer" },
      },
    })
  end,
} 