# Installation Instructions

This document provides detailed installation instructions for the Neovim configuration on different operating systems.

## Prerequisites for All Platforms

- Neovim 0.9.0 or later
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for proper icon display
- Node.js and npm (for certain LSP servers)
- Python 3.8+ (for Python development features)
- Ripgrep (for Telescope file searching)

## Windows Installation

### 1. Prerequisites

1. Install [Neovim](https://github.com/neovim/neovim/releases)
   - Download the latest release and add it to your PATH
   - Alternatively, install with Chocolatey: `choco install neovim`

2. Install Git:
   ```powershell
   winget install -e --id Git.Git
   ```

3. Install Python:
   ```powershell
   winget install -e --id Python.Python.3.10
   ```

4. Install Node.js:
   ```powershell
   winget install -e --id OpenJS.NodeJS.LTS
   ```

5. Install Ripgrep:
   ```powershell
   winget install -e --id BurntSushi.ripgrep
   ```

6. Install a Nerd Font:
   - Download a font from [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
   - Install by right-clicking the .ttf file and selecting "Install"
   - Configure your terminal to use the Nerd Font

### 2. Configuration Installation

1. Backup your existing Neovim configuration (if any):
   ```powershell
   if (Test-Path ~\AppData\Local\nvim) {
     Rename-Item ~\AppData\Local\nvim ~\AppData\Local\nvim.bak
   }
   ```

2. Clone the repository:
   ```powershell
   git clone https://github.com/yourusername/nvim-config.git ~\AppData\Local\nvim
   ```

3. Open Neovim to initialize:
   ```powershell
   nvim
   ```
   - Lazy.nvim will automatically install and all plugins will be downloaded
   - This may take a few minutes on the first launch

### 3. Python Setup for Windows

1. Create a virtual environment (if using Python features):
   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   ```

2. Install Python dependencies:
   ```powershell
   pip install uv ruff python-lsp-server pylint black
   ```

## macOS Installation

### 1. Prerequisites

1. Install Homebrew (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Neovim and dependencies:
   ```bash
   brew install neovim git python node ripgrep
   ```

3. Install a Nerd Font:
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-hack-nerd-font
   ```
   - Configure your terminal to use the Nerd Font

### 2. Configuration Installation

1. Backup your existing Neovim configuration (if any):
   ```bash
   if [ -d ~/.config/nvim ]; then
     mv ~/.config/nvim ~/.config/nvim.bak
   fi
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. Open Neovim to initialize:
   ```bash
   nvim
   ```
   - Lazy.nvim will automatically install and all plugins will be downloaded
   - This may take a few minutes on the first launch

### 3. Python Setup for macOS

1. Create a virtual environment (if using Python features):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

2. Install Python dependencies:
   ```bash
   pip install uv ruff python-lsp-server pylint black
   ```

## Linux Installation

### 1. Prerequisites

For Debian/Ubuntu:
```bash
sudo apt update
sudo apt install neovim git python3 python3-pip nodejs npm ripgrep
```

For Arch Linux:
```bash
sudo pacman -S neovim git python python-pip nodejs npm ripgrep
```

For Fedora:
```bash
sudo dnf install neovim git python3 python3-pip nodejs npm ripgrep
```

Install a Nerd Font:
```bash
# Example for Ubuntu/Debian
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Hack Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
fc-cache -fv
```

### 2. Configuration Installation

1. Backup your existing Neovim configuration (if any):
   ```bash
   if [ -d ~/.config/nvim ]; then
     mv ~/.config/nvim ~/.config/nvim.bak
   fi
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. Open Neovim to initialize:
   ```bash
   nvim
   ```
   - Lazy.nvim will automatically install and all plugins will be downloaded
   - This may take a few minutes on the first launch

### 3. Python Setup for Linux

1. Create a virtual environment (if using Python features):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

2. Install Python dependencies:
   ```bash
   pip install uv ruff python-lsp-server pylint black
   ```

## Troubleshooting

### Common Issues

1. **Plugin installation fails**
   - Check your internet connection
   - Ensure git is properly installed and configured
   - Try running `:Lazy sync` manually

2. **Icons not displaying correctly**
   - Verify you've installed and configured a Nerd Font
   - Restart your terminal after font installation

3. **LSP servers not working**
   - Run `:Mason` and check if servers are installed
   - Install missing servers with `:MasonInstall <server-name>`
   - Check `:checkhealth` for more detailed diagnostics

4. **Python features not working**
   - Ensure Python is installed and in your PATH
   - Verify the virtual environment is activated
   - Check if Python packages are installed with `pip list`

5. **Performance issues**
   - Check startup time with `nvim --startuptime startup.log`
   - Consider disabling unused plugins in `lua/plugins.lua`

For more help, create an issue on GitHub.
