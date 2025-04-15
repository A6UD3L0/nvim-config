# Ultimate Backend Development Neovim Configuration

A comprehensive Neovim configuration optimized for backend development and data science. This configuration combines ThePrimeagen's powerful keybindings with NvChad's simplicity to create the ultimate IDE experience for Python, Go, Rust, TypeScript, SQL, and more.

## ✨ Features

- **Streamlined Interface**
  - Custom color theme with focus-enhancing color palette
  - Distraction-free coding environment
  - Visual noise reduction with strategic syntax highlighting
  - Fallback to Tokyonight theme for reliability

- **Powerful LSP Integration**
  - Autocompletion via nvim-cmp
  - Diagnostics and code actions
  - Go-to-definition, references, and more
  - Signature help as you type

- **Deep Backend Language Support**
  - Python with environments, virtual env management
  - Go support with gopls
  - Rust support with rust-analyzer
  - C/C++ support
  - SQL language support
  - Docker files and compose

- **Lightning-Fast Navigation**
  - Telescope fuzzy finder
  - Harpoon for quick file jumping
  - NvimTree file explorer

- **Effective Git Integration**
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

## 🚀 Installation

### 1. Clean Old Neovim Configurations (Recommended)

To ensure a fresh start, remove or back up any previous Neovim configuration. **This will delete your old config!**

```bash
mv ~/.config/nvim ~/.config/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
```

### 2. Clone the Configuration

```bash
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
```

### 3. Launch Neovim and Install Plugins

Open Neovim (the first launch will install plugins):
```bash
nvim
```

Then, in Neovim, run:
```
:Lazy sync
```
Wait for all plugins to finish installing, then restart Neovim.

### 4. Verify Setup

Check for errors and missing dependencies:
```
:checkhealth
```

If you see any issues, follow the suggestions or install missing system dependencies as needed.

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
| `<leader>t`  | Terminal operations                         |
| `<leader>u`  | Utilities (undotree, helpers)               |
| `<leader>w`  | Window/Tab operations                       |
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

## 📦 Essential Plugins

This configuration includes carefully selected plugins for backend development:

### Core Plugins
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin manager
- **[nvim-lualine](https://github.com/nvim-lualine/lualine.nvim)** - Statusline
- **[nvim-notify](https://github.com/rcarriga/nvim-notify)** - Notification manager
- **[which-key](https://github.com/folke/which-key.nvim)** - Keybinding helper
- **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** - Fallback theme

### Language Support
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configuration
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - LSP/DAP/Linter manager
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion
- **[null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)** - Diagnostics and formatting

### Navigation
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)** - File explorer
- **[harpoon](https://github.com/ThePrimeagen/harpoon)** - File navigation

### Git Integration
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git indicators
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** - Git interface

## 🔧 Troubleshooting

### Common Issues and Fixes

1. **Invalid Plugin Specs**
   If you see errors like these:
   ```
   Invalid plugin spec { colors = {...}, setup = <function> }
   Invalid plugin spec { log = {}, logfile = "...", setup = <function> }
   Invalid plugin spec { config = <function>, name = "lualine_config" }
   Invalid plugin spec { config = <function>, name = "notify_config" }
   ```
   
   This happens because some utility modules are being loaded as plugins. The fix is easy:
   
   ```bash
   # Navigate to your config
   cd ~/.config/nvim
   
   # Make the fix script executable
   chmod +x fix_plugins.sh
   
   # Run the script
   ./fix_plugins.sh
   ```
   
   This script will:
   - Move utility modules out of the plugins directory
   - Create proper plugin specifications
   - Install required plugins
   - Set up the configuration correctly

2. **Module Not Found Errors**
   If you see errors like:
   ```
   module 'nvim-notify' not found
   ```
   
   Run these commands inside Neovim:
   ```
   :Lazy sync
   :checkhealth
   ```
   
   If that doesn't fix it, run the fix_plugins.sh script as described above.

3. **Theme Not Applied**
   If your Tokyonight theme isn't loading, manually apply it:
   ```
   :colorscheme tokyonight
   ```
   
   To make it load automatically, add this to your init.lua:
   ```lua
   vim.api.nvim_create_autocmd("VimEnter", {
     callback = function()
       vim.cmd("colorscheme tokyonight")
     end
   })
   ```

### Complete Reset and Installation

If you're still experiencing issues, here's a complete reset and installation procedure:

```bash
# Step 1: Clean all Neovim files
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Step 2: Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Step 3: Run the fix_plugins script
cd ~/.config/nvim
chmod +x fix_plugins.sh
./fix_plugins.sh

# Step 4: Start Neovim
nvim

# Step 5: Inside Neovim, run:
# :Lazy sync
# :checkhealth
```

This procedure ensures all plugins are properly installed and configured.

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

## 🎨 UI/UX

This configuration includes a clean, modern UI with the Tokyonight theme:

- Uses a balanced, easy-on-the-eyes color palette
- Provides clear visual hierarchy to reduce distraction
- Features a professional looking interface for long coding sessions
- Ensures excellent readability for code and documentation

The Tokyonight theme provides several variants (night, storm, day, and moon) which can be 
configured in the `lua/plugins/ui.lua` file.

## 🙏 Acknowledgements

This configuration draws inspiration from:
- ThePrimeagen's Neovim configuration
- NvChad's simplicity and speed
- TJ DeVries' Neovim tutorials

## 📄 License

MIT
