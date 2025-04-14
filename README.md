# Backend Development Neovim Configuration

A streamlined Neovim configuration focused specifically on backend development and data science. This configuration combines ThePrimeagen's keybindings with NvChad's simplicity to create an efficient development environment.

## Features

- **Elegant Rose Pine Theme** - Beautiful and easy on the eyes with transparent backgrounds
- **Enhanced Command-Line UI** - Fuzzy search, icons, and modern look with wilder.nvim
- **Advanced Python Development Tools**:
  - Poetry integration for package management
  - Virtual environment handling with smart detection
  - Requirements.txt installation shortcuts
  - Python debugging and testing
- **Comprehensive Backend Support**:
  - Go, Rust, TypeScript, SQL, Docker, and more
  - LSP integration for all major backend languages
  - Intelligent code completion with nvim-cmp
- **Intuitive Interface**:
  - Which-key integration showing all commands
  - Elegant statusline with file information
  - Clear visual indicators for Git changes
- **Efficient Workflow**:
  - All essential ThePrimeagen keymaps
  - Terminal integration with toggleterm
  - Git integration with fugitive, diffview, and gitsigns

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
# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -
```

#### Linux
- Your distribution's package manager (apt, pacman, dnf, etc.)
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install neovim ripgrep fd-find nodejs npm golang python3 python3-pip
# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -

# Arch Linux
sudo pacman -S neovim ripgrep fd nodejs npm go python python-pip
# For Poetry integration (optional but recommended)
curl -sSL https://install.python-poetry.org | python3 -
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

# Start Neovim - plugins will be installed automatically
nvim
```

### macOS and Linux

```bash
# Backup existing configuration
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Clone the repository
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

## Key Features and Usage

### Python Development Tools

#### Poetry Integration

| Keybind | Description |
|---------|-------------|
| `<leader>pi` | Install packages from requirements.txt |
| `<leader>pp` | Poetry package management menu |
| `<leader>ppa` | Add a package with Poetry |
| `<leader>ppr` | Remove a package with Poetry |
| `<leader>ppu` | Update all packages with Poetry |
| `<leader>ppo` | Show outdated packages with Poetry |
| `<leader>ppn` | Create a new Poetry project |
| `<leader>ppi` | Install dependencies with Poetry |
| `<leader>ppb` | Build package with Poetry |
| `<leader>pps` | Start Poetry shell |
| `<leader>ppe` | Edit pyproject.toml |

#### Virtual Environment Management

| Keybind | Description |
|---------|-------------|
| `<leader>cv` | Activate .venv in current project |
| `<leader>ca` | Activate any venv by name |
| `<leader>pv` | Select a venv using venv-selector |
| `<leader>vd` | Run Python environment diagnostics |
| `<leader>vt` | Test current virtualenv |

#### Python Coding and Execution

| Keybind | Description |
|---------|-------------|
| `<leader>pr` | Run Python file with arguments |
| `<leader>tr` | Run current Python file |
| `<leader>pe` | Execute selected Python code |
| `<leader>pn` | Create new Python file with template |

### Command Line Enhancements

The command-line interface has been enhanced with wilder.nvim for a more intuitive experience:

- **Fuzzy Search**: Type part of a command to see matching options
- **Visual Indicators**: Icons show the type of each completion item
- **Beautiful Design**: Rose Pine-themed interface with rounded corners
- **Navigation**: Use Tab/Shift+Tab to navigate completions

### Advanced Terminal Integration

| Keybind | Description |
|---------|-------------|
| `<C-t>` | Toggle terminal |
| `<leader>tp` | Open Python REPL |
| `<leader>ti` | Open IPython with matplotlib support |
| `<Esc>` or `jk` | Exit terminal mode |

### Git Integration

| Keybind | Description |
|---------|-------------|
| `<leader>gs` | Git status (Fugitive) |
| `<leader>gc` | Git commit |
| `<leader>gd` | Git diff |
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log |
| `<leader>gp` | Git push |

### File Navigation

| Keybind | Description |
|---------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Browse buffers |
| `<leader>fh` | Help tags |
| `<leader>e` | Toggle file explorer |

## Plugin List

This configuration includes carefully selected plugins for backend development:

### Core
- **lazy.nvim** - Plugin manager
- **rose-pine** - Beautiful theme optimized for long coding sessions
- **nvim-treesitter** - Advanced syntax highlighting and code understanding
- **lualine.nvim** - Elegant statusline

### LSP and Completion
- **nvim-lspconfig** - Easy LSP configuration
- **mason.nvim** - LSP installer
- **nvim-cmp** - Completion engine
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Pre-configured snippets

### Python Specific
- **venv-selector.nvim** - Python virtual environment management
- **nvim-dap-python** - Python debugging
- **Python REPL integration** - Run Python code from within Neovim
- **Poetry integration** - Package management for Python

### File Navigation
- **telescope.nvim** - Fuzzy finder
- **nvim-tree.lua** - File explorer
- **harpoon** - File bookmarking

### Terminal and Command Line
- **toggleterm.nvim** - Terminal integration
- **wilder.nvim** - Enhanced command-line UI

### Git Integration
- **vim-fugitive** - Git commands
- **gitsigns.nvim** - Git change indicators
- **diffview.nvim** - Git diff viewer

## Customization

### Modifying Keybindings

Edit `lua/mappings.lua` to change keybindings:

```lua
-- Example: Change the terminal toggle key from <C-t> to <C-y>
map("n", "<C-y>", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal" })
```

### Adding New Plugins

Edit files in the `lua/plugins/` directory to add or modify plugins:

```lua
-- Example: Add a new plugin
return {
  {
    "plugin-author/plugin-name",
    config = function()
      -- Configuration here
    end
  }
}
```

## Troubleshooting

### Common Issues on Windows
- If you encounter font issues, make sure you have a Nerd Font properly installed and configured
- For WSL, ensure interop is enabled between Windows and WSL
- If LSP servers fail to install, try running Neovim with administrator privileges once

### Python Environment Issues
- Run `:VenvDiagnostics` to identify Python environment issues
- Ensure pynvim is installed: `pip install pynvim`
- If using Poetry, make sure Poetry is in your PATH

### Plugin Installation Problems
- If plugins fail to install, try running `:Lazy sync`
- Check your internet connection
- Ensure git is properly configured

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by ThePrimeagen's init.lua and NvChad
- Thanks to all the plugin authors for their amazing work
