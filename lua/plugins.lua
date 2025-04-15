return {
  -- UI/Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", config = true },
  
  -- Notifications with PROPER MODULE LOADING
  { "rcarriga/nvim-notify", 
    event = "VeryLazy",
    config = function()
      -- Create a basic fallback if notify isn't available
      local ok, notify = pcall(require, "notify")
      if not ok then
        -- If module isn't found, set up a simple fallback
        vim.notify = function(msg, level, opts)
          return vim.api.nvim_echo({{msg, level or ""}}, true, {})
        end
        return
      end
      
      -- Normal setup if module is found
      notify.setup({
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
      vim.notify = notify
    end
  },
  
  -- Which-key with PROPER ERROR HANDLING
  { "folke/which-key.nvim", 
    lazy = false, -- Load immediately to ensure it's available for leader key press
    priority = 100, -- High priority to ensure it loads early
    config = function()
      -- Create a basic setup that won't fail
      local ok, wk = pcall(require, "which-key")
      if not ok then
        vim.notify("Which-key not found, some keybindings may not work", vim.log.levels.WARN)
        return
      end
      
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = false,
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
        window = {
          border = "single",
          position = "bottom",
        },
        layout = {
          spacing = 6,
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        triggers = {"<leader>"}, -- Only show which-key for leader
        triggers_nowait = {}, -- Don't use nowait triggers
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
        show_help = true,
        show_keys = true,
      })
      
      -- Register key groups
      wk.register({
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code/lsp" },
        ["<leader>d"] = { name = "+docs" },
        ["<leader>dm"] = { name = "+ml-docs" },
        ["<leader>e"] = { name = "+explorer" },
        ["<leader>f"] = { name = "+find/file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>k"] = { name = "+keymaps" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>p"] = { name = "+python/env/dependencies" },
        ["<leader>r"] = { name = "+run/requirements" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>u"] = { name = "+utilities" },
        ["<leader>w"] = { name = "+window/tab" },
        ["<leader>x"] = { name = "+execute" },
        ["<leader>z"] = { name = "+zen/focus" },
        ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
      })
    end
  },
}
