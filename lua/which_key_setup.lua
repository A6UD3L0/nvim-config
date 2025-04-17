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
    disable = {                           
      buftypes = {},
      filetypes = { "TelescopePrompt" },  -- Don't activate in Telescope prompt
    },
  })
  
  -- Set up custom icons for better visual organization
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
    harpoon = "🔱 ",
    run = "▶️ "
  }
  
  -- Register keymapping groups to match our streamlined config
  which_key.register({
    ["<leader>b"] = { name = icons.buffer .. "Buffers" },
    ["<leader>c"] = { name = icons.code .. "Code Actions" },
    ["<leader>d"] = { name = icons.docs .. "Docs & Help" },
    ["<leader>e"] = { name = icons.files .. "Explorer" },
    ["<leader>f"] = { name = icons.search .. "Find/Telescope" },
    ["<leader>g"] = { name = icons.git .. "Git" },
    ["<leader>h"] = { name = icons.harpoon .. "Harpoon" },
    ["<leader>l"] = { name = icons.code .. "LSP" },
    ["<leader>r"] = { name = icons.run .. "Run" },
    ["<leader>u"] = { name = icons.undo .. "Undotree" },
    ["<leader>v"] = { name = "VirtualEnv" },
    ["<leader>w"] = { name = icons.windows .. "Windows" },
  }, { mode = "n", prefix = "<leader>" })

  -- Git submenu
  which_key.register({
    g = {
      name = icons.git .. "Git",
      g = { "<cmd>Neogit<CR>", "Neogit" },
      l = { "<cmd>LazyGit<CR>", "LazyGit" },
      b = { "<cmd>Telescope git_branches<CR>", "Branches" },
      c = { "<cmd>Telescope git_commits<CR>", "Commits" },
      s = { "<cmd>Telescope git_status<CR>", "Status" },
    }
  }, { prefix = "<leader>" })

  -- LSP submenu
  which_key.register({
    l = {
      name = icons.code .. "LSP",
      f = { function() vim.lsp.buf.format({ async = true }) end, "Format" },
      r = { "<cmd>LspRestart<CR>", "Restart LSP" },
      i = { "<cmd>LspInfo<CR>", "LSP Info" },
      s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
      d = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
      t = { function() 
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not current })
      end, "Toggle Inline Diagnostics" },
    }
  }, { prefix = "<leader>" })

  -- Find (Telescope) submenu
  which_key.register({
    f = {
      name = icons.search .. "Find/Telescope",
      f = { "<cmd>Telescope find_files<CR>", "Find Files" },
      g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
      b = { "<cmd>Telescope buffers<CR>", "Buffers" },
      h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
      r = { "<cmd>Telescope oldfiles<CR>", "Recent Files" },
    }
  }, { prefix = "<leader>" })

  -- Harpoon submenu
  which_key.register({
    h = {
      name = icons.harpoon .. "Harpoon",
      a = { function() require("harpoon"):list():append() end, "Add File" },
      t = { function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Toggle Menu" },
      ["1"] = { function() require("harpoon"):list():select(1) end, "File 1" },
      ["2"] = { function() require("harpoon"):list():select(2) end, "File 2" },
      ["3"] = { function() require("harpoon"):list():select(3) end, "File 3" },
      ["4"] = { function() require("harpoon"):list():select(4) end, "File 4" },
    }
  }, { prefix = "<leader>" })

  -- Run submenu
  which_key.register({
    r = {
      name = icons.run .. "Run",
      r = { function() require("mappings")._run_file() end, "Run Current File" },
      n = { function() require("mappings")._python_run_file() end, "Run Python File" },
    }
  }, { prefix = "<leader>" })

  -- Window submenu
  which_key.register({
    w = {
      name = icons.windows .. "Windows",
      ["-"] = { "<cmd>split<CR>", "Split Horizontal" },
      ["|"] = { "<cmd>vsplit<CR>", "Split Vertical" },
      q = { "<cmd>q<CR>", "Close Window" },
      h = { "<C-w>h", "Go Left" },
      j = { "<C-w>j", "Go Down" },
      k = { "<C-w>k", "Go Up" },
      l = { "<C-w>l", "Go Right" },
    }
  }, { prefix = "<leader>" })

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
