#!/bin/bash
# AutoTerm Setup Script

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
AUTOTERM_DIR="$SCRIPT_DIR"

echo "🚀 Setting up AutoTerm AI Terminal Assistant"
echo "==========================================="
echo

# Check Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required but not found"
    exit 1
fi

echo "✓ Python 3 found: $(python3 --version)"

# Install Python dependencies
echo
echo "📦 Installing Python dependencies..."
# Force using PyPI (public) instead of custom package repositories
pip3 install -r "$AUTOTERM_DIR/requirements.txt" --index-url https://pypi.org/simple --quiet

# Make Python script executable
chmod +x "$AUTOTERM_DIR/ai_terminal.py"

# Setup API key
echo
echo "🔑 Setting up Groq API key..."
python3 "$AUTOTERM_DIR/ai_terminal.py" --setup

# Test connection
echo
echo "🧪 Testing connection to Groq API..."
if python3 "$AUTOTERM_DIR/ai_terminal.py" --test; then
    echo "✓ Connection test successful!"
else
    echo "❌ Connection test failed. Please check your API key."
    exit 1
fi

# Setup zsh integration
echo
echo "🔧 Setting up zsh integration..."

ZSHRC="$HOME/.zshrc"

# Check if already added
if grep -q "source.*autoterm.zsh" "$ZSHRC" 2>/dev/null; then
    echo "⚠️  AutoTerm already configured in ~/.zshrc"
else
    echo "" >> "$ZSHRC"
    echo "# AutoTerm AI Terminal Assistant" >> "$ZSHRC"
    echo "source \"$AUTOTERM_DIR/autoterm.zsh\"" >> "$ZSHRC"
    echo "✓ Added AutoTerm to ~/.zshrc"
fi

echo
echo "✅ Setup complete!"
echo
echo "To start using AutoTerm:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Type: # your query here"
echo "  3. Press Tab twice to generate a command"
echo "  4. Press Enter to execute, Esc to cancel, or Tab to refine"
echo
echo "Example: # find all python files modified in the last week"
echo

