# Ultimate Backend & Data Science Neovim IDE

A comprehensive Neovim configuration optimized for backend development, data science, and machine learning workflows. This configuration combines ThePrimeagen's efficient keybindings with NvChad's simplicity and elegance, enhanced with specialized tools for development and data analysis.

![Neovim Backend & Data Science IDE](https://raw.githubusercontent.com/NvChad/nvchad.github.io/src/static/img/screenshots/nvdash.webp)

## ✨ Features

- **Backend Development Focus**: Optimized for Python, Go, C/C++, SQL, and other backend languages
- **Data Science Support**: Special tools for Python data analysis, Jupyter notebooks, and scientific computing
- **Machine Learning Workflow**: Integrated tools for ML development, model training, and experimentation
- **Git Mastery**: Enhanced Git integration with Fugitive, Gitsigns, Diffview, and LazyGit
- **AI Code Completion**: GitHub Copilot integration for intelligent code suggestions
- **Interactive Learning**: KeyTrainer and DataScienceTrainer games for learning Neovim and data science workflows
- **Advanced Debugging**: Comprehensive DAP setup for Python, Go, and C/C++
- **Beautiful UI**: Modern interface with Catppuccin theme and customized highlights

## 🛠️ Specialized Tools

- **Jupyter Integration**: Work with Jupyter notebooks directly in Neovim
- **REPL Support**: Interactive code execution for Python, R, and other languages
- **Database Client**: Integrated DB client for SQL operations and data exploration
- **CSV Handling**: Special tools for working with tabular data
- **SnipRun**: Run code snippets in various languages without leaving Neovim
- **Enhanced Undotree**: Better visualization of your editing history

## 🎮 Interactive Learning Games

Master your workflow with specialized training modules:

### KeyTrainer
Learn and practice Neovim keybindings with interactive exercises:
- `:KeyMap` - General keybinding training
- `:HarpoonTrainer` - Master quick file navigation
- `:GitTrainer` - Learn Git operations
- `:UndoTrainer` - Master history navigation
- `:MotionsTrainer` - Become proficient with Vim motions
- `:TextObjectsTrainer` - Master text manipulation

### DataScienceTrainer
Learn data science workflows directly in Neovim with progressive challenges:
- `:DataScienceTrainer` or `:DST` - Start the main game
- `:DST basics` - Start with Python basics
- `:DST numpy` - Learn NumPy operations
- `:DST pandas` - Practice Pandas data manipulation
- `:DST visualization` - Create data visualizations
- `:DST ml` - Build machine learning models
- `:DST advanced` - Complete advanced workflows

## 📋 Prerequisites

- Neovim 0.9.0 or later
- Git
- A Nerd Font (recommended: JetBrainsMono Nerd Font)
- Python 3.6+ with pip (for data science features)
- Node.js and npm (for LSP features)
- [Ripgrep](https://github.com/BurntSushi/ripgrep) for telescope live grep

## 💻 Installation

### One-Command Installation

```bash
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim && nvim
```

### Step-by-Step Installation

1. **Backup your existing configuration** (if you have one):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. **Clone this repository**:

```bash
git clone https://github.com/A6UD3L0/nvim-config ~/.config/nvim
```

3. **Make it your own** (optional):

```bash
rm -rf ~/.config/nvim/.git
git init ~/.config/nvim
```

4. **Start Neovim** to automatically install plugins:

```bash
nvim
```

The first launch will:
- Install lazy.nvim (plugin manager)
- Download and install all configured plugins
- Set up the UI and theme

5. **Install Language Servers and Tools**:

After lazy.nvim finishes downloading plugins, run:

```
:MasonInstallAll
```

This will install all pre-configured language servers, formatters, linters, and debugging tools.

6. **For Data Science Features** (optional):

Install required Python packages:

```bash
pip install numpy pandas matplotlib seaborn scikit-learn nltk
```

## 🔄 Updating

To update your plugins to the latest versions:

```
:Lazy sync
```

## 🎨 Customizing the UI

The configuration uses Catppuccin as the default theme. You can change themes in `lua/chadrc.lua`:

```lua
M.base46 = {
  theme = "catppuccin", -- Change this to another theme
}
```

Available themes include: "catppuccin", "tokyonight", "gruvbox", "onedark", "nord", and more.

## ⌨️ Key Keybindings

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
| `<leader>u` | Toggle Undotree |
| `<leader>gg` | Open LazyGit |

## 🐍 Data Science & Machine Learning

### DataScienceTrainer Controls
- `n` - Next challenge
- `p` - Previous challenge
- `h` - Show hint
- `s` - Show solution
- `r` - Run current challenge in a new buffer
- `o` - Open challenge in editor with full instructions
- `c` - Change category
- `l` - Change difficulty level
- `q`/`Esc` - Quit game

### Jupyter Notebook Integration
- `<leader>jS` - Start Jupynium server
- `<leader>jA` - Attach to Jupyter notebook
- `<leader>jE` - Execute selected cells

### Code Execution
- `<leader>sr` - Run code snippet under cursor
- `<leader>sl` - Start live code runner
- `<leader>sc` - Close live runner
- `<leader>si` - Show runner information

## 🔄 Git Workflow

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

## 🔎 Debugging

- `<leader>dt` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue execution
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>du` - Toggle debug UI
- `<leader>dx` - Terminate debugging session

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- ThePrimeagen for the keybinding philosophy
- NvChad for the UI inspiration
- The Neovim community for all the amazing plugins

## 🧹 Uninstallation

If you need to completely remove this configuration:

### Linux / MacOS (unix)
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
```

### Windows (PowerShell)
```powershell
Remove-Item -Recurse -Force ~\AppData\Local\nvim
Remove-Item -Recurse -Force ~\AppData\Local\nvim-data
