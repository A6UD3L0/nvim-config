#!/bin/bash
# Installation and validation script for Neovim configuration

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Neovim Ultimate Backend Development Configuration${NC}"
echo -e "${BLUE}=================================================${NC}"

# Check if neovim is installed
if command -v nvim >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Neovim is installed${NC}"
else
    echo -e "${RED}✗ Neovim is not installed${NC}"
    echo -e "${YELLOW}Please install Neovim first:${NC}"
    echo "  - macOS: brew install neovim"
    echo "  - Linux: Use your package manager or install from source"
    echo "  - Windows: Use scoop, chocolatey, or download from the official website"
    exit 1
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -n 1 | cut -d ' ' -f 2)
echo -e "${GREEN}✓ Neovim version: ${NVIM_VERSION}${NC}"

# Check for required dependencies
echo -e "\n${BLUE}Checking dependencies...${NC}"

# Check Git
if command -v git >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Git is installed${NC}"
else
    echo -e "${RED}✗ Git is not installed${NC}"
    echo -e "${YELLOW}Please install Git first${NC}"
    exit 1
fi

# Check Python
if command -v python3 >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Python is installed${NC}"
    echo -e "  $(python3 --version)"
else
    echo -e "${YELLOW}⚠ Python is not installed or not in PATH${NC}"
    echo -e "  Some features may not work correctly"
fi

# Check node.js for LSP servers
if command -v node >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Node.js is installed${NC}"
    echo -e "  $(node --version)"
else
    echo -e "${YELLOW}⚠ Node.js is not installed${NC}"
    echo -e "  Some LSP servers may not work correctly"
fi

# Check for ripgrep (used by Telescope)
if command -v rg >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Ripgrep is installed${NC}"
else
    echo -e "${YELLOW}⚠ Ripgrep is not installed${NC}"
    echo -e "  Telescope fuzzy finding will be limited"
fi

# Setup directories
echo -e "\n${BLUE}Setting up configuration directories...${NC}"

# Create Neovim config directory if it doesn't exist
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Creating Neovim config directory...${NC}"
    mkdir -p "$NVIM_CONFIG_DIR"
fi

# If config files already exist, create a backup
if [ "$(ls -A $NVIM_CONFIG_DIR 2>/dev/null)" ]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}_backup_$(date +%Y%m%d%H%M%S)"
    echo -e "${YELLOW}Existing configuration found. Creating backup at ${BACKUP_DIR}${NC}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    mkdir -p "$NVIM_CONFIG_DIR"
fi

# Copy configuration files
echo -e "\n${BLUE}Installing configuration files...${NC}"
cp -r $(pwd)/* "$NVIM_CONFIG_DIR/"
echo -e "${GREEN}✓ Configuration files installed${NC}"

# Create Python virtual environment for Neovim
echo -e "\n${BLUE}Setting up Python environment for Neovim...${NC}"
if command -v python3 >/dev/null 2>&1; then
    VENV_DIR="${HOME}/.venvs/neovim"
    if [ ! -d "$VENV_DIR" ]; then
        echo -e "${YELLOW}Creating Python virtual environment...${NC}"
        python3 -m venv "$VENV_DIR"
        "${VENV_DIR}/bin/pip" install pynvim
        echo -e "${GREEN}✓ Python environment created${NC}"
    else
        echo -e "${GREEN}✓ Python environment already exists${NC}"
    fi
fi

# Inform user about first run
echo -e "\n${BLUE}Installation complete!${NC}"
echo -e "${YELLOW}First run instructions:${NC}"
echo -e "1. Start Neovim with: ${GREEN}nvim${NC}"
echo -e "2. Plugins will be automatically installed on first run"
echo -e "3. LSP servers will be installed using Mason (:Mason)"
echo -e "4. Run :checkhealth to verify everything is working correctly"
echo -e "\n${GREEN}Enjoy your new Neovim setup for backend development!${NC}"
