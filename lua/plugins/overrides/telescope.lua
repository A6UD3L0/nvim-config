-- Clean Telescope configuration with proper event handling
local M = {}

function M.setup()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  -- Create proper autocmd for TelescopeFindPre (will be triggered by Telescope internally)
  vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopeFindPre",
    callback = function()
      -- This event is triggered before Telescope creates the floating windows
      -- We don't need to do anything here, just registering it properly
    end,
  })
  
  -- Setup Telescope with recommended configuration
  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
        },
      },
      file_ignore_patterns = { "node_modules", "__pycache__", "%.git/", "%.ds_store" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      file_browser = {
        theme = "dropdown",
        hijack_netrw = true,
      },
    },
  })
  
  -- Load extensions safely
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "file_browser")
end

return M
