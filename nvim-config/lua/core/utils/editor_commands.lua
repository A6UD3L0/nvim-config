-- lua/core/utils/editor_commands.lua
-- Canonical UV project/user-command and which-key integration

local M = {}

local uv_commands = {
  { name = 'UvInit',        uv = 'init',           opts = { nargs = 1,  desc = 'UV: init project' } },
  { name = 'UvAdd',         uv = 'add',            opts = { nargs = '+', desc = 'UV: add dependency' } },
  { name = 'UvRun',         uv = 'run',            opts = { nargs = '*', desc = 'UV: run command' } },
  { name = 'UvLock',        uv = 'lock',           opts = { nargs = 0,  desc = 'UV: lock dependencies' } },
  { name = 'UvSync',        uv = 'sync',           opts = { nargs = 0,  desc = 'UV: sync environment' } },
  { name = 'UvPython',      uv = 'python',         opts = { nargs = '*', desc = 'UV: python subcommand' } },
  { name = 'UvPin',         uv = 'python pin',     opts = { nargs = 1,  desc = 'UV: pin Python version' } },
  { name = 'UvToolInstall', uv = 'tool install',   opts = { nargs = 1,  desc = 'UV: install tool' } },
  { name = 'Uvx',           uv = 'tool run',       opts = { nargs = '+', desc = 'UV: run tool (uvx)' } },
}

local function has_toggleterm()
  return pcall(require, 'toggleterm')
end

--- Register all UV :Uv* user commands
function M.setup_commands()
  if vim.fn.executable('uv') ~= 1 then
    vim.notify('UV is not installed or not in PATH. Project commands unavailable.', vim.log.levels.WARN, { title = 'UV/Commands' })
    return
  end
  local use_toggleterm = has_toggleterm()
  for _, cmd in ipairs(uv_commands) do
    vim.api.nvim_create_user_command(cmd.name, function(params)
      local args = params and params.args or ''
      local base = cmd.uv
      local full = string.format('uv %s %s', base, args)
      if use_toggleterm then
        vim.cmd('TermExec cmd="'..full..'"')
      else
        vim.cmd('terminal '..full)
      end
    end, cmd.opts)
  end
end

--- Register Which-Key UV submenu under <leader>p
function M.setup_wk(wk)
  if not wk then return end
  local entries = {}
  for _, cmd in ipairs(uv_commands) do
    local key = cmd.name:gsub('^Uv', ''):lower()
    entries[key] = { ':'..cmd.name..' ', cmd.opts.desc }
  end
  wk.register({
    p = {
      name = ' Python/Project',
      i = entries.init,
      a = entries.add,
      r = entries.run,
      l = entries.lock,
      s = entries.sync,
      p = entries.python,
      v = entries.pin,
      t = {
        name = '+Tool',
        i = entries.toolinstall,
        x = entries.uvx or entries.toolrun,
      },
    },
  }, { prefix = '<leader>' })
end

return M
