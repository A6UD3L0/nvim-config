# Ultimate Backend & Data Science Neovim IDE

A comprehensive Neovim configuration optimized for backend development, data science, and machine learning workflows. This configuration combines ThePrimeagen's efficient keybindings with NvChad's simplicity and elegance, enhanced with specialized tools for development and data analysis.

![Neovim Backend & Data Science](https://raw.githubusercontent.com/NvChad/nvchad.github.io/src/static/img/screenshots/nvdash.webp)

## Features

- **Backend Development Focus**: Optimized for Python, Go, C/C++, SQL, and other backend languages
- **Data Science Support**: Special tools for Python data analysis, Jupyter notebooks, and scientific computing
- **Machine Learning Workflow**: Integrated tools for ML development, model training, and experimentation
- **Git Mastery**: Enhanced Git integration with Fugitive, Gitsigns, Diffview, and LazyGit
- **AI Code Completion**: GitHub Copilot integration for intelligent code suggestions
- **Interactive Learning**: KeyTrainer game with specialized modules for different workflows
- **Advanced Debugging**: Comprehensive DAP setup for Python, Go, and C/C++
- **Beautiful UI**: Modern interface with Catppuccin theme and customized highlights

## Specialized Tools

- **Jupyter Integration**: Work with Jupyter notebooks directly in Neovim
- **REPL Support**: Interactive code execution for Python, R, and other languages
- **Database Client**: Integrated DB client for SQL operations and data exploration
- **CSV Handling**: Special tools for working with tabular data
- **SnipRun**: Run code snippets in various languages without leaving Neovim
- **Enhanced Undotree**: Better visualization of your editing history

## Keybinding Training Modules

Master your Neovim workflow with specialized training modules:
- `:KeyMap` - General keybinding training
- `:HarpoonTrainer` - Master quick file navigation
- `:GitTrainer` - Learn Git operations
- `:UndoTrainer` - Master history navigation
- `:MotionsTrainer` - Become proficient with Vim motions
- `:TextObjectsTrainer` - Master text manipulation

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

4. **Install Language Servers and Tools**:

After lazy.nvim finishes downloading plugins, run:

```
:MasonInstallAll
```

This will install all the pre-configured language servers, formatters, and linters.

5. **Optional: Remove Git Information**

If you want to make this your own configuration without the original repository's history:

```bash
rm -rf ~/.config/nvim/.git
```

## Updating

To update your plugins to the latest versions:

```
:Lazy sync
```

To update NvChad core (if a new version is available):

```
:NvChadUpdate
```

## Learn Your Configuration

Start the keybinding trainer game to practice and learn your custom keybindings:

```
:KeyMap
```

## Customizing the UI

For detailed information on customizing the UI and themes:

```
:help nvui
```

This will provide documentation on customizing the base46 theme, highlights, and other UI components.

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

## Data Science & Machine Learning Keybindings

### Jupyter Notebook Integration
- `<leader>jS` - Start Jupynium server
- `<leader>jA` - Attach to Jupyter notebook
- `<leader>jE` - Execute selected cells

### Code Execution
- `<leader>sr` - Run code snippet under cursor
- `<leader>sl` - Start live code runner
- `<leader>sc` - Close live runner
- `<leader>si` - Show runner information

### Database Operations
- `<leader>db` - Toggle database UI
- `<leader>da` - Add database connection

### Documentation
- `<leader>dd` - Generate code documentation

## Git Workflow

### Fugitive
- `<leader>gs` - Git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff

### Gitsigns
- `<leader>gh` - Preview hunk
- `<leader>gr` - Reset hunk
- `<leader>gs` - Stage hunk
- `]h` / `[h` - Navigate between hunks

### Diffview
- `<leader>gv` - Open diffview
- `<leader>gf` - View file history

### LazyGit
- `<leader>gg` - Open LazyGit interface

## Debugging

- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue execution
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>du` - Toggle debug UI
- `<leader>dx` - Terminate debugging session

## Customization

The configuration is organized into modular components that are easy to customize:

- `lua/chadrc.lua`: Main configuration and UI settings
- `lua/mappings.lua`: All keybindings organized by category
- `lua/plugins/init.lua`: Plugin configuration
- `lua/configs/`: Individual configuration files for major plugins

## Uninstallation

If you need to completely remove this configuration:

### Linux / MacOS (unix)
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
```

### Flatpak (linux)
```bash
rm -rf ~/.var/app/io.neovim.nvim/config/nvim
rm -rf ~/.var/app/io.neovim.nvim/data/nvim
rm -rf ~/.var/app/io.neovim.nvim/.local/state/nvim
```

### Windows CMD
```cmd
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data
```

### Windows PowerShell
```powershell
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```

## Credits & Inspiration

1. [NvChad](https://github.com/NvChad/NvChad) - Base framework and UI components
2. [ThePrimeagen](https://github.com/ThePrimeagen/init.lua) - Keybindings and workflow optimizations
3. [LazyVim](https://github.com/LazyVim/starter) - Inspiration for the starter configuration
