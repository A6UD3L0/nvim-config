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
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle horizontal terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=40<CR>", desc = "Toggle vertical terminal" },
      { "<C-t>", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal with Ctrl+t" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = function()
        return math.floor(vim.o.lines * 0.3)
      end,
      autochdir = true,
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return term.name
        end,
      },
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.85)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 3,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- Custom terminal setup for Python, allowing CD and code execution
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Python terminal for executing current file
      local python = Terminal:new({
        cmd = "python3",
        direction = "horizontal",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
        end,
      })
      
      -- Function to execute current Python file
      function _PYTHON_TOGGLE()
        python:toggle()
      end
      
      -- Function to execute current Python file
      function _PYTHON_RUN_FILE()
        local file = vim.fn.expand("%:p")
        local python_exec = Terminal:new({
          cmd = "python3 " .. file,
          direction = "horizontal",
          close_on_exit = false,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
            vim.cmd("startinsert!")
          end,
        })
        python_exec:toggle()
      end
      
      -- IPython terminal for interactive Python work
      local ipython = Terminal:new({
        cmd = "ipython",
        direction = "horizontal",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", {noremap = true, silent = true})
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
        end,
      })
      
      function _IPYTHON_TOGGLE()
        ipython:toggle()
      end
      
      -- Virtual environment activation terminal
      local venv_activate = Terminal:new({
        cmd = function()
          local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
          if venv_path ~= "" then
            return "source " .. vim.fn.getcwd() .. '/' .. venv_path .. '/bin/activate'
          else
            return "echo 'No .venv directory found in current project'"
          end
        end,
        direction = "horizontal",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
        on_exit = function(t, job, exit_code, name)
          if exit_code == 0 then
            print("Virtual environment activated")
          end
        end,
      })
      
      function _VENV_ACTIVATE()
        venv_activate:toggle()
      end
      
      -- Terminal with automatic CD to git repo root
      local git_root_term = Terminal:new({
        cmd = function()
          local file_path = vim.fn.expand('%:p:h')
          local repo_root = vim.fn.system('git -C ' .. file_path .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
          if repo_root ~= "" then
            return "cd " .. repo_root
          else
            return "echo 'Not a git repository' && cd " .. file_path
          end
        end,
        direction = "horizontal",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      
      function _GIT_ROOT_TERM()
        git_root_term:toggle()
      end
      
      -- Create direct keymappings
      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", {desc = "Toggle Python Terminal"})
      vim.keymap.set("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", {desc = "Toggle IPython Terminal"})
      vim.keymap.set("n", "<leader>tr", "<cmd>lua _PYTHON_RUN_FILE()<CR>", {desc = "Run Python File"})
      vim.keymap.set("n", "<leader>tv", "<cmd>lua _VENV_ACTIVATE()<CR>", {desc = "Activate Virtual Environment"})
      vim.keymap.set("n", "<leader>tg", "<cmd>lua _GIT_ROOT_TERM()<CR>", {desc = "Terminal at Git Root"})
    end,
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
