# Minimalist Modular Neovim Config for Python, C, Go, SQL, Docker, and ML

This Neovim configuration is designed for high-performance, minimalism, and a clean, modern UI/UX. It is modular, DRY, and optimized for programming in Python, C, Go, SQL, Docker, and machine learning workflows.

## Features
- **Minimal, modular Lua config**: All settings and plugins are organized in `lua/custom/` modules.
- **Single source of truth for keymaps**: All `<leader>` mappings are consolidated in `lua/custom/whichkey_mece.lua` using which-key (MECE, mnemonic, non-overlapping).
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
2. **Install system dependencies:**
   - [ripgrep](https://github.com/BurntSushi/ripgrep)
   - [fd](https://github.com/sharkdp/fd)
   - [python3, pip, uv](https://github.com/astral-sh/uv)
   - [Go, Docker, SQL client(s)]
   - [Node.js, npm] (for some LSP/formatter tools)
   - [luarocks, luacheck, stylua] (for linting/formatting Lua, optional)
   - [busted] (for Lua tests, optional)
3. **Open Neovim:**
   ```sh
   nvim
   ```
   The config will bootstrap itself and install `lazy.nvim` and all plugins.

## Configuration Structure
- `init.lua` — entry point, loads all modules
- `lua/custom/settings.lua` — core Neovim options
- `lua/custom/ui.lua` — UI tweaks
- `lua/custom/plugins/init.lua` — all plugins for lazy.nvim
- `lua/custom/whichkey_mece.lua` — all <leader> mappings, grouped and described (MECE)
- `lua/custom/lsp.lua`, `treesitter.lua`, `null-ls.lua`, `repl.lua`, `test-debug.lua`, `docker.lua`, `sql.lua`, `uv_python.lua` — language/workflow modules

## Branches
- **mainv4-ui-refactor**: Ongoing main config development
- **nvim-uv-python**: Python/uv integration branch
- **final**: Stable, production-ready config (this branch)

## Philosophy
- **Minimal**: Only essential plugins and settings for fast startup and low memory
- **DRY**: No duplicated logic or mappings
- **MECE**: Keymaps are Mutually Exclusive, Collectively Exhaustive, mnemonic, and non-overlapping
- **Extensible**: Easy to add new language/workflow modules

## Updating & Contributing
- To update plugins: `:Lazy update`
- To lint/format Lua: `luacheck lua/custom/` and `stylua lua/custom/`
- To run tests: `busted ./lua/custom` (if present)

## Credits
- Inspired by Kickstart.nvim, LazyVim, and the Neovim community.

---

**For issues, feature requests, or questions, please open an issue or PR on GitHub.**
