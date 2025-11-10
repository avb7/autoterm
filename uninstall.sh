#!/bin/bash
# AutoTerm Uninstallation Script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

echo -e "${BLUE}AutoTerm Uninstaller${NC}"
echo ""

# Detect installation type
if [ -d "$HOME/.local/lib/autoterm" ]; then
    INSTALL_TYPE="user"
    echo "Detected user installation at ~/.local"
elif [ -d "/usr/local/lib/autoterm" ]; then
    INSTALL_TYPE="system"
    echo "Detected system installation at /usr/local"
else
    echo -e "${RED}✗${NC} AutoTerm installation not found"
    exit 1
fi

echo ""
read -p "Do you want to uninstall AutoTerm? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled"
    exit 0
fi

echo ""
echo "Uninstalling AutoTerm..."

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "$INSTALL_TYPE" = "system" ]; then
    if [ "$EUID" -ne 0 ]; then
        sudo make uninstall
    else
        make uninstall
    fi
else
    make uninstall-user
fi

# Remove from .zshrc
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    if grep -q "source.*autoterm.zsh" "$ZSHRC"; then
        echo ""
        read -p "Remove AutoTerm from ~/.zshrc? [y/N] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create backup
            cp "$ZSHRC" "$ZSHRC.backup"
            # Remove AutoTerm lines
            sed -i.bak '/# AutoTerm/d; /autoterm\.zsh/d' "$ZSHRC"
            echo -e "${GREEN}✓${NC} Removed from ~/.zshrc (backup: ~/.zshrc.backup)"
        fi
    fi
fi

# Ask about config files
echo ""
read -p "Remove configuration and history? [y/N] " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.config/autoterm"
    echo -e "${GREEN}✓${NC} Configuration removed"
else
    echo -e "${YELLOW}ℹ${NC} Configuration preserved at ~/.config/autoterm"
fi

echo ""
echo -e "${GREEN}✓${NC} AutoTerm uninstalled successfully"
echo ""

