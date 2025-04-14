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
| `<leader>t`  | Terminal operations                         |
| `<leader>u`  | Utilities (undotree, helpers)               |
| `<leader>v`  | Virtual environment (Python venv)           |
| `<leader>w`  | Window operations                           |
| `<leader>x`  | Execute code (run scripts, REPL)            |
| `<leader>z`  | Zen/Focus mode                              |

## 🔧 Installation

### Prerequisites

```bash
# Install required dependencies
# On macOS
brew install neovim ripgrep fd nodejs python3

# On Ubuntu/Debian
sudo apt install neovim ripgrep fd-find nodejs python3 python3-pip

# Install Python provider for Neovim
pip3 install pynvim
```

### Setup

1. Clone this repository to your Neovim config directory:

```bash
# Backup your existing config if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
```

2. Launch Neovim and let it install plugins:

```bash
nvim
```

The plugin manager will automatically install all plugins on first launch.

3. Install language servers:

```
# Inside Neovim
:MasonInstall pyright gopls typescript-language-server lua-language-server
```

## 🧠 Recent Updates

- Implemented MECE-compliant keybinding structure throughout the entire configuration
- Fixed directory search functionality for better project navigation
- Enhanced Telescope integration with improved filtering
- Fixed issues with Telescope devdocs extension and wilder.nvim
- Centralized all keybindings in mappings.lua for better organization
- Added GitHub Copilot integration for AI-assisted coding

## 🌟 Credits

This configuration draws inspiration from:
- ThePrimeagen's Neovim setup
- NvChad's simplicity and speed
- TJ DeVries' Neovim tutorials

## 📄 License

MIT
