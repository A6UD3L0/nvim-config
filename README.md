# 🚀 Ultimate Neovim Configuration

A powerful Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim) with enhanced productivity plugins and keymaps.

![Neovim Screenshot](https://i.imgur.com/your-screenshot.png) *Screenshot coming soon*

## ✨ Features

- 🚀 Blazing fast startup and navigation
- 🎨 Beautiful UI with Tokyo Night colorscheme
- 🧠 Smart autocompletion with nvim-cmp and LSP
- 🔍 Advanced file searching with Telescope
- 📝 Enhanced editing with LSP, snippets, and more
- 🧰 Built-in terminal, git integration, and debugging
- 🎯 Smart keymaps for maximum productivity

## 🛠️ Requirements

- Neovim >= 0.9.0
- Git >= 2.19.0
- A Nerd Font (recommended)
- Node.js (for LSPs)
- [LazyGit](https://github.com/jesseduffield/lazygit) (optional but recommended)

## 🚀 Installation

1. Backup your current Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
   ```

3. Start Neovim and let LazyVim handle the installation:
   ```bash
   nvim
   ```

## 🎯 Keymaps

### General
- `<leader>e`: Toggle file explorer
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Find buffers
- `<leader>fh`: Find help tags

### LSP
- `gd`: Go to definition
- `gr`: Show references
- `K`: Show documentation
- `[d`/`]d`: Navigate diagnostics
- `<leader>rn`: Rename symbol
- `<leader>fm`: Format buffer

### Git
- `<leader>gg`: Open LazyGit
- `<leader>gl`: Toggle LazyGit in terminal
- `]g`/`[g`: Navigate git changes

### Terminal
- `Ctrl+\`: Toggle terminal
- `jk` or `Esc`: Exit terminal mode
- `Ctrl+h/j/k/l`: Navigate between windows in terminal mode

### Harpoon
- `<leader>ha`: Add file to Harpoon
- `<leader>hh`: Toggle Harpoon menu
- `<leader>1`-`<leader>5`: Jump to marked files

### UndoTree
- `<leader>u`: Toggle UndoTree

## 🧩 Plugins

### Core
- [LazyVim](https://github.com/LazyVim/LazyVim) - Plugin manager and base config
- [Mason](https://github.com/williamboman/mason.nvim) - LSP/DAP/Linter/Formatter manager
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletion
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder

### UI
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Colorscheme
- [Lualine](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [Nvim-Tree](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
- [Bufferline](https://github.com/akinsho/bufferline.nvim) - Tabs

### Productivity
- [Harpoon](https://github.com/ThePrimeagen/harpoon) - Mark and jump to files
- [Undotree](https://github.com/mbbill/undotree) - Visualize undo history
- [LazyGit](https://github.com/kdheepak/lazygit.nvim) - Git interface
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Comment toggling

## ⚙️ Configuration

- `lua/config/`: Core configuration files
- `lua/plugins/`: Plugin configurations
- `lua/plugins/autocomplete.lua`: Autocomplete setup
- `lua/plugins/lsp.lua`: LSP configuration
- `lua/plugins/ui.lua`: UI customizations
- `lua/plugins/utilities.lua`: Additional utilities

## 🚀 Getting Started

1. Install the [Nerd Font](https://www.nerdfonts.com/) of your choice
2. Install [LazyGit](https://github.com/jesseduffield/lazygit)
3. Install language servers with `:Mason`
4. Use `:Lazy` to manage plugins

## 📝 License

MIT

## 🙏 Credits

- [LazyVim](https://github.com/LazyVim/LazyVim)
- [Neovim](https://neovim.io/)
- All plugin authors
