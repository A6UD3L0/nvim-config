# 💤 Neovim Config (Cross-Platform)

A modern, batteries-included Neovim configuration for developers who want a fast, extensible, and beautiful editing experience. This setup is cross-platform (macOS, Linux, Windows/WSL) and features first-class LSP, DAP, Treesitter, Telescope, Lazy, Harpoon, uv, and more.

---

## ✨ Features
- **LSP**: Out-of-the-box Language Server Protocol support
- **DAP**: Debug Adapter Protocol integration
- **Treesitter**: Syntax highlighting & code navigation
- **Telescope**: Fuzzy finding for files, text, buffers, etc.
- **Lazy.nvim**: Fast, lazy-loaded plugin manager
- **Harpoon**: Quick file navigation/bookmarking
- **uv**: Python project management (with virtualenv auto-activation)
- **ToggleTerm**: Integrated terminal
- **Git**: LazyGit integration & native commands
- **Formatters & Linters**: null-ls, mason-null-ls, and more
- **Beautiful UI**: WhichKey, Noice, custom icons, and Nerd Font support

---

## 🚦 Prerequisites

### Universal
- **Neovim**: v0.9.0+ (recommended: latest stable)
- **Git**
- **Node.js** (v16+)
- **Python 3** + `pip`
- **Go** (for some LSPs/tools)
- **ripgrep** (`rg`)
- **fd**
- **lazygit**
- **Nerd Font** (e.g., JetBrains Mono Nerd Font, FiraCode Nerd Font)

### macOS
- [Homebrew](https://brew.sh/)

### Linux (Ubuntu/Debian)
- `apt`, `curl`, `wget`, `snap` (optional)

### Windows
- [WSL2](https://docs.microsoft.com/en-us/windows/wsl/) (recommended)
- [Chocolatey](https://chocolatey.org/) or [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Nerd Font](https://www.nerdfonts.com/font-downloads)

---

## ⚡️ Installation

### 1. Install Dependencies

#### macOS (Homebrew)
```bash
brew install neovim git node python3 go ripgrep fd lazygit
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y neovim git nodejs npm python3 python3-pip golang-go ripgrep fd-find lazygit fonts-jetbrains-mono
# fd binary is 'fdfind' on Ubuntu, symlink for compatibility:
sudo ln -s $(which fdfind) /usr/local/bin/fd || true
```

#### Windows (WSL)
```bash
# In Ubuntu WSL terminal
sudo apt update
sudo apt install -y neovim git nodejs npm python3 python3-pip golang-go ripgrep fd-find lazygit fonts-jetbrains-mono
sudo ln -s $(which fdfind) /usr/local/bin/fd || true
```

#### Windows (Native)
- Install [Neovim](https://github.com/neovim/neovim/releases/latest)
- [Git for Windows](https://git-scm.com/)
- [Node.js](https://nodejs.org/)
- [Python](https://www.python.org/)
- [Go](https://go.dev/dl/)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [fd](https://github.com/sharkdp/fd/releases)
- [lazygit](https://github.com/jesseduffield/lazygit/releases)
- [Nerd Font](https://www.nerdfonts.com/font-downloads)

You can also use [Chocolatey](https://chocolatey.org/) or [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/):
```powershell
choco install neovim git nodejs python golang ripgrep fd lazygit
# Or
winget install Neovim.Neovim Git.Git OpenJS.NodeJS Python.Python.3 GoLang.Go ripgrep.fd lazygit.lazygit
```

### 2. Clone This Config

```bash
git clone https://github.com/YOURUSERNAME/nvim-config.git ~/.config/nvim
```
- On Windows native: `%USERPROFILE%\AppData\Local\nvim`

### 3. Launch Neovim
```bash
nvim
```
- Plugins will auto-install via Lazy.nvim on first launch.

---

## 🔧 Initial Setup Commands

### Python & Node Providers
```bash
pip3 install --user pynvim
npm install -g neovim
```

### Go LSP (if using Go)
```bash
go install golang.org/x/tools/gopls@latest
```

### Check Health
Open Neovim and run:
```
:checkhealth
```
- Follow any instructions to resolve missing providers.

---

## ⌨️ Keymaps (MECE)

### <leader>f – File & Search
- `<leader>ff` – Find Files (Telescope)
- `<leader>fg` – Live Grep (Telescope)
- `<leader>fb` – Buffers (Telescope)
- `<leader>fh` – Help Tags (Telescope)
- `<leader>fe` – File Explorer (NvimTree)
- `<leader>fr` – Recent Files (Telescope)
- `<leader>fk` – Keymaps (Telescope)

### <leader>g – Git
- `<leader>gs` – Status (LazyGit)
- `<leader>gc` – Commit

### <leader>l – LSP
- `<leader>ld` – Goto Definition
- `<leader>lh` – Hover Documentation
- `<leader>lr` – Restart LSP
- `<leader>lR` – Rename
- `<leader>la` – Code Action
- `<leader>lf` – Format
- `<leader>le` – Diagnostics
- `<leader>ln` – Next Diagnostic
- `<leader>lp` – Prev Diagnostic

### <leader>h – Harpoon
- `<leader>ha` – Add File
- `<leader>hm` – Menu
- `<leader>hn` – Next
- `<leader>hp` – Prev
- `<leader>h1`/`h2`/`h3`/`h4` – Nav File 1-4

### <leader>b – Buffers
- `<leader>bn` – New Buffer
- `<leader>bx` – Close Buffer
- `<leader>bl` – List Buffers
- `<leader>bp` – Prev Buffer
- `<leader>bN` – Next Buffer

### <leader>u – Undo/History
- `<leader>uu` – Toggle UndoTree

### <leader>d – Folds
- `<leader>do` – Open All Folds
- `<leader>dc` – Close All Folds
- `<leader>dn` – Open Fold
- `<leader>dm` – Close Fold

### <leader>P – Python/Project (uv)
- `<leader>Pi` – Init Project
- `<leader>Pa` – Add Dependency
- `<leader>Pr` – Run Project Command
- `<leader>Pl` – Lock Dependencies
- `<leader>Ps` – Sync Project
- `<leader>Pv` – Set Python Version
- `<leader>Pp` – Pin Python Version
- `<leader>Pt` – Install Tool
- `<leader>Px` – Run Tool (uvx)

### <leader>t – Terminal (ToggleTerm)
- `<leader>tt` – Toggle Horizontal Terminal
- `<leader>tv` – Toggle Vertical Terminal
- `<leader>tf` – Toggle Floating Terminal

### <leader>x – Misc/Utilities
- `<leader>xs` – Substitute Word
- `<leader>xc` – Cellular Automaton (make it rain)
- `<leader>xS` – Source File

### <leader>d – Debug (DAP)
- `<leader>ds` – Start/Continue Debug
- `<leader>di` – Step Into
- `<leader>do` – Step Over
- `<leader>du` – Step Out
- `<leader>db` – Toggle Breakpoint
- `<leader>dB` – Set Conditional Breakpoint
- `<leader>dr` – Open REPL
- `<leader>dl` – Run Last Debug
- `<leader>dt` – Toggle DAP UI
- `<leader>de` – Eval Expression
- `<leader>dc` – Clear Breakpoints

---

## 🖼️ Screenshots

![Telescope Fuzzy Finder](https://raw.githubusercontent.com/YOURUSERNAME/nvim-config/main/screenshots/telescope.png)
![LSP Hover](https://raw.githubusercontent.com/YOURUSERNAME/nvim-config/main/screenshots/lsp-hover.png)

---

## 🛠 Troubleshooting & FAQ

- **LSP not working**: Check `:checkhealth` and ensure all language servers are installed.
- **Treesitter compile error**: Ensure you have a C compiler (e.g., `build-essential` on Linux, Xcode CLT on macOS).
- **Windows shell issues**: Use WSL for best results; ensure your fonts are patched and terminal supports Nerd Fonts.
- **Python provider errors**: Run `pip3 install --user pynvim` and restart Neovim.
- **Missing icons**: Install a Nerd Font and set it in your terminal.
- **Plugin install issues**: Delete `~/.local/share/nvim` and restart Neovim to force plugin reinstall.

---

## 🙏 Credits
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [ThePrimeagen's nvim config](https://github.com/ThePrimeagen/init.lua)
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [benomahony/uv.nvim](https://github.com/benomahony/uv.nvim)
- ...and all plugin authors!

---

> _Happy hacking!_ 🥷
