# Ultimate Backend Development Neovim Configuration

A comprehensive Neovim configuration optimized for backend development and data science. This configuration combines ThePrimeagen's powerful keybindings with NvChad's simplicity for an efficient development experience with beautiful UI elements.

![Neovim Dashboard](https://raw.githubusercontent.com/A6UD3L0/nvim-config/main/assets/dashboard.png)

## 🚀 Features

- **Gorgeous UI**
  - Rose Pine theme with customized transparency
  - Beautiful welcome dashboard with Alpha
  - Integrated file explorer with NvimTree
  - Modern statusline with Lualine
  - Tab and buffer management with Barbar

- **Python Development Arsenal**
  - Poetry integration for seamless package management
  - Virtual environment handling with automatic detection
  - Requirements.txt generation and installation shortcuts
  - Python debugging with DAP integration
  - Integrated REPL with Python and IPython support

- **Backend Language Support**
  - First-class support for Python, Go, Rust, TypeScript, SQL
  - Docker and Kubernetes integration
  - Database clients and SQL execution
  - LSP integration with intelligent code actions
  - Treesitter for advanced syntax highlighting

- **Intelligent Code Assistance**
  - GitHub Copilot integration
  - Completion with nvim-cmp
  - Snippets with LuaSnip
  - Automated import management
  - Advanced code diagnostics and linting

- **Efficient Git Workflow**
  - Gitsigns for inline git information
  - Fugitive for git commands
  - Diffview for code comparison
  - Merge conflict resolution tools

- **Productivity Boosters**
  - Terminal integration with Toggleterm
  - Project management with Telescope
  - MECE-compliant keybinding system with logical namespaces
  - File navigation with Telescope fuzzy finder
  - Undotree for change history visualization

## 📋 System Requirements

- Neovim 0.9.0 or higher
- Git
- Node.js and npm (for LSP servers)
- Python 3.8+ with pip (for Python language support)
- Rust/Cargo (for language servers)
- Ripgrep (for Telescope searches)
- A Nerd Font (for icons)

## ⚡ MECE Keybinding Structure

This configuration uses a **M**utually **E**xclusive, **C**ollectively **E**xhaustive (MECE) keybinding structure for maximum efficiency and intuitiveness:

| Namespace    | Purpose                                     |
|--------------|---------------------------------------------|
| `<leader>b`  | Buffer operations                           |
| `<leader>c`  | Code editing (formatting, styling)          |
| `<leader>d`  | Documentation (devdocs, help)               |
| `<leader>e`  | Explorer operations                         |
| `<leader>f`  | Find/File operations                        |
| `<leader>g`  | Git operations                              |
| `<leader>h`  | Harpoon operations                          |
| `<leader>k`  | Keymaps (show key bindings, help)           |
| `<leader>l`  | LSP operations (diagnostics, actions)       |
| `<leader>o`  | Organize (Poetry package management)        |
| `<leader>p`  | Project operations                          |
| `<leader>r`  | Run/Requirements                            |
| `<leader>s`  | Search/Replace operations                   |
| `<leader>t`  | Terminal/Tab operations                     |
| `<leader>u`  | Utilities (undotree, helpers)               |
| `<leader>v`  | Virtual environment (Python venv)           |
| `<leader>w`  | Window operations                           |
| `<leader>x`  | Execute code (run scripts, REPL)            |
| `<leader>z`  | Zen/Focus mode                              |

## 🔑 Key Productivity Shortcuts

- `jk` - Exit insert mode (faster than pressing Escape)
- `<C-h/j/k/l>` - Navigate between windows without using leader key
- `<leader>we` - Make all windows equal size
- `<leader>e` - Toggle file explorer
- `<leader>ff` - Find files
- `<leader>fg` - Find text in files (grep)
- `<leader>u` - Toggle Undotree
- `<leader>gg` - Open LazyGit
- `<leader>tt` - Toggle terminal
- `<leader>do` - Open documentation in a pane with search capabilities

## 🔧 Installation

### Quick Start (Automated)

The easiest way to install this configuration is to use the included installation script:

```bash
# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git
cd nvim-config

# Run the installation script
./install.sh
```

### Manual Installation

#### Prerequisites

##### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required dependencies
brew install neovim ripgrep fd node python3

# Create Python virtual environment for Neovim
mkdir -p ~/.venvs/neovim
python3 -m venv ~/.venvs/neovim
~/.venvs/neovim/bin/pip install pynvim
```

##### Linux (Ubuntu/Debian)

```bash
# Update packages
sudo apt update

# Install dependencies
sudo apt install -y neovim ripgrep fd-find git curl wget nodejs npm python3 python3-pip python3-venv

# Create Python virtual environment for Neovim
mkdir -p ~/.venvs/neovim
python3 -m venv ~/.venvs/neovim
~/.venvs/neovim/bin/pip install pynvim
```

##### Windows

```powershell
# Install scoop if not already installed (run in PowerShell)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Install dependencies
scoop install neovim ripgrep fd git nodejs python

# Install Python provider
pip install pynvim

# Create Python virtual environment for Neovim
mkdir -p $HOME\.venvs\neovim
python -m venv $HOME\.venvs\neovim
$HOME\.venvs\neovim\Scripts\pip install pynvim
```

#### Setting Up the Configuration

##### macOS/Linux

```bash
# Backup your existing Neovim configuration if necessary
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim (plugins will be installed automatically on first run)
nvim
```

##### Windows

```powershell
# Backup your existing Neovim configuration if necessary
if (Test-Path $env:LOCALAPPDATA\nvim) {
    Rename-Item -Path $env:LOCALAPPDATA\nvim -NewName nvim.bak
}

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git $env:LOCALAPPDATA\nvim

# Start Neovim (plugins will be installed automatically on first run)
nvim
```

## 🧹 Uninstallation

### macOS/Linux

```bash
# Remove Neovim configuration
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Optionally restore your previous configuration
[ -d ~/.config/nvim.bak ] && mv ~/.config/nvim.bak ~/.config/nvim
```

### Windows

```powershell
# Remove Neovim configuration
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data

# Optionally restore your previous configuration
if (Test-Path $env:LOCALAPPDATA\nvim.bak) {
    Rename-Item -Path $env:LOCALAPPDATA\nvim.bak -NewName nvim
}
```

## 📚 Documentation

### Using the Documentation Pane

This configuration includes a powerful documentation system with pane-based search:

1. Press `<leader>do` to open documentation in a floating window
2. Press `<leader>dO` to open documentation in a split pane
3. Use `/` to search within the documentation (standard Vim search)
4. Press `n` to move to the next search result, `N` for previous
5. Press `q` or `<Esc>` to close the documentation pane

### Installing Additional Documentation

1. Press `<leader>di` to open the documentation installer
2. Select the documentation you want to install
3. Press `<CR>` to install

### Window Navigation

Navigate between panes using:
- `<C-h>` - Move to the left window
- `<C-j>` - Move to the window below
- `<C-k>` - Move to the window above
- `<C-l>` - Move to the right window

Or use the leader-based commands:
- `<leader>ww` - Cycle through windows
- `<leader>wp` - Go to previous window

## 🛠️ Customization

You can customize this configuration by editing the relevant files:
- Main settings: `~/.config/nvim/init.lua`
- Key mappings: `~/.config/nvim/lua/mappings.lua`
- Plugin configuration: `~/.config/nvim/lua/plugins/`
- LSP configuration: `~/.config/nvim/lua/plugins/lsp.lua`

## 🙏 Acknowledgements

This configuration draws inspiration from:
- ThePrimeagen's Neovim configuration
- NvChad's simplicity and speed
- TJ DeVries' Neovim tutorials

## 📄 License

MIT
