# AutoTerm - AI-Powered Terminal Assistant 🤖⚡

Transform your terminal with AI. Type what you want in natural language, get the perfect command instantly.

```bash
# find all python files modified today
```
Press **Tab Tab** → `find . -name "*.py" -type f -mtime 0`

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/autoterm)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](README.md)

## Why AutoTerm? 🎯

- **⚡ Blazing Fast** - Uses Groq's ultra-fast AI models (< 1 second)
- **🧠 Context Aware** - Remembers your conversation, build commands iteratively  
- **🎨 Natural Flow** - Integrates seamlessly into your workflow
- **🔒 Safe** - AI suggests confirmation flags for destructive operations
- **📚 Learning Tool** - Discover new commands and flags
- **🌈 Multi-Shell** - Works with zsh, bash, and fish

## Quick Start

### Installation

```bash
# Clone or download
git clone https://github.com/yourusername/autoterm.git
cd autoterm

# Interactive installer (easiest - does everything automatically)
./install.sh

# OR manual with make (requires manual shell config)
make install-user              # User only (~/.local)
# Then manually:
#   1. autoterm --setup
#   2. echo 'source ~/.local/lib/autoterm/autoterm.zsh' >> ~/.zshrc
#   3. source ~/.zshrc
```

> **💡 Tip:** `./install.sh` automatically configures your shell.  
> `make install` requires manual configuration. See [docs/INSTALL.md](docs/INSTALL.md) for details.

### Usage

**ZSH (interactive mode):**
```bash
# show me the 10 largest files
[Press Tab Tab]
```

**Bash/Fish (command mode):**
```bash
autoterm show me the 10 largest files
# or
at show me the 10 largest files
```

## Features

### 🔄 Persistent Context

AutoTerm remembers everything in your session:

```bash
# find python files
```
→ `find . -name "*.py"`

```bash
# only in src directory
```  
💭 *Using context from 1 previous command(s)*  
→ `find src -name "*.py"`

### 🎯 Interactive Refinement (ZSH)

Press **Tab** after a suggestion to see history and refine:

```
━━━ Conversation History ━━━
1. Query: find large files
   Command: find . -type f -size +100M
━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Type your refinement and press Tab Tab again:
# sort by size
```

### 🧹 Clear Context

Start fresh anytime:
```bash
# clear
[Press Tab Tab]
```

## Documentation

📚 **[Documentation Index](docs/INDEX.md)** - All documentation organized  
📋 **[Quick Summary](docs/SUMMARY.md)** - TL;DR version

**Quick Links:**
- [Quick Start Guide](docs/QUICKSTART.md) - Get started in 5 minutes
- [Installation Guide](docs/INSTALL.md) - Detailed installation & differences
- [Shell Support](docs/SHELL_SUPPORT.md) - Works with zsh, bash, fish
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Examples](examples/example-queries.txt) - 100+ example queries
- Man Page: `man autoterm`

## Project Structure

```
autoterm/
├── bin/
│   └── autoterm-backend        # Python AI backend
├── lib/
│   ├── autoterm.zsh           # ZSH integration (interactive)
│   ├── autoterm.bash          # Bash integration (command mode)
│   └── autoterm.fish          # Fish integration (command mode)
├── docs/                       # Complete documentation
│   ├── INDEX.md               # Documentation index
│   ├── QUICKSTART.md          # Quick start guide
│   ├── INSTALL.md             # Installation guide
│   ├── SHELL_SUPPORT.md       # Shell & terminal support
│   ├── TROUBLESHOOTING.md     # Troubleshooting guide
│   ├── FAQ.md                 # Frequently asked questions
│   ├── CONTRIBUTING.md        # Contribution guidelines
│   ├── CHANGELOG.md           # Version history
│   └── PROJECT_STRUCTURE.md   # Technical structure
├── examples/
│   └── example-queries.txt    # 100+ example queries
├── tests/
│   └── test_basic.py          # Test suite
├── install.sh                  # Interactive installer
├── uninstall.sh               # Uninstaller
├── Makefile                   # Build system
├── autoterm.1                 # Man page
└── README.md                  # This file
```

## Requirements

- **macOS** or **Linux**
- **Python 3.7+**
- **zsh**, **bash**, or **fish** shell
- **Groq API key** (free at [console.groq.com](https://console.groq.com))
- **Any terminal emulator** (Ghostty, Kitty, iTerm2, Alacritty, etc.)

## Key Features

| Feature | ZSH | Bash | Fish |
|---------|-----|------|------|
| Double-tab activation | ✅ | ❌ | ❌ |
| Interactive mode | ✅ | ❌ | ❌ |
| Command generation | ✅ | ✅ | ✅ |
| Context persistence | ✅ | ✅ | ✅ |
| Conversation history | ✅ | ❌ | ❌ |
| In-line refinement | ✅ | ❌ | ❌ |
| Works in all terminals | ✅ | ✅ | ✅ |

**Recommended:** Use **zsh** for the best experience.

## Installation Options

### Method 1: Interactive Installer (Recommended)
```bash
./install.sh
```
✅ Automatically configures everything including shell  
✅ Detects your shell (zsh/bash/fish)  
✅ Runs setup wizard  
✅ Tests connection  

### Method 2: Makefile (Manual Configuration)
```bash
# User installation
make install-user

# System-wide (requires sudo)
sudo make install
```
⚠️ Requires manual steps after:
1. `autoterm --setup` - Configure API key
2. Add to shell config (see output for command)
3. `source ~/.zshrc` - Reload shell

### Method 3: Manual
See [docs/INSTALL.md](docs/INSTALL.md) for detailed instructions.

> **Key Difference:** `install.sh` modifies your shell config automatically.  
> `make install` does NOT - you must add to shell config manually.

## Uninstallation

```bash
# Interactive
./uninstall.sh

# Or with make
make uninstall-user    # User installation
sudo make uninstall    # System installation
```

## Example Queries

```bash
# File operations
# find all log files from last week
# compress all videos in this folder
# count lines in all python files

# System monitoring
# show processes using more than 50% CPU
# check disk usage sorted by size
# find what's listening on port 8080

# Git operations
# show git branches sorted by date
# create branch called feature-x
# commit all changes with message fix bug

# Advanced
# backup database with timestamp
# find duplicate files by hash
# monitor file changes in realtime
```

See [examples/example-queries.txt](examples/example-queries.txt) for 100+ more!

## Troubleshooting

**API key not found:**
```bash
autoterm-backend --setup
```

**Double-tab not working:**
```bash
grep autoterm ~/.zshrc
source ~/.zshrc
```

**Command not found:**
```bash
which autoterm-backend
export PATH="$HOME/.local/bin:$PATH"
```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for complete troubleshooting guide.

## Contributing

Contributions welcome! See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

Areas we need help:
- Shell support (nushell, xonsh, PowerShell)
- Testing on different platforms
- Documentation improvements
- Bug reports and fixes

## Changelog

See [docs/CHANGELOG.md](docs/CHANGELOG.md) for version history.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Credits

- Powered by [Groq](https://groq.com) - Ultra-fast AI inference
- Built for terminal enthusiasts
- Inspired by natural language interfaces

## Support

- **Documentation**: [docs/INDEX.md](docs/INDEX.md)
- **Issues**: [GitHub Issues](https://github.com/yourusername/autoterm/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/autoterm/discussions)
- **FAQ**: [docs/FAQ.md](docs/FAQ.md)

---

**Made with ❤️ for terminal enthusiasts**

⭐ Star us on GitHub if you find this useful!
