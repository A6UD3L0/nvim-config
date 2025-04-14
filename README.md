# Backend Development Neovim Configuration

A streamlined Neovim configuration focused specifically on backend development and data science. This configuration combines ThePrimeagen's keybindings with NvChad's simplicity to create an efficient development environment.

## Prerequisites

### All Platforms
- Neovim 0.9.0 or later
- Git
- A Nerd Font installed and configured in your terminal
- Node.js and npm (for LSP servers)
- Python 3.8+ (for Python development)
- gcc/clang (for C/C++ development)
- Go 1.16+ (for Go development)

### Platform-Specific Requirements

#### Windows
- Windows Terminal or Alacritty recommended
- Git for Windows
- Scoop or Chocolatey package manager (recommended)
- Windows Subsystem for Linux (WSL) for best experience
- Ensure Nerd Fonts are properly installed in Windows Terminal

#### macOS
- Homebrew package manager
```bash
# Install essential tools
brew install neovim ripgrep fd node go python
```

#### Linux
- Your distribution's package manager (apt, pacman, dnf, etc.)
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install neovim ripgrep fd-find nodejs npm golang python3 python3-pip

# Arch Linux
sudo pacman -S neovim ripgrep fd nodejs npm go python python-pip
```

## Installation Instructions

### Windows

```powershell
# Backup existing Neovim configuration
if (Test-Path ~\AppData\Local\nvim) {
    Rename-Item -Path ~\AppData\Local\nvim -NewName nvim.bak
}

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~\AppData\Local\nvim

# Create data and state directories if they don't exist
if (-not (Test-Path ~\AppData\Local\nvim-data)) {
    New-Item -ItemType Directory -Path ~\AppData\Local\nvim-data
}

# Start Neovim to install plugins
nvim
```

### macOS

```bash
# Backup existing Neovim configuration
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim to install plugins
nvim
```

### Linux

```bash
# Backup existing Neovim configuration
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim to install plugins
nvim
```

## Key Features

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

### General
- `<leader>` = Space
- `<leader><leader>` - Show all keybindings
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Quit all

### Navigation
- `<C-h/j/k/l>` - Navigate between windows
- `<C-d>` - Half-page down & center
- `<C-u>` - Half-page up & center
- `<S-h/l>` - Previous/next buffer

### Terminal
- `<leader>tt` - Toggle terminal (horizontal)
- `<leader>tf` - Toggle floating terminal
- `<leader>tv` - Toggle vertical terminal
- `<C-t>` - Toggle terminal
- `<Esc>` or `jk` - Exit terminal mode

### File Navigation
- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files

### Code and LSP
- `<leader>lf` - Format document
- `<leader>lr` - Rename symbol
- `<leader>ld` - Go to definition
- `<leader>la` - Code actions
- `gd` - Go to definition
- `K` - Hover documentation

### Git
- `<leader>gg` - Git status
- `<leader>gb` - Git blame
- `<leader>gp` - Git push
- `<leader>gc` - Git commit

### Python Specific
- `<leader>tr` - Run Python file
- `<leader>tp` - Toggle Python REPL
- `<leader>ti` - Toggle IPython
- `<leader>tv` - Activate virtual environment
- `<leader>pv` - Select Python venv

### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dt` - Toggle debug UI

### Database
- `<leader>db` - Toggle database UI
- `<leader>da` - Add database connection

### Harpoon
- `<leader>a` - Add file to harpoon
- `<leader>h` - Harpoon menu
- `<leader>1-4` - Jump to harpoon file 1-4

## Structure

The configuration is organized into a minimal, clean structure:

- `init.lua` - Main configuration file
- `lua/mappings.lua` - Keybindings
- `lua/backend-essentials/init.lua` - Backend development tools and utilities
- `lua/plugins/backend-essentials.lua` - Essential plugins for backend development
- `lua/plugins/init.lua` - Plugin loader

## Customization

This configuration is intentionally minimal and focused. To add custom plugins, edit `lua/plugins/init.lua`.

## Troubleshooting

### Common Issues on Windows
- If you encounter font issues, make sure you have a Nerd Font properly installed and configured
- For WSL, ensure interop is enabled between Windows and WSL
- If LSP servers fail to install, try running Neovim with administrator privileges once

### Common Issues on macOS/Linux
- If plugins fail to install, ensure git is installed and properly configured
- For Python projects, create a virtual environment (.venv) in your project root
- Run `:checkhealth` command in Neovim to diagnose any issues

## Updates

To update the configuration:

```bash
cd ~/.config/nvim  # or ~\AppData\Local\nvim on Windows
git pull
```

Then run `:Lazy sync` inside Neovim to update plugins.
