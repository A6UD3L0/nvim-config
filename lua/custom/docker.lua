-- docker.lua: Integrate docker-tools.nvim with which-key for Docker commands

local ok, docker_tools = pcall(require, 'docker-tools')
if not ok then
  vim.notify('[nvim-config] docker-tools.nvim not found. Docker integration disabled.', vim.log.levels.WARN)
  return
end

-- Optionally, you can configure docker-tools here (default config is used in plugins/init.lua)
-- docker_tools.setup({ ... })

-- Register Docker commands in which-key if available
local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
  wk.register({
    ["<leader>d"] = {
      name = ' Docker',
      c = { function() docker_tools.containers.toggle() end, 'Containers' },
      i = { function() docker_tools.images.toggle() end, 'Images' },
      l = { function() docker_tools.logs.toggle() end, 'Logs' },
      s = { function() docker_tools.shell.toggle() end, 'Shell' },
    }
  })
end
