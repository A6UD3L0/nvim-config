-- lualine.lua: Clean, icon-driven statusline with venv display
local function venv_name()
  local venv = os.getenv('VIRTUAL_ENV') or vim.g.uv_python_env or ''
  if venv ~= '' then
    return ' ' .. vim.fn.fnamemodify(venv, ':t')
  end
  return ''
end

require('lualine').setup {
  options = {
    theme = 'everforest',
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { venv_name, 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
