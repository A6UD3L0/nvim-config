# Backend & Data Science Neovim Configuration

A feature-rich Neovim configuration optimized for backend development and data science, combining ThePrimeagen's keybindings with NvChad's simplicity and elegance.

![Neovim Backend & Data Science](https://raw.githubusercontent.com/NvChad/nvchad.github.io/src/static/img/screenshots/nvdash.webp)

## Features

- **Backend Development Focus**: Optimized for Python, Go, C/C++, SQL, and other backend languages
- **Data Science Support**: Special tools for Python data analysis, Jupyter notebooks, and scientific computing
- **ThePrimeagen's Keybindings**: Efficient key mappings inspired by ThePrimeagen for faster coding
- **KeyTrainer Game**: Custom plugin to learn keybindings through an interactive game (`:KeyMap` to start)
- **Enhanced LSP**: Advanced language server configuration for better code intelligence
- **Debugging**: Integrated debugging for Python, Go, and C/C++
- **Beautiful UI**: Modern interface with Catppuccin theme and customized highlights

## One-Command Installation

```bash
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim && nvim
```

## Manual Installation

1. **Backup your existing configuration** (if you have one):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. **Clone this repository**:

```bash
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim
```

3. **Start Neovim** to automatically install plugins:

```bash
nvim
```

4. **Install Language Servers and Tools** (inside Neovim):

```
:Mason
```
Select and install the tools you need for your workflow.

## Key Features and Components

### Plugin Management
- Uses `lazy.nvim` for efficient plugin management
- Lazy-loads plugins for faster startup

### Language Support
- **Python**: LSP, formatter, debugger, REPL integration, Jupyter support
- **Go**: Complete Go toolchain with LSP, debugger, and error snippets
- **SQL**: Language server, formatter, and database client
- **C/C++**: LSP, debugger, and formatter
- **Web**: JavaScript/TypeScript support
- **Docker/K8s**: YAML validation with schema

### Development Tools
- **Telescope**: Fuzzy finder for files, text, and more
- **Harpoon**: Quick file navigation between frequently used files
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Mason**: Package manager for LSP, DAP, linters, and formatters
- **DAP**: Debug Adapter Protocol for interactive debugging

### Productivity Features
- **KeyTrainer**: Custom game to practice keybindings (`:KeyMap`)
- **Custom Mappings**: Efficient keybindings organized by category
- **Database Client**: Integrated DB management with vim-dadbod
- **Git Integration**: Fugitive for Git operations
- **Smart Formatting**: Automatic code formatting on save

## Learn Your Configuration

Start the keybinding trainer game to practice and learn your custom keybindings:

```
:KeyMap
```

## Important Keybindings

| Keybinding | Description |
|------------|-------------|
| `Space` | Leader key |
| `jk` | Exit insert mode |
| `;` | Enter command mode |
| `<C-s>` | Save file |
| `<leader>pv` | Open file explorer |
| `<leader>ff` | Find files |
| `<leader>fw` | Find text in files |
| `<leader>f` | Format code |
| `<leader>dt` | Toggle breakpoint |
| `<leader>dc` | Start debugging |
| `<leader>ha` | Add file to Harpoon |
| `<leader>hh` | Toggle Harpoon menu |
| `<leader>dd` | Generate docstring |

## Language-Specific Features

### Python Data Science
- Jupyter notebook integration
- Interactive REPL support
- NumPy-style docstring generation
- Debugging with debugpy

### Go Development
- Error handling snippets
- Integrated debugging with Delve
- Auto imports and formatting

### SQL & Database Work
- SQL formatting and linting
- Database client interface
- Schema-aware completions

## Customization

The configuration is organized into modular components that are easy to customize:

- `lua/chadrc.lua`: Main configuration and UI settings
- `lua/mappings.lua`: All keybindings organized by category
- `lua/plugins/init.lua`: Plugin configuration
- `lua/configs/`: Individual configuration files for major plugins

## Credits & Inspiration

1. [NvChad](https://github.com/NvChad/NvChad) - Base framework and UI components
2. [ThePrimeagen](https://github.com/ThePrimeagen/init.lua) - Keybindings and workflow optimizations
3. [LazyVim](https://github.com/LazyVim/starter) - Inspiration for the starter configuration
