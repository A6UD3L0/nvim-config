-- Indent guides and scrollbar configuration
require('ibl').setup {
  indent = { char = '│', highlight = 'Comment' },
  scope = { enabled = true, show_start = false, show_end = false },
}
require('scrollbar').setup {
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
