# Neovim Configuration Structure

This document provides a detailed overview of how this Neovim configuration is structured, making it easier to understand and customize.

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/                     # Lua modules
│   ├── plugins/             # Plugin specifications
│   │   ├── init.lua         # Core plugins
│   │   ├── completion.lua   # Completion plugins (nvim-cmp)
│   │   ├── copilot.lua      # GitHub Copilot integration
│   │   ├── dev_tools.lua    # LSP and development tools
│   │   └── datascience.lua  # Data science specific plugins
│   ├── configs/             # Plugin configurations
│   │   ├── lspconfig.lua    # LSP settings
│   │   ├── lazy.lua         # Lazy.nvim settings
│   │   ├── commands.lua     # Custom commands
│   │   ├── conform.lua      # Formatter settings
│   │   ├── copilot_patches.lua # Fixes for deprecated APIs
│   │   └── dap/             # Debugging configurations
│   ├── keytrainer/          # Custom key training module
│   ├── chadrc.lua           # UI configuration inspired by NvChad
│   ├── mappings.lua         # All keybindings
│   └── options.lua          # Neovim options and settings
└── README.md                # Documentation
```

## Core Components

### 1. Plugin Management

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management, which offers:

- Lazy-loading plugins for faster startup
- Automatic plugin installation
- Dependency management
- Plugin configuration

Lazy.nvim is initialized in `init.lua` and configured in `configs/lazy.lua`.

### 2. Key Mapping System

Keybindings are set up in `mappings.lua` using which-key for discovery:

- Leader key is set to Space
- Press `<leader><leader>` (Space+Space) to see all available commands
- Keybindings are organized by functionality (files, LSP, Git, etc.)

### 3. LSP Configuration

Language Server Protocol support is configured in `configs/lspconfig.lua`:

- Mason.nvim handles automatic installation of language servers
- Each language has specific LSP settings
- Includes custom on_attach function for keybindings

### 4. Completion Engine

The completion system is in `plugins/completion.lua`:

- Nvim-cmp as the main completion engine
- Sources include LSP, buffer, path, snippets, and Copilot
- LuaSnip for snippet support
- Custom keybindings for completion navigation

### 5. UI and Themes

UI elements are configured in `chadrc.lua`:

- Theme selection and configuration
- Status line (lualine)
- Buffer line
- Nvim-tree for file navigation
- Icons and visual elements

## Backend Development Support

This configuration specifically targets backend development with:

### Languages

- **Python**: LSP, formatting, linting, debugging, and test running
- **Go**: LSP, formatting, testing, and debugging
- **C/C++**: LSP and debugging
- **SQL**: LSP and formatting
- **Lua**: LSP and formatting

### Tools

- **Git**: Integration with fugitive and gitsigns
- **Docker**: Syntax highlighting and commands
- **Terminal**: Integrated terminal and command running
- **Debugging**: DAP for various languages

## Customization Guide

### Adding New Plugins

To add a new plugin:

1. Create a new file in `lua/plugins/` directory or add to existing files
2. Use the lazy.nvim spec format:

```lua
return {
  {
    "author/plugin-name",
    dependencies = { "dependency1", "dependency2" },
    config = function()
      -- Configuration here
    end,
  }
}
```

3. Import your plugin file in `init.lua` if needed

### Modifying Keybindings

Edit `lua/mappings.lua` to change keybindings. Use the which-key format:

```lua
wk.register({
  mode = { "n", "v" },
  { "key", "command", desc = "Description" },
}, { prefix = "<leader>" })
```

### Changing LSP Settings

1. Find the language server in `configs/lspconfig.lua`
2. Modify the settings table for that server

### Adding Custom Commands

Edit `configs/commands.lua` to add new commands:

```lua
vim.api.nvim_create_user_command("CommandName", function(opts)
  -- Command functionality
end, {})
```

## Performance Considerations

This configuration is optimized for performance:

- Plugins are lazy-loaded when needed
- LSP servers are only started for relevant filetypes
- Treesitter parsers are installed on-demand
- UI elements are kept minimal

To check startup performance:
```
:Lazy profile
```

To disable features you don't need, simply comment out the related plugins in the appropriate files.
