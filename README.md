# Ultimate Backend Development Neovim Configuration

A comprehensive Neovim configuration optimized for backend development and data science. This configuration combines ThePrimeagen's powerful keybindings with NvChad's simplicity to create the ultimate IDE experience for Python, Go, Linux, Git, C, SQL, Docker, and more.

## ✨ Features

- **ThePrimeagen-Inspired Workflow**
  - Fast navigation with optimized keybindings
  - Efficient window and buffer management
  - Text manipulation optimized for coding speed
  - System clipboard integration for seamless copy/paste

- **Beautiful Interface**
  - Custom color theme with focus-enhancing color palette
  - Distraction-free coding environment
  - Visual noise reduction with strategic syntax highlighting
  - Fallback to Tokyonight theme for reliability

- **Powerful LSP Integration**
  - Autocompletion via nvim-cmp
  - Diagnostics and code actions
  - Go-to-definition, references, and more
  - Signature help as you type

- **Deep Backend Language Support**
  - Python with environments, virtual env management
  - Go support with gopls
  - C/C++ support with clangd
  - SQL language support
  - Docker files and compose
  - YAML for Kubernetes and configuration

- **Lightning-Fast Navigation**
  - Telescope fuzzy finder with project awareness
  - Harpoon for quick file jumping (ThePrimeagen style)
  - NvimTree file explorer
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
  - Logical keybinding system with which-key integration
  - UndoTree for visualizing change history
  - Project management with Telescope integration

## 📋 System Requirements

- Neovim 0.9.0 or higher
- Git
- Node.js and npm (for LSP servers)
- Python 3.8+ with pip (for Python language support)
- Ripgrep (for Telescope searches)
- A Nerd Font (for icons)
- Optional: Glow (for Markdown previewing in DevDocs)

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

### 4. Verify Setup

Check for errors and missing dependencies:
```
:checkhealth
```

If you see any issues, follow the suggestions or install missing system dependencies as needed.

## ⌨️ Key Bindings

This configuration features ThePrimeagen's optimized key bindings combined with a logical namespaced structure for maximum efficiency.

### ThePrimeagen's Essential Keybindings

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
| `<leader>p`      | Paste without overwriting register         |
| `<leader>y`      | Yank to system clipboard                   |
| `<leader>Y`      | Yank line to system clipboard              |
| `<leader>d`      | Delete to void register                    |

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
| `<leader>dh`     | HTTP documentation                        |
| `<leader>dG`     | Git documentation                         |
| `<leader>dI`     | Install DevDocs                           |
| `<leader>dU`     | Update all DevDocs                        |

### LSP and Code Navigation

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `gd`             | Go to definition                           |
| `gr`             | Go to references                           |
| `gi`             | Go to implementation                       |
| `gt`             | Go to type definition                      |
| `K`              | Show documentation hover                   |
| `<C-k>`          | Show signature help                        |
| `<leader>ca`     | Code actions                               |
| `<leader>cr`     | Rename symbol                              |
| `<leader>cf`     | Format code                                |
| `<leader>cd`     | Line diagnostics                           |
| `[d`             | Previous diagnostic                        |
| `]d`             | Next diagnostic                            |

### Project Navigation

| Key Binding      | Action                                     |
|------------------|-------------------------------------------|
| `<leader>pf`     | Find files in project                      |
| `<C-p>`          | Find Git files                             |
| `<leader>ps`     | Project search (grep)                      |
| `<leader>/`      | Fuzzy find in buffer                       |

## 📦 Essential Plugins

This configuration includes carefully selected plugins for backend development:

### Core Plugins
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin manager
- **[nvim-lualine](https://github.com/nvim-lualine/lualine.nvim)** - Statusline
- **[nvim-notify](https://github.com/rcarriga/nvim-notify)** - Notification manager
- **[which-key](https://github.com/folke/which-key.nvim)** - Keybinding helper
- **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** - Fallback theme

### Language Support
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configuration
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - LSP/DAP/Linter manager
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion
- **[neodev.nvim](https://github.com/folke/neodev.nvim)** - Neovim Lua API development

### Navigation
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)** - File explorer
- **[harpoon](https://github.com/ThePrimeagen/harpoon)** - File navigation

### Git Integration
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git indicators
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** - Git interface

### Text Editing
- **[undotree](https://github.com/mbbill/undotree)** - Visualize undo history
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Syntax highlighting

### Documentation
- **[nvim-devdocs](https://github.com/luckasRanarison/nvim-devdocs)** - Developer documentation

### Terminal and UI
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** - Terminal integration
- **[alpha-nvim](https://github.com/goolord/alpha-nvim)** - Dashboard

## 🤝 Contributing

Contributions to improve this configuration are welcome! Feel free to submit pull requests for bug fixes, improvements, or new features.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- ThePrimeagen for workflow inspiration and key binding philosophy
- NvChad for UI simplicity concepts
- All plugin authors for their incredible work

---

Happy coding with your ultimate backend development environment! 🚀
