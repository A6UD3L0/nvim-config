-- Core configuration module loader
-- Loads all core Neovim settings

-- Load basic vim options and behaviors
require("core.options")

-- Load keymaps (based on ThePrimeagen's style with NvChad simplicity)
require("core.keymaps")

-- Load autocommands
require("core.autocmds")
