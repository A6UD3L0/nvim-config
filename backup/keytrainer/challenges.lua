-- Challenges for KeyTrainer
-- Enhanced with comprehensive Vim motions and Harpoon mastery

local M = {}

-- Beginner mode challenges (Basic navigation and commands)
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
  {
    description = "Move cursor to the beginning of the line",
    keybinding = "0",
    hint = "A single number key",
  },
  {
    description = "Move cursor to the first non-whitespace character",
    keybinding = "^",
    hint = "A symbol key found above the 6",
  },
  {
    description = "Move cursor to the end of the line",
    keybinding = "$",
    hint = "A symbol key often used in regex",
  },
}

-- Intermediate mode challenges (More advanced navigation and editing)
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
  {
    description = "Delete current line and enter insert mode",
    keybinding = "cc",
    hint = "Double tap a letter that copies",
  },
  {
    description = "Delete from cursor to end of line and enter insert mode",
    keybinding = "C",
    hint = "Uppercase version of a common letter",
  },
  {
    description = "Change inside parentheses",
    keybinding = "ci(",
    hint = "c + i + a bracket",
  },
  {
    description = "Jump to matching bracket or parenthesis",
    keybinding = "%",
    hint = "A symbol key used in many programming languages",
  },
}

-- Advanced mode challenges (Complex editing and navigation)
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
    description = "Navigate to first harpoon mark",
    keybinding = "<leader>h1",
    hint = "Leader key + h + number",
  },
  {
    description = "Navigate to second harpoon mark",
    keybinding = "<leader>h2",
    hint = "Leader key + h + number",
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
  {
    description = "Delete from cursor to next occurrence of 'x'",
    keybinding = "dtx",
    hint = "d + t + character",
  },
  {
    description = "Change until the end of the word",
    keybinding = "ce",
    hint = "c + e",
  },
  {
    description = "Delete an entire paragraph",
    keybinding = "dap",
    hint = "d + a + p",
  },
}

-- Harpoon mastery challenges (focused on Harpoon navigation)
M.harpoon = {
  {
    description = "Add current file to Harpoon",
    keybinding = "<leader>ha",
    hint = "Leader key followed by 'ha'",
  },
  {
    description = "Open Harpoon's quick menu",
    keybinding = "<leader>hh",
    hint = "Leader key followed by 'hh'",
  },
  {
    description = "Navigate to the first Harpoon mark",
    keybinding = "<leader>h1",
    hint = "Leader key + h + the position number",
  },
  {
    description = "Navigate to the second Harpoon mark",
    keybinding = "<leader>h2",
    hint = "Leader key + h + the position number",
  },
  {
    description = "Navigate to the third Harpoon mark",
    keybinding = "<leader>h3",
    hint = "Leader key + h + the position number",
  },
  {
    description = "Navigate to the fourth Harpoon mark",
    keybinding = "<leader>h4",
    hint = "Leader key + h + the position number",
  },
  {
    description = "Add current file to Harpoon and then navigate to first mark",
    keybinding = "<leader>ha<leader>h1",
    hint = "Combo: add file then jump to first mark",
  },
  {
    description = "Toggle Harpoon quick menu and remove a file (press 'd' in menu)",
    keybinding = "<leader>hhd",
    hint = "Open menu then press delete key",
  },
  {
    description = "Navigate with Harpoon between marks (back and forth)",
    keybinding = "<leader>h1<leader>h2",
    hint = "Jump to mark 1 then to mark 2",
  },
  {
    description = "Add a file to Harpoon then immediately navigate to 2nd mark",
    keybinding = "<leader>ha<leader>h2",
    hint = "Combo: add file then navigate",
  },
}

-- Vim motions mastery challenges
M.vim_motions = {
  {
    description = "Move to the next word (beginning)",
    keybinding = "w",
    hint = "A single letter for 'word'",
  },
  {
    description = "Move to the next WORD (beginning)",
    keybinding = "W",
    hint = "Uppercase version of previous command",
  },
  {
    description = "Move to the end of current word",
    keybinding = "e",
    hint = "A single letter for 'end'",
  },
  {
    description = "Move to the end of current WORD",
    keybinding = "E",
    hint = "Uppercase version of previous command",
  },
  {
    description = "Move to the beginning of previous word",
    keybinding = "b",
    hint = "A single letter for 'back'",
  },
  {
    description = "Move to the beginning of previous WORD",
    keybinding = "B",
    hint = "Uppercase version of previous command",
  },
  {
    description = "Move to the first occurrence of 'x' forward",
    keybinding = "fx",
    hint = "f + any character",
  },
  {
    description = "Move to the first occurrence of 'x' backward",
    keybinding = "Fx",
    hint = "Uppercase f + any character",
  },
  {
    description = "Move to just before the first occurrence of 'x' forward",
    keybinding = "tx",
    hint = "t + any character",
  },
  {
    description = "Move to just after the first occurrence of 'x' backward",
    keybinding = "Tx",
    hint = "Uppercase t + any character",
  },
  {
    description = "Repeat last f, F, t, or T motion forward",
    keybinding = ";",
    hint = "A single symbol key (might conflict with your command mode mapping)",
  },
  {
    description = "Move to the matching bracket under cursor",
    keybinding = "%",
    hint = "A symbol key (percent)",
  },
  {
    description = "Move to the top of the screen",
    keybinding = "H",
    hint = "Uppercase direction key for 'High'",
  },
  {
    description = "Move to the middle of the screen",
    keybinding = "M",
    hint = "Uppercase letter for 'Middle'",
  },
  {
    description = "Move to the bottom of the screen",
    keybinding = "L",
    hint = "Uppercase direction key for 'Low'",
  },
  {
    description = "Jump to line 10",
    keybinding = "10G",
    hint = "Number + uppercase letter",
  },
  {
    description = "Jump to the first line of the file",
    keybinding = "gg",
    hint = "Double tap a letter",
  },
  {
    description = "Jump to the last line of the file",
    keybinding = "G",
    hint = "Single uppercase letter",
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
    description = "Generate Python docstring with Neogen",
    keybinding = "<leader>dd",
    hint = "Leader key followed by 'dd' for 'docstring'",
  },
  {
    description = "Toggle database client UI",
    keybinding = ":DBUI<CR>",
    hint = "Command to toggle database UI",
  },
  {
    description = "Switch to insert mode at the beginning of the line",
    keybinding = "I",
    hint = "Uppercase version of the key used to enter insert mode",
  },
  {
    description = "Switch to insert mode at the end of the line",
    keybinding = "A",
    hint = "Uppercase version of a letter near 'i'",
  },
  {
    description = "Connect to a REPL for the current Python file",
    keybinding = ":let b:cmdline_app = 'python'<CR>",
    hint = "Setting variable then running IPython",
  },
  {
    description = "Toggle undotree visualization",
    keybinding = ":UndotreeToggle<CR>",
    hint = "Command to toggle a history visualization tool",
  },
}

-- TEXT OBJECT MASTERY challenges (for advanced editing)
M.text_objects = {
  {
    description = "Delete inside parentheses - di(",
    keybinding = "di(",
    hint = "d + i + opening parenthesis",
  },
  {
    description = "Change inside quotes - ci\"",
    keybinding = "ci\"",
    hint = "c + i + double quote",
  },
  {
    description = "Yank inside braces - yi{",
    keybinding = "yi{",
    hint = "y + i + opening brace",
  },
  {
    description = "Delete around parentheses (including them) - da(",
    keybinding = "da(",
    hint = "d + a + opening parenthesis",
  },
  {
    description = "Change around quotes (including them) - ca\"",
    keybinding = "ca\"",
    hint = "c + a + double quote",
  },
  {
    description = "Delete inside word - diw",
    keybinding = "diw",
    hint = "d + i + w",
  },
  {
    description = "Change around word - caw",
    keybinding = "caw",
    hint = "c + a + w",
  },
  {
    description = "Delete inside paragraph - dip",
    keybinding = "dip",
    hint = "d + i + p",
  },
  {
    description = "Yank around paragraph - yap",
    keybinding = "yap",
    hint = "y + a + p",
  },
  {
    description = "Change inside tag (HTML/XML) - cit",
    keybinding = "cit",
    hint = "c + i + t",
  },
  {
    description = "Delete around tag (HTML/XML) - dat",
    keybinding = "dat",
    hint = "d + a + t",
  },
  {
    description = "Change inside function block or class - cib",
    keybinding = "cib",
    hint = "c + i + b",
  },
  {
    description = "Yank inside inner block - yi}",
    keybinding = "yi}",
    hint = "y + i + closing brace",
  },
}

-- Terminal and Development Workflow challenges
M.workflow = {
  {
    description = "Toggle floating terminal",
    keybinding = ":ToggleTerm<CR>",
    hint = "Command to toggle terminal",
  },
  {
    description = "Open Mason package manager",
    keybinding = ":Mason<CR>",
    hint = "Command to open LSP/DAP installer",
  },
  {
    description = "Start Git command in Fugitive",
    keybinding = ":Git<CR>",
    hint = "Command to open Git interface",
  },
  {
    description = "Apply linting fixes to current file",
    keybinding = "<leader>f",
    hint = "Leader key followed by letter for format",
  },
  {
    description = "View git hunks in the current file",
    keybinding = ":Gitsigns preview_hunk<CR>",
    hint = "Command to view Git changes",
  },
  {
    description = "View LSP references for symbol under cursor",
    keybinding = "<leader>lsr",
    hint = "Leader key followed by 'ls' + 'r'",
  },
  {
    description = "Rename symbol under cursor",
    keybinding = "<leader>lsn",
    hint = "Leader key followed by 'ls' + 'n'",
  },
  {
    description = "Show hover documentation",
    keybinding = "K",
    hint = "Single uppercase key that moves text in visual mode",
  },
  {
    description = "Format comment block (wrap text)",
    keybinding = "gq}",
    hint = "g + q + movement",
  },
  {
    description = "Run Python code snippet under cursor",
    keybinding = "<Plug>SnipRun",
    hint = "SnipRun execution key",
  },
}

-- Git mastery challenges for enhanced workflow
M.git_tools = {
  {
    description = "Open main fugitive Git interface",
    keybinding = "<leader>gs",
    hint = "Leader + gs for 'git status'",
  },
  {
    description = "Show Git blame for current file",
    keybinding = "<leader>gb",
    hint = "Leader + gb for 'git blame'",
  },
  {
    description = "Open Git diff split",
    keybinding = "<leader>gd",
    hint = "Leader + gd for 'git diff'",
  },
  {
    description = "Open LazyGit terminal interface",
    keybinding = "<leader>gg",
    hint = "Leader + gg for 'git GUI'",
  },
  {
    description = "Preview Git hunk under cursor",
    keybinding = "<leader>gh",
    hint = "Leader + gh for 'git hunk'",
  },
  {
    description = "Stage current Git hunk",
    keybinding = "<leader>gs",
    hint = "Leader + gs for 'git stage'",
  },
  {
    description = "Reset (unstage) current Git hunk",
    keybinding = "<leader>gr",
    hint = "Leader + gr for 'git reset'",
  },
  {
    description = "Reset all changes in current buffer",
    keybinding = "<leader>gR",
    hint = "Capital R version of reset command",
  },
  {
    description = "Stage entire buffer",
    keybinding = "<leader>gS",
    hint = "Capital S version of stage command",
  },
  {
    description = "Show full blame for current line",
    keybinding = "<leader>gB",
    hint = "Leader + g + Capital B for 'git Blame'",
  },
  {
    description = "Toggle inline Git blame",
    keybinding = "<leader>gtb",
    hint = "Leader + gt + b for 'git toggle blame'",
  },
  {
    description = "Navigate to next Git hunk",
    keybinding = "]h",
    hint = "Right bracket + h for 'hunk'",
  },
  {
    description = "Navigate to previous Git hunk",
    keybinding = "[h",
    hint = "Left bracket + h for 'hunk'",
  },
  {
    description = "Open Git diffview",
    keybinding = "<leader>gv",
    hint = "Leader + gv for 'git view'",
  },
  {
    description = "View current file Git history",
    keybinding = "<leader>gf",
    hint = "Leader + gf for 'git file'",
  },
}

-- Undotree and history management challenges
M.history_management = {
  {
    description = "Toggle Undotree visualization",
    keybinding = "<leader>u",
    hint = "Leader + u for 'undo'",
  },
  {
    description = "Jump to older text state in undotree",
    keybinding = "g-",
    hint = "g followed by minus sign",
  },
  {
    description = "Jump to newer text state in undotree",
    keybinding = "g+",
    hint = "g followed by plus sign",
  },
  {
    description = "Undo last change",
    keybinding = "u",
    hint = "Single letter for 'undo'",
  },
  {
    description = "Redo last undone change",
    keybinding = "<C-r>",
    hint = "Control plus a letter",
  },
  {
    description = "Jump to older change position",
    keybinding = "g;",
    hint = "g followed by semicolon",
  },
  {
    description = "Jump to newer change position",
    keybinding = "g,",
    hint = "g followed by comma",
  },
  {
    description = "Mark buffer as 'clean' state",
    keybinding = ":later 1f<CR>",
    hint = "Command that advances to next file state",
  },
  {
    description = "Return to previous 'clean' state",
    keybinding = ":earlier 1f<CR>",
    hint = "Command that goes back to previous file state",
  },
  {
    description = "Show Undo history for current buffer",
    keybinding = ":undolist<CR>",
    hint = "Command showing numbers of changes you can undo",
  },
}

return M
