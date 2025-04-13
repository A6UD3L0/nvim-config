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
    operators = { gc = "Comments" },
    key_labels = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    window = {
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
    
    -- Register key mappings
    wk.register({
      mode = { "n", "v" },
      ["<leader>"] = {
        f = { name = "Find/Files" },
        g = { name = "Git" },
        b = { name = "Buffers" },
        l = { name = "LSP" },
        d = { name = "Debug" },
        t = { name = "Terminal/Toggle" },
        h = { name = "Help/Harpoon" },
        c = { name = "Code" },
        w = { name = "Window" },
        p = { name = "Project" },
        s = { name = "Search" },
        e = { name = "Explorer" },
      },
    })
  end,
} 