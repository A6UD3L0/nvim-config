-- Challenges for KeyTrainer
-- These challenges are tailored to the custom keybinding configuration

local M = {}

-- Beginner mode challenges
M.beginner = {
  {
    description = "Exit insert mode without using Escape key",
    keybinding = "jk",
    hint = "Two letters that you mapped as an Escape alternative",
  },
  {
    description = "Save the current file",
    keybinding = "<C-s>",
    hint = "Control + a letter",
  },
  {
    description = "Open command mode",
    keybinding = ";",
    hint = "A single character you've mapped to ':'",
  },
  {
    description = "Move to the window on the left",
    keybinding = "<C-h>",
    hint = "Control + a direction key (hjkl)",
  },
  {
    description = "Move to the window on the right",
    keybinding = "<C-l>",
    hint = "Control + a direction key (hjkl)",
  },
  {
    description = "Open file explorer (netrw)",
    keybinding = "<leader>pv",
    hint = "Leader key followed by 'pv' (ThePrimeagen's classic)",
  },
  {
    description = "Move down half a page and center cursor",
    keybinding = "<C-d>",
    hint = "Control + a letter for 'down'",
  },
  {
    description = "Move up half a page and center cursor",
    keybinding = "<C-u>",
    hint = "Control + a letter for 'up'",
  },
}

-- Intermediate mode challenges
M.intermediate = {
  {
    description = "Format the current file",
    keybinding = "<leader>f",
    hint = "Leader key followed by a single letter for 'format'",
  },
  {
    description = "Find files using Telescope",
    keybinding = "<leader>ff",
    hint = "Leader key followed by 'ff' for 'find files'",
  },
  {
    description = "Search for text in files using Telescope",
    keybinding = "<leader>fw",
    hint = "Leader key followed by 'fw' for 'find word'",
  },
  {
    description = "List open buffers using Telescope",
    keybinding = "<leader>fb",
    hint = "Leader key followed by 'fb' for 'find buffers'",
  },
  {
    description = "Move selected text down in visual mode",
    keybinding = "J",
    hint = "A single capital letter (in visual mode)",
  },
  {
    description = "Move selected text up in visual mode",
    keybinding = "K",
    hint = "A single capital letter (in visual mode)",
  },
  {
    description = "Restart the Language Server",
    keybinding = "<leader>lr",
    hint = "Leader key followed by 'lr' for 'LSP restart'",
  },
  {
    description = "Search and replace the word under cursor",
    keybinding = "<leader>s",
    hint = "Leader key followed by a single letter for 'substitute'",
  },
}

-- Advanced mode challenges
M.advanced = {
  {
    description = "Add current file to harpoon",
    keybinding = "<leader>ha",
    hint = "Leader key followed by 'ha' for 'harpoon add'",
  },
  {
    description = "Toggle harpoon quick menu",
    keybinding = "<leader>hh",
    hint = "Leader key followed by 'hh' for 'harpoon'",
  },
  {
    description = "Toggle a breakpoint for debugging",
    keybinding = "<leader>dt",
    hint = "Leader key followed by 'dt' for 'debug toggle'",
  },
  {
    description = "Continue debugging after a breakpoint",
    keybinding = "<leader>dc",
    hint = "Leader key followed by 'dc' for 'debug continue'",
  },
  {
    description = "Paste without yanking the selection",
    keybinding = "<leader>p",
    hint = "Leader key followed by a single letter (in visual mode)",
  },
  {
    description = "Yank to the system clipboard",
    keybinding = "<leader>y",
    hint = "Leader key followed by a single letter",
  },
  {
    description = "Delete without yanking",
    keybinding = "<leader>d",
    hint = "Leader key followed by a single letter",
  },
  {
    description = "Source (reload) the current file",
    keybinding = "<leader><leader>",
    hint = "Press the leader key twice",
  },
}

-- Backend development focused challenges
M.backend_focus = {
  {
    description = "Insert Go error handling snippet (return)",
    keybinding = "<leader>ee",
    hint = "Leader key followed by 'ee' for 'error'",
  },
  {
    description = "Insert Go error handling snippet (fatal)",
    keybinding = "<leader>ef",
    hint = "Leader key followed by 'ef' for 'error fatal'",
  },
  {
    description = "Make the current file executable",
    keybinding = "<leader>x",
    hint = "Leader key followed by a single letter for 'executable'",
  },
  {
    description = "View help tags with Telescope",
    keybinding = "<leader>fh",
    hint = "Leader key followed by 'fh' for 'find help'",
  },
  {
    description = "Find old (recently used) files",
    keybinding = "<leader>fo",
    hint = "Leader key followed by 'fo' for 'find old'",
  },
  {
    description = "Alternative way to exit insert mode",
    keybinding = "<C-c>",
    hint = "Control + a letter",
  },
  {
    description = "Join line without moving cursor",
    keybinding = "J",
    hint = "A single capital letter (in normal mode)",
  },
  {
    description = "Center view after finding next search match",
    keybinding = "n",
    hint = "The default key to find next match",
  },
}

return M
