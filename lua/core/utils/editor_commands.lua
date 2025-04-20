-- lua/core/utils/editor_commands.lua
-- Utility for defining UV-related user commands and integrating with which-key

local M = {}

--- Helper to define a :Uv* command if uv is available, else warn.
---@param name string Command name (e.g. 'UvInit')
---@param uv_base string UV subcommand (e.g. 'init', 'add', ...)
---@param opts table { nargs, desc }
function M.define_uv_cmd(name, uv_base, opts)
  if vim.fn.executable('uv') == 1 then
    vim.api.nvim_create_user_command(name, function(params)
      local args = params.args or ''
      local cmd = string.format('uv %s %s', uv_base, args)
      vim.cmd('terminal '..cmd)
    end, opts)
  else
    vim.api.nvim_create_user_command(name, function()
      vim.notify('UV is not installed or not in PATH', vim.log.levels.WARN, { title = 'UV Command' })
    end, opts)
  end
end

--- Setup all UV commands and which-key integration
---@param wk table the which-key module
function M.setup_wk(wk)
  if vim.fn.executable('uv') ~= 1 then
    vim.notify('UV is not installed or not in PATH. Project commands unavailable.', vim.log.levels.WARN, { title = 'UV/WhichKey' })
    return
  end
  local cmds = {
    { 'UvInit',        'init',           { nargs = 1,  desc = 'UV: init project' } },
    { 'UvAdd',         'add',            { nargs = '+', desc = 'UV: add dependency' } },
    { 'UvRun',         'run',            { nargs = '*', desc = 'UV: run command' } },
    { 'UvLock',        'lock',           { nargs = 0,  desc = 'UV: lock dependencies' } },
    { 'UvSync',        'sync',           { nargs = 0,  desc = 'UV: sync environment' } },
    { 'UvPython',      'python',         { nargs = '*', desc = 'UV: python subcommand' } },
    { 'UvPin',         'python pin',     { nargs = 1,  desc = 'UV: pin Python version' } },
    { 'UvToolInstall', 'tool install',   { nargs = 1,  desc = 'UV: install tool' } },
    { 'Uvx',           'tool run',       { nargs = '+', desc = 'UV: run tool (uvx)' } },
  }
  local wk_entries = {}
  for _, c in ipairs(cmds) do
    M.define_uv_cmd(c[1], c[2], c[3])
    local key = c[1]:gsub('^Uv', ''):lower()
    wk_entries[key] = { ':'..c[1]..' ', c[3].desc }
  end
  wk.register({
    p = {
      name = ' Python/Project',
      i = wk_entries.init,
      a = wk_entries.add,
      r = wk_entries.run,
      l = wk_entries.lock,
      s = wk_entries.sync,
      v = wk_entries.python,
      p = wk_entries.pin,
      t = wk_entries.toolinstall,
      x = wk_entries.uvx,
    }
  }, { prefix = '<leader>' })
end

return M
