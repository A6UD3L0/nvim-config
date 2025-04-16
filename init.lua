-- Streamlined Neovim Configuration for Backend Development and Data Science
-- Based on ThePrimeagen's style with NvChad simplicity

-- Set leader key to space (must be before lazy bootstrap)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap and configure lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- UI Tweaks for a better experience
vim.opt.termguicolors = true               -- Enable 24-bit RGB colors
vim.opt.number = true                      -- Show line numbers
vim.opt.relativenumber = true              -- Show relative line numbers
vim.opt.cursorline = true                  -- Highlight the current line
vim.opt.scrolloff = 20                     -- Keep text positioned at ~3/4ths of the screen
vim.opt.sidescrolloff = 8                  -- Keep 8 columns left/right of cursor
vim.opt.showmode = false                   -- Don't show mode (shown in statusline)
vim.opt.signcolumn = "yes"                 -- Always show the signcolumn
vim.opt.wrap = false                       -- Don't wrap lines by default
vim.opt.linebreak = true                   -- Wrap at word boundaries if wrap is on
vim.opt.list = true                        -- Show whitespace characters
vim.opt.listchars = {                      -- Configure whitespace characters
  tab = "→ ",
  trail = "·",
  extends = "▶",
  precedes = "◀",
  nbsp = "␣",
}
vim.opt.fillchars:append({                 -- Make splits look nicer
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
})
vim.opt.mouse = "a"                        -- Enable mouse in all modes
vim.opt.splitbelow = true                  -- Open new horizontal splits below
vim.opt.splitright = true                  -- Open new vertical splits to the right
vim.opt.pumheight = 15                     -- Maximum number of items in popup menu
vim.opt.pumblend = 10                      -- Pseudo-transparency for popup menu
vim.opt.winblend = 10                      -- Pseudo-transparency for floating windows

-- Eye comfort settings for long coding sessions
vim.opt.syntax = "on"                      -- Enable syntax highlighting with optimizations
vim.opt.lazyredraw = false                 -- Don't use lazyredraw as it conflicts with noice.nvim
vim.opt.ttyfast = true                     -- Faster terminal connection
vim.opt.conceallevel = 0                   -- Don't hide characters in markdown/etc
vim.opt.background = "dark"                -- Dark background for less eye strain

-- Cursor customization for better visibility
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20,o:hor50"

-- Enhanced window/pane management
vim.opt.equalalways = true                 -- Make window size equal when splitting
vim.opt.splitkeep = "screen"               -- Keep text on same screen line when splitting

-- Enhanced window decorations and visual cues
vim.opt.winbar = "%=%m %f"                 -- Show file path in window bar
vim.opt.title = true                       -- Show file in terminal title
vim.opt.colorcolumn = "100"                -- Show a ruler at column 100
vim.opt.cursorlineopt = "both"             -- Highlight both line number and text line

-- Better command-line experience
vim.opt.cmdheight = 1                      -- Height of the command line
vim.opt.laststatus = 3                     -- Global statusline
vim.opt.showcmd = true                     -- Show commands as you type them
vim.opt.wildmode = "longest:full,full"     -- Command line completion mode
vim.opt.wildoptions = "pum"                -- Use popup menu for wildmode

-- Searching
vim.opt.hlsearch = true                    -- Highlight search matches
vim.opt.incsearch = true                   -- Show matches as you type
vim.opt.ignorecase = true                  -- Ignore case when searching
vim.opt.smartcase = true                   -- Don't ignore case with capital letters

-- Make backspace behave normally
vim.opt.backspace = "indent,eol,start"

-- Enable soft word wrapping for markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Editor settings
vim.opt.tabstop = 4             -- Number of spaces tabs count for
vim.opt.softtabstop = 4         -- Number of spaces in tab when editing
vim.opt.shiftwidth = 4          -- Number of spaces to use for autoindent
vim.opt.expandtab = true        -- Tabs are spaces
vim.opt.smartindent = true      -- Insert indents automatically
vim.opt.swapfile = false        -- Don't use swapfile
vim.opt.backup = false          -- Don't create backup files
vim.opt.undofile = true         -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Where to store undo history
vim.opt.updatetime = 50         -- Faster completion
vim.opt.colorcolumn = "80"      -- Show column marker at 80 characters
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Command line UI improvements
vim.opt.wildmenu = true         -- Command-line completion
vim.opt.wildmode = "longest:full,full" -- Complete till longest common string, then start wildmenu
vim.opt.cmdheight = 1           -- Command-line height
vim.opt.laststatus = 3          -- Global statusline
vim.opt.showmatch = true        -- Jump to matching bracket briefly

-- Better display of invisibles
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}

-- Better search experience
vim.opt.ignorecase = true       -- Ignore case in search
vim.opt.smartcase = true        -- Unless search has uppercase
vim.opt.incsearch = true        -- Show matches as you type
vim.opt.hlsearch = true         -- Highlight search results

-- Buffer settings
vim.opt.hidden = true           -- Allow switching from unsaved buffers
vim.opt.confirm = true          -- Confirm changes when exiting buffers
vim.opt.completeopt = "menuone,noselect" -- Better completion experience

-- Disable unused providers to remove health check warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Configure Python provider
if vim.fn.has('macunix') == 1 then
  -- macOS Python path
  vim.g.python3_host_prog = vim.fn.expand('~/.venvs/neovim/bin/python3')
elseif vim.fn.has('unix') == 1 then
  -- Linux Python path - adjust if needed
  vim.g.python3_host_prog = vim.fn.expand('~/.venvs/neovim/bin/python3')
elseif vim.fn.has('win32') == 1 then
  -- Windows Python path - adjust if needed
  vim.g.python3_host_prog = vim.fn.expand('~/AppData/Local/Programs/Python/Python39/python.exe')
end

-- Unset VIRTUAL_ENV to prevent the Python virtualenv warning
if vim.env.VIRTUAL_ENV then
  -- Store the original value in case we need it later
  vim.g.original_virtual_env = vim.env.VIRTUAL_ENV
  -- Unset it to avoid the warning
  vim.env.VIRTUAL_ENV = nil
end

-- Ensure data directories exist
local function ensure_dir(path)
  local stat = vim.loop.fs_stat(path)
  if not stat then
    vim.fn.mkdir(path, "p")
  end
end

-- Create necessary data directories
ensure_dir(vim.fn.stdpath("data") .. "/undodir")
ensure_dir(vim.fn.stdpath("data") .. "/backup")
ensure_dir(vim.fn.stdpath("data") .. "/swap")
ensure_dir(vim.fn.stdpath("data") .. "/shada")

-- Load mappings
require("mappings")

-- Load backend-essential configurations
local backend = require("backend-essentials")

-- Set up auto commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go", "c", "cpp", "sql", "dockerfile", "yaml", "json" },
  callback = function()
    -- Set appropriate indent for backend languages
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    
    -- Special settings for specific filetypes
    if vim.bo.filetype == "go" then
      vim.opt_local.expandtab = false
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
    elseif vim.bo.filetype == "python" then
      vim.opt_local.colorcolumn = "88" -- Black formatter uses 88 characters
    end
  end
})

-- Ensure terminal opens in the bottom center
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- Dynamically adjust scrolloff to keep text at 3/4ths of window height
vim.api.nvim_create_autocmd({"VimResized", "BufEnter", "WinEnter"}, {
  callback = function()
    local win_height = vim.api.nvim_win_get_height(0)
    -- Set scrolloff to approximately 3/4 of window height
    local new_scrolloff = math.floor(win_height * 0.75)
    vim.opt_local.scrolloff = new_scrolloff
  end,
})

-- Auto light/dark mode based on time of day for eye comfort
vim.api.nvim_create_autocmd({"VimEnter", "FocusGained"}, {
  callback = function()
    local current_hour = tonumber(os.date("%H"))
    local is_night = current_hour < 7 or current_hour >= 19  -- Night: 7pm to 7am
    
    if is_night then
      -- Night settings (darker, warmer)
      vim.opt.background = "dark"
      vim.cmd("colorscheme rose-pine-moon")  -- Use the darker variant
      -- Slightly reduce contrast for night viewing
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })  -- Transparent background
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    else
      -- Day settings
      vim.opt.background = "light"
      vim.cmd("colorscheme rose-pine-dawn")  -- Use the lighter variant
    end
  end,
})

-- Additional comfort settings for long coding sessions
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
  callback = function()
    vim.opt.cursorline = true  -- Highlight current line when focused
  end,
})

vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
  callback = function()
    vim.opt.cursorline = false  -- No highlight when not focused
  end,
})

-- Set up automatic filetype detection for backend files
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.py", "*.go", "*.rs", "*.ts", "*.java", "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

-- Set easier to read tab settings for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "javascript", "typescript", "json", "yaml", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Automatically format Go files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Fix common typos in command mode
vim.cmd([[
  cnoreabbrev W w
  cnoreabbrev Q q
  cnoreabbrev Wq wq
  cnoreabbrev WQ wq
  cnoreabbrev Qa qa
  cnoreabbrev Wqa wqa
]])

-- Set shorter updatetime for faster response
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Load venv_diagnostics module
local venv_ok, venv_diagnostics = pcall(require, "venv_diagnostics")
if venv_ok then
  _G.VenvDiagnostics = venv_diagnostics
end

-- Set up commands for commonly used functions
vim.api.nvim_create_user_command("Format", function()
  if require("conform") then
    require("conform").format()
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format current buffer with LSP or formatter" })

-- Initialize backend development tools after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    -- Setup backend development features
    backend.setup_lsp()
    backend.setup_tools()
    backend.setup_debugging()
    
    -- Show message on first installation
    if vim.fn.filereadable(vim.fn.stdpath("config") .. "/.installed") == 0 then
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.defer_fn(function()
            vim.cmd([[
              echohl WarningMsg
              echo "Installation complete! Backend Development environment is ready."
              echohl None
            ]])
            vim.fn.writefile({}, vim.fn.stdpath("config") .. "/.installed")
          end, 1000)
        end,
        once = true,
      })
    end
  end,
})

-- Set up plugin management with Lazy
require("lazy").setup({
  -- Core plugins
  { import = "plugins" },
  
  -- Linting and formatting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        python = {"flake8", "mypy"},
        lua = {"luacheck"},
        go = {"golangci-lint"},
      }
      
      -- Run lint on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black", "isort" },
          go = { "gofmt", "goimports" },
          lua = { "stylua" },
          json = { "jq" },
          yaml = { "yamlfmt" },
          sql = { "sqlfluff" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
  
  -- UI Improvements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          prompt_align = "left",
          insert_only = true,
          border = "rounded",
          relative = "cursor",
          win_options = {
            winblend = 10,
            wrap = false,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf", "builtin" },
          trim_prompt = true,
          border = "rounded",
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },

}, {
  install = {
    colorscheme = { "rose-pine" },
  },
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠️",
      event = "📅",
      ft = "📂",
      init = "⚙️",
      keys = "🔑",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
