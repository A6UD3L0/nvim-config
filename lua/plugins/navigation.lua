-- Enhanced Navigation Plugins for Backend Development
return {
  -- Telescope with enhanced project awareness
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    cmd = "Telescope",
    version = false,
    keys = {
      -- Project-aware file finding (ThePrimeagen style)
      { "<leader>pf", function() require("config.telescope").setup().project_files() end, desc = "Find files in project" },
      { "<leader>ps", function() require("config.telescope").setup().project_grep() end, desc = "Search in project" },
      
      -- Buffer management
      { "<leader>fb", function() require("config.telescope").setup().buffers() end, desc = "Find buffers" },
      
      -- Recent files with better history
      { "<leader>fr", function() require("config.telescope").setup().recent_files() end, desc = "Recent files" },
      
      -- General telescope commands
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Projects" },
      
      -- Git integration
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
    },
    config = function()
      require("config.telescope").setup()
    end,
  },
  
  -- Harpoon for quick file navigation (ThePrimeagen style)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<leader>hh", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
      -- Traditional Harpoon bindings
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
      -- Navigation between marks
      { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon previous mark" },
      { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon next mark" },
    },
    config = function()
      require("config.harpoon").setup()
    end,
  },
  
  -- NvimTree file explorer with git integration
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "Find in file explorer" },
      { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
    },
    config = function()
      require("config.nvim-tree").setup()
    end,
  },
  
  -- Illuminate for highlighting current word occurrences
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      
      -- Set highlighting style
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
    end,
  },
  
  -- Enhanced jumping with leap
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    keys = {
      { "s", function() require("leap").leap { target_windows = { vim.fn.win_getid() } } end, mode = { "n", "x", "o" }, desc = "Leap forward" },
      { "S", function() require("leap").leap { backward = true, target_windows = { vim.fn.win_getid() } } end, mode = { "n", "x", "o" }, desc = "Leap backward" },
    },
    config = function()
      require("leap").add_default_mappings(false)
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
      require("leap").opts.case_sensitive = false
    end,
  },
  
  -- Flit for improved f/t motions
  {
    "ggandor/flit.nvim",
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx", multiline = true },
  },
  
  -- Better folding with nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines folded"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, add padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        
        table.insert(newVirtText, { suffix, "Comment" })
        return newVirtText
      end,
    },
    init = function()
      -- Using the fold commands in normal mode
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except kinds" })
      vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Close folds with" })
      vim.keymap.set("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Peek folded lines" })
    end,
  },
}
