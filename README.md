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

- **Machine Learning & Data Science**
  - Integrated documentation for ML libraries (scikit-learn, NumPy, Pandas)
  - Direct shortcuts to TensorFlow, PyTorch, and Matplotlib documentation
  - Virtual environment management optimized for data science workflows
  - Intelligent code completion for ML libraries
  - Notebook-like experience with code execution

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
  - LazyGit for visual Git operations
  - Diffview for code comparison
  - Merge conflict resolution tools

- **Productivity Boosters**
  - Terminal integration with Toggleterm
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
| `<leader>dm` | Machine Learning documentation              |
| `<leader>e`  | Explorer operations                         |
| `<leader>f`  | Find/File operations                        |
| `<leader>g`  | Git operations                              |
| `<leader>h`  | Harpoon operations                          |
| `<leader>k`  | Keymaps (show key bindings, help)           |
| `<leader>l`  | LSP operations (diagnostics, actions)       |
| `<leader>p`  | Python/Environment/Dependencies             |
| `<leader>r`  | Run/Requirements                            |
| `<leader>s`  | Search/Replace operations                   |
| `<leader>t`  | Terminal/Tab operations                     |
| `<leader>u`  | Utilities (undotree, helpers)               |
| `<leader>w`  | Window operations                           |
| `<leader>x`  | Execute code (run scripts, REPL)            |
| `<leader>z`  | Zen/Focus mode                              |

### Documentation Keybindings

Documentation is accessible through the `<leader>d` namespace with ML-specific documentation under `<leader>dm`:

| Binding           | Action                                    |
|-------------------|-------------------------------------------|
| `<leader>do`      | Toggle documentation panel                |
| `<leader>dO`      | Open documentation in buffer              |
| `<leader>df`      | Fetch documentation index                 |
| `<leader>di`      | Install documentation                     |
| `<leader>du`      | Update documentation                      |
| `<leader>dU`      | Update all documentation                  |
| `<leader>dh`      | Search in documentation                   |
| `<leader>dm`      | Browse ML documentation (interactive)     |
| `<leader>dmk`     | scikit-learn documentation               |
| `<leader>dmn`     | NumPy documentation                       |
| `<leader>dmp`     | Pandas documentation                      |
| `<leader>dmt`     | TensorFlow documentation                  |
| `<leader>dmy`     | PyTorch documentation                     |
| `<leader>dmm`     | Matplotlib documentation                  |

## 🔧 Installation

### Completely Fresh Install (Fix Plugin Errors)

If you're experiencing plugin errors, the most reliable fix is a complete reinstall:

#### macOS/Linux

```bash
# Backup your existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Install plugin manager (lazy.nvim)
git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

# Install critical plugins for ADHD-friendly theme
git clone https://github.com/folke/tokyonight.nvim ~/.local/share/nvim/lazy/tokyonight.nvim
git clone https://github.com/nvim-lualine/lualine.nvim ~/.local/share/nvim/lazy/lualine.nvim
git clone https://github.com/rcarriga/nvim-notify ~/.local/share/nvim/lazy/nvim-notify
git clone https://github.com/folke/which-key.nvim ~/.local/share/nvim/lazy/which-key.nvim

# Launch Neovim (plugins will be installed automatically)
nvim
```

#### Windows

```powershell
# Backup your existing config (optional)
Rename-Item -Path $env:LOCALAPPDATA\nvim -NewName nvim.bak -Force -ErrorAction SilentlyContinue
Rename-Item -Path $env:LOCALAPPDATA\nvim-data -NewName nvim-data.bak -Force -ErrorAction SilentlyContinue

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git $env:LOCALAPPDATA\nvim

# Create plugin directories
New-Item -Path $env:LOCALAPPDATA\nvim-data\lazy -ItemType Directory -Force

# Install plugin manager (lazy.nvim)
git clone https://github.com/folke/lazy.nvim.git $env:LOCALAPPDATA\nvim-data\lazy\lazy.nvim

# Install critical plugins for ADHD-friendly theme
git clone https://github.com/folke/tokyonight.nvim $env:LOCALAPPDATA\nvim-data\lazy\tokyonight.nvim
git clone https://github.com/nvim-lualine/lualine.nvim $env:LOCALAPPDATA\nvim-data\lazy\lualine.nvim
git clone https://github.com/rcarriga/nvim-notify $env:LOCALAPPDATA\nvim-data\lazy\nvim-notify
git clone https://github.com/folke/which-key.nvim $env:LOCALAPPDATA\nvim-data\lazy\which-key.nvim

# Launch Neovim (plugins will be installed automatically)
nvim
```

### Standard Installation

If you're not experiencing plugin errors, you can use the regular installation method:

#### Prerequisites

##### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required dependencies
brew install neovim ripgrep fd node python3 git curl

# Install a Nerd Font (required for icons)
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font

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

# Install a more recent version of Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

# Install a Nerd Font (required for icons)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Fira Code Regular Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
fc-cache -f -v

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

# Install a Nerd Font (required for icons)
scoop bucket add nerd-fonts
scoop install FiraCode-NF

# Install Python provider
pip install pynvim

# Create Python virtual environment for Neovim
mkdir -p $HOME\.venvs\neovim
python -m venv $HOME\.venvs\neovim
$HOME\.venvs\neovim\Scripts\pip install pynvim
```

#### Setting Up the Configuration

1. **Backup your existing configuration** (if you have one):

   ```bash
   # macOS/Linux
   mv ~/.config/nvim ~/.config/nvim.bak
   
   # Windows (PowerShell)
   Rename-Item -Path $env:LOCALAPPDATA\nvim -NewName nvim.bak -Force -ErrorAction SilentlyContinue
   ```

2. **Clone this repository**:

   ```bash
   # macOS/Linux
   git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
   
   # Windows (PowerShell)
   git clone https://github.com/A6UD3L0/nvim-config.git $env:LOCALAPPDATA\nvim
   ```

3. **Start Neovim**:

   ```bash
   nvim
   ```

   On first start, all plugins will be installed automatically. This may take a few minutes.

4. **Install LSP Servers** (inside Neovim):

   ```vim
   :Mason
   ```

   Use the Mason UI to install any needed language servers (press `i` on a server to install):
   - `pyright` (Python)
   - `gopls` (Go)
   - `rust_analyzer` (Rust)
   - `tsserver` (TypeScript/JavaScript)
   - `lua_ls` (Lua)
   - `sqlls` (SQL)

## 🎨 ADHD-Friendly UI

This configuration includes a specially designed ADHD-friendly theme that:

- Uses calming blues and greens as primary colors
- Reserves energetic colors (yellow/orange) only for important elements
- Provides clear visual hierarchy to reduce distraction
- Features a muted background that's easy on the eyes for long coding sessions

To activate the ADHD-friendly theme:

```vim
:ApplyADHDTheme
```

The theme colors were selected based on research showing that for people with ADHD:
- Blues create a sense of peace and tranquility
- Greens have a calming effect and are associated with balance
- Muted browns are grounding and help maintain focus
- Strategic use of yellow/orange for only the most important elements helps direct attention where needed

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
- `<leader>dm` - Browse ML library documentation interactively
- `<leader>dmk` - Quick access to scikit-learn documentation
- `<leader>vr` - Run Python file with virtual environment
- `<leader>oi` - Install Poetry dependencies

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
