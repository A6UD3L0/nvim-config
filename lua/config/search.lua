-- Enhanced search functionality with centered results and improved UX
local M = {}

function M.setup()
  -- Enhanced search configuration for better focus
  -- Center search results during navigation for better focus
  local keymap = vim.keymap.set
  
  -- Center search results when navigating
  keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
  keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
  
  -- Center the screen when jumping between matches
  keymap("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
  keymap("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })
  
  -- Keep cursor centered when joining lines
  keymap("n", "J", "mzJ`z", { desc = "Join lines (preserve cursor)" })
  
  -- Keep search term in the middle when searching
  keymap("n", "*", "*zzzv", { desc = "Search word under cursor (centered)" })
  keymap("n", "#", "#zzzv", { desc = "Search word under cursor backward (centered)" })
  keymap("n", "g*", "g*zzzv", { desc = "Search word under cursor (no boundaries, centered)" })
  keymap("n", "g#", "g#zzzv", { desc = "Search word under cursor backward (no boundaries, centered)" })
  
  -- Center screen when navigating to marks
  keymap("n", "'", "'zzzv", { desc = "Go to mark (centered)" })
  keymap("n", "`", "`zzzv", { desc = "Go to mark exact position (centered)" })
  
  -- Search enhancement with better UI
  vim.opt.hlsearch = true       -- Highlight search results
  vim.opt.incsearch = true      -- Incremental search
  vim.opt.ignorecase = true     -- Ignore case in search patterns
  vim.opt.smartcase = true      -- Override ignorecase if pattern contains uppercase
  
  -- Enhanced searching with highlighting
  vim.cmd[[
  augroup search_highlighting
    autocmd!
    " Temporarily highlight yanked text
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
  augroup END
  ]]
  
  -- Clear search highlighting with ESC in normal mode
  keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })
  
  -- Quick search and replace for word under cursor
  keymap("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 
    { desc = "Search and replace word under cursor" })
  
  -- Project-wide search and replace with confirmation
  keymap("n", "<leader>sp", function()
    local word = vim.fn.expand("<cword>")
    local cmd = string.format([[:%s/\<%s\>/%s/gc]], word, word)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
  end, { desc = "Project search/replace with confirmation" })
  
  -- Helper function for improved searching with visual selection
  -- Allows searching for visually selected text
  vim.cmd([[
  function! s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    
    if len(lines) == 0
        return ''
    endif
    
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    
    return join(lines, "\n")
  endfunction
  ]])
  
  -- Search for visually selected text
  keymap("v", "/", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>zzzv", 
    { desc = "Search for visual selection", silent = true })
  
  -- Search for visually selected text on star (*) press
  keymap("v", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>zzzv]], 
    { desc = "Search for visual selection (forward)" })
  
  keymap("v", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>zzzv]], 
    { desc = "Search for visual selection (backward)" })
end

return M
