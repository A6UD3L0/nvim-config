# Contributing to Neovim Configuration

Thank you for your interest in contributing to this Neovim configuration! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Development Workflow](#development-workflow)
- [Coding Style](#coding-style)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. Help create a positive and inclusive environment for everyone.

## Development Workflow

### Branching Strategy

- `main`: The production branch containing stable code
- `develop`: The development branch for integrating features
- `feature/*`: Feature branches for new functionality
- `fix/*`: Fix branches for bug fixes
- `refactor/*`: Refactoring branches for code improvements

Always create your branch from `develop` and submit pull requests back to `develop`.

### Environment Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git
   ```
3. Set up the upstream remote:
   ```bash
   git remote add upstream https://github.com/mainrepo/nvim-config.git
   ```
4. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Coding Style

### Lua Coding Standards

- Use 2 spaces for indentation
- Use snake_case for variables and functions
- Use PascalCase for modules and classes
- Keep line length to a maximum of 100 characters
- Add comments for complex logic
- Use local variables whenever possible
- Follow the existing module structure

### Documentation

- Document all public functions and modules
- Include examples where appropriate
- Update the README.md when adding significant features

## Plugin Management

When adding new plugins:

1. Ensure the plugin follows the lazy loading pattern
2. Add appropriate dependencies
3. Include reasonable default configuration
4. Verify the plugin works across different platforms
5. Ensure the plugin doesn't conflict with existing ones

## Testing

Before submitting changes:

1. Run `:checkhealth` to verify Neovim health
2. Test all modified functionality
3. Run the test suite:
   ```lua
   :lua require('core.tests').run_all()
   ```
4. Verify changes work on different Neovim versions (if possible)

## Submitting Changes

1. Commit your changes with meaningful commit messages
2. Push your branch to your fork
3. Submit a pull request to the `develop` branch
4. Include a description of the changes and any relevant issues addressed
5. Wait for reviews and address any feedback

## Adding Features

When adding new features:

1. Discuss major changes in an issue first
2. Follow the modular architecture patterns
3. Update or add tests for the new functionality
4. Update documentation to reflect changes
5. Ensure backward compatibility or provide migration instructions

Thank you for contributing to make this Neovim configuration better!
