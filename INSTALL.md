# INSTALL.md — Minimalist Modular Neovim Configuration

## 1. Backup & Migration

### Back Up Existing Neovim Config
```sh
mv ~/.config/nvim ~/.config/nvim_backup_$(date +%Y%m%d)
# For Windows:
ren %APPDATA%\nvim nvim_backup_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
```

### Export/Restore Old Settings
- To restore: move your backup back to `~/.config/nvim` or `%APPDATA%\nvim`.
- To merge: copy over select files (e.g. snippets, settings) into the new structure.

---

## 2. Repository Setup

### Clone the Repo
```sh
git clone https://github.com/A6UD3L0/nvim-config.git ~/.config/nvim
cd ~/.config/nvim
```

### Switch to Desired Branch
```sh
git checkout final   # or mainv4-ui-refactor, nvim-uv-python, etc.
```

---

## 3. Cross-Platform Prerequisites

### Linux (Ubuntu/Debian)
```sh
sudo apt update
sudo apt install -y neovim git ripgrep fd-find python3 python3-pip nodejs npm golang docker.io
# Symlink fd if needed:
ln -s $(which fdfind) ~/.local/bin/fd
```

### Fedora
```sh
sudo dnf install -y neovim git ripgrep fd-find python3 python3-pip nodejs npm golang docker
```

### macOS (Homebrew)
```sh
brew install neovim git ripgrep fd python3 node go docker luarocks
brew install --cask docker
# (Optional) For Lua lint/format:
brew install stylua
luarocks install luacheck
```

### Windows (WSL or Native)
- **WSL**: Use Ubuntu/Fedora steps above inside WSL.
- **Native**:
  - [Install Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows)
  - [Install Scoop](https://scoop.sh/) or [Chocolatey](https://chocolatey.org/)
  - With Scoop:
    ```powershell
    scoop install neovim git ripgrep fd python nodejs go
    scoop install docker
    ```
  - With Chocolatey:
    ```powershell
    choco install neovim git ripgrep fd python nodejs golang docker-desktop
    ```
- **Clipboard**: Install [win32yank](https://github.com/equalsraf/win32yank) for clipboard support.

### Environment Variables & Shell Tweaks
- Ensure `$PATH` includes nvim, python, go, node, docker, etc.
- For Docker: Add user to `docker` group (`sudo usermod -aG docker $USER`), then log out/in.
- For Python: Use [uv](https://github.com/astral-sh/uv) for project management.

---

## 4. Plugin Manager Bootstrapping
- On first launch, `init.lua` will auto-install [lazy.nvim](https://github.com/folke/lazy.nvim).
- To sync plugins manually:
  ```sh
  nvim
  :Lazy sync
  :Mason
  :MasonInstallAll
  ```
- Use `:Mason` to install LSP servers, formatters, and DAPs as needed.

---

## 5. Configuration Activation

### Standard Location
- **Linux/macOS**: `~/.config/nvim`
- **Windows**: `%APPDATA%\nvim`

### Alternative: Launch with Custom Path
```sh
nvim -u /path/to/your/repo/init.lua
```

---

## 6. Post-Install Checks

### Health Checks
```sh
nvim --headless -c "checkhealth" -c "quit"
```
- Or in Neovim:
  - `:checkhealth`
  - Check for: core, LSP, Treesitter, which-key, uv.nvim

### Troubleshooting
- If a plugin or parser is missing, run `:Lazy sync` or `:TSInstall <lang>`.
- For LSP issues, use `:Mason` and ensure all servers are installed.
- For Python/uv: ensure `uv` is in your PATH and a `.venv` or `pyproject.toml` exists in your project.

---

## 7. Usage & Getting Started

### Launch Neovim
```sh
nvim
```

### Discover Keymaps
- Press `<leader>?` or `<leader>` to see available mappings (which-key).
- All mappings are grouped by workflow: File, Git, LSP, REPL, Test, Debug, Docker, SQL, Python/uv, Tabs, etc.

### Documentation
- See `README.md` for config structure and features.
- See `lua/custom/whichkey_mece.lua` for keymap groups.
- See language/workflow modules in `lua/custom/` for specific integrations (REPL, test, debug, Docker, SQL, uv.nvim).

---

## 8. Platform-Specific Notes

### Windows
- **WSL**: Use Linux install instructions; symlink config to `/mnt/c/Users/<User>/AppData/Local/nvim` if needed.
- **Clipboard**: Install [win32yank](https://github.com/equalsraf/win32yank) and set up Neovim clipboard provider.
- **Python/Go**: Use official installers or Scoop/Chocolatey.
- **Docker**: Use Docker Desktop for Windows.
- **Path Handling**: Use forward slashes or double backslashes in config paths.

### macOS
- Use Homebrew for all dependencies.
- For Python/Go: `brew install python3 go`
- For Docker: `brew install --cask docker`

### Linux
- Use APT/Yum/DNF for dependencies.
- For Docker: Add user to `docker` group and restart session.
- For clipboard: Install `xclip` or `wl-clipboard` if needed.

---

## 9. Updating & Maintenance

### Pull Latest Changes
```sh
git pull origin final
```

### Update Plugins & LSPs
- In Neovim:
  - `:Lazy update`
  - `:Mason` → update or install new servers

### Test New Branches Safely
```sh
git checkout -b my-feature
# Make changes, test, and merge as needed
```
- Always back up your config before major changes.

---

**For help, see the README, open an issue, or join the Neovim community!**
