# Neovim Python Project & Dev Environment

## Overview
A modular, portable Neovim configuration focused on Python development, modern plugin UX, and seamless project management with [UV](https://github.com/astral-sh/uv). Features:
- **MECE-structured leader-key mappings** (with which-key popups)
- **Full Python/UV workflow integration** (init, add, run, sync, lock, pin, tool install/run)
- **Intuitive plugin mappings** for file explorer, fuzzy finder, LSP, undo, bookmarks, folds, and more
- **Polished UI**: Clean, centered which-key popups with icons and readable layout
- **Portable**: Clone and use on any machine with minimal setup

---

## Prerequisites
- **Neovim**: v0.9+ (latest stable recommended)
- **Python**: 3.8+
- **UV**: [Install instructions](#install-uv)
- **git**, [ripgrep](https://github.com/BurntSushi/ripgrep), [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) for terminal integration (recommended)

---

## Installation

### 1. Clone the Repo
```sh
git clone <your-fork-url> ~/.config/nvim
cd ~/.config/nvim
git checkout docs/update  # or main/master if not using a docs branch
```

### 2. Install Plugins
Launch Neovim and run:
```
:Lazy sync
```

### 3. Check Health
```
:checkhealth
```
Resolve any missing dependencies.

---

## UV Python Workflow

**Project root is auto-detected** (by `.venv/`, `pyproject.toml`, or `.python-version`).

| Command                | Description                  |
|------------------------|------------------------------|
| `:UvInit <args>`       | Initialize a new UV project  |
| `:UvAdd <args>`        | Add dependencies             |
| `:UvRun <args>`        | Run a command in env         |
| `:UvLock`              | Lock dependencies            |
| `:UvSync`              | Sync dependencies            |
| `:UvPython <args>`     | Python management            |
| `:UvPin <args>`        | Pin Python version           |
| `:UvToolInstall <args>`| Install tool (e.g. black)    |
| `:Uvx <args>`          | Run tool with uvx            |

**Example:**
```vim
:UvInit myproj
:UvAdd ruff
:UvRun ruff check
:UvLock
:UvSync
:UvPython install 3.11
:UvPin 3.11
:UvToolInstall black
:Uvx black --version
```

---

## Keybinding Summary

### Which-Key Groups (all under `<leader>`)
| Prefix | Group         | Example Mappings                          |
|--------|--------------|-------------------------------------------|
| P      | Python/Proj  | `Pi` Init, `Pa` Add, `Pr` Run, ...        |
| e      | Explorer     | `ee` Toggle, `ef` Focus                   |
| s      | Search       | `sf` Files, `sg` Grep, `sb` Buffers, ...  |
| b      | Buffers      | `bn` New, `bx` Close, `bl` List           |
| u      | Undo         | `uu` Toggle UndoTree                      |
| h      | Harpoon      | `ha` Add, `hm` Menu, `hn` Next, ...       |
| l      | LSP          | `lr` Restart, `ld` Def, `lk` Hover, ...   |
| f      | Folds        | `fo` Open all, `fc` Close all             |
| x      | Misc         | `xs` Substitute, `xc` Cellular, `xS` Src  |

### Core Plugin Mappings
- **File Explorer:** `<leader>ee` (toggle), `<leader>ef` (focus)
- **Fuzzy Finder:** `<leader>sf` (files), `<leader>sg` (grep), ...
- **UndoTree:** `<leader>uu`
- **Harpoon:** `<leader>ha`, `<leader>hm`, ...
- **LSP:** `<leader>ld` (definition), `<leader>lr` (restart), ...
- **Folds:** `<leader>fo`, `<leader>fc`, ...

---

## Troubleshooting
- **Plugin not found:** Run `:Lazy sync` and restart Neovim.
- **UV not found:** Ensure `uv` is installed and in your `PATH`.
- **Terminal commands:** Ensure `toggleterm.nvim` is installed for UV commands.
- **Keymaps not working:** Confirm `require('custom.remap')` and `require('custom.whichkey_mece')` are loaded in your `init.lua`.

---

## Links & References
- [custom/remap.lua](lua/custom/remap.lua)
- [custom/whichkey_mece.lua](lua/custom/whichkey_mece.lua)
- [custom/plugins/init.lua](lua/custom/plugins/init.lua)
- [INSTALL.md](INSTALL.md)
- [UV](https://github.com/astral-sh/uv)
- [Neovim](https://neovim.io/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [which-key.nvim](https://github.com/folke/which-key.nvim)

---

## Install UV

### macOS/Linux (Homebrew or pipx)
```sh
brew install astral-sh/uv/uv
# or
pipx install uv
```

### Windows (PowerShell)
```powershell
pipx install uv
```

---

Happy hacking!
