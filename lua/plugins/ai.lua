-- AI-powered coding assistant plugins
-- Provides intelligent code completion and assistance

return {
  -- GitHub Copilot with Lua configuration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot-cmp",  -- Add Copilot source for nvim-cmp
    },
    config = function()
      require("copilot").setup({
        -- Set a different authentication method to avoid issues
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = "<M-k>",
            accept_line = "<M-j>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        filetypes = {
          ["*"] = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
          TelescopePrompt = false,
        },
        copilot_node_command = 'node', -- Node.js version path
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10,         -- #completions for panel
              inlineSuggestCount = 3, -- #completions for getCompletions
            }
          },
        }
      })
    end,
  },

  -- Copilot CMP integration
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("copilot_cmp").setup({
        method = "getCompletionsCycling",
        formatters = {
          label = require("copilot_cmp.format").format_label_text,
          insert_text = require("copilot_cmp.format").format_insert_text,
          preview = require("copilot_cmp.format").deindent,
        },
      })
    end
  },

  -- LLM command interface with prompt templates
  {
    "David-Kunz/gen.nvim",
    cmd = { "Gen", "GenRun" },
    opts = {
      model = "codellama:13b",  -- default model
      host = "localhost",
      port = "11434",
      display_mode = "float",   -- display mode for responses (float, split, vsplit)
      show_prompt = false,      -- show prompt in completions
      command = "curl",         -- command used to communicate with the LLM
      debug = false,
    },
    keys = {
      { "<leader>ai", ":Gen<CR>", mode = { "n", "v" }, desc = "AI Generate" },
      { "<leader>ae", ":Gen explain<CR>", mode = { "n", "v" }, desc = "AI Explain" },
      { "<leader>ar", ":Gen refactor<CR>", mode = { "n", "v" }, desc = "AI Refactor" },
    },
  },
}
