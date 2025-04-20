# Minimalist Neovim Config for Python, C, Go, SQL, Docker, and ML

This Neovim configuration is designed for high-performance, minimalism, and a clean, modern UI/UX. It is modular, DRY, and optimized for programming in Python, C, Go, SQL, Docker, and machine learning workflows.

## Features
- **Minimal, modular Lua config**: All settings and plugins are organized in `lua/custom/` modules.
- **Single source of truth for keymaps**: All `<leader>` mappings are consolidated in `lua/custom/keymaps.lua` using which-key.
- **Everforest theme**: Soft, eye-friendly colorscheme with lualine, bufferline, and icons.
- **Lazy loading**: All plugins are lazy-loaded for fast startup.
- **Language support**:
  - **LSP**: Python (pyright), C/C++ (clangd), Go (gopls), SQL (sqls), Docker (dockerls), Bash (bashls)
  - **Formatters/Linters**: black, ruff, clang-format, gofmt, sqlfluff, hadolint
  - **Treesitter**: Auto-installs parsers for all relevant languages
- **Interactive workflow**:
  - **REPL**: iron.nvim with IPython integration
  - **Debugging**: nvim-dap, dap-ui for Python and Go
  - **Testing**: neotest for Python and Go
  - **SQL**: vim-dadbod, dadbod-ui
  - **Docker**: nvim-docker, toggleterm
  - **Python project management**: uv.nvim with venv auto-activation
- **Modern UI/UX**: lualine, bufferline, indent-blankline, nvim-scrollbar, icons, smooth scrolling

## Installation
1. **Clone this repo:**
   ```sh
   git clone <your-fork-or-this-repo> ~/.config/nvim
   ```
2. **Open Neovim:**
   ```sh
   nvim
   ```
   The config will bootstrap itself and install `lazy.nvim` and all plugins.
3. **Install system dependencies:**
   - [ripgrep](https://github.com/BurntSushi/ripgrep)
   - [fd](https://github.com/sharkdp/fd)
   - [python3, pip, uv](https://github.com/astral-sh/uv)
   - [Go, Docker, SQL client(s)]
   - [Node.js, npm] (for some LSP/formatter tools)

## Configuration Structure
- `init.lua` — entry point, loads all modules
- `lua/custom/settings.lua` — core Neovim options
- `lua/custom/ui.lua` — UI tweaks
- `lua/custom/plugins/init.lua` — all plugins for lazy.nvim
- `lua/custom/keymaps.lua` — all <leader> mappings, grouped and described
- `lua/custom/lsp.lua`, `treesitter.lua`, `null-ls.lua`, `repl.lua`, `test-debug.lua`, `docker.lua`, `sql.lua`, `uv_python.lua` — language/workflow modules

## Philosophy
- **Minimal**: Only essential plugins and settings for fast startup and low memory
- **DRY**: No duplicated logic or mappings
- **Performance**: Lazy loading, async, and optimized plugin/event triggers
- **Clarity**: All mappings and groups are clearly described in which-key

## Extending
- Add new plugins to `lua/custom/plugins/init.lua`
- Add new mappings to `lua/custom/keymaps.lua`
- Add/extend language support in the relevant module

## Keymaps
See `lua/custom/keymaps.lua` for all <leader> mappings, grouped by workflow (File, Git, LSP, REPL, Test, Debug, Docker, SQL, Python, etc.)

## Python Project Management
See `INSTALL.md` for full details on uv.nvim integration and Python project workflow.

---

**Enjoy your fast, minimalist Neovim setup!**
