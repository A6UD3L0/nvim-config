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

## 🎨 Customization

### Changing Theme
Edit `lua/chadrc.lua` to change the theme:

```lua
M.ui = {
  theme = "catppuccin", -- Change to another theme
}
```

Available themes include: catppuccin, tokyonight, gruvbox, onedark, and more.

### Plugin Management
Use Lazy.nvim for managing plugins:

```
:Lazy check     # Check for updates
:Lazy update    # Update plugins
:Lazy sync      # Sync plugins (install/clean)
:Lazy profile   # View startup profile
```

## 🔄 Learning Resources

- Press `Space+Space` to explore available commands
- Use Leap for quick navigation (press `s` to activate)
- Try the more advanced LSP features like code actions
- Learn Git workflow with the dedicated Git keybindings

## 📋 Troubleshooting

### LSP Not Working
Run `:LspInfo` to check the status, then `:Mason` to install missing servers.

### Missing Dependencies
Run `:checkhealth` to see what dependencies need to be installed.

### Keybinding Conflicts
Check for conflicts with `:WhichKey`

---

*This configuration is maintained with ❤️ for backend developers who want power and simplicity.*
