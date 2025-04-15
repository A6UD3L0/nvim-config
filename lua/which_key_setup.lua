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
    ["<leader>"] = {
      b = { name = "+buffer" },
      c = { name = "+code/lsp" },
      d = { name = "+docs" },
      dm = { name = "+ml-docs" },
      e = { name = "+explorer" },
      f = { name = "+find/file" },
      g = { name = "+git" },
      h = { name = "+harpoon" },
      k = { name = "+keymaps" },
      l = { name = "+lsp" },
      p = { name = "+python/env" },
      r = { name = "+run/requirements" },
      s = { name = "+search" },
      t = { name = "+terminal" },
      u = { name = "+utilities" },
      w = { name = "+window/tab" },
      x = { name = "+execute" },
      z = { name = "+zen/focus" },
      ["?"] = { name = "show keymaps" },
    },
  })
  
  -- Ensure leader key works as expected
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
end

return M
