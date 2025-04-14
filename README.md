# Backend Development Neovim Configuration

A streamlined Neovim configuration focused specifically on backend development and data science. This configuration combines ThePrimeagen's keybindings with NvChad's simplicity to create an efficient development environment.

## Features

- **Focused on Backend Languages**: Python, Go, C, SQL, Docker
- **Terminal Integration**: Bottom-centered terminal with IDE-like appearance
- **Enhanced Python Experience**: 
  - Virtual environment management
  - File execution
  - IPython integration
  - Debugging support
- **Git Integration**: Comprehensive Git workflow
- **Database Support**: SQL editing and database connections
- **Clean Structure**: Minimal, organized configuration
- **Which-Key Display**: Upper-right corner with improved UI

## Key Bindings

- `<leader>` = Space
- `<leader>tt` - Toggle terminal (horizontal)
- `<leader>tf` - Toggle floating terminal
- `<leader>tr` - Run Python file
- `<leader>tp` - Python REPL
- `<leader>ti` - IPython REPL
- `<leader>tv` - Activate virtual environment
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>e` - File explorer
- `<leader><leader>` - Show all keybindings

## Structure

- `init.lua` - Main configuration file
- `lua/mappings.lua` - Keybindings
- `lua/backend-essentials/init.lua` - Backend development tools
- `lua/plugins/backend-essentials.lua` - Essential plugins
- `lua/plugins/init.lua` - Plugin loader

## Installation

1. Back up your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. Start Neovim and let it install plugins:
   ```bash
   nvim
   ```

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (recommended)
- Python 3 (for Python development)
- Go (for Go development)

## Customization

This configuration is intentionally minimal and focused. Add custom plugins by editing `lua/plugins/init.lua`.
