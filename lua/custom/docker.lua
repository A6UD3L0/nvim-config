-- docker.lua: Configure nvim-docker and toggleterm for Docker workflows
require('toggleterm').setup {}
require('docker').setup {}

-- Remove all <leader> mappings from here; they will be consolidated in keymaps.lua
