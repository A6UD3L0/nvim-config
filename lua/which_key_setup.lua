-- Ensure which-key displays correctly when leader key is pressed
local M = {}

function M.setup()
  -- Set timeoutlen to a value that allows which-key to appear quickly
  vim.opt.timeout = true
  vim.opt.timeoutlen = 300  -- Reduce the timeout for faster which-key response (ms)
  
  -- Initial which-key setup with specific settings for leader key display
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("Which-key not found, using fallback configuration", vim.log.levels.WARN)
    return
  end
  
  -- Custom mappings for which-key menu only
  which_key.register({
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>c"] = { name = "+code/lsp" },
    ["<leader>d"] = { name = "+docs" },
    ["<leader>df"] = { name = "Docs for current filetype" },
    ["<leader>dm"] = { name = "+ml-docs" },
    ["<leader>e"] = { name = "+explorer" },
    ["<leader>f"] = { name = "+find/file" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>gb"] = { name = "Git blame (LazyGit)" },
    ["<leader>gl"] = { name = "Git logs for current file" },
    ["<leader>h"] = { name = "+harpoon" },
    ["<leader>k"] = { name = "+keymaps" },
    ["<leader>l"] = { name = "+lsp" },
    ["<leader>p"] = { name = "+project/python" },
    ["<leader>pf"] = { name = "Find files in project" },
    ["<leader>ps"] = { name = "Project search (grep)" },
    ["<leader>q"] = { name = "+quickfix" },
    ["<leader>r"] = { name = "+run/requirements" },
    ["<leader>s"] = { name = "+search/substitute" },
    ["<leader>t"] = { name = "+terminal" },
    ["<leader>u"] = { name = "+undotree/utilities" },
    ["<leader>ut"] = { name = "Toggle Undotree" },
    ["<leader>uf"] = { name = "Focus Undotree" },
    ["<leader>w"] = { name = "+window/tab" },
    ["<leader>x"] = { name = "+execute" },
    ["<leader>y"] = { name = "Yank to system clipboard" },
    ["<leader>Y"] = { name = "Yank line to system clipboard" },
    ["<leader>z"] = { name = "+zen/focus" },
    ["<leader>/"] = { name = "Fuzzy find in buffer" },
    ["<leader>?"] = { "Show all keymaps (cheatsheet)" },
    ["<leader>1"] = { name = "Harpoon file 1" },
    ["<leader>2"] = { name = "Harpoon file 2" },
    ["<leader>3"] = { name = "Harpoon file 3" },
    ["<leader>4"] = { name = "Harpoon file 4" },
    ["<leader>5"] = { name = "Harpoon file 5" },
  })
  
  -- Register insert mode key mappings to be shown in which-key
  which_key.register({
    ["jk"] = { "<ESC>", "Exit insert mode" },
  }, { mode = "i" })
  
  -- Ensure leader key works as expected
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
end

return M
