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
  - Unified keybinding system with logical namespaces
  - File navigation with Telescope fuzzy finder
  - Undotree for change history visualization

## 📋 System Requirements

### Essential Requirements (All Platforms)
- Neovim 0.9.0 or later
- Git
- Node.js 14+ and npm (for LSP servers)
- Python 3.8+ with pip
- A Nerd Font installed and configured in your terminal
- Ripgrep and fd for Telescope fuzzy finding

### Platform-Specific Requirements

#### Windows
- Windows Terminal, Alacritty, or other modern terminal
- PowerShell 7+ recommended
- Git for Windows
- Windows Subsystem for Linux (WSL2) recommended for best experience
- Scoop or Chocolatey package managers (recommended)

#### macOS
- Homebrew package manager
- iTerm2 or Terminal.app
- macOS Catalina (10.15) or newer

#### Linux
- Modern terminal emulator (Alacritty, Kitty, GNOME Terminal, etc.)
- Your distribution's package manager (apt, pacman, dnf)
- X11 or Wayland display server

## 🧹 Cleaning Previous Neovim Installations

Before installing this configuration, it's recommended to clean up any existing Neovim setup to prevent conflicts.

### Windows Cleanup

```powershell
# Stop any running Neovim instances
taskkill /F /IM nvim.exe /T

# Remove Neovim configuration
Remove-Item -Recurse -Force ~\AppData\Local\nvim -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~\AppData\Local\nvim-data -ErrorAction SilentlyContinue

# Clear plugin managers if used previously
Remove-Item -Recurse -Force ~\.vim -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~\vimfiles -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~\.local\share\nvim -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~\AppData\Local\nvim-data -ErrorAction SilentlyContinue

# Clear cache and state
Remove-Item -Recurse -Force ~\.cache\nvim -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~\AppData\Local\State\nvim -ErrorAction SilentlyContinue
```

### macOS/Linux Cleanup

```bash
# Stop any running Neovim instances
pkill -f nvim

# Remove Neovim configuration
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Clear plugin managers if used previously
rm -rf ~/.vim
rm -rf ~/.local/share/nvim/site
rm -rf ~/.local/share/nvim/lazy

# Clear packer compiled files if used
rm -rf ~/.local/share/nvim/site/pack
rm -rf ~/.cache/nvim/packer*

# Clear Mason packages if used
rm -rf ~/.local/share/nvim/mason

# LSP logs and cache
rm -rf ~/.local/state/nvim
rm -f ~/.cache/nvim/lsp.log
```

## 💻 Installation Instructions

### Windows Installation

#### Option 1: PowerShell (Recommended)

```powershell
# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git $env:LOCALAPPDATA\nvim

# Install dependencies using Scoop
scoop install neovim gcc ripgrep fd nodejs python
pip install pynvim

# If using WSL
wsl --install
wsl --update

# Start Neovim - plugins will be installed automatically
nvim
```

#### Option 2: Windows with WSL

```bash
# In WSL terminal
sudo apt update && sudo apt install -y neovim ripgrep fd-find nodejs npm python3 python3-pip
pip3 install pynvim

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

### macOS Installation

```bash
# Install required dependencies
brew install neovim ripgrep fd node go python
pip3 install pynvim

# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

### Linux Installation

#### Ubuntu/Debian

```bash
# Install required dependencies
sudo apt update
sudo apt install -y neovim ripgrep fd-find nodejs npm golang python3 python3-pip
pip3 install pynvim

# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

#### Arch Linux

```bash
# Install required dependencies
sudo pacman -S neovim ripgrep fd nodejs npm go python python-pip
pip install pynvim

# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

## ⌨️ Keybinding Reference

All keybindings are organized in namespaces with a consistent structure for easy memorization.

### Namespace Structure

| Prefix            | Category                                   |
|-------------------|------------------------------------------- |
| `<leader>b`       | Buffer operations                          |
| `<leader>c`       | Code actions (LSP related)                 |
| `<leader>cd`      | Change directory operations                |
| `<leader>d`       | Debug operations                           |
| `<leader>e`       | File explorer operations                   |
| `<leader>f`       | Find/Files operations (Telescope)          |
| `<leader>g`       | Git operations                             |
| `<leader>h`       | Harpoon operations                         |
| `<leader>l`       | LSP operations                             |
| `<leader>o`       | Poetry operations                          |
| `<leader>r`       | Requirements.txt operations                |
| `<leader>t`       | Terminal operations                        |
| `<leader>u`       | Undotree operations                        |
| `<leader>v`       | Virtual environment operations             |
| `<leader>w`       | Window operations                          |
| `<leader>y`       | Python operations                          |

### Terminal Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>tp`      | Toggle Python REPL                         |
| `<leader>ti`      | Toggle IPython with matplotlib support     |
| `<leader>tt`      | Toggle floating terminal                   |
| `<leader>th`      | Toggle horizontal terminal                 |
| `<leader>tv`      | Toggle vertical terminal                   |
| `<Esc>` or `jk`   | Exit terminal mode                         |

### Python Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>yr`      | Run current Python file                    |
| `<leader>ye`      | Execute selected Python code (visual mode) |
| `<leader>yi`      | Execute selected code in IPython           |
| `<leader>yt`      | Run Python tests with Telescope            |
| `<leader>yn`      | Create new Python file with boilerplate    |

### Virtual Environment Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>vs`      | Select Python virtual environment          |
| `<leader>vc`      | Select cached virtual environment          |
| `<leader>vd`      | Run virtual environment diagnostics        |
| `<leader>vt`      | Test current virtual environment           |

### File Operations (Telescope)

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>ff`      | Find files                                 |
| `<leader>fg`      | Find text in files (live grep)             |
| `<leader>fb`      | Find open buffers                          |
| `<leader>fh`      | Find help tags                             |
| `<leader>fr`      | Find recent files                          |
| `<leader>fm`      | Find marks                                 |
| `<leader>fs`      | Save current file                          |
| `<leader>fS`      | Save all files                             |

### File Explorer Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>e`       | Toggle file explorer                       |
| `<leader>ef`      | Focus file explorer                        |

### Window Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>wv`      | Split window vertically                    |
| `<leader>wh`      | Split window horizontally                  |
| `<leader>we`      | Make splits equal size                     |
| `<leader>wx`      | Close current split                        |
| `<leader>wq`      | Quit window                                |
| `<leader>wQ`      | Quit all windows                           |
| `<leader>wL`      | Increase window width                      |
| `<leader>wH`      | Decrease window width                      |
| `<leader>wK`      | Increase window height                     |
| `<leader>wJ`      | Decrease window height                     |

### Git Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>gs`      | Stage hunk                                 |
| `<leader>gr`      | Reset hunk                                 |
| `<leader>gS`      | Stage buffer                               |
| `<leader>gu`      | Undo stage hunk                            |
| `<leader>gR`      | Reset buffer                               |
| `<leader>gp`      | Preview hunk                               |
| `<leader>gb`      | Blame line                                 |
| `]c`              | Next hunk                                  |
| `[c`              | Previous hunk                              |

### LSP Operations

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>lf`      | Format buffer                              |
| `<leader>lr`      | Rename symbol                              |
| `<leader>la`      | Code action                                |
| `<leader>ld`      | Go to definition                           |
| `<leader>lD`      | Go to declaration                          |
| `<leader>li`      | Go to implementation                       |
| `<leader>lt`      | Go to type definition                      |
| `<leader>lh`      | Hover documentation                        |
| `<leader>ls`      | Signature help                             |
| `<leader>lR`      | Find references                            |

### Undotree

| Keybinding        | Action                                     |
|-------------------|------------------------------------------- |
| `<leader>u`       | Toggle Undotree                            |

## 🔧 Configuration Structure

The configuration is organized into modular files for easier maintenance:

```
📁 nvim-config/
├── 📁 lua/                     # Lua configuration files
│   ├── 📁 plugins/            # Plugin configurations
│   │   └── 📄 backend-essentials.lua  # Core plugins
│   ├── 📄 dashboard.lua       # Alpha dashboard setup
│   ├── 📄 init.lua            # Main initialization
│   ├── 📄 mappings.lua        # All keybindings in one place
│   └── 📄 venv_diagnostics.lua # Python venv utilities
├── 📁 plugin/                  # Autoload folder
├── 📄 init.lua                 # Entry point
└── 📄 README.md                # Documentation
```

## 🔄 Updating the Configuration

To update to the latest version:

```bash
# Navigate to your config directory
cd ~/.config/nvim    # Linux/macOS
cd $env:LOCALAPPDATA\nvim    # Windows

# Pull the latest changes
git pull

# Start Neovim to install any new plugins
nvim
```

## 🛠️ Troubleshooting

### Common Issues

**Issue**: Plugins fail to install
**Solution**: 
```bash
# Remove plugin directories and reinstall
rm -rf ~/.local/share/nvim/lazy/
# Or on Windows
Remove-Item -Recurse -Force ~\AppData\Local\nvim-data\lazy
# Then restart Neovim
```

**Issue**: Missing icons or broken UI
**Solution**: Make sure you have a Nerd Font installed and configured in your terminal

**Issue**: LSP not working for a specific language
**Solution**: 
```bash
# Inside Neovim
:LspInfo          # Check if LSP is attached
:Mason            # Install missing language servers
```

**Issue**: Telescope not finding files
**Solution**: Make sure ripgrep and fd are installed and in your PATH

**Issue**: Virtual environment detection not working
**Solution**: Run the virtual environment diagnostics
```
# Inside Neovim
<leader>vd        # Run virtual environment diagnostics
```

## 📝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- [ThePrimeagen](https://github.com/ThePrimeagen/init.lua) for the keybinding inspiration
- [NvChad](https://github.com/NvChad/NvChad) for UI simplicity concepts
- [Neovim](https://neovim.io/) team for the incredible editor
- All plugin authors who made this configuration possible
