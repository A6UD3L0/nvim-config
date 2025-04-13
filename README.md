# Ultimate Backend Development Neovim Configuration

A powerful yet clean Neovim setup that combines ThePrimeagen's efficient functionality with NvChad's simplicity and aesthetics. Specifically optimized for backend development in Python, Go, C, SQL, and Docker.

![Neovim Backend IDE](https://user-images.githubusercontent.com/292349/213446185-5e0a886c-492e-46bb-9192-cb8afb439fb2.png)

## ✨ Key Features

- **ThePrimeagen + NvChad Philosophy**: Powerful features with a clean, accessible interface
- **Backend Development Focus**: Full support for Python, Go, C, SQL, Docker, and more
- **Super Fast Navigation**: Harpoon, Telescope, and Leap for quick file and code navigation
- **Git Mastery**: Enhanced Git integration with Fugitive and Gitsigns
- **Beautiful UI**: Modern Catppuccin theme with customized highlights
- **AI Code Completion**: GitHub Copilot integration for intelligent coding assistance
- **Keybinding Discovery**: Press `Space+Space` to explore all available commands
- **Advanced Debugging**: Comprehensive DAP setup for all major backend languages

## 🚀 Getting Started

### Prerequisites

- Neovim 0.9.0 or later
- Git
- A Nerd Font (recommended: JetBrainsMono Nerd Font)
- Node.js and npm (for LSP features)
- Python 3.6+ with pip
- Ripgrep for telescope fuzzy finding

### Installation

```bash
# Back up existing configuration if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim

# Start Neovim to install plugins
nvim
```

On first launch:
1. Plugins will be automatically installed
2. Run `:MasonInstallAll` to set up language servers and tools
3. Press `Space+Space` to explore keybindings

## 📋 Comprehensive Installation Guide

### Step 1: Uninstall Previous Neovim Configuration

Before installing this configuration, it's best to remove or backup your existing setup:

#### For macOS/Linux:

```bash
# Stop any running Neovim instances
pkill -f nvim

# Backup your existing Neovim config
mv ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d)

# Backup Neovim state and cache directories
mv ~/.local/share/nvim ~/.local/share/nvim.bak.$(date +%Y%m%d)
mv ~/.local/state/nvim ~/.local/state/nvim.bak.$(date +%Y%m%d)
mv ~/.cache/nvim ~/.cache/nvim.bak.$(date +%Y%m%d)
```

#### For Windows:

```powershell
# Backup your existing Neovim config
Rename-Item -Path $env:LOCALAPPDATA\nvim -NewName $env:LOCALAPPDATA\nvim.bak.$(Get-Date -Format "yyyyMMdd")

# Backup Neovim state and cache directories
Rename-Item -Path $env:LOCALAPPDATA\nvim-data -NewName $env:LOCALAPPDATA\nvim-data.bak.$(Get-Date -Format "yyyyMMdd")
```

### Step 2: Install Required Dependencies

#### Font Installation:

1. Download [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
2. Install it on your system
3. Configure your terminal to use the font

#### For macOS:

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install neovim ripgrep fd node python
pip3 install pynvim

# Optional tools for enhanced functionality
brew install lazygit fzf bat
```

#### For Ubuntu/Debian:

```bash
# Update package lists
sudo apt update

# Install required packages
sudo apt install -y git curl unzip
sudo apt install -y python3 python3-pip nodejs npm
pip3 install pynvim

# Install Ripgrep and fd-find
sudo apt install -y ripgrep fd-find

# Install Neovim (latest version)
# Check https://github.com/neovim/neovim/releases for the latest version
wget https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
sudo cp -r nvim-linux64/* /usr/local/
```

#### For Arch Linux:

```bash
sudo pacman -S neovim git ripgrep fd nodejs npm python python-pip
pip install pynvim
```

### Step 3: Clone This Repository

```bash
# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim
```

### Step 4: GitHub Copilot Setup (Optional)

If you want to use GitHub Copilot:

1. Make sure you have a GitHub account with Copilot access
2. Start Neovim and run `:Copilot setup`
3. Follow the authentication instructions

### Step 5: First Launch and Plugin Installation

```bash
# Start Neovim
nvim
```

On first launch:
1. Plugins will be automatically installed with Lazy.nvim
2. Wait for the installation to complete (this may take a few minutes)
3. Run `:MasonInstallAll` to set up language servers and tools
4. Restart Neovim to activate all features

## ⌨️ Essential Keybindings

### Navigation
| Keybinding | Description |
|------------|-------------|
| `Space+Space` | Show all keybindings |
| `jk` | Exit insert mode |
| `;` | Enter command mode |
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-d>/<C-u>` | Half-page down/up (centered) |

### Files & Search
| Keybinding | Description |
|------------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Find text in files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Browse buffers |
| `<leader>fc` | Find in current buffer |
| `<leader>fB` | File browser |

### Code Navigation & LSP
| Keybinding | Description |
|------------|-------------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format code |
| `<leader>D` | Type definition |

### Git
| Keybinding | Description |
|------------|-------------|
| `<leader>gs` | Git status |
| `<leader>gb` | Git blame |
| `<leader>gd` | Git diff |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gc` | Git commit |

### Harpoon
| Keybinding | Description |
|------------|-------------|
| `<leader>ha` | Add file to Harpoon |
| `<leader>hh` | Harpoon menu |
| `<C-h/j/k/l>` | Jump to Harpoon marks 1-4 |

### Debugging (DAP)
| Keybinding | Description |
|------------|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start/continue debugging |
| `<leader>dt` | Toggle debugging UI |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |

### Language-Specific
| Keybinding | Description |
|------------|-------------|
| `<leader>pt` | Run pytest on current file |
| `<leader>pT` | Run Python file |
| `<leader>gr` | Run Go file |
| `<leader>gt` | Run Go tests |
| `<leader>dc` | Docker-compose up |
| `<leader>dd` | Docker-compose down |

## 🛠️ Backend Development Tools

### Python
- Complete LSP support via Pyright and Jedi
- Advanced linting with Ruff
- Integrated test running with Pytest
- Virtual environment management
- Debugging with DAP and debugpy

### Go
- Full LSP support with gopls
- Code formatting with gofumpt
- Quick test running
- Debug integration with Delve

### SQL
- SQL language server for completion
- Formatting and linting
- Database connections (with external tools)

### Docker
- Dockerfile and docker-compose syntax
- Integrated container management commands
- YAML validation for configuration files

### Git
- Beautiful diff view
- Blame integration
- Commit staging and navigation
- Branch management

## 🧑‍💻 Plugin List & Features

This configuration includes carefully selected plugins for the optimal backend development experience:

### Core Features
- **lazy.nvim**: Modern plugin manager with lazy-loading
- **which-key.nvim**: Keybinding discovery and management
- **telescope.nvim**: Fuzzy finder for files, code, and more
- **nvim-tree.lua**: File explorer
- **bufferline.nvim**: Buffer and tab management
- **lualine.nvim**: Status line
- **catppuccin.nvim**: Beautiful theme with syntax highlighting

### Code Intelligence
- **nvim-lspconfig**: Configuration for Language Server Protocol
- **mason.nvim**: Language server and tool manager
- **nvim-cmp**: Completion engine with LSP integration
- **LuaSnip**: Snippet engine for faster coding
- **nvim-treesitter**: Advanced syntax highlighting and code parsing

### Git Integration
- **gitsigns.nvim**: Show git diff in the sign column
- **vim-fugitive**: Full git integration within Neovim

### Editing Enhancements
- **nvim-autopairs**: Auto-close brackets and quotes
- **Comment.nvim**: Easy code commenting
- **nvim-surround**: Manage surrounding pairs
- **undotree**: Visual history browser
- **conform.nvim**: Formatter

### Navigation
- **harpoon**: Quick file marking and navigation
- **leap.nvim**: Fast motion within the buffer

### Debugging
- **nvim-dap**: Debug Adapter Protocol support
- **nvim-dap-ui**: UI for debugging
- **nvim-dap-python**: Python debugging integration

### AI Assistance
- **copilot.lua**: GitHub Copilot integration
- **copilot-cmp**: Copilot completion source for nvim-cmp

## 🔧 Troubleshooting

### Health Check

Run `:checkhealth` to diagnose issues with your setup. This will help identify missing dependencies or misconfigurations.

### Common Issues

1. **Plugins failing to load**: 
   - Run `:Lazy sync` to reinstall plugins
   - Check external dependencies like ripgrep, node.js

2. **LSP not working**:
   - Run `:LspInfo` to see the status
   - Run `:Mason` to install missing language servers
   - Check language server logs with `:LspLog`

3. **Copilot not connecting**:
   - Ensure your GitHub account has Copilot access
   - Run `:Copilot status` to check connection status

4. **Font icons missing**:
   - Make sure you've installed and configured a Nerd Font

5. **Performance issues**:
   - Run `:Lazy profile` to identify slow plugins
   - Consider disabling heavy plugins you don't use

### Resetting Configuration

If things go wrong and you need to start fresh:

```bash
# Remove the configuration directory
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Then reinstall following the installation steps above
```

## 🔧 Recent Fixes

### April 2025 Updates

- **Fixed Telescope Error**: Resolved issue with invalid 'User TelescopeFindPre' event that was causing Telescope to crash when trying to use file finding features
- **Updated Which-Key Configuration**: Replaced deprecated 'window' option with modern 'win' option in the which-key setup to fix health check warnings
- **Improved Overall Stability**: Addressed several minor issues detected in the Neovim health check to ensure smoother operation

To apply these fixes:
1. Pull the latest changes from the repository
2. Restart Neovim
3. Run `:checkhealth` to verify the fixes

## 🎨 Customization

### Changing Theme
Edit `lua/chadrc.lua` to change the theme:

```lua
M.ui = {
  theme = "catppuccin", -- Change to another theme
}
```

Available themes include: catppuccin, tokyonight, gruvbox, onedark, and more.

### Adding Custom Plugins

To add your own plugins, create or edit `lua/plugins/custom.lua`:

```lua
return {
  -- Add new plugins here
  {
    "username/plugin-name",
    config = function()
      -- Your plugin configuration
    end,
  },
}
```

Then add it to the import list in `init.lua`:

```lua
require("lazy").setup({
  -- Other imports
  { import = "plugins.custom" },
}, lazy_config)
```

### Customizing Keybindings

Edit `lua/mappings.lua` to change keybindings:

```lua
wk.register({
  mode = { "n", "v" },
  -- Add or modify keybindings
  { "your-key", "your-command", desc = "Your description" },
}, { prefix = "<leader>" })
```

## 🔄 Updating

To update the configuration and plugins:

```bash
# Update the configuration
cd ~/.config/nvim
git pull

# Update plugins
nvim -c "Lazy sync"
```

## 🎓 Learning Resources

- **Neovim Documentation**: `:help nvim`
- **Plugin Documentation**: `:help [plugin-name]`
- **Integrated Learning**: Press `Space+Space` to explore keybindings
- **GitHub Repository**: Check for new updates and features

---

*This configuration is maintained with ❤️ for backend developers who want power and simplicity.*
