#!/bin/bash
# One-command fix for plugin loading errors

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Fixing Neovim Plugin Loading Errors${NC}"
echo -e "${BLUE}=================================${NC}"

# Move problematic modules to a new location where lazy.nvim won't scan them
echo -e "\n${BLUE}Moving custom modules out of the plugin path...${NC}"

# Create a modules directory if it doesn't exist
MODULES_DIR="${HOME}/.config/nvim/lua/modules"
mkdir -p "$MODULES_DIR"

# Create backup of the current state
BACKUP_DIR="${HOME}/.config/nvim_backup_$(date +%Y%m%d%H%M%S)"
echo -e "${YELLOW}Creating backup at ${BACKUP_DIR}${NC}"
mkdir -p "$BACKUP_DIR"
cp -r "${HOME}/.config/nvim" "$BACKUP_DIR"

# Clean old Neovim data
echo -e "\n${BLUE}Cleaning Neovim data directories...${NC}"
rm -rf "${HOME}/.local/share/nvim"
rm -rf "${HOME}/.local/state/nvim"
rm -rf "${HOME}/.cache/nvim"
echo -e "${GREEN}✓ Cleaned Neovim data directories${NC}"

# Create lazy.nvim and required plugin directories
echo -e "\n${BLUE}Installing essential plugins...${NC}"
mkdir -p "${HOME}/.local/share/nvim/lazy"

# Install plugin manager
git clone https://github.com/folke/lazy.nvim.git "${HOME}/.local/share/nvim/lazy/lazy.nvim"

# Install critical plugins directly
git clone https://github.com/folke/tokyonight.nvim "${HOME}/.local/share/nvim/lazy/tokyonight.nvim"
git clone https://github.com/nvim-lualine/lualine.nvim "${HOME}/.local/share/nvim/lazy/lualine.nvim"
git clone https://github.com/rcarriga/nvim-notify "${HOME}/.local/share/nvim/lazy/nvim-notify"
git clone https://github.com/folke/which-key.nvim "${HOME}/.local/share/nvim/lazy/which-key.nvim"

echo -e "${GREEN}✓ Essential plugins installed${NC}"

# Move custom modules to the modules directory
echo -e "\n${BLUE}Moving custom modules...${NC}"

# Move ADHD theme and keybind logger to modules directory
if [ -f "${HOME}/.config/nvim/lua/plugins/adhd_friendly_theme.lua" ]; then
    cp "${HOME}/.config/nvim/lua/plugins/adhd_friendly_theme.lua" "$MODULES_DIR/"
    rm "${HOME}/.config/nvim/lua/plugins/adhd_friendly_theme.lua"
    echo -e "${GREEN}✓ Moved adhd_friendly_theme.lua to modules directory${NC}"
fi

if [ -f "${HOME}/.config/nvim/lua/plugins/keybind_logger.lua" ]; then
    cp "${HOME}/.config/nvim/lua/plugins/keybind_logger.lua" "$MODULES_DIR/"
    rm "${HOME}/.config/nvim/lua/plugins/keybind_logger.lua"
    echo -e "${GREEN}✓ Moved keybind_logger.lua to modules directory${NC}"
fi

if [ -f "${HOME}/.config/nvim/lua/plugins/lualine.lua" ]; then
    rm "${HOME}/.config/nvim/lua/plugins/lualine.lua"
    echo -e "${GREEN}✓ Removed lualine.lua from plugins directory${NC}"
fi

if [ -f "${HOME}/.config/nvim/lua/plugins/notify.lua" ]; then
    rm "${HOME}/.config/nvim/lua/plugins/notify.lua"
    echo -e "${GREEN}✓ Removed notify.lua from plugins directory${NC}"
fi

# Create a proper plugin file for lualine and notify
echo -e "\n${BLUE}Creating proper plugin specifications...${NC}"

# Create a plugins.lua file with proper specs
PLUGINS_FILE="${HOME}/.config/nvim/lua/plugins.lua"
cat > "$PLUGINS_FILE" << 'EOL'
return {
  -- UI/Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", config = true },
  { "rcarriga/nvim-notify", config = function()
    require("nvim-notify").setup({
      background_colour = "#000000",
      stages = "fade",
      timeout = 3000,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      on_open = function() pcall(vim.api.nvim_set_hl, 0, "NotifyBackground", { bg = "#000000" }) end,
      silent = true,
    })
    vim.notify = require("nvim-notify")
  end
  },
  { "folke/which-key.nvim", event = "VeryLazy", config = true },
}
EOL
echo -e "${GREEN}✓ Created proper plugin specifications${NC}"

# Create module loader file
echo -e "\n${BLUE}Creating module loader...${NC}"
MODULES_LOADER="${HOME}/.config/nvim/lua/modules/init.lua"
mkdir -p "${HOME}/.config/nvim/lua/modules"
cat > "$MODULES_LOADER" << 'EOL'
-- Load ADHD-friendly theme
local adhd_ok, adhd = pcall(require, "modules.adhd_friendly_theme")
if adhd_ok then
  -- The module is available, apply it
  _G.ADHD_THEME = adhd
else
  vim.notify("ADHD-friendly theme not found", vim.log.levels.WARN)
end

-- Load keybind logger
local logger_ok, logger = pcall(require, "modules.keybind_logger")
if logger_ok then
  -- The module is available
  _G.KEYBIND_LOGGER = logger
else
  vim.notify("Keybind logger not found", vim.log.levels.WARN)
end

-- Return the module
return {
  adhd = adhd_ok and adhd or nil,
  logger = logger_ok and logger or nil,
}
EOL
echo -e "${GREEN}✓ Created module loader${NC}"

# Update init.lua to load modules
echo -e "\n${BLUE}Updating init.lua to load modules...${NC}"
INIT_FILE="${HOME}/.config/nvim/init.lua"

# Check if init.lua exists, create a basic one if not
if [ ! -f "$INIT_FILE" ]; then
  cat > "$INIT_FILE" << 'EOL'
-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- Load plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Load custom modules
require("modules")

-- Load mappings
pcall(require, "mappings")

-- Apply ADHD-friendly theme
if _G.ADHD_THEME then
  _G.ADHD_THEME.setup()
  _G.ADHD_THEME.setup_lualine()
end
EOL
  echo -e "${GREEN}✓ Created a new init.lua${NC}"
else
  # Backup the existing init.lua
  cp "$INIT_FILE" "${INIT_FILE}.bak"
  
  # Append module loading to init.lua
  cat >> "$INIT_FILE" << 'EOL'

-- Load custom modules
require("modules")

-- Apply ADHD-friendly theme if available
if _G.ADHD_THEME then
  _G.ADHD_THEME.setup()
  _G.ADHD_THEME.setup_lualine()
end
EOL
  echo -e "${GREEN}✓ Updated init.lua${NC}"
fi

echo -e "\n${BLUE}Fixes complete!${NC}"
echo -e "${YELLOW}Instructions:${NC}"
echo -e "1. Start Neovim with: ${GREEN}nvim${NC}"
echo -e "2. If you still see plugin errors, close Neovim and run this script again"
echo -e "3. To activate the ADHD-friendly theme, type: ${GREEN}:lua _G.ADHD_THEME.setup()${NC}"
echo -e "\n${GREEN}Your Neovim configuration is now fixed!${NC}"
