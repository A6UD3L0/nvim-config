# Neovim Configuration

A modern, modular Neovim configuration designed for Python development with a focus on maintainability, performance, and user experience.

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=flat-square&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-%232C2D72.svg?style=flat-square&logo=lua&logoColor=white)
![Python](https://img.shields.io/badge/Python-%233776AB.svg?style=flat-square&logo=python&logoColor=white)

## Overview

This Neovim configuration provides a comprehensive development environment with a focus on Python development. It features a modular architecture with clear separation of concerns, centralized LSP configuration, unified keybinding system, and a plugin architecture that optimizes startup time and performance.

## Features

- **Modular Architecture**: MECE (Mutually Exclusive, Collectively Exhaustive) design with clear separation of concerns
- **Centralized LSP Configuration**: Standardized language server setup with per-language configuration modules
- **Unified Keybinding System**: Consistent key mappings with which-key integration
- **Python Development Environment**: First-class support for Python with uv.nvim integration
- **Event System**: Robust event management for extensibility
- **Plugin System**: Clean plugin organization with lazy-loading for better startup performance
- **Testing Framework**: Automated testing for configuration validation

## Quick Start

### Installation

See [INSTALL.md](./INSTALL.md) for detailed platform-specific installation instructions.

```bash
# Backup your existing configuration (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim

# Start Neovim to install plugins
nvim
```

### Key Mappings

The complete key mapping reference is available in [KEYMAPS.md](./KEYMAPS.md).

Basic mappings to get started:
- `<Space>` - Leader key
- `<Space>f` - File operations 
- `<Space>e` - Text editing
- `<Space>p` - Python tools
- `<Space>g` - Git operations
- `<Space>l` - LSP functions

## Directory Structure

```
nvim-config/
├── lua/
│   ├── core/                      # Core functionality
│   │   ├── keybindings/           # Key mapping modules
│   │   ├── lsp/                   # LSP configuration
│   │   │   └── servers/           # Server configurations
│   │   ├── utils/                 # Utility functions
│   │   ├── events.lua             # Event management system
│   │   ├── plugin_system.lua      # Plugin architecture
│   │   ├── schema.lua             # Configuration schema validation
│   │   ├── settings.lua           # Settings management
│   │   └── tests/                 # Testing framework
│   ├── plugins/                   # Domain-specific plugins
│   │   └── python.lua             # Python tooling integration
│   └── plugins.lua                # Main plugin definitions
├── CHANGELOG.md                   # Version history and changes
├── CONTRIBUTING.md                # Contribution guidelines
├── INSTALL.md                     # Installation instructions
├── KEYMAPS.md                     # Keybinding reference
├── README.md                      # This file
└── init.lua                       # Neovim entry point
```

## Python Development

This configuration provides a seamless Python development experience:

- **Virtual Environment Management**: Automatic detection and activation
- **Dependency Management**: Install, update, and manage packages with uv.nvim
- **LSP Integration**: Enhanced code intelligence with Pyright and Ruff
- **Testing Framework**: Pytest integration with visual feedback

```lua
-- Example: Managing Python environments
<Space>pe  -- Activate virtual environment
<Space>pi  -- Show environment info
<Space>pp  -- Install package
<Space>pr  -- Run current file
```

## Customization

The configuration is designed to be easily customizable:

1. **Plugins**: Edit `lua/plugins.lua` to add or remove plugins
2. **Keybindings**: Modify files in `lua/core/keybindings/` for custom key mappings
3. **LSP Servers**: Configure language servers in `lua/core/lsp/servers/`
4. **Settings**: Adjust global settings in `lua/core/settings.lua`

## Health Check

Run `:checkhealth` to identify any issues with your installation. Common issues and solutions are documented in [INSTALL.md](./INSTALL.md#troubleshooting).

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on how to contribute to this project.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for a detailed list of changes in each version.

## License

MIT