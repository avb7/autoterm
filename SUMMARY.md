# AutoTerm - Summary

## What is AutoTerm?

AutoTerm is an AI-powered terminal assistant that translates natural language queries into executable shell commands. Simply describe what you want to do, and AutoTerm generates the exact command using Groq's ultra-fast AI models.

## Quick Overview

### Installation
```bash
# Interactive installer (easiest)
./install.sh

# Or with make
make install-user              # User installation (~/.local)
sudo make install              # System-wide (/usr/local)
```

### Usage by Shell

**ZSH (Interactive Mode):**
```bash
# find all python files
[Press Tab Tab]
→ Interactive mode with Enter/Esc/Tab
```

**Bash/Fish (Command Mode):**
```bash
autoterm find all python files
# or
at find all python files
→ Y/N confirmation prompt
```

### Key Features

- ⚡ **Ultra-fast** - < 1 second response time (Groq AI)
- 🧠 **Context-aware** - Remembers entire conversation
- 🎨 **Natural language** - No need to remember syntax
- 🔒 **Safe** - Shows command before execution
- 🌈 **Multi-shell** - zsh, bash, fish
- 🖥️ **All terminals** - Ghostty, Kitty, iTerm2, etc.

### Command Reference

```bash
# Setup
autoterm --setup          # Configure API key
autoterm --test           # Test connection
autoterm --version        # Show version

# Usage (bash/fish)
autoterm <query>          # Generate and confirm command
at <query>                # Short alias

# Usage (zsh)
# <query>                 # Type query starting with #
[Tab Tab]                 # Generate command
[Enter]                   # Execute
[Esc]                     # Cancel
[Tab]                     # Refine with history

# Clear context
# clear                   # Start fresh conversation
[Tab Tab]
```

## Key Differences: make install vs install.sh

### `make install` (Manual Configuration)

**What it does:**
- ✅ Copies files to installation directory
- ✅ Installs Python dependencies
- ✅ Sets file permissions
- ❌ Does NOT modify shell configs
- ❌ Does NOT setup API key automatically

**After running:**
```bash
# You must manually:
1. Run: autoterm --setup
2. Add to shell: echo 'source ~/.local/lib/autoterm/autoterm.zsh' >> ~/.zshrc
3. Reload: source ~/.zshrc
```

**Use when:**
- You prefer manual control
- Installing on multiple machines with scripts
- You want to customize installation

---

### `install.sh` (Automatic Configuration)

**What it does:**
- ✅ Copies files to installation directory
- ✅ Installs Python dependencies
- ✅ Sets file permissions
- ✅ **Automatically modifies shell configs**
- ✅ **Automatically runs autoterm --setup**
- ✅ **Detects your shell automatically**
- ✅ Tests connection

**After running:**
- Everything is configured
- Just reload shell: `source ~/.zshrc`
- Ready to use immediately

**Use when:**
- First time installation
- You want guided setup
- You prefer automatic configuration

## Architecture

```
User Input (# query)
         ↓
ZSH Detection (double-tab)
         ↓
lib/autoterm.zsh
         ↓
bin/autoterm (Python)
         ↓
Groq API
         ↓
Command Generated
         ↓
User Confirms
         ↓
Command Executed
```

## File Structure

```
/usr/local/  (or ~/.local/)
├── bin/
│   └── autoterm              # Main command
├── lib/autoterm/
│   ├── autoterm.zsh         # ZSH integration
│   ├── autoterm.bash        # Bash integration
│   └── autoterm.fish        # Fish integration
└── share/
    ├── autoterm/examples/
    ├── doc/autoterm/
    └── man/man1/autoterm.1

~/.config/autoterm/
├── config.json              # API key (600 permissions)
└── history.json             # Last 10 queries

~/.zshrc (or ~/.bashrc or fish config)
└── source /path/to/autoterm.zsh  # Added by installer or manually
```

## Shell Comparison

| Feature | ZSH | Bash | Fish |
|---------|-----|------|------|
| Double-tab activation | ✅ | ❌ | ❌ |
| Interactive mode (Enter/Esc/Tab) | ✅ | ❌ | ❌ |
| Command generation | ✅ | ✅ | ✅ |
| Context persistence | ✅ | ✅ | ✅ |
| Conversation history display | ✅ | ❌ | ❌ |
| In-line refinement | ✅ | ❌ | ❌ |
| Y/N confirmation | ✅ | ✅ | ✅ |
| Command mode (autoterm query) | ✅ | ✅ | ✅ |

**Recommendation:** Use ZSH for best experience.

## Terminal Emulator Compatibility

✅ Works in **ALL** terminal emulators:
- Ghostty, Kitty, Alacritty, iTerm2, Warp, Terminal.app, Hyper, GNOME Terminal, Konsole, etc.

**Important:** The terminal emulator is just the display window. AutoTerm works identically in all of them. What matters is your **shell** (zsh/bash/fish), not your terminal.

## Common Commands

```bash
# Setup
autoterm --setup                    # Configure API key
autoterm --test                     # Test connection

# File operations
autoterm find all python files
autoterm compress all videos
autoterm count lines in js files

# System monitoring
autoterm show CPU usage
autoterm find large files
autoterm check disk space

# Git operations
autoterm commit all changes
autoterm create branch feature-x
autoterm show recent commits

# Advanced
autoterm backup with timestamp
autoterm find duplicates
autoterm monitor file changes
```

## Documentation Quick Links

- **Getting Started**: [docs/QUICKSTART.md](docs/QUICKSTART.md)
- **Installation**: [docs/INSTALL.md](docs/INSTALL.md)
- **Shell Support**: [docs/SHELL_SUPPORT.md](docs/SHELL_SUPPORT.md)
- **Troubleshooting**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- **FAQ**: [docs/FAQ.md](docs/FAQ.md)
- **All Docs**: [docs/INDEX.md](docs/INDEX.md)

## Requirements

- **OS**: macOS or Linux
- **Shell**: zsh, bash, or fish
- **Python**: 3.7+
- **API Key**: Free from [console.groq.com](https://console.groq.com)
- **Terminal**: Any (Ghostty, Kitty, iTerm2, Alacritty, etc.)

## Key Points

1. **`autoterm` is the command** (not `autoterm-backend`)
2. **`make install` doesn't modify shell configs** - you must add manually
3. **`install.sh` does everything automatically** - including shell config
4. **ZSH has the best experience** with double-tab activation
5. **All terminal emulators work the same** - shell is what matters
6. **Context persists throughout session** - build commands iteratively
7. **Always review before executing** - safety first!

## Version

Current: **1.0.0**

See [docs/CHANGELOG.md](docs/CHANGELOG.md) for version history.

## License

MIT License - See [LICENSE](LICENSE)

---

**Ready to start?** Run `./install.sh` or see [docs/QUICKSTART.md](docs/QUICKSTART.md)!

