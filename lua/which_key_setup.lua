-- Ensure which-key displays correctly when leader key is pressed
local M = {}

function M.setup()
  -- Set timeoutlen to a value that allows which-key to appear quickly
  vim.opt.timeout = true
  vim.opt.timeoutlen = 250  -- Faster which-key response (250ms instead of 300ms)
  
  -- Initial which-key setup with specific settings for leader key display
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("Which-key not found, using fallback configuration", vim.log.levels.WARN)
    return
  end
  
  -- Enhanced Which-Key setup with better UX
  which_key.setup({
    plugins = {
      marks = true,       -- Shows marks when pressing '
      registers = true,   -- Shows registers when pressing " in NORMAL mode
      spelling = {
        enabled = false,  -- Disabled by default to avoid distraction
        suggestions = 20, -- Maximum suggestions to show
      },
      presets = {
        operators = true,    -- adds help for operators like d, y, ...
        motions = true,      -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = true,          -- misc bindings to work with windows
        z = true,            -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
    icons = {
      breadcrumb = "»", -- Symbol used in the command line area
      separator = "➜", -- Symbol used between a key and its label
      group = "+", -- Symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- Scroll down in the popup
      scroll_up = "<c-u>",   -- Scroll up in the popup
    },
    window = {
      border = "rounded",      -- Can be "none", "single", "double", "shadow" or "rounded"
      position = "bottom",     -- Position at the bottom for familiarity
      margin = { 1, 0, 1, 0 }, -- Extra margin [top, right, bottom, left]
      padding = { 1, 2, 1, 2 }, -- Extra padding [top, right, bottom, left]
      winblend = 0,            -- No transparency for better readability
    },
    layout = {
      height = { min = 4, max = 25 },  -- min and max height of the columns
      width = { min = 20, max = 50 },  -- min and max width of the columns
      spacing = 3,                     -- spacing between columns
      align = "center",                -- align columns left, center or right
    },
    ignore_missing = false,            -- Don't hide mappings with no label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- Hide these command prefixes
    show_help = true,                  -- Show a help message in the command line
    show_keys = true,                  -- Show the key press in the popup
    triggers = "auto",                 -- "auto" automatically setup triggers
    triggers_nowait = {                -- These keys should trigger immediately
      -- Marks
      "`",
      "'",
      "g`",
      "g'",
      -- Registers
      "\"",
      "<c-r>",
      -- Spelling
      "z=",
    },
    triggers_blacklist = {
      -- These never trigger
      i = { "j", "k" },
      v = { "j", "k" },
    },
    -- Custom highlight colors
    -- NOTE: To get matching colors, use :hi to see your theme's highlights
    color_devicons = true,                -- Make icons colorful
    disable = {                           
      buftypes = {},
      filetypes = { "TelescopePrompt" },  -- Don't activate in Telescope prompt
    },
  })
  
  -- Set up custom icons and groupings for better organization
  local icons = {
    code = "⚙️ ",
    search = "🔍 ",
    docs = "📚 ", 
    git = "🌿 ",
    files = "📁 ",
    buffer = "📄 ", 
    terminal = "💻 ",
    windows = "🪟 ",
    debug = "🐛 ",
    undo = "⏪ ",
    navigation = "🧭 ", 
    util = "🔧 ", 
    test = "🧪 ", 
    keymaps = "⌨️ ",
    ai = "🤖 ",
    python = "🐍 ",
    harpoon = "🔱 ",
  }
  
  -- Register essential group names (individual mappings should be registered in their respective modules)
  which_key.register({
    ["<leader>b"] = { name = icons.buffer .. "Buffers & Tabs" },
    ["<leader>c"] = { name = icons.code .. "Code Actions & LSP" },
    ["<leader>d"] = { name = icons.docs .. "Docs & Help" },
    ["<leader>e"] = { name = icons.files .. "File Explorer" },
    ["<leader>f"] = { name = icons.search .. "Find & Search" },
    ["<leader>g"] = { name = icons.git .. "Git & VCS" },
    ["<leader>h"] = { name = icons.harpoon .. "Harpoon (Marks)" },
    ["<leader>k"] = { name = icons.keymaps .. "Keymaps & Cheatsheet" },
    ["<leader>l"] = { name = icons.code .. "LSP" },
    ["<leader>p"] = { name = icons.python .. "Python/Project" },
    ["<leader>q"] = { name = "Quickfix & Lists" },
    ["<leader>r"] = { name = icons.test .. "Run & Test" },
    ["<leader>s"] = { name = icons.search .. "Substitute/Search" },
    ["<leader>t"] = { name = icons.terminal .. "Terminal" },
    ["<leader>u"] = { name = icons.undo .. "Undo/Utilities" },
    ["<leader>w"] = { name = icons.windows .. "Window/Tab" },
    ["<leader>x"] = { name = icons.util .. "Execute/Utils" },
    ["<leader>z"] = { name = "+Zen/Focus" },
    ["<leader>?"] = { name = "Show all keymaps (cheatsheet)" },
  }, { mode = "n", prefix = "<leader>" })

  -- Show all keymaps with <leader>?
  vim.keymap.set("n", "<leader>?", function()
    which_key.show("", {mode = "n", auto = true})
  end, { desc = "Show all keymaps (cheatsheet)" })

  -- Ensure leader key is always mapped (no accidental spacebar insert)
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
end

-- Expose a register_group function for plugin modules to use
function M.register_group(group_mappings, opts)
  opts = opts or {}
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("Which-key not found, unable to register mappings", vim.log.levels.WARN)
    return
  end
  which_key.register(group_mappings, opts)
end

return M
