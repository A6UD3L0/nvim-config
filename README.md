# Ultimate Backend Development Neovim Configuration

A powerful yet clean Neovim setup that combines ThePrimeagen's efficient functionality with NvChad's simplicity and aesthetics. Specifically optimized for backend development in Python, Go, C, SQL, and Docker.

![Neovim Backend IDE](https://user-images.githubusercontent.com/292349/213446185-5e0a886c-492e-46bb-9192-cb8afb439fb2.png)

## ✨ Key Features

- **Modern Development Environment**: Clean, efficient, and powerful setup
- **Backend Development Focus**: Full support for Python, Go, C, SQL, Docker
- **Super Fast Navigation**: Harpoon, Telescope, and Leap for quick file and code navigation
- **Git Integration**: Enhanced Git workflow with Fugitive and Gitsigns
- **Beautiful UI**: Modern Catppuccin theme with customized highlights
- **AI Code Completion**: GitHub Copilot integration
- **Keybinding Discovery**: Press `Space+Space` to explore all commands
- **Advanced Debugging**: Comprehensive DAP setup for all major backend languages
- **Data Science Support**: R language integration and database clients

## 🚀 Quick Start

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

## 📂 Configuration Structure

```
nvim-config/
├── init.lua                    # Main entry point
├── lua/
│   ├── core/                   # Core neovim settings
│   ├── plugins/                # Plugin definitions and configs
│   │   ├── dev_tools.lua       # Development tools (LSP, DAP, etc.)
│   │   ├── completion.lua      # Completion setup
│   │   ├── ui.lua              # UI enhancements
│   │   └── which-key.lua       # Keybinding management
│   └── configs/                # Plugin configurations
│       ├── dap.lua             # Debug adapter setup
│       ├── dapui.lua           # Debug UI configuration
│       ├── lspconfig.lua       # Language server setup
│       └── init.lua            # Configuration initialization
```

## 🛠️ Development Features

### Language Support

- **Python**: Pyright LSP, debugging with DAP, formatting with Black/isort
- **Go**: Gopls integration, debugging with Delve, formatting with gofumpt
- **C/C++**: Clangd support with LLDB debugging
- **SQL**: SQL Language Server with database client
- **Docker**: Docker Language Server

### Key Tools

- **Telescope**: Fuzzy finding for files, code, and more
- **Treesitter**: Advanced syntax highlighting
- **LSP**: Full language server integration
- **GitHub Copilot**: AI code completion
- **Debugging**: Language-specific DAP configurations
- **Git**: Complete git workflow

## ⌨️ Essential Keybindings

### Navigation
| Keybinding | Description |
|------------|-------------|
| `<Space>f` | Find files and more |
| `<Space>g` | Git operations |
| `<Space>l` | LSP operations |
| `<Space>d` | Debug operations |
| `<Space>t` | Terminal/Toggle features |

### Development
| Keybinding | Description |
|------------|-------------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show documentation |
| `<Space>ca` | Code actions |
| `<Space>rn` | Rename symbol |

### Git
| Keybinding | Description |
|------------|-------------|
| `<Space>gg` | Git status |
| `<Space>gb` | Git blame |
| `<Space>gd` | Git diff |
| `<Space>gc` | Git commit |

## 🔧 Post-Installation

After installation:
1. Run `:MasonInstallAll` to set up language servers and tools
2. Configure your preferred language servers in `lua/configs/lspconfig.lua`
3. Customize keybindings in `lua/plugins/which-key.lua`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

# Neovim Configuration Learning Game

An interactive Python game that helps you learn your Neovim configuration and keybindings.

## Features

- Quiz Mode: Test your knowledge of Neovim keybindings
- Practice Mode: Learn keybindings by category
- Colorful interface for better visibility
- Covers all major keybinding categories from your configuration

## Installation

1. Make sure you have Python 3 installed
2. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## How to Play

1. Run the game:
   ```bash
   python nvim_config_game.py
   ```

2. Choose a game mode:
   - Quiz Mode: Test your knowledge with random questions
   - Practice Mode: Learn keybindings by category
   - Exit: Quit the game

3. In Quiz Mode:
   - Choose how many questions you want (1-20)
   - Answer questions about keybindings
   - Get immediate feedback on your answers
   - See your final score

4. In Practice Mode:
   - Choose a category to practice
   - View all keybindings in that category
   - Study at your own pace

## Categories

The game covers the following keybinding categories:

- Find: File and buffer navigation
- Debug: Debugging commands
- Git: Version control operations
- Harpoon: File marking and navigation
- Window: Window management
- LSP: Language Server Protocol commands
- Comment: Code commenting

## Contributing

Feel free to add more keybindings or features to the game. The code is structured to make it easy to add new categories or modify existing ones.
