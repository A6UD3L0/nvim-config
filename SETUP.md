# Backend & Machine Learning Neovim Config

Welcome to your modern, portable Neovim configuration—optimized for backend development and machine learning!

---

## 🚀 Quick Start

1. **Prerequisites**
   - **Neovim**: v0.8.0 or newer (v0.9+ recommended)
   - **Git**
   - **Nerd Font** (optional, for icons)
   - **Python 3** and **pip** (for LSP, DAP, and test integration)
   - **Go** (for Go LSP/DAP)

2. **Installation**
   ```sh
   git clone <your-repo-url> ~/.config/nvim
   # or symlink this directory to ~/.config/nvim
   ln -s /path/to/this/repo ~/.config/nvim
   ```
   - Open Neovim: `nvim`
   - Plugins will bootstrap automatically on first launch.

3. **First Launch**
   - Run `:checkhealth` to verify your environment.
   - Run `:Mason` to see/manage LSP/DAP/tool installations.

---

## 🧠 Features & Plugins

- **Syntax & Parsing**: Treesitter for Python, C, Go, SQL, Bash, JSON, YAML
- **LSP**: Mason installs and manages `pyright`, `clangd`, `gopls`, `sqls`, `bashls`
- **Completion**: nvim-cmp with buffer, path, and LSP sources
- **Debugging**: nvim-dap, DAP-UI, dap-python, dap-go
- **Testing**: vim-test, iron.nvim (REPL)
- **Terminal**: toggleterm.nvim (`<leader>tt`)
- **Git**: gitsigns.nvim, neogit, lazygit
- **Navigation**: telescope.nvim (files, grep, buffers, etc.)
- **Keymap Discovery**: which-key.nvim (organized leader keybindings)
- **Project Commands**: UV/Editor commands under `<leader>p`

---

## 🎹 Keybindings

- `<leader>` is set to **Space**
- **Telescope**: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers)
- **LSP**: `gd` (goto definition), `K` (hover), `<leader>rn` (rename)
- **DAP**: `<F5>` (continue), `<F10>` (step over), `<leader>db` (toggle breakpoint)
- **Testing**: `<leader>tn` (nearest), `<leader>tf` (file)
- **Terminal**: `<leader>tt`
- **Git**: `<leader>gs` (status), `<leader>gc` (commit), `<leader>gp` (push)
- **WhichKey**: `<leader>` (shows organized popup)

For a full list, hit `<leader>` in normal mode to open the WhichKey popup.

---

## 🛠️ Customization

- Add custom plugins to `lua/custom/plugins/*.lua`
- Add/modify keymaps in `lua/custom/remap.lua`
- Add project/UV commands in `lua/core/utils/editor_commands.lua`

---

## 🩺 Troubleshooting

- Run `:checkhealth` for diagnostics
- Use `:Lazy` to manage/update plugins
- Use `:Mason` to manage LSPs/DAPs/tools
- If plugins fail to install, ensure you have internet access and correct permissions

---

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [WhichKey.nvim](https://github.com/folke/which-key.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

---

## 📝 Next Steps

- Explore the config and plugins
- Customize your workflow
- Enjoy a productive ML/backend dev experience in Neovim!

---

*For questions or issues, open an issue in your repo or consult the plugin docs above.*
