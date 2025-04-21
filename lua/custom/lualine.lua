-- lualine.lua: Clean, icon-driven statusline with venv display and safe loading
local function safe_require(mod)
  local ok, m = pcall(require, mod)
  if not ok then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load '" .. mod .. "'. Lualine will be disabled.", vim.log.levels.WARN)
    end)
    return nil
  end
  return m
end

local lualine = safe_require('lualine')
if not lualine then return end

local function venv_name()
  local venv = os.getenv('VIRTUAL_ENV') or vim.g.uv_python_env or ''
  if venv ~= '' then
    return ' ' .. vim.fn.fnamemodify(venv, ':t')
  end
  return ''
end

lualine.setup {
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
