# Neovim Keybindings Reference

This document provides a comprehensive overview of all keybindings in the configuration, organized by namespace according to MECE (Mutually Exclusive, Collectively Exhaustive) principles.

## Navigation

- `<C-h>` - Move to left window
- `<C-j>` - Move to window below
- `<C-k>` - Move to window above
- `<C-l>` - Move to right window
- `jk` - Exit insert mode (alternative to Escape)

## Leader Key

The leader key is set to `<Space>`. All other keybindings are organized under this leader key in logical namespaces.

## Terminal Operations (`<leader>t`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>tt`     | Toggle terminal               | Toggle horizontal terminal                  |
| `<leader>tf`     | Floating terminal             | Toggle floating terminal                    |
| `<leader>tv`     | Vertical terminal             | Toggle vertical terminal                    |
| `<leader>ts`     | Smart terminal                | Smart terminal with venv activation         |
| `<leader>tp`     | Python terminal               | Open Python REPL                            |
| `<leader>ti`     | IPython terminal              | Open IPython terminal                       |
| `<leader>tr`     | Run Python file               | Run current Python file                     |
| `<leader>td`     | Docker terminal               | Open Docker terminal                        |
| `<leader>tb`     | Database terminal             | Open database client terminal               |

## Buffer Operations (`<leader>b`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>bd`     | Delete buffer                 | Close the current buffer                    |
| `<leader>bn`     | Next buffer                   | Switch to the next buffer                   |
| `<leader>bp`     | Previous buffer               | Switch to the previous buffer               |
| `<leader>ba`     | Close all buffers             | Close all open buffers                      |
| `<leader>bs`     | Save buffer                   | Save the current buffer                     |
| `<leader>bw`     | Save and close buffer         | Save and close the current buffer           |
| `<leader>bl`     | List buffers                  | Show a list of all open buffers             |
| `<leader>bf`     | Format buffer                 | Format the current buffer                   |
| `<leader>bc`     | Close other buffers           | Close all buffers except current            |

## File Explorer (`<leader>e`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>e`      | Toggle explorer               | Open/close the file explorer                |
| `<leader>ef`     | Focus explorer                | Focus on the file explorer                  |
| `<leader>ee`     | Refresh explorer              | Refresh the file explorer                   |
| `<leader>ec`     | Collapse all folders          | Collapse all open folders in explorer       |

## Find/Search Operations (`<leader>f`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>ff`     | Find files                    | Search for files by name                    |
| `<leader>fg`     | Find text                     | Search for text in files (grep)             |
| `<leader>fb`     | Find buffers                  | Search through open buffers                 |
| `<leader>fh`     | Find help                     | Search through help topics                  |
| `<leader>fr`     | Find recent files             | Show recently used files                    |
| `<leader>fs`     | Find string                   | Search for a string in current buffer       |
| `<leader>fc`     | Find commands                 | Search through available commands           |
| `<leader>fd`     | Find diagnostics              | Show current diagnostics                    |
| `<leader>fi`     | Find symbols                  | Show document symbols                       |

## Python/Environment/Dependencies (`<leader>p`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>pa`     | Activate environment          | Activate a Python virtual environment       |
| `<leader>ps`     | Select environment            | Select a Python virtual environment         |
| `<leader>pc`     | Select cached environment     | Select a previously used environment        |
| `<leader>pn`     | Create new environment        | Create a new virtual environment            |
| `<leader>pi`     | Show environment info         | Display information about current env       |
| `<leader>pr`     | Run with environment          | Run current file with active env            |
| `<leader>pe`     | Execute selection             | Execute selected Python code                |
| `<leader>pp`     | Run in IPython                | Run selected code in IPython                |
| `<leader>pnf`    | New Python file               | Create a new Python file                    |
| `<leader>pt`     | Run Python tests              | Run Python tests                            |
| `<leader>pg`     | Generate requirements         | Generate requirements.txt from Poetry       |
| `<leader>pb`     | Build Poetry package          | Build a Poetry package                      |
| `<leader>ppub`   | Publish Poetry package        | Publish a Poetry package                    |
| `<leader>psh`    | Poetry shell                  | Start a Poetry shell                        |
| `<leader>ped`    | Edit pyproject.toml           | Edit the pyproject.toml file                |
| `<leader>prun`   | Poetry run command            | Run a command with Poetry                   |
| `<leader>prq`    | Edit requirements.txt         | Edit the requirements.txt file              |
| `<leader>pinst`  | Install requirements          | Install from requirements.txt               |

## Harpoon (`<leader>h`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>ha`     | Add file                      | Add file to Harpoon                         |
| `<leader>hh`     | Toggle menu                   | Toggle Harpoon menu                         |
| `<leader>h1`     | Jump to file 1                | Jump to first Harpoon file                  |
| `<leader>h2`     | Jump to file 2                | Jump to second Harpoon file                 |
| `<leader>h3`     | Jump to file 3                | Jump to third Harpoon file                  |
| `<leader>h4`     | Jump to file 4                | Jump to fourth Harpoon file                 |

## Git Operations (`<leader>g`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>gg`     | LazyGit                       | Open LazyGit interface                      |
| `<leader>gc`     | Git commit                    | Create a new Git commit                     |
| `<leader>gp`     | Git push                      | Push to remote repository                   |
| `<leader>gl`     | Git log                       | Show Git commit log                         |
| `<leader>gb`     | Git blame                     | Show Git blame for current file             |
| `<leader>gd`     | Git diff                      | Show Git diff for current file              |
| `<leader>gs`     | Git status                    | Show Git status                             |
| `<leader>gr`     | Git reset                     | Reset current file to last commit           |
| `<leader>ga`     | Git stage file                | Stage the current file                      |
| `<leader>gu`     | Git unstage file              | Unstage the current file                    |
| `<leader>gh`     | Git history                   | Show file history                           |
| `<leader>gf`     | Git fetch                     | Fetch from remote                           |
| `<leader>gC`     | Git checkout                  | Checkout a branch                           |
| `<leader>gB`     | Git branches                  | Show all branches                           |

## Documentation/Help (`<leader>d`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>do`     | Toggle documentation          | Toggle documentation panel                  |
| `<leader>dO`     | Open in buffer                | Open documentation in buffer                |
| `<leader>df`     | Fetch index                   | Fetch documentation index                   |
| `<leader>di`     | Install documentation         | Install documentation                       |
| `<leader>du`     | Update documentation          | Update documentation                        |
| `<leader>dU`     | Update all                    | Update all documentation                    |
| `<leader>dh`     | Search documentation          | Search in documentation                     |
| `<leader>dm`     | Browse ML docs                | Browse Machine Learning documentation       |
| `<leader>dmk`    | scikit-learn docs             | Open scikit-learn documentation             |
| `<leader>dmn`    | NumPy docs                    | Open NumPy documentation                    |
| `<leader>dmp`    | Pandas docs                   | Open Pandas documentation                   |
| `<leader>dmt`    | TensorFlow docs               | Open TensorFlow documentation               |
| `<leader>dmy`    | PyTorch docs                  | Open PyTorch documentation                  |
| `<leader>dmm`    | Matplotlib docs               | Open Matplotlib documentation               |

## Code/LSP Operations (`<leader>c`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>cf`     | Format code                   | Format current buffer                       |
| `<leader>ca`     | Code actions                  | Show available code actions                 |
| `<leader>cr`     | Rename symbol                 | Rename the symbol under cursor              |
| `<leader>cd`     | Show diagnostics              | Show diagnostics for current line           |
| `<leader>cD`     | All diagnostics               | Show all diagnostics                        |
| `<leader>ci`     | Organize imports              | Organize imports in current file            |
| `<leader>cs`     | Document symbols              | Show document symbols                       |
| `<leader>cS`     | Workspace symbols             | Show workspace symbols                      |

## Window/Tab Operations (`<leader>w`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>wv`     | Split vertically              | Split window vertically                     |
| `<leader>wh`     | Split horizontally            | Split window horizontally                   |
| `<leader>we`     | Equal size                    | Make split windows equal size               |
| `<leader>wx`     | Close split                   | Close current split                         |
| `<leader>wq`     | Quit window                   | Quit current window                         |
| `<leader>wQ`     | Quit all                      | Quit all windows                            |
| `<leader>wL`     | Increase width                | Increase window width                       |
| `<leader>wH`     | Decrease width                | Decrease window width                       |
| `<leader>wK`     | Increase height               | Increase window height                      |
| `<leader>wJ`     | Decrease height               | Decrease window height                      |
| `<leader>ww`     | Cycle windows                 | Cycle through windows                       |
| `<leader>wp`     | Previous window               | Go to previous window                       |
| `<leader>wo`     | Only                          | Close all other windows                     |
| `<leader>wt`     | Move to tab                   | Move window to new tab                      |
| `<leader>w=`     | Equalize                      | Equalize window sizes                       |
| `<leader>ws`     | Split horizontal              | Split window horizontally                   |
| `<leader>wn`     | New tab                       | Create a new tab                            |
| `<leader>wc`     | Close tab                     | Close current tab                           |
| `<leader>wo`     | Close other tabs              | Close all other tabs                        |
| `<leader>wl`     | Next tab                      | Go to next tab                              |
| `<leader>wj`     | Previous tab                  | Go to previous tab                          |

*Note: Non-leader window navigation uses `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` for left, down, up, right.*

## Undotree (`<leader>u`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>u`      | Toggle Undotree               | Toggle the Undotree panel                   |

## Keymaps (`<leader>k`, `<leader>?`)

| Keybinding       | Action                        | Description                                 |
|------------------|-------------------------------|---------------------------------------------|
| `<leader>k`      | Show keybindings              | Show all keybindings (which-key)            |
| `<leader>?`      | Show keymaps                  | Show searchable keymaps                     |

## ADHD-Friendly Theme Command

| Command             | Action                        | Description                                 |
|---------------------|-------------------------------|---------------------------------------------|
| `:ApplyADHDTheme`   | Apply ADHD theme              | Apply the ADHD-friendly color theme         |
| `:KeybindLog`       | Show keybind log              | Show log of keybinding errors and warnings  |
