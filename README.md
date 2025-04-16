# Ultimate Backend Development Neovim Configuration

A comprehensive Neovim configuration optimized for backend development and data science. This configuration combines ThePrimeagen's powerful keybindings with NvChad's simplicity to create the ultimate IDE experience for Python, Go, Linux, Git, C, SQL, Docker, and more.

<p align="center">
  <img src="https://img.shields.io/badge/Neovim-0.9.0+-green.svg" alt="Neovim 0.9.0+">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/ThePrimeagen-Inspired-purple.svg" alt="ThePrimeagen Inspired">
  <img src="https://img.shields.io/badge/NvChad-Simplicity-orange.svg" alt="NvChad Simplicity">
</p>

![Neovim Configuration Screenshot](https://raw.githubusercontent.com/A6UD3L0/nvim-config/assets/screenshot.png)

## ✨ Features

- **ThePrimeagen-Inspired Workflow**
  - Fast navigation with optimized keybindings
  - Efficient window and buffer management
  - Text manipulation optimized for coding speed
  - System clipboard integration for seamless copy/paste

- **Modern UI/UX Design** 🆕
  - Consistent rounded borders across all plugin interfaces
  - Beautiful icons and visual indicators
  - Carefully selected color themes for reduced eye strain
  - MECE (Mutually Exclusive, Collectively Exhaustive) design principles
  - Enhanced status line with contextual information

- **Intuitive Keybindings** 🆕
  - Logical namespaced key structure with which-key integration
  - Color-coded key groups for better visual organization
  - Discoverable commands with descriptive help text
  - Consistent keybinding pattern across all features
  - `Q` mapped to match `q` for intuitive macro recording

- **Powerful LSP Integration**
  - Autocompletion via nvim-cmp
  - Diagnostics and code actions
  - Go-to-definition, references, and implementations
  - Signature help as you type
  - Symbol navigation and workspace management

- **Deep Backend Language Support**
  - Python with environments, virtual env management
  - Go support with gopls
  - C/C++ support with clangd
  - SQL language support
  - Docker files and compose
  - YAML for Kubernetes and configuration

- **Lightning-Fast Navigation**
  - Telescope fuzzy finder with project awareness and enhanced UI
  - Harpoon for quick file jumping (ThePrimeagen style)
  - NvimTree file explorer with git integration
  - Center search results for better focus

- **Comprehensive Git Integration**
  - LazyGit for visual Git operations
  - Gitsigns for inline git hunks
  - Git blame and history navigation
  - Merge conflict resolution tools

- **Enhanced Documentation**
  - DevDocs for offline documentation
  - Language-specific doc access (Python, Go, SQL, etc.)
  - Documentation viewer with beautiful rendering
  - Integrated help system

- **Productivity Boosters**
  - Terminal integration with Toggleterm
  - UndoTree for visualizing change history
  - Project management with Telescope integration
  - Code time tracking

- **Robust Plugin Architecture** 🆕
  - MECE module structure with clear separation of concerns
  - Lazy-loaded plugins for faster startup
  - Circular dependency prevention
  - Carefully balanced plugins for optimal performance
  - Graceful fallbacks when optional dependencies are missing

## 📋 System Requirements

- Neovim 0.9.0 or higher
- Git
- Node.js and npm (for LSP servers)
- Python 3.8+ with pip (for Python language support)
- Ripgrep (for Telescope searches)
- A Nerd Font (for icons)
- Optional: Glow (for Markdown previewing in DevDocs)
- Optional: lazygit (for Git integration)
- Optional: fd (for faster file finding)

## 🚀 Installation

### 1. Clean Old Neovim Configurations (Recommended)

To ensure a fresh start, remove or back up any previous Neovim configuration. **This will delete your old config!**

```bash
mv ~/.config/nvim ~/.config/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim_backup_$(date +%Y%m%d%H%M%S) 2>/dev/null || true
```

### 2. Clone the Configuration

```bash
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
```

### 3. Launch Neovim and Install Plugins

Open Neovim (the first launch will install plugins):
```bash
nvim
```

Then, in Neovim, run:
```
:Lazy sync
```
Wait for all plugins to finish installing, then restart Neovim.

### 4. Install LSP Servers and Tools

Use Mason to install the language servers you need:
```
:MasonInstall pyright gopls clangd lua-language-server typescript-language-server bash-language-server dockerfile-language-server
```

### 5. Verify Setup

Check for errors and missing dependencies:
```
:checkhealth
```

If you see any issues, follow the suggestions or install missing system dependencies as needed.

## ⌨️ Key Bindings

This configuration features ThePrimeagen's optimized key bindings combined with a logical namespaced structure for maximum efficiency. All keybindings are discoverable through which-key by pressing the leader key (Space).

### Navigation & Editing Keybindings

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `jk`             | Exit insert mode (faster than Escape)      |
| `<C-h/j/k/l>`    | Navigate between windows                   |
| `J` (visual)     | Move selected lines down                   |
| `K` (visual)     | Move selected lines up                     |
| `J` (normal)     | Join lines without moving cursor           |
| `<C-d>`          | Move down half page and center             |
| `<C-u>`          | Move up half page and center               |
| `n/N`            | Next/previous search result (centered)     |
| `Q`              | Same as `q` (macro recording)              |
| `<leader>p`      | Paste without overwriting register         |
| `<leader>y`      | Yank to system clipboard                   |
| `<leader>Y`      | Yank line to system clipboard              |
| `<leader>d`      | Delete to void register                    |
| `<leader>?`      | Show all keymaps (cheatsheet)              |

### Namespaced Key Structure

| Namespace    | Purpose                                     |
|--------------|---------------------------------------------|
| `<leader>b`  | Buffer operations                           |
| `<leader>c`  | Code actions and LSP operations             |
| `<leader>d`  | Documentation (DevDocs, help)               |
| `<leader>dm` | Machine Learning documentation              |
| `<leader>e`  | Explorer operations                         |
| `<leader>f`  | Find/File operations                        |
| `<leader>g`  | Git operations                              |
| `<leader>h`  | Harpoon operations                          |
| `<leader>k`  | Keymaps (show key bindings, help)           |
| `<leader>l`  | LSP operations (diagnostics, actions)       |
| `<leader>p`  | Project/Python/Dependencies                 |
| `<leader>q`  | Quickfix list operations                    |
| `<leader>r`  | Run/Requirements                            |
| `<leader>s`  | Search/Replace operations                   |
| `<leader>t`  | Terminal operations                         |
| `<leader>u`  | Undotree and utilities                      |
| `<leader>w`  | Window/Tab operations                       |
| `<leader>x`  | Execute code (run scripts, REPL)            |
| `<leader>z`  | Zen/Focus mode                              |

### Git Integration (LazyGit + Gitsigns)

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>gg`     | Open LazyGit                              |
| `<leader>gf`     | LazyGit file history                      |
| `<leader>gc`     | LazyGit current file                      |
| `<leader>gl`     | LazyGit logs for current file             |
| `<leader>gb`     | LazyGit blame                             |
| `<leader>gs`     | Stage hunk                                |
| `<leader>gr`     | Reset hunk                                |
| `<leader>gS`     | Stage buffer                              |
| `<leader>gu`     | Undo stage hunk                           |
| `<leader>gp`     | Preview hunk                              |
| `<leader>gB`     | Blame line (full)                         |
| `<leader>gL`     | Toggle line blame                         |
| `<leader>gd`     | Diff this                                 |
| `]c`             | Next hunk                                 |
| `[c`             | Previous hunk                             |

### LSP and Code Navigation

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `gd`             | Go to definition                          |
| `gr`             | Go to references                          |
| `gi`             | Go to implementation                      |
| `gt`             | Go to type definition                     |
| `K`              | Show documentation                        |
| `<C-k>`          | Show signature help                       |
| `<leader>ca`     | Code actions                              |
| `<leader>cr`     | Rename symbol                             |
| `<leader>cf`     | Format code                               |
| `<leader>cd`     | Line diagnostics                          |
| `<leader>cq`     | Diagnostics to quickfix                   |
| `[d`             | Previous diagnostic                       |
| `]d`             | Next diagnostic                           |
| `<leader>cs`     | Document symbols                          |
| `<leader>cS`     | Workspace symbols                         |
| `<leader>cI`     | LSP info                                  |
| `<leader>cR`     | LSP restart                               |

### Telescope Searching

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>ff`     | Find files                                |
| `<leader>fg`     | Live grep                                 |
| `<leader>fb`     | Buffers                                   |
| `<leader>fh`     | Help tags                                 |
| `<leader>fr`     | Recent files                              |
| `<leader>fc`     | Colorscheme select                        |
| `<leader>fk`     | Keymaps                                   |
| `<leader>ft`     | Todo comments                             |
| `<leader>pf`     | Find files in project                     |
| `<C-p>`          | Find Git files                            |
| `<leader>ps`     | Project search (grep)                     |
| `<leader>/`      | Fuzzy find in buffer                      |

### Python Development

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>pa`     | Select Python environment                  |
| `<leader>pc`     | Use cached Python environment              |
| `<leader>pp`     | Install Python package                    |
| `<leader>pr`     | Run Python file                           |
| `<leader>pi`     | Open IPython REPL                         |
| `<leader>pd`     | Generate Python docstring                 |
| `<leader>pt`     | Run Python tests                          |

### Terminal Integration

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>tt`     | Toggle terminal (horizontal)              |
| `<C-t>`          | Toggle terminal with Ctrl+t               |
| `<leader>tv`     | Toggle terminal (vertical)                |
| `<leader>tf`     | Toggle terminal (float)                   |
| `<leader>tp`     | Toggle Python terminal                    |
| `<leader>td`     | Toggle Docker terminal                    |
| `<leader>ts`     | Toggle SQL terminal                       |

### UndoTree Visualization

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>u`      | Toggle Undotree                           |
| `<leader>ut`     | Toggle Undotree (alternate)               |
| `<leader>uf`     | Focus Undotree                            |

### Harpoon File Navigation

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>ha`     | Add file to Harpoon                       |
| `<leader>hh`     | Show Harpoon menu                         |
| `<leader>1-5`    | Jump to Harpoon files 1-5                 |

### Documentation with DevDocs

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>dd`     | Open DevDocs                              |
| `<leader>df`     | Open docs for current filetype            |
| `<leader>dP`     | Python documentation                      |
| `<leader>dg`     | Go documentation                          |
| `<leader>dt`     | Terraform documentation                   |
| `<leader>dk`     | Kubernetes documentation                  |
| `<leader>dD`     | Docker documentation                      |
| `<leader>ds`     | SQL documentation                         |
| `<leader>db`     | Bash documentation                        |

## 🧩 Architecture

The configuration follows a MECE (Mutually Exclusive, Collectively Exhaustive) design principle to ensure clean separation of concerns, maintainability, and performance.

### Core Components:

- **`init.lua`**: Entry point and basic configuration
- **`lua/plugins.lua`**: Plugin management with lazy.nvim
- **`lua/settings.lua`**: Core Neovim settings independent of plugins
- **`lua/mappings.lua`**: Key mappings and functions
- **`lua/which_key_setup.lua`**: Which-key configuration for keybinding organization
- **`lua/plugins/`**: Domain-specific plugin configurations

### Plugin Architecture:

Plugins are organized into logical domains:
- **UI and Appearance**: Theme, status line, bufferline, etc.
- **Editor and Syntax**: Treesitter, indentation, comments, etc.
- **LSP and Completion**: Language servers, completion, snippets
- **Navigation**: Telescope, Harpoon, file explorer
- **Git Integration**: LazyGit, Gitsigns, diffview
- **Languages**: Python, Go, and other language-specific plugins
- **Utilities**: Terminal, documentation, debugging

## 🛠️ Configuration

### Customizing Themes

To change the color theme:
```lua
-- In lua/plugins/ui.lua, modify the colorscheme line
vim.cmd("colorscheme tokyonight") -- Change to your preferred theme
```

### Adding New LSP Servers

To add more language servers:
1. Install the server with Mason: `:MasonInstall server_name`
2. Add server configuration in `lua/plugins/backend-essentials.lua`

### Adding Custom Keybindings

1. Add your mappings to `lua/mappings.lua`
2. Register namespaces in `lua/which_key_setup.lua`

## 🔧 Troubleshooting

### Common Issues

#### LSP Not Working
- Check Mason has installed the required servers: `:Mason`
- Verify server configured in `lua/plugins/backend-essentials.lua`
- Run `:LspInfo` to check the status of language servers

#### Slow Performance
- Check startup time: `nvim --startuptime startup.log`
- Use `:TSUpdate` to update Treesitter parsers
- Ensure outdated plugins are updated with `:Lazy update`

#### Unicode/Icon Issues
- Verify a Nerd Font is installed and configured in your terminal
- Check terminal supports true color with: `:checkhealth`

#### Telescope Issues
- Ensure ripgrep is installed for live grep functionality
- Check `:checkhealth telescope` for any missing dependencies

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

- [ThePrimeagen](https://github.com/ThePrimeagen) for the workflow inspiration
- [NvChad](https://github.com/NvChad/NvChad) for UI/UX concepts
- [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for parsing
- All plugin authors who made this configuration possible

## 📊 Statistics

- **Startup Time**: ~100ms (with lazy loading)
- **LOC**: ~5,000 lines of configuration
- **Plugins**: 50+ carefully selected plugins
- **LSP Servers**: Configured for 10+ programming languages
- **Keybindings**: 200+ optimized keybindings with logical grouping
