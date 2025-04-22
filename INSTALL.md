# Python Project Management with UV in Neovim

This configuration integrates [UV](https://github.com/astral-sh/uv) into Neovim for seamless Python project management.

## Project Root Detection
- UV integration auto-detects a project root by searching for `.venv/`, `pyproject.toml`, or `.python-version`.

## User Commands
The following Vim commands are available (executed via a terminal, requires `toggleterm.nvim` or equivalent):

```
:UvInit <args>         # Initialize a new UV project
:UvAdd <args>          # Add one or more dependencies
:UvRun <args>          # Run a command in the UV environment
:UvLock                # Lock dependencies
:UvSync                # Sync dependencies
:UvPython <args>       # Run 'uv python <args>'
:UvPin <args>          # Pin a Python version
:UvToolInstall <args>  # Install a tool (e.g. black, ruff)
:Uvx <args>            # Run a tool with uvx
```

## Keybindings
All common UV actions are mapped with `<leader>p` (project) and `<leader>t` (tool):

| Keybinding       | Command         | Description                  |
|------------------|----------------|------------------------------|
| `<leader>pi`     | :UvInit        | Initialize project           |
| `<leader>pa`     | :UvAdd         | Add dependencies             |
| `<leader>pr`     | :UvRun         | Run command in env           |
| `<leader>pl`     | :UvLock        | Lock dependencies            |
| `<leader>ps`     | :UvSync        | Sync dependencies            |
| `<leader>pp`     | :UvPython      | Python management            |
| `<leader>pv`     | :UvPin         | Pin Python version           |
| `<leader>ti`     | :UvToolInstall | Install tool                 |
| `<leader>tx`     | :Uvx           | Run tool with uvx            |

## Automatic VirtualEnv Activation
When you open a Python file, if a `.venv/` directory is found in the project root, it will be auto-activated for your shell session.

## Example Usage
```
:UvInit example
:UvAdd ruff
:UvRun ruff check
:UvLock
:UvSync
:UvPython install 3.11
:UvPin 3.11
:UvToolInstall black
:Uvx black --version
```

## Troubleshooting
- **UV not found:** Ensure `uv` is installed and available in your `PATH`.
- **ToggleTerm required:** These commands require a terminal integration such as `toggleterm.nvim`.
- **Virtualenv activation:** Only affects shell commands run from within Neovim, not external terminals.

## Installation Guide: UV for Python Project Management

### 1. Remove Previous UV Versions

Before installing a new version of UV, ensure any previous versions are removed:

- **macOS/Linux:**
  ```sh
  pipx uninstall uv || pip uninstall uv || brew uninstall uv || rm -rf $(which uv)
  ```
- **Windows (PowerShell):**
  ```powershell
  pipx uninstall uv; pip uninstall uv; Remove-Item (Get-Command uv).Source -Force
  ```

---

### 2. Install UV

#### macOS (Homebrew or pipx)
```sh
# Using Homebrew (recommended)
brew install astral-sh/uv/uv

# Or using pipx
pipx install uv
```

#### Linux (pipx or prebuilt binary)
```sh
# Using pipx
pipx install uv

# Or download a prebuilt binary from:
# https://github.com/astral-sh/uv/releases
# Then move it to a directory in your PATH, e.g.:
chmod +x uv-linux-x86_64
sudo mv uv-linux-x86_64 /usr/local/bin/uv
```

#### Windows (pipx or prebuilt binary)
```powershell
# Using pipx
pipx install uv

# Or download the Windows executable from:
# https://github.com/astral-sh/uv/releases
# Add the directory to your PATH if needed.
```

---

### 3. Verify Installation

After installation, check that UV is available:
```sh
uv --version
```
If this fails, ensure your PATH is set correctly and that you are not running an old version.

---

### 4. Neovim Requirements
- This configuration expects [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) or a similar terminal plugin for :TermExec.
- Python 3.7+ is recommended. Use `uv python install <version>` to manage Python versions.

---

### 5. Troubleshooting
- **UV not found:** Make sure the install directory is in your PATH and restart your terminal/editor.
- **Permission errors:** Try running your shell/editor as administrator or use `sudo` where appropriate.
- **Windows:** If you see execution policy errors, you may need to allow running scripts (`Set-ExecutionPolicy RemoteSigned`).

---
For more info, see the [UV documentation](https://github.com/astral-sh/uv).
