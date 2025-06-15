local M = {}

function M.config()
  -- Set up LazyGit toggle function
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = 'lazygit',
    dir = 'git_dir',
    direction = 'float',
    float_opts = { border = 'double' },
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
    end,
    on_close = function()
      vim.cmd('startinsert!')
    end,
  })

  _G._lazygit_toggle = function()
    lazygit:toggle()
  end

  -- Set up keymaps
  local keymaps = {
    -- Undotree
    { 'n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'UndoTree Toggle' } },
    
    -- Harpoon
    { 'n', '<leader>ha', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Harpoon Add File' } },
    { 'n', '<leader>hh', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon Menu' } },
    { 'n', '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = 'Harpoon to File 1' } },
    { 'n', '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = 'Harpoon to File 2' } },
    { 'n', '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = 'Harpoon to File 3' } },
    { 'n', '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = 'Harpoon to File 4' } },
    { 'n', '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", { desc = 'Harpoon to File 5' } },
    { 'n', '<leader>hp', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Harpoon Prev' } },
    { 'n', '<leader>hn', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Harpoon Next' } },
    
    -- LazyGit
    { 'n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' } },
    { 'n', '<leader>gc', '<cmd>LazyGitConfig<cr>', { desc = 'LazyGit Config' } },
    { 'n', '<leader>gl', '<cmd>lua _lazygit_toggle()<cr>', { desc = 'LazyGit Toggle' } },
    
    -- ToggleTerm
    { 'n', '<leader>gt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' }},
  }
  
  -- Terminal mode keymaps
  local term_keymaps = {
    { 't', '<esc>', [[<C-\\><C-n>]], { noremap = true, silent = true } },
    { 't', 'jk', [[<C-\\><C-n>]], { noremap = true, silent = true } },
    { 't', '<C-h>', [[<C-\\><C-n><C-W>h]], { noremap = true, silent = true } },
    { 't', '<C-j>', [[<C-\\><C-n><C-W>j]], { noremap = true, silent = true } },
    { 't', '<C-k>', [[<C-\\><C-n><C-W>k]], { noremap = true, silent = true } },
    { 't', '<C-l>', [[<C-\\><C-n><C-W>l]], { noremap = true, silent = true } },
  }
  
  -- Apply keymaps
  for _, map in ipairs(keymaps) do
    vim.keymap.set(unpack(map))
  end
  
  for _, map in ipairs(term_keymaps) do
    vim.keymap.set(unpack(map))
  end
end

return M
