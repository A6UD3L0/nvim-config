-- docker.lua: Configure nvim-docker and toggleterm for Docker workflows, with safe loading
do
  local ok_toggleterm, toggleterm = pcall(require, 'toggleterm')
  if not ok_toggleterm then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'toggleterm'. Docker terminal integration will be disabled.", vim.log.levels.WARN)
    end)
    return
  end
  toggleterm.setup {}
  local ok_docker, docker = pcall(require, 'docker')
  if not ok_docker then
    vim.schedule(function()
      vim.notify("[nvim-config] Could not load 'docker'. Docker integration will be incomplete.", vim.log.levels.WARN)
    end)
    return
  end
  docker.setup {}
end

-- Remove all <leader> mappings from here; they will be consolidated in keymaps.lua
