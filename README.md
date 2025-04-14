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

## Plugin Documentation

### Harpoon - Quick File Navigation

Harpoon provides lightning-fast navigation between your most frequently used files.

| Keybind | Description |
|---------|-------------|
| `<leader>ha` | Add current file to harpoon |
| `<leader>hh` | Toggle harpoon quick menu |
| `<leader>h1` | Navigate to harpoon file 1 |
| `<leader>h2` | Navigate to harpoon file 2 |
| `<leader>h3` | Navigate to harpoon file 3 |
| `<leader>h4` | Navigate to harpoon file 4 |
| `<leader>hp` | Navigate to previous harpoon mark |
| `<leader>hn` | Navigate to next harpoon mark |

**Usage Tips:**
- Mark your most important project files with `<leader>ha`
- Use the quick menu (`<leader>hh`) to see all marked files at once
- The numerical shortcuts (`<leader>h1-4`) are the fastest way to jump between files

![Harpoon Quick Menu](https://raw.githubusercontent.com/ThePrimeagen/harpoon/master/assets/harpoon-quick-menu.png)

### Undotree - Visual History Navigation

Undotree provides a visual representation of your edit history, allowing you to navigate to any previous state of your file.

| Keybind | Description |
|---------|-------------|
| `<leader>u` | Toggle Undotree panel |

**Usage Tips:**
- Use Undotree when you need to go back to a specific version of your file
- The visual tree makes it easy to see branching edit history
- Navigate the tree using standard Vim motions (j/k)
- Press Enter on a state to revert to it

![Undotree Visualization](https://raw.githubusercontent.com/mbbill/undotree/master/doc/undotree.png)

### Telescope - Fuzzy Finding

Telescope is a highly extendable fuzzy finder over lists.

| Keybind | Description |
|---------|-------------|
| `<leader>ff` | Find files in current directory |
| `<leader>fg` | Live grep in current directory |
| `<leader>fb` | Browse open buffers |
| `<leader>fh` | Search help tags |
| `<leader>fr` | Browse recent files |
| `<leader>fc` | Browse colorscheme |
| `<leader>fk` | Search keymaps |
| `<leader>f/` | Search current buffer |
| `<leader>fd` | Browse diagnostics |
| `<leader>fs` | Browse LSP document symbols |
| `<leader>fw` | Browse LSP workspace symbols |

**Usage Tips:**
- Type a few characters to fuzzy-find what you need
- Use `Ctrl-n`/`Ctrl-p` to move up/down the results
- Press `Tab` to select multiple items when applicable
- Press `Ctrl-v` to open in vertical split, `Ctrl-x` for horizontal split

### LSP and Diagnostics

Language Server Protocol integration for intelligent code assistance.

| Keybind | Description |
|---------|-------------|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Show hover documentation |
| `<leader>lr` | Rename symbol |
| `<leader>la` | Code actions |
| `<leader>lf` | Format document |
| `<leader>ld` | Show diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

**Usage Tips:**
- Install language servers using `:Mason`
- Check language server status with `:LspInfo`
- Format on save is enabled for most file types

### Multiple Pane Management

Efficiently work with multiple files side by side.

| Keybind | Description |
|---------|-------------|
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |
| `<leader>se` | Make splits equal size |
| `<leader>sx` | Close current split |
| `<C-h>` | Move to left window |
| `<C-j>` | Move to bottom window |
| `<C-k>` | Move to top window |
| `<C-l>` | Move to right window |
| `<C-Up>` | Decrease window height |
| `<C-Down>` | Increase window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |

**Usage Tips:**
- Use vertical splits (`<leader>sv`) for comparing files side by side
- Use horizontal splits (`<leader>sh`) for viewing documentation while coding
- Resize windows with `<C-arrows>` to optimize your workspace

### UI Enhancements

This configuration includes several UI enhancements for a better coding experience:

#### Visually Appealing Interface

- **Rose Pine Theme** with transparent backgrounds for distraction-free coding
- **Custom Statusline** showing file information, Git status, and diagnostics
- **Rounded Corners** on floating windows and popups
- **Icons** throughout the interface for better visual identification
- **Syntax Highlighting** powered by Treesitter for accurate code coloring

#### Focused Coding Experience

- **Distraction-free Mode**: Toggle with `<leader>z` to hide UI elements
- **Winbar** showing current code context at the top of the window
- **Indent Guides** for better code structure visualization
- **Git Integration** with inline blame and status indicators
- **Error Highlighting** that's visible but not distracting

#### Context-Aware UI

The UI adapts to what you're doing:

- **LSP Status Indicator** shows when language servers are active
- **Mode Indicator** changes color based on current mode (normal, insert, visual)
- **Task Running Indicator** when async processes are active
- **File Type Icons** for quick visual recognition

#### Customized for Backend Development

- **Database Connections** shown in the sidebar
- **Terminal Integration** with proper styling
- **Python Environment Indicator** in the statusline
- **Color Coded Diagnostics** with severity levels

### Code Folding

Organize and navigate your code with folding.

| Keybind | Description |
|---------|-------------|
| `<leader>zc` | Close fold |
| `<leader>zo` | Open fold |
| `<leader>za` | Toggle fold |
| `<leader>zC` | Close all folds |
| `<leader>zO` | Open all folds |
| `<leader>zA` | Toggle all folds |

### Nvim-Tree File Explorer

A file explorer that integrates with Git, icons, and more.

| Keybind | Description |
|---------|-------------|
| `<leader>e` | Toggle file explorer |
| `<leader>o` | Focus file explorer |

**In Explorer Window:**
- `a` - Create new file/directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `x` - Cut file to clipboard
- `c` - Copy file to clipboard
- `p` - Paste from clipboard
- `y` - Copy filename
- `Y` - Copy relative path
- `<C-v>` - Open in vertical split
- `<C-x>` - Open in horizontal split

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
