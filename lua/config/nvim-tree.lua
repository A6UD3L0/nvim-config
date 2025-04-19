-- Enhanced NvimTree configuration with git integration and backend development focus
local M = {}

function M.setup()
  -- Use utility for plugin existence check
  local utils = require('utils')
  local status_ok, nvim_tree = utils.require_safe("nvim-tree", "nvim-tree")
  if not status_ok then
    vim.notify("nvim-tree not found. File navigation may not work properly.", vim.log.levels.WARN)
    return
  end

  -- Create auto commands for better behavior
  local function create_nvim_tree_autocmds()
    local api = require("nvim-tree.api")
    local group = vim.api.nvim_create_augroup("NvimTreeCustom", { clear = true })
    
    -- Auto close if NvimTree is the last window
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if layout[1] == "leaf" and
           vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win()), "filetype") == "NvimTree" and
           layout[2] == vim.api.nvim_get_current_win() then
          vim.cmd("confirm quit")
        end
      end
    })
    
    -- Open file on creation
    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      
      -- Define custom keybindings with NvChad simplicity and ThePrimeagen style
      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)
      
      -- Custom mappings for backend development
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
      vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
      vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
      vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Hidden"))
      vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
      vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
      vim.keymap.set("n", "P", function()
        local node = api.tree.get_node_under_cursor()
        print(node.absolute_path)
      end, opts("Print Node Path"))
      
      -- Special mappings for backend files
      vim.keymap.set("n", "x", function()
        local node = api.tree.get_node_under_cursor()
        if node then
          local path = node.absolute_path
          local extension = path:match("%.([^%.]+)$")
          
          if extension == "py" then
            vim.cmd("terminal python " .. vim.fn.shellescape(path))
          elseif extension == "go" then
            vim.cmd("terminal go run " .. vim.fn.shellescape(path))
          elseif extension == "sh" then
            vim.cmd("terminal bash " .. vim.fn.shellescape(path))
          elseif extension == "sql" then
            vim.cmd("terminal sqlite3 < " .. vim.fn.shellescape(path))
          else
            vim.notify("No execution handler for this file type", vim.log.levels.INFO)
          end
        end
      end, opts("Execute File"))
    end

    return on_attach
  end

  local on_attach = create_nvim_tree_autocmds()

  -- Configure tree with git integration and optimized defaults
  nvim_tree.setup({
    on_attach = on_attach,
    filters = {
      dotfiles = false,
      git_ignored = false,
      custom = { "^.git$", "^node_modules$", "^__pycache__$" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    view = {
      adaptive_size = false,
      width = 30,
      side = "left",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },
    git = {
      enable = true,
      ignore = false,
      timeout = 500,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
      },
      open_file = {
        quit_on_open = false,
        resize_window = true,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
    trash = {
      cmd = "trash",
      require_confirm = true,
    },
    live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = true,
    },
    log = {
      enable = false,
      truncate = false,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        diagnostics = false,
        git = false,
        profile = false,
      },
    },
    -- Enhanced renderer with better git indicators and file icons
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = true,
      full_name = false,
      highlight_opened_files = "all",
      root_folder_label = ":~:s?$?/..?",
      indent_width = 2,
      indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          bottom = "─",
          none = " ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          bookmark = "",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
      special_files = {
        "Cargo.toml",
        "Makefile",
        "README.md",
        "readme.md",
        "CMakeLists.txt",
        "go.mod",
        "go.sum",
        "requirements.txt",
        "pyproject.toml",
        "setup.py",
        "Dockerfile",
        "docker-compose.yml",
      },
      symlink_destination = true,
    },
  })

  -- Mappings
  local keymap = vim.keymap.set
  
  -- Main file explorer toggle (ThePrimeagen style)
  keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
  
  -- Enhanced file operations
  keymap("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find File in Explorer" })
  keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh Explorer" })
  keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse Explorer" })
  
  -- Focused file explorer
  keymap("n", "<leader>eg", function()
    require("nvim-tree.api").tree.toggle({
      find_file = true,
      focus = true,
      update_root = true,
    })
  end, { desc = "Focus File in Explorer" })
end

return M
