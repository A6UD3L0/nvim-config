-- UV Python Project Management Integration for Neovim
-- Only project root detection, command creation, and venv logic live here. All keymaps are in whichkey_mece.lua.

local uv_utils = {}

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

if vim.fn.executable('uv') == 0 then
  vim.schedule(function()
    vim.notify('UV not found in PATH. Please install UV for Python project management.', vim.log.levels.WARN)
  end)
end
