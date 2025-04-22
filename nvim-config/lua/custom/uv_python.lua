-- UV Python Project Management Integration for Neovim
-- Project root detection and .venv auto-activation only

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

-- Setup UV commands and Which-Key integration
local ok, uv_cmds = pcall(require, 'core.utils.editor_commands')
if ok then
  uv_cmds.setup_commands()
  local wk_ok, wk = pcall(require, 'which-key')
  if wk_ok then
    uv_cmds.setup_wk(wk)
  end
end

return uv_utils
