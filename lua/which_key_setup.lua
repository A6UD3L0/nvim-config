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
  
  -- Visual grouping of keybindings for better UX
  local groups = {
    code = { "c", "l" },           -- Code and LSP
    navigation = { "f", "h", "p" }, -- File, Harpoon, Project
    git = { "g" },                 -- Git
    ui = { "z", "u" },             -- Zen, Utilities
    window = { "w" },              -- Window
    tests = { "r" },               -- Run tests
    docs = { "d" },                -- Documentation
    misc = { "b", "q", "s", "t", "x", "k", "e" }, -- Buffer, quickfix, etc.
  }
  
  -- Color-coded groups
  local group_colors = {
    code = "#7DCFFF",      -- Blue for code/LSP
    navigation = "#BB9AF7", -- Purple for navigation
    git = "#9ECE6A",       -- Green for git
    ui = "#FF9E64",        -- Orange for UI
    window = "#2AC3DE",    -- Cyan for windows
    tests = "#E0AF68",     -- Yellow for tests 
    docs = "#7AA2F7",      -- Light blue for docs
    misc = "#F7768E",      -- Red for misc
  }
  
  -- Set up color highlighting for which-key groups
  for group_name, color in pairs(group_colors) do
    for _, prefix in ipairs(groups[group_name] or {}) do
      vim.api.nvim_set_hl(0, "WhichKey" .. prefix:upper(), { fg = color, bold = true })
    end
  end
  
  -- Register key groups with icons for better visual organization
  which_key.register({
    ["<leader>b"] = { name = icons.buffer .. "+buffer" },
    ["<leader>c"] = { name = icons.code .. "+code/lsp" },
    ["<leader>ca"] = { name = "Code actions" },
    ["<leader>cr"] = { name = "Rename symbol" },
    ["<leader>cf"] = { name = "Format code" },
    ["<leader>cd"] = { name = "Line diagnostics" },
    ["<leader>cq"] = { name = "List diagnostics" },
    ["<leader>cw"] = { name = "Add workspace folder" },
    ["<leader>cW"] = { name = "Remove workspace folder" },
    ["<leader>cl"] = { name = "List workspace folders" },
    ["<leader>cs"] = { name = "Document symbols" },
    ["<leader>cS"] = { name = "Workspace symbols" },
    ["<leader>ci"] = { name = "Find implementations" },
    ["<leader>cD"] = { name = "Find type definitions" },
    ["<leader>cu"] = { name = "Find usages/references" },
    ["<leader>cC"] = { name = "Incoming calls" },
    ["<leader>cO"] = { name = "Outgoing calls" },
    ["<leader>cT"] = { name = "Toggle inline diagnostics" },
    ["<leader>cI"] = { name = "LSP info" },
    ["<leader>cR"] = { name = "LSP restart" },
    ["<leader>cp"] = { name = "Peek definition" },
    ["<leader>d"] = { name = icons.docs .. "+docs" },
    ["<leader>df"] = { name = "Docs for current filetype" },
    ["<leader>dm"] = { name = "+ml-docs" },
    ["<leader>e"] = { name = icons.files .. "+explorer" },
    ["<leader>f"] = { name = icons.search .. "+find/file" },
    ["<leader>g"] = { name = icons.git .. "+git" },
    ["<leader>gs"] = { name = "Stage hunk" },
    ["<leader>gr"] = { name = "Reset hunk" },
    ["<leader>gS"] = { name = "Stage buffer" },
    ["<leader>gu"] = { name = "Undo stage hunk" },
    ["<leader>gR"] = { name = "Reset buffer" },
    ["<leader>gp"] = { name = "Preview hunk" },
    ["<leader>gB"] = { name = "Blame line (full)" },
    ["<leader>gL"] = { name = "Toggle line blame" },
    ["<leader>gd"] = { name = "Diff this" },
    ["<leader>gx"] = { name = "Toggle deleted" },
    ["<leader>gb"] = { name = "Git blame (LazyGit)" },
    ["<leader>gl"] = { name = "Git logs for current file" },
    ["<leader>gg"] = { name = "Open LazyGit" },
    ["<leader>gf"] = { name = "LazyGit File History" },
    ["<leader>gc"] = { name = "LazyGit Current File" },
    ["<leader>h"] = { name = icons.harpoon .. "+harpoon" },
    ["<leader>k"] = { name = icons.keymaps .. "+keymaps" },
    ["<leader>l"] = { name = icons.code .. "+lsp" },
    ["<leader>lh"] = { name = "Toggle inlay hints" },
    ["<leader>li"] = { name = "LSP info" },
    ["<leader>lr"] = { name = "LSP restart" },
    ["<leader>ls"] = { name = "LSP start" },
    ["<leader>lS"] = { name = "LSP stop" },
    ["<leader>p"] = { name = icons.python .. "+project/python" },
    ["<leader>pf"] = { name = "Find files in project" },
    ["<leader>ps"] = { name = "Project search (grep)" },
    ["<leader>q"] = { name = "+quickfix" },
    ["<leader>r"] = { name = icons.test .. "+run/requirements" },
    ["<leader>s"] = { name = icons.search .. "+search/substitute" },
    ["<leader>t"] = { name = icons.terminal .. "+terminal" },
    ["<leader>u"] = { name = icons.undo .. "+undotree/utilities" },
    ["<leader>ut"] = { name = "Toggle Undotree" },
    ["<leader>uf"] = { name = "Focus Undotree" },
    ["<leader>w"] = { name = icons.windows .. "+window/tab" },
    ["<leader>x"] = { name = icons.util .. "+execute" },
    ["<leader>y"] = { name = "Yank to system clipboard" },
    ["<leader>Y"] = { name = "Yank line to system clipboard" },
    ["<leader>z"] = { name = "+zen/focus" },
    ["<leader>/"] = { name = "Fuzzy find in buffer" },
    ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
    ["<leader>1"] = { name = "Harpoon file 1" },
    ["<leader>2"] = { name = "Harpoon file 2" },
    ["<leader>3"] = { name = "Harpoon file 3" },
    ["<leader>4"] = { name = "Harpoon file 4" },
    ["<leader>5"] = { name = "Harpoon file 5" },
    ["[c"] = { name = "Previous git hunk" },
    ["]c"] = { name = "Next git hunk" },
    ["[d"] = { name = "Previous diagnostic" },
    ["]d"] = { name = "Next diagnostic" },
    ["[e"] = { name = "Previous error" },
    ["]e"] = { name = "Next error" },
    ["[w"] = { name = "Previous warning" },
    ["]w"] = { name = "Next warning" },
  })
  
  -- Register insert mode key mappings to be shown in which-key
  which_key.register({
    ["jk"] = { "<ESC>", "Exit insert mode" },
  }, { mode = "i" })
  
  -- Register visual mode key mappings
  which_key.register({
    ["<leader>y"] = { "\"+y", "Yank to system clipboard" },
    ["<leader>d"] = { "\"_d", "Delete to void register" },
    ["<leader>p"] = { "\"_dP", "Paste without overwriting register" },
    ["J"] = { ":m '>+1<CR>gv=gv", "Move selected lines down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move selected lines up" },
  }, { mode = "v" })
  
  -- Create a help message keymap to show all keys (as a cheat sheet)
  vim.keymap.set("n", "<leader>?", function()
    which_key.show("", {mode = "n", auto = true})
  end, { desc = "Show all keymaps (cheatsheet)" })
  
  -- Ensure leader key works as expected
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
end

return M
