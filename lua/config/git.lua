-- Comprehensive Git integration for Neovim
-- Features enhanced visual operations, inline hunks, blame, and conflict resolution

local M = {}

function M.setup()
  -- Setup enhanced Gitsigns with better visual indicators and navigation
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    vim.notify("gitsigns.nvim not found. Git integration will be limited.", vim.log.levels.WARN)
    return
  end

  -- Define customized signs for better visibility
  local signs = {
    add          = { hl = "GitSignsAdd",    text = "▎", numhl = "GitSignsAddNr",    linehl = "GitSignsAddLn" },
    change       = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete       = { hl = "GitSignsDelete", text = "▁", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete    = { hl = "GitSignsDelete", text = "▔", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    untracked    = { hl = "GitSignsAdd",    text = "┆", numhl = "GitSignsAddNr",    linehl = "GitSignsAddLn" },
  }

  -- Configure Gitsigns with comprehensive features
  gitsigns.setup({
    signs = signs,
    count_chars = {
      [1]   = "₁", [2]   = "₂", [3]   = "₃", [4]   = "₄", [5]   = "₅",
      [6]   = "₆", [7]   = "₇", [8]   = "₈", [9]   = "₉", ["+"] = "₊",
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with <leader>gb
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
    -- Enhanced on_attach with ThePrimeagen style navigation
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation between hunks
      map("n", "]h", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Next git hunk" })

      map("n", "[h", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous git hunk" })

      -- Actions for hunks
      map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>gs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage selected hunk" })
      map("v", "<leader>gr", function() gitsigns.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset selected hunk" })
      map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
      
      -- Blame operations
      map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame" })
      map("n", "<leader>gB", function() gitsigns.blame_line({ full = true }) end, { desc = "Git blame with details" })
      
      -- Diff operations
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
      map("n", "<leader>gD", function() gitsigns.diffthis("~") end, { desc = "Diff with HEAD" })
      
      -- Toggle features
      map("n", "<leader>gx", gitsigns.toggle_deleted, { desc = "Toggle show deleted" })
      map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
      
      -- Text object for hunks
      map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
    end,
  })

  -- Setup LazyGit with enhanced integration
  vim.g.lazygit_floating_window_winblend = 0
  vim.g.lazygit_floating_window_scaling_factor = 0.95
  vim.g.lazygit_floating_window_border_chars = {'╭','─','╮','│','╯','─','╰','│'}
  vim.g.lazygit_floating_window_use_plenary = 0
  vim.g.lazygit_use_neovim_remote = 0
  vim.g.lazygit_use_custom_config_file_path = 0

  -- Enhance with git-conflict for merge conflict resolution
  local conflict_ok, git_conflict = pcall(require, "git-conflict")
  if conflict_ok then
    git_conflict.setup({
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })

    -- Set up keymaps for conflict resolution
    local keymap = vim.keymap.set
    keymap("n", "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", { desc = "Choose our changes" })
    keymap("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Choose their changes" })
    keymap("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Choose both changes" })
    keymap("n", "<leader>gc0", "<cmd>GitConflictChooseNone<CR>", { desc = "Choose no changes" })
    keymap("n", "<leader>gcn", "<cmd>GitConflictNextConflict<CR>", { desc = "Next conflict" })
    keymap("n", "<leader>gcp", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous conflict" })
    keymap("n", "<leader>gcl", "<cmd>GitConflictListQf<CR>", { desc = "List conflicts" })
  end

  -- Setup diffview.nvim for better diff viewing and history navigation
  local diffview_ok, diffview = pcall(require, "diffview")
  if diffview_ok then
    diffview.setup({
      diff_binaries = false,
      enhanced_diff_hl = true,
      git_cmd = { "git" },
      use_icons = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          max_count = 256,
          follow = false,
          all = false,
          merges = false,
          no_merges = false,
          reverse = false,
        },
        win_config = {
          width = 35,
        },
      },
      commit_log_panel = {
        win_config = {},
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        view = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
        file_panel = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
        file_history_panel = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
      },
    })

    -- Set up keymaps for Diffview
    local keymap = vim.keymap.set
    keymap("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
    keymap("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
    keymap("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history (current)" })
    keymap("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "File history (project)" })
  end

  -- Setup Octo.nvim for GitHub PR integration if available
  local octo_ok, octo = pcall(require, "octo")
  if octo_ok then
    octo.setup({
      ssh_aliases = {}, -- SSH aliases. e.g. { ["github.com-work"] = "github.com" }
      reaction_viewer_hint_icon = "",
      user_icon = " ",
      timeline_marker = "",
      timeline_indent = "2",
      right_bubble_delimiter = "",
      left_bubble_delimiter = "",
      snippet_context_lines = 4,
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings = {
        issue = {
          close_issue = "<space>ic",
          reopen_issue = "<space>io",
          list_issues = "<space>il",
          reload = "<C-r>",
          open_in_browser = "<C-b>",
          copy_url = "<C-y>",
          add_assignee = "<space>aa",
          remove_assignee = "<space>ad",
          add_label = "<space>la",
          remove_label = "<space>ld",
          goto_issue = "<space>gi",
          add_comment = "<space>ca",
          delete_comment = "<space>cd",
          next_comment = "]c",
          prev_comment = "[c",
          react_hooray = "<space>rp",
          react_heart = "<space>rh",
          react_eyes = "<space>re",
          react_thumbs_up = "<space>r+",
          react_thumbs_down = "<space>r-",
          react_rocket = "<space>rr",
          react_laugh = "<space>rl",
          react_confused = "<space>rc",
        },
        pull_request = {
          checkout_pr = "<space>po",
          merge_pr = "<space>pm",
          squash_and_merge_pr = "<space>psm",
          list_commits = "<space>pc",
          list_changed_files = "<space>pf",
          show_pr_diff = "<space>pd",
          add_reviewer = "<space>va",
          remove_reviewer = "<space>vd",
          close_pr = "<space>pc",
          reopen_pr = "<space>po",
          list_prs = "<space>pl",
        },
        review_thread = {
          goto_issue = "<space>gi",
          add_comment = "<space>ca",
          add_suggestion = "<space>sa",
          delete_comment = "<space>cd",
          next_comment = "]c",
          prev_comment = "[c",
          select_next_entry = "]q",
          select_prev_entry = "[q",
          close_review_tab = "<C-c>",
          react_hooray = "<space>rp",
          react_heart = "<space>rh",
          react_eyes = "<space>re",
          react_thumbs_up = "<space>r+",
          react_thumbs_down = "<space>r-",
          react_rocket = "<space>rr",
          react_laugh = "<space>rl",
          react_confused = "<space>rc",
        },
        submit_win = {
          approve_review = "<C-a>",
          comment_review = "<C-m>",
          request_changes = "<C-r>",
          close_review_tab = "<C-c>",
        },
        review_diff = {
          add_review_comment = "<space>ca",
          add_review_suggestion = "<space>sa",
          focus_files = "<leader>e",
          toggle_files = "<leader>b",
          next_comment = "]c",
          prev_comment = "[c",
          select_next_entry = "]q",
          select_prev_entry = "[q",
          close_review_tab = "<C-c>",
          toggle_viewed = "<leader><space>",
        },
      },
    })

    -- Set up keymaps for Octo
    local keymap = vim.keymap.set
    keymap("n", "<leader>go", "<cmd>Octo<CR>", { desc = "Open GitHub menu" })
    keymap("n", "<leader>gP", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
    keymap("n", "<leader>gi", "<cmd>Octo issue list<CR>", { desc = "List issues" })
  end

  -- Setup Neogit for magit-like experience
  local neogit_ok, neogit = pcall(require, "neogit")
  if neogit_ok then
    neogit.setup({
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      auto_refresh = true,
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      kind = "tab",
      commit_popup = {
        kind = "split",
      },
      popup = {
        kind = "split",
      },
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      sections = {
        untracked = {
          folded = false,
        },
        unstaged = {
          folded = false,
        },
        staged = {
          folded = false,
        },
        stashes = {
          folded = true,
        },
        unpulled = {
          folded = true,
        },
        unmerged = {
          folded = false,
        },
        recent = {
          folded = true,
        },
      },
    })

    -- Set up keymaps for Neogit
    local keymap = vim.keymap.set
    keymap("n", "<leader>gm", "<cmd>Neogit<CR>", { desc = "Open Neogit (Magit)" })
  end

  -- Set up Telescope git integration keymaps
  if pcall(require, "telescope") then
    local keymap = vim.keymap.set
    keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
    keymap("n", "<leader>gC", "<cmd>Telescope git_bcommits<CR>", { desc = "Git buffer commits" })
    keymap("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
    keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
    keymap("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Git stash" })
  end

  -- Register Git group with Which-key if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>g"] = { name = "+git" },
      ["<leader>gc"] = { name = "+conflicts" },
    })
  end
end

return M
