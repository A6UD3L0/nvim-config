#!/bin/bash
set -e

cd /Users/juan/Desktop/nvim-config-main

echo "=== RUNNING NEOVIM CONFIGURATION TESTS ==="
echo "Testing from: $(pwd)"

# 1. Test basic startup
echo -e "\n=== TEST 1: Basic Startup ==="
nvim --version | head -n 2

# 2. Test health checks
echo -e "\n=== TEST 2: Health Checks ==="
nvim --headless -c "checkhealth" -c "quit" 2>&1 | grep -A 100 "health"

# 3. Test plugin loading
echo -e "\n=== TEST 3: Plugin Loading ==="
nvim --headless -c "lua print('Lazy plugin status: ' .. tostring(pcall(require, 'lazy')))" -c "quit" 2>&1 | grep "Lazy plugin status"

# 4. Test keybinding manager
echo -e "\n=== TEST 4: Keybinding Manager ==="
nvim --headless -c "lua print('Keybinding status: ' .. tostring(pcall(require, 'config.keybindings')))" -c "quit" 2>&1 | grep "Keybinding status"

# 5. Test which-key integration
echo -e "\n=== TEST 5: Which-Key Integration ==="
nvim --headless -c "lua print('Which-key status: ' .. tostring(pcall(require, 'config.which-key')))" -c "quit" 2>&1 | grep "Which-key status"

# 6. Test terminal module
echo -e "\n=== TEST 6: Terminal Module ==="
nvim --headless -c "lua print('Terminal module status: ' .. tostring(pcall(require, 'config.terminal')))" -c "quit" 2>&1 | grep "Terminal module status"

# 7. Test LSP configuration
echo -e "\n=== TEST 7: LSP Configuration ==="
nvim --headless -c "lua print('LSP config status: ' .. tostring(pcall(require, 'config.lsp')))" -c "quit" 2>&1 | grep "LSP config status"

# 8. Test undotree configuration
echo -e "\n=== TEST 8: Undotree Configuration ==="
nvim --headless -c "lua print('Undotree config status: ' .. tostring(pcall(require, 'config.undotree')))" -c "quit" 2>&1 | grep "Undotree config status"

# 9. Test project configuration
echo -e "\n=== TEST 9: Project Configuration ==="
nvim --headless -c "lua print('Project config status: ' .. tostring(pcall(require, 'config.project')))" -c "quit" 2>&1 | grep "Project config status"

# 10. Test plugin architecture
echo -e "\n=== TEST 10: Plugin Architecture ==="
nvim --headless -c "lua print('Plugin modules: ' .. vim.inspect(vim.tbl_keys(require('plugins'))))" -c "quit" 2>&1 | grep "Plugin modules"

echo -e "\n=== TESTS COMPLETED ==="
echo "Now launching full Neovim instance for manual testing..."
