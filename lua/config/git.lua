-- Comprehensive Git integration for Neovim
-- Features enhanced visual operations, inline hunks, blame, and conflict resolution

local M = {}

-- Helper function to check if an executable exists
local function executable_exists(exe)
  return vim.fn.executable(exe) == 1
end

function M.setup()
  -- Setup enhanced Gitsigns with better visual indicators and navigation
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    vim.notify("gitsigns.nvim not found. Git integration will be limited.", vim.log.levels.WARN)
    return
  end

  -- Define git sign highlight groups using the modern API
  local function setup_git_highlights()
    vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
    
    vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
    
    vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignsAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })
    
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GitSignsAdd" })
    
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
    vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsAddNr" })
    
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDeleteLn" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChangeLn" })
    vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { link = "GitSignsAddLn" })
  end
  
  -- Create highlight groups before configuring gitsigns
  setup_git_highlights()

  -- Configure Gitsigns with the modern approach
  gitsigns.setup({
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
      untracked    = { text = "┆" },
    },
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
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      
      -- Define keymappings
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      
      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next git hunk" })
      
      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous git hunk" })
      
      -- Actions
      map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>ghs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage selected hunk" })
      map("v", "<leader>ghr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset selected hunk" })
      map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>ghb", gs.blame_line, { desc = "Blame line" })
      map("n", "<leader>ghB", function() gs.blame_line({ full = true }) end, { desc = "Full blame line" })
      map("n", "<leader>ghtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
      map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
      map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff this (~)" })
      map("n", "<leader>ghtd", gs.toggle_deleted, { desc = "Toggle deleted" })
    end,
  })
  
  -- Git conflict management (if available)
  local conflict_ok, git_conflict = pcall(require, "git-conflict")
  if conflict_ok then
    -- Fix deprecated vim.highlight usage by using the proper vim.api.nvim_set_hl function
    local conflict_setup_ok, _ = pcall(function()
      git_conflict.setup({
        default_mappings = false,
        default_commands = true,
        disable_diagnostics = false,
        -- Use highlight groups directly instead of dynamic highlighting
        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })
    end)
    
    if not conflict_setup_ok then
      vim.notify("git-conflict.nvim setup failed, falling back to minimal configuration", vim.log.levels.WARN)
      -- Create the highlight groups manually using the non-deprecated API
      vim.api.nvim_set_hl(0, "GitConflictCurrent", { link = "DiffText" })
      vim.api.nvim_set_hl(0, "GitConflictIncoming", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "GitConflictAncestor", { link = "DiffChange" })
    end
    
    -- Custom keymaps for Git conflict resolution
    local keymap = vim.keymap.set
    keymap("n", "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", { desc = "Choose ours" })
    keymap("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Choose theirs" })
    keymap("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Choose both" })
    keymap("n", "<leader>gc0", "<cmd>GitConflictChooseNone<CR>", { desc = "Choose none" })
    keymap("n", "<leader>gcl", "<cmd>GitConflictListQf<CR>", { desc = "List conflicts" })
    keymap("n", "]x", "<cmd>GitConflictNextConflict<CR>", { desc = "Next conflict" })
    keymap("n", "[x", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous conflict" })
  else
    vim.notify("git-conflict not found. Conflict resolution features unavailable.", vim.log.levels.DEBUG)
  end
  
  -- DiffView setup (if available)
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
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              max_count = 512,
              follow = true,
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      keymaps = {
        disable_defaults = false,
        view = {
          ["<tab>"]      = "select_next_entry",
          ["<s-tab>"]    = "select_prev_entry",
          ["<leader>e"]  = "focus_files",
          ["<leader>b"]  = "toggle_files",
        },
        file_panel = {
          ["j"]             = "next_entry",
          ["<down>"]        = "next_entry",
          ["k"]             = "prev_entry",
          ["<up>"]          = "prev_entry",
          ["h"]             = "toggle_collapse",
          ["l"]             = "open_selected_entry",
          ["<cr>"]          = "open_selected_entry",
          ["<2-LeftMouse>"] = "open_selected_entry",
          ["<c-b>"]         = "scroll_view(-0.25)",
          ["<c-f>"]         = "scroll_view(0.25)",
          ["<tab>"]         = "select_next_entry",
          ["<s-tab>"]       = "select_prev_entry",
          ["q"]             = "close",
          ["R"]             = "refresh_files",
        },
        file_history_panel = {
          ["g!"]            = "options",
        },
      },
    })
    
    -- Keymaps for diffview - avoid duplicate bindings
    local keymap = vim.keymap.set
    keymap("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
    keymap("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
    keymap("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
  else
    vim.notify("diffview.nvim not found. Enhanced diff view unavailable.", vim.log.levels.DEBUG)
  end
  
  -- GitHub integration with Octo (if available and GitHub CLI is installed)
  local has_gh_cli = executable_exists("gh")
  if not has_gh_cli then
    vim.notify("GitHub CLI (gh) not found. Octo.nvim will be disabled.", vim.log.levels.WARN)
  else
    local octo_ok, octo = pcall(require, "octo")
    if octo_ok then
      -- Safe setup with error handling
      local octo_setup_ok, err = pcall(function()
        octo.setup({
          ssh_aliases = {}, -- SSH aliases. e.g. { ["github.com-work"] = "github.com" }
          reaction_viewer_hint_icon = "",
          user_icon = " ",
          timeline_marker = "",
          timeline_indent = "2",
          right_bubble_delimiter = "",
          left_bubble_delimiter = "",
          github_hostname = "",
          snippet_context_lines = 4,
          file_panel = {
            size = 10,
            use_icons = true
          },
          mappings = {
            issue = {
              close_issue = { lhs = "<leader>ic", desc = "close issue" },
              reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
              list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
              reload = { lhs = "<leader>ir", desc = "reload issue" },
              open_in_browser = { lhs = "<leader>ib", desc = "open issue in browser" },
              copy_url = { lhs = "<leader>iy", desc = "copy url to system clipboard" },
              add_assignee = { lhs = "<leader>ia", desc = "add assignee" },
              remove_assignee = { lhs = "<leader>id", desc = "remove assignee" },
              create_label = { lhs = "<leader>iL", desc = "create label" },
              add_label = { lhs = "<leader>il", desc = "add label" },
              remove_label = { lhs = "<leader>iR", desc = "remove label" },
              goto_issue = { lhs = "<leader>ig", desc = "navigate to a local repo issue" },
              add_comment = { lhs = "<leader>iC", desc = "add comment" },
              delete_comment = { lhs = "<leader>iD", desc = "delete comment" },
              next_comment = { lhs = "]c", desc = "go to next comment" },
              prev_comment = { lhs = "[c", desc = "go to previous comment" },
              react_hooray = { lhs = "<leader>i1", desc = "add/remove 🎉 reaction" },
              react_heart = { lhs = "<leader>i2", desc = "add/remove ❤️ reaction" },
              react_eyes = { lhs = "<leader>i3", desc = "add/remove 👀 reaction" },
              react_thumbs_up = { lhs = "<leader>i4", desc = "add/remove 👍 reaction" },
              react_thumbs_down = { lhs = "<leader>i5", desc = "add/remove 👎 reaction" },
              react_rocket = { lhs = "<leader>i6", desc = "add/remove 🚀 reaction" },
              react_laugh = { lhs = "<leader>i7", desc = "add/remove 😄 reaction" },
              react_confused = { lhs = "<leader>i8", desc = "add/remove 😕 reaction" },
            },
            pull_request = {
              checkout_pr = { lhs = "<leader>po", desc = "checkout PR" },
              merge_pr = { lhs = "<leader>pm", desc = "merge commit PR" },
              squash_and_merge_pr = { lhs = "<leader>psm", desc = "squash and merge PR" },
              list_commits = { lhs = "<leader>pc", desc = "list PR commits" },
              list_changed_files = { lhs = "<leader>pf", desc = "list PR changed files" },
              show_pr_diff = { lhs = "<leader>pd", desc = "show PR diff" },
              add_reviewer = { lhs = "<leader>pv", desc = "add reviewer" },
              remove_reviewer = { lhs = "<leader>pvd", desc = "remove reviewer request" },
              close_pr = { lhs = "<leader>px", desc = "close PR" },
              reopen_pr = { lhs = "<leader>po", desc = "reopen PR" },
              list_prs = { lhs = "<leader>pL", desc = "list open PRs on same repo" },
              reload = { lhs = "<leader>pr", desc = "reload PR" },
              open_in_browser = { lhs = "<leader>pb", desc = "open PR in browser" },
              copy_url = { lhs = "<leader>py", desc = "copy url to system clipboard" },
              goto_file = { lhs = "gf", desc = "go to file" },
              add_assignee = { lhs = "<leader>pa", desc = "add assignee" },
              remove_assignee = { lhs = "<leader>pad", desc = "remove assignee" },
              create_label = { lhs = "<leader>pcl", desc = "create label" },
              add_label = { lhs = "<leader>pl", desc = "add label" },
              remove_label = { lhs = "<leader>pld", desc = "remove label" },
              goto_pr = { lhs = "<leader>pg", desc = "navigate to a local repo PR" },
              add_comment = { lhs = "<leader>pC", desc = "add comment" },
              delete_comment = { lhs = "<leader>pD", desc = "delete comment" },
              next_comment = { lhs = "]c", desc = "go to next comment" },
              prev_comment = { lhs = "[c", desc = "go to previous comment" },
              react_hooray = { lhs = "<leader>p1", desc = "add/remove 🎉 reaction" },
              react_heart = { lhs = "<leader>p2", desc = "add/remove ❤️ reaction" },
              react_eyes = { lhs = "<leader>p3", desc = "add/remove 👀 reaction" },
              react_thumbs_up = { lhs = "<leader>p4", desc = "add/remove 👍 reaction" },
              react_thumbs_down = { lhs = "<leader>p5", desc = "add/remove 👎 reaction" },
              react_rocket = { lhs = "<leader>p6", desc = "add/remove 🚀 reaction" },
              react_laugh = { lhs = "<leader>p7", desc = "add/remove 😄 reaction" },
              react_confused = { lhs = "<leader>p8", desc = "add/remove 😕 reaction" },
            },
            review_thread = {
              goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
              add_comment = { lhs = "<leader>ca", desc = "add comment" },
              add_suggestion = { lhs = "<leader>sa", desc = "add suggestion" },
              delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
              next_comment = { lhs = "]c", desc = "go to next comment" },
              prev_comment = { lhs = "[c", desc = "go to previous comment" },
              select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
              select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
              close_review_tab = { lhs = "<leader>rc", desc = "close review tab" },
              react_hooray = { lhs = "<leader>r1", desc = "add/remove 🎉 reaction" },
              react_heart = { lhs = "<leader>r2", desc = "add/remove ❤️ reaction" },
              react_eyes = { lhs = "<leader>r3", desc = "add/remove 👀 reaction" },
              react_thumbs_up = { lhs = "<leader>r4", desc = "add/remove 👍 reaction" },
              react_thumbs_down = { lhs = "<leader>r5", desc = "add/remove 👎 reaction" },
              react_rocket = { lhs = "<leader>r6", desc = "add/remove 🚀 reaction" },
              react_laugh = { lhs = "<leader>r7", desc = "add/remove 😄 reaction" },
              react_confused = { lhs = "<leader>r8", desc = "add/remove 😕 reaction" },
            },
            submit_win = {
              approve_review = { lhs = "<C-a>", desc = "approve review" },
              comment_review = { lhs = "<C-m>", desc = "comment review" },
              request_changes = { lhs = "<C-r>", desc = "request changes review" },
              close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            },
            review_diff = {
              add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment" },
              add_review_suggestion = { lhs = "<leader>sa", desc = "add a new review suggestion" },
              focus_files = { lhs = "<leader>e", desc = "move focus to changed files panel" },
              toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
              next_thread = { lhs = "]t", desc = "move to next thread" },
              prev_thread = { lhs = "[t", desc = "move to previous thread" },
              select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
              select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
              close_review_tab = { lhs = "<leader>rc", desc = "close review tab" },
              toggle_viewed = { lhs = "<leader>tv", desc = "toggle viewed state" },
            },
            file_panel = {
              next_entry = { lhs = "j", desc = "move to next changed file" },
              prev_entry = { lhs = "k", desc = "move to previous changed file" },
              select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
              refresh_files = { lhs = "R", desc = "refresh changed files panel" },
              focus_files = { lhs = "<leader>e", desc = "move focus to changed files panel" },
              toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
              select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
              select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
              close_review_tab = { lhs = "<leader>rc", desc = "close review tab" },
              toggle_viewed = { lhs = "<leader>tv", desc = "toggle viewed state" },
            },
          }
        })
      end)
      
      if not octo_setup_ok then
        vim.notify("Octo.nvim setup failed: " .. tostring(err), vim.log.levels.ERROR)
      end
      
      -- Keymaps for GitHub operations - using unique keys to avoid overlaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "List GitHub issues" })
      keymap("n", "<leader>oP", "<cmd>Octo pr list<CR>", { desc = "List GitHub PRs" })
      keymap("n", "<leader>or", "<cmd>Octo repo list<CR>", { desc = "List GitHub repos" })
    else
      vim.notify("Octo.nvim not found. GitHub integration unavailable.", vim.log.levels.DEBUG)
    end
  end
  
  -- Set up telescope git pickers if telescope is available
  if pcall(require, "telescope") then
    local keymap = vim.keymap.set
    -- Use consistent keymap patterns to avoid duplicate mappings
    keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
    keymap("n", "<leader>gC", "<cmd>Telescope git_bcommits<CR>", { desc = "Git buffer commits" })
    keymap("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
    keymap("n", "<leader>gS", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
    keymap("n", "<leader>gT", "<cmd>Telescope git_stash<CR>", { desc = "Git stash" })
  end
end

return M
