#!/bin/bash
# AutoTerm Installation Script
# Works on macOS and Linux

set -e

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AutoTerm AI Terminal Assistant    ║${NC}"
echo -e "${BLUE}║           Version ${VERSION}              ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=Mac;;
    *)          PLATFORM="UNKNOWN:${OS}"
esac

echo -e "${GREEN}✓${NC} Platform: ${PLATFORM}"

# Detect shell
CURRENT_SHELL="$(basename "$SHELL")"
echo -e "${GREEN}✓${NC} Shell: ${CURRENT_SHELL}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    INSTALL_MODE="system"
    echo -e "${YELLOW}ℹ${NC} Running as root - will install system-wide"
else
    echo ""
    echo "Installation mode:"
    echo "  1) User installation (~/.local)     [Recommended]"
    echo "  2) System installation (/usr/local) [Requires sudo]"
    echo ""
    read -p "Choose [1-2]: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[2]$ ]]; then
        INSTALL_MODE="system"
    else
        INSTALL_MODE="user"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Checking dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗${NC} Python 3 is required but not found"
    exit 1
fi
echo -e "${GREEN}✓${NC} Python 3: $(python3 --version)"

# Check zsh
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}✗${NC} zsh is required but not found"
    exit 1
fi
echo -e "${GREEN}✓${NC} zsh: $(zsh --version)"

# Check pip3
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}✗${NC} pip3 is required but not found"
    exit 1
fi
echo -e "${GREEN}✓${NC} pip3: $(pip3 --version | head -n1)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Installing Python dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Install groq package
echo "Installing groq package..."
pip3 install groq --index-url https://pypi.org/simple --quiet || {
    echo -e "${RED}✗${NC} Failed to install groq package"
    echo "Try manually: pip3 install groq --index-url https://pypi.org/simple"
    exit 1
}
echo -e "${GREEN}✓${NC} Python dependencies installed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Installing AutoTerm..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$SCRIPT_DIR"

if [ "$INSTALL_MODE" = "system" ]; then
    if [ "$EUID" -ne 0 ]; then
        echo "System installation requires sudo"
        sudo make install
    else
        make install
    fi
else
    make install-user
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4: Setting up Groq API key..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Find autoterm command
if [ "$INSTALL_MODE" = "user" ]; then
    AUTOTERM_CMD="$HOME/.local/bin/autoterm"
else
    AUTOTERM_CMD="/usr/local/bin/autoterm"
fi

if [ -x "$AUTOTERM_CMD" ]; then
    python3 "$AUTOTERM_CMD" --setup
else
    echo -e "${YELLOW}⚠${NC} autoterm command not found at expected location"
    echo "Run manually: autoterm --setup"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5: Testing connection..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -x "$AUTOTERM_CMD" ]; then
    if python3 "$AUTOTERM_CMD" --test; then
        echo -e "${GREEN}✓${NC} Connection test successful!"
    else
        echo -e "${YELLOW}⚠${NC} Connection test failed (check API key)"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 6: Configuring shell..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Determine lib path base
if [ "$INSTALL_MODE" = "user" ]; then
    LIB_BASE="$HOME/.local/lib/autoterm"
else
    LIB_BASE="/usr/local/lib/autoterm"
fi

# Configure based on detected shell
case "$CURRENT_SHELL" in
    zsh)
        SHELL_RC="$HOME/.zshrc"
        SHELL_LIB="$LIB_BASE/autoterm.zsh"
        SHELL_NAME="zsh"
        ;;
    bash)
        SHELL_RC="$HOME/.bashrc"
        SHELL_LIB="$LIB_BASE/autoterm.bash"
        SHELL_NAME="bash"
        ;;
    fish)
        SHELL_RC="$HOME/.config/fish/config.fish"
        SHELL_LIB="$LIB_BASE/autoterm.fish"
        SHELL_NAME="fish"
        mkdir -p "$HOME/.config/fish"
        ;;
    *)
        echo -e "${YELLOW}⚠${NC} Unknown shell: $CURRENT_SHELL"
        echo "Please manually add to your shell config:"
        echo "  source $LIB_BASE/autoterm.[zsh|bash|fish]"
        SHELL_RC=""
        ;;
esac

if [ -n "$SHELL_RC" ]; then
    # Check if already configured
    if grep -q "source.*autoterm\.$SHELL_NAME" "$SHELL_RC" 2>/dev/null; then
        echo -e "${YELLOW}ℹ${NC} AutoTerm already configured in $SHELL_RC"
    else
        echo "" >> "$SHELL_RC"
        echo "# AutoTerm AI Terminal Assistant" >> "$SHELL_RC"
        echo "source \"$SHELL_LIB\"" >> "$SHELL_RC"
        echo -e "${GREEN}✓${NC} Added AutoTerm to $SHELL_RC"
    fi
fi

# Check if ~/.local/bin is in PATH (for user installations)
if [ "$INSTALL_MODE" = "user" ]; then
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo ""
        echo -e "${YELLOW}⚠${NC} ~/.local/bin is not in your PATH"
        echo "Add this to your ~/.zshrc:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉        ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "To start using AutoTerm:"
echo ""
echo -e "  ${BLUE}1.${NC} Restart your terminal or run:"
if [ "$CURRENT_SHELL" = "zsh" ]; then
    echo -e "     ${YELLOW}source ~/.zshrc${NC}"
    echo ""
    echo -e "  ${BLUE}2.${NC} Type a query starting with #:"
    echo -e "     ${YELLOW}# find all python files${NC}"
    echo ""
    echo -e "  ${BLUE}3.${NC} Press ${GREEN}Tab Tab${NC} to generate a command"
    echo ""
    echo -e "  ${BLUE}4.${NC} Press ${GREEN}Enter${NC} to execute, ${RED}Esc${NC} to cancel, or ${YELLOW}Tab${NC} to refine"
elif [ "$CURRENT_SHELL" = "bash" ]; then
    echo -e "     ${YELLOW}source ~/.bashrc${NC}"
    echo ""
    echo -e "  ${BLUE}2.${NC} Use the autoterm command:"
    echo -e "     ${YELLOW}autoterm find all python files${NC}"
    echo -e "     or: ${YELLOW}at find all python files${NC}"
elif [ "$CURRENT_SHELL" = "fish" ]; then
    echo -e "     ${YELLOW}source ~/.config/fish/config.fish${NC}"
    echo ""
    echo -e "  ${BLUE}2.${NC} Use the autoterm command:"
    echo -e "     ${YELLOW}autoterm 'find all python files'${NC}"
    echo -e "     or: ${YELLOW}at 'find all python files'${NC}"
else
    echo -e "     ${YELLOW}source your shell config${NC}"
fi
echo ""
echo "Documentation:"
echo "  Index:         docs/INDEX.md"
echo "  Shell Support: docs/SHELL_SUPPORT.md"
echo "  FAQ:           docs/FAQ.md"
echo "  Man Page:      man autoterm"
echo ""
echo "Enjoy your AI-powered terminal! ✨"
echo ""

