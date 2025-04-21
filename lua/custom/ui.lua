-- Indent guides and scrollbar configuration, with safe loading
do
  local ok_ibl, ibl = pcall(require, 'ibl')
  if not ok_ibl then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'ibl'. Indent guides will be disabled.", vim.log.levels.WARN)
    end)
  else
    ibl.setup {
      indent = { char = '│', highlight = 'Comment' },
      scope = { enabled = true, show_start = false, show_end = false },
    }
  end
  local ok_scrollbar, scrollbar = pcall(require, 'scrollbar')
  if not ok_scrollbar then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'scrollbar'. Scrollbar will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  scrollbar.setup {
    handle = { color = '#888888' },
    marks = {
      Search = { color = '#fab387' },
      Error = { color = '#e06c75' },
      Warn = { color = '#e5c07b' },
      Info = { color = '#56b6c2' },
      Hint = { color = '#98c379' },
      Misc = { color = '#c678dd' },
    },
  }
end
