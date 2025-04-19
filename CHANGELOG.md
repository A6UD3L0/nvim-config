# Changelog

All notable changes to this Neovim configuration will be documented in this file.

## [1.0.0] - 2025-04-19

### Major Refactoring and Architecture Changes

#### Added
- Modular architecture with MECE (Mutually Exclusive, Collectively Exhaustive) design
- Centralized LSP configuration system with per-language server modules
- Unified keybinding system with domain-specific mapping files
- Python development environment with uv.nvim integration
- Event system for plugin-to-plugin communication
- Comprehensive settings management with validation
- Testing framework for configuration validation

#### Changed
- Migrated from multiple disconnected config files to structured core modules
- Reorganized plugin definitions with proper lazy-loading
- Standardized plugin checking with utilities
- Simplified keybinding interface with which-key integration
- Enhanced LSP configuration with diagnostics and server-specific options

#### Removed
- Deprecated the old `mappings.lua` in favor of the new keybinding system
- Removed the entire `config/` directory with its disconnected configuration files
- Eliminated duplicate configuration logic
- Removed outdated which-key setup
- Archived experimental and temporary files

#### Fixed
- Fixed Telescope error with 'User TelescopeFindPre' event
- Resolved which-key warnings by updating to the correct mapping format
- Fixed errors with invalid plugin specifications
- Improved consistency in keybinding definitions
- Enhanced error handling and fallbacks

## [0.9.0] - Prior to Refactoring

### Initial Configuration

- Basic Neovim configuration with various plugins
- Support for Python development
- LSP integration with different language servers
- Keybinding system with which-key
- Various utility plugins for improving workflow
