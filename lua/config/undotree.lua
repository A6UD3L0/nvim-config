-- Enhanced UndoTree configuration for better change history visualization
-- Provides easy navigation through file modifications in a visual timeline

local M = {}

function M.setup()
  -- Check if undotree is available
  if vim.fn.exists(":UndotreeToggle") == 0 then
    vim.notify("UndoTree not found. Change history visualization will be limited.", vim.log.levels.WARN)
    return
  end

  -- Configure UndoTree with better defaults
  vim.g.undotree_WindowLayout = 2       -- Layout 2: tree on the left, diff at the bottom
  vim.g.undotree_SplitWidth = 30        -- Width of the tree panel
  vim.g.undotree_DiffpanelHeight = 10   -- Height of the diff panel
  vim.g.undotree_SetFocusWhenToggle = 1 -- Automatically focus when opened
  vim.g.undotree_ShortIndicators = 1    -- Use short indicators to save space
  vim.g.undotree_DiffAutoOpen = 1       -- Auto open diff panel
  vim.g.undotree_RelativeTimestamp = 1  -- Use relative timestamps
  vim.g.undotree_HelpLine = 1           -- Show help line
  vim.g.undotree_CursorLine = 1         -- Highlight cursor line
  
  -- Create custom highlights for a better visual experience
  vim.api.nvim_set_hl(0, "UndotreeBranch", { fg = "#f6c177", italic = true }) -- Branch nodes
  vim.api.nvim_set_hl(0, "UndotreeNode", { fg = "#9ccfd8" })                  -- Regular nodes
  vim.api.nvim_set_hl(0, "UndotreeNodeCurrent", { fg = "#eb6f92", bold = true }) -- Current node
  vim.api.nvim_set_hl(0, "UndotreeSavedNode", { fg = "#31748f", bold = true }) -- Saved state nodes
  vim.api.nvim_set_hl(0, "UndotreeNextState", { fg = "#c4a7e7" })             -- Next state indicators
  vim.api.nvim_set_hl(0, "UndotreeTimeStamp", { fg = "#908caa" })             -- Timestamps
  vim.api.nvim_set_hl(0, "UndotreeHelp", { fg = "#f6c177", italic = true })    -- Help text
  vim.api.nvim_set_hl(0, "UndotreeSeq", { fg = "#ebbcba" })                   -- Sequence numbers
  vim.api.nvim_set_hl(0, "UndotreeCurrent", { fg = "#eb6f92", bold = true })  -- Current position

  -- Enhanced undotree features
  -- Create automatic undo history save points
  vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    callback = function()
      if vim.bo.filetype ~= "TelescopePrompt" then
        -- Create an undo breakpoint when modifying text
        vim.cmd("let &undolevels=&undolevels")
      end
    end
  })
  
  -- Persistent undo history across sessions
  local undodir = vim.fn.stdpath('data') .. '/undodir'
  
  -- Create undodir if it doesn't exist
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
  end
  
  -- Set undofile to save undo history
  vim.opt.undodir = undodir
  vim.opt.undofile = true
  vim.opt.undolevels = 1000
  vim.opt.undoreload = 10000
  
  -- ThePrimeagen-style keymappings
  vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
  vim.keymap.set("n", "<leader>ur", vim.cmd.UndotreeToggle, { desc = "Show Undo History" })
  
  -- Add helper to automatically configure the undotree window when opened
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "undotree",
    callback = function()
      -- Add extra keymaps for the undotree window
      local bufnr = vim.api.nvim_get_current_buf()
      
      -- Close with q key
      vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>UndotreeHide<CR>", {
        noremap = true, silent = true, desc = "Close undotree"
      })
      
      -- Show help with ?
      vim.api.nvim_buf_set_keymap(bufnr, "n", "?", "<cmd>UndotreeHelp<CR>", {
        noremap = true, silent = true, desc = "Undotree help"
      })
      
      -- Ensure window looks good
      vim.opt_local.signcolumn = "no"
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      
      -- Set more readable colors
      vim.cmd([[
        hi! link UndotreeNode Special
        hi! link UndotreeBranch Statement
        hi! link UndotreeCurrent Identifier
        hi! link UndotreeSeq Number
        hi! link UndotreeNext Question
        hi! link UndotreeTimeStamp Comment
        hi! link UndotreeSavedSmall String
        hi! link UndotreeNodeCurrent Function
      ]])
    end
  })
end

return M
