#!/bin/bash

# Nvim Configuration Cleanup Script
# This script safely removes files that have been deprecated after the refactoring

echo "=== Neovim Configuration Cleanup ==="
echo "This script will remove files that have been replaced by the new modular architecture."
echo "Creating backup directory first..."

# Create a backup directory
BACKUP_DIR="./backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"

# Function to safely move files to backup
backup_file() {
  if [ -f "$1" ]; then
    echo "Backing up: $1"
    # Create the directory structure in backup
    mkdir -p "$(dirname "$BACKUP_DIR/$1")"
    # Move the file to backup
    mv "$1" "$BACKUP_DIR/$1"
    echo "  ✓ Moved to backup"
  else
    echo "  × File not found: $1"
  fi
}

echo ""
echo "Backing up and removing deprecated files..."

# Deprecated mapping file
backup_file "lua/mappings.lua"

# Deprecated config files
CONFIG_FILES=(
  "lua/config/completion.lua"
  "lua/config/git.lua"
  "lua/config/harpoon.lua"
  "lua/config/keybindings.lua"
  "lua/config/lsp.lua"
  "lua/config/nvim-tree.lua"
  "lua/config/project.lua"
  "lua/config/pytools.lua"
  "lua/config/search.lua"
  "lua/config/telescope.lua"
  "lua/config/terminal.lua"
  "lua/config/time-tracking.lua"
  "lua/config/undotree.lua"
  "lua/config/which-key.lua"
)

for file in "${CONFIG_FILES[@]}"; do
  backup_file "$file"
done

# Check if config directory is empty, if so, remove it
if [ -d "lua/config" ] && [ -z "$(ls -A lua/config)" ]; then
  echo "Removing empty config directory"
  rmdir "lua/config"
fi

echo ""
echo "Backup and cleanup complete!"
echo "All removed files were backed up to: $BACKUP_DIR"
echo "If you encounter any issues, you can restore them from the backup."
echo ""
echo "To verify your Neovim configuration is working correctly:"
echo "  1. Start Neovim: nvim"
echo "  2. Run health check: :checkhealth"
echo ""

# Make script executable
chmod +x "$0"
