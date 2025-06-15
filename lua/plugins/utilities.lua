return {
  -- Undotree - Visualize undo history
  {
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'UndoTree Toggle' },
    },
    config = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_SplitWidth = 40
    end,
  },

  -- Harpoon - Mark and jump to important files
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ha', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Harpoon Add File' },
      { '<leader>hh', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = 'Harpoon Menu' },
      { '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = 'Harpoon to File 1' },
      { '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = 'Harpoon to File 2' },
      { '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = 'Harpoon to File 3' },
      { '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = 'Harpoon to File 4' },
      { '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = 'Harpoon to File 5' },
      { '<leader>hp', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = 'Harpoon Prev' },
      { '<leader>hn', "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = 'Harpoon Next' },
    },
    config = function()
      require('harpoon').setup({
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          enter_on_sendcmd = false,
          tmux_autoclose_windows = false,
          excluded_filetypes = { 'harpoon' },
          mark_branch = false,
        },
      })
    end,
  },

  -- LazyGit - Git client
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
      { '<leader>gc', '<cmd>LazyGitConfig<cr>', desc = 'LazyGit Config' },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'} -- customize lazygit popup window border
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
      
      -- Custom function to toggle LazyGit in a floating window
      local function lazygit_toggle()
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
          cmd = 'lazygit',
          dir = 'git_dir',
          direction = 'float',
          float_opts = {
            border = 'double',
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd('startinsert!')
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd('startinsert!')
          end,
        })
        lazygit:toggle()
      end
      
      vim.keymap.set('n', '<leader>gl', lazygit_toggle, { noremap = true, silent = true, desc = 'LazyGit Toggle' })
    end,
  },

  -- Better terminal integration
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      })

      -- Custom terminal commands
      local Terminal = require('toggleterm.terminal').Terminal
      
      -- LazyGit in floating window
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd('startinsert!')
        end,
      })
      
      -- Function to toggle LazyGit
      function _lazygit_toggle()
        lazygit:toggle()
      end
      
      -- Keymaps for terminal windows
      vim.api.nvim_set_keymap('n', '<leader>gt', '<cmd>ToggleTerm<CR>', {noremap = true, silent = true, desc = 'Toggle Terminal'})
      vim.api.nvim_set_keymap('t', '<esc>', [[<C-\><C-n>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('t', 'jk', [[<C-\><C-n>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-W>h]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-W>j]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-W>k]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-W>l]], {noremap = true, silent = true})
    end,
  },
}

-- Add keymaps for the utilities
local function setup_keymaps()
  -- Undotree
  vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'UndoTree Toggle' })
  
  -- Harpoon
  vim.keymap.set('n', '<leader>ha', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Harpoon Add File' })
  vim.keymap.set('n', '<leader>hh', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon Menu' })
  vim.keymap.set('n', '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = 'Harpoon to File 1' })
  vim.keymap.set('n', '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = 'Harpoon to File 2' })
  vim.keymap.set('n', '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = 'Harpoon to File 3' })
  vim.keymap.set('n', '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = 'Harpoon to File 4' })
  vim.keymap.set('n', '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", { desc = 'Harpoon to File 5' })
  vim.keymap.set('n', '<leader>hp', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Harpoon Prev' })
  vim.keymap.set('n', '<leader>hn', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Harpoon Next' })
  
  -- LazyGit
  vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
  vim.keymap.set('n', '<leader>gc', '<cmd>LazyGitConfig<cr>', { desc = 'LazyGit Config' })
  vim.keymap.set('n', '<leader>gl', '<cmd>lua _lazygit_toggle()<cr>', { desc = 'LazyGit Toggle' })
end

-- Call the setup function
setup_keymaps()
