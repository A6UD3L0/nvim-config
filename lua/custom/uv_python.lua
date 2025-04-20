-- UV Python Project Management Integration for Neovim
-- Auto-detect project root, define :Uv* commands, leader keymaps, and auto-activate .venv

local uv_utils = {}

-- Project root detection for Python/UV
function uv_utils.find_project_root()
  local cwd = vim.fn.getcwd()
  for _, marker in ipairs({ '.venv', 'pyproject.toml', '.python-version' }) do
    local found = vim.fn.finddir(marker, cwd .. ';')
    if found ~= '' then
      return vim.fn.fnamemodify(found, ':p:h')
    end
    found = vim.fn.findfile(marker, cwd .. ';')
    if found ~= '' then
      return vim.fn.fnamemodify(found, ':p:h')
    end
  end
  return cwd
end

-- Define UV commands using terminal execution (requires toggleterm.nvim or similar)
local function define_uv_commands()
  vim.api.nvim_create_user_command('UvInit',   function(opts) vim.cmd('TermExec cmd="uv init ' .. opts.args .. '"') end, { nargs = 1 })
  vim.api.nvim_create_user_command('UvAdd',    function(opts) vim.cmd('TermExec cmd="uv add ' .. opts.args .. '"') end, { nargs = '+' })
  vim.api.nvim_create_user_command('UvRun',    function(opts) vim.cmd('TermExec cmd="uv run ' .. opts.args .. '"') end, { nargs = '+' })
  vim.api.nvim_create_user_command('UvLock',   function() vim.cmd('TermExec cmd="uv lock"') end, {})
  vim.api.nvim_create_user_command('UvSync',   function() vim.cmd('TermExec cmd="uv sync"') end, {})
  vim.api.nvim_create_user_command('UvPython', function(opts) vim.cmd('TermExec cmd="uv python ' .. opts.args .. '"') end, { nargs = 1 })
  vim.api.nvim_create_user_command('UvPin',    function(opts) vim.cmd('TermExec cmd="uv python pin ' .. opts.args .. '"') end, { nargs = 1 })
  vim.api.nvim_create_user_command('UvToolInstall', function(opts) vim.cmd('TermExec cmd="uv tool install ' .. opts.args .. '"') end, { nargs = '+' })
  vim.api.nvim_create_user_command('Uvx',      function(opts) vim.cmd('TermExec cmd="uvx ' .. opts.args .. '"') end, { nargs = 1 })
end

define_uv_commands()

-- Keybindings for UV commands (leader+p/leader+t)
local map = vim.api.nvim_set_keymap
local keyopts = { noremap = true, silent = false }
map('n', '<leader>pi', ':UvInit ', keyopts)
map('n', '<leader>pa', ':UvAdd ',  keyopts)
map('n', '<leader>pr', ':UvRun ',  keyopts)
map('n', '<leader>pl', ':UvLock<CR>', keyopts)
map('n', '<leader>ps', ':UvSync<CR>', keyopts)
map('n', '<leader>pp', ':UvPython ', keyopts)
map('n', '<leader>pv', ':UvPin ',   keyopts)
map('n', '<leader>ti', ':UvToolInstall ', keyopts)
map('n', '<leader>tx', ':Uvx ',     keyopts)

-- Auto-activate .venv on BufEnter for Python files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.py',
  callback = function()
    local root = uv_utils.find_project_root()
    local venv = root .. '/.venv'
    if vim.fn.isdirectory(venv) == 1 then
      vim.cmd('silent !source ' .. venv .. '/bin/activate')
    end
  end,
})

-- Optional: Notify user if UV is not found in PATH
if vim.fn.executable('uv') == 0 then
  vim.schedule(function()
    vim.notify('UV not found in PATH. Please install UV for Python project management.', vim.log.levels.WARN)
  end)
end
