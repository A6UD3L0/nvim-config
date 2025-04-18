-- Git integration plugins for comprehensive version control
return {
  -- Gitsigns for inline git hunks and blame
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Loading from our centralized Git configuration
      require("config.git").setup()
    end,
  },

  -- LazyGit integration for visual Git operations
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", 
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit current file" },
      { "<leader>gl", "<cmd>LazyGitFilterCurrentFile<CR>", desc = "LazyGit file logs" },
      { "<leader>gb", "<cmd>LazyGitFilter<CR>", desc = "LazyGit blame" },
    },
  },

  -- Git-conflict for merge conflict resolution
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = true, -- Configuration happens in config/git.lua
  },

  -- Diffview for better diff viewing and history navigation
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "File history (project)" },
    },
    config = true, -- Configuration happens in config/git.lua
  },

  -- Neogit for magit-like experience 
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gm", "<cmd>Neogit<CR>", desc = "Open Neogit (Magit)" },
    },
    config = true, -- Configuration happens in config/git.lua
  },
  
  -- Octo for GitHub integration (Pull Requests, Issues)
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = {
      { "<leader>go", "<cmd>Octo<CR>", desc = "Open GitHub menu" },
      { "<leader>gP", "<cmd>Octo pr list<CR>", desc = "List PRs" },
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List issues" },
    },
    config = true, -- Configuration happens in config/git.lua
  },
  
  -- Git blame line visualization
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gtb", "<cmd>GitBlameToggle<CR>", desc = "Toggle Git blame" },
    },
    config = function()
      require("gitblame").setup {
        enabled = false, -- Start with blame disabled
        delay = 500, -- Update delay in milliseconds
        virtual_text_format = "  %s • %a • %r • %d",
      }
    end,
  },
  
  -- Git web browser integration
  {
    "ruifm/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, mode = "n", desc = "Copy git URL" },
      { "<leader>gy", function() require("gitlinker").get_buf_range_url("v") end, mode = "v", desc = "Copy git URL" },
    },
    config = function()
      require("gitlinker").setup {
        callbacks = {
          ["github.com"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          print_url = true,
        },
      }
    end,
  },
  
  -- Telescope-git-diffs for better visualization
  {
    "paopaol/telescope-git-diffs.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local telescope = require("telescope")
      pcall(telescope.load_extension, "git_diffs")
      
      -- Add additional keybindings
      vim.keymap.set("n", "<leader>gd", function() 
        telescope.extensions.git_diffs.diff_commits({ 
          layout_config = { 
            width = 0.95,
            height = 0.85,
          } 
        }) 
      end, { desc = "Git diff commits" })
    end,
  },
}
