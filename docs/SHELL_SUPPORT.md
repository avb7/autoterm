# Shell Support

AutoTerm works with multiple shells and terminal emulators.

## Understanding the Difference

### Terminal Emulators (The Window)
These are the **applications** that display your terminal:
- ✅ **Ghostty** - Modern, fast, GPU-accelerated
- ✅ **Kitty** - GPU-accelerated, feature-rich
- ✅ **Alacritty** - Fastest, written in Rust
- ✅ **iTerm2** - Popular on macOS
- ✅ **Warp** - AI-powered terminal
- ✅ **Hyper** - Electron-based
- ✅ **Terminal.app** - macOS default
- ✅ **GNOME Terminal** - Linux default
- ✅ **Konsole** - KDE default

**AutoTerm works in ALL terminal emulators!** The emulator doesn't matter.

### Shells (The Command Interpreter)
These are the **programs** that interpret your commands:
- ✅ **zsh** - Full support with double-tab activation
- ✅ **bash** - Supported via `autoterm` command
- ✅ **fish** - Supported via `autoterm` command
- ❌ **nushell** - Not yet supported
- ❌ **xonsh** - Not yet supported

## Shell-Specific Usage

### ZSH (Full Interactive Mode)

**Setup:**
```bash
# Add to ~/.zshrc
source /path/to/autoterm.zsh
```

**Usage:**
```bash
# find all python files
[Press Tab Tab]
```

**Features:**
- ✅ Double-tab activation
- ✅ Interactive mode (Enter/Esc/Tab)
- ✅ Automatic context persistence
- ✅ Conversation history display
- ✅ In-line refinement

### Bash (Command Mode)

**Setup:**
```bash
# Add to ~/.bashrc
source /path/to/autoterm.bash
```

**Usage:**
```bash
autoterm find all python files
# or use alias
at find all python files
```

**Features:**
- ✅ Command interface
- ✅ Context persistence
- ✅ Y/N confirmation prompt
- ⚠️ No double-tab (bash limitation)
- ⚠️ No interactive refinement UI

### Fish (Command Mode)

**Setup:**
```fish
# Add to ~/.config/fish/config.fish
source /path/to/autoterm.fish
```

**Usage:**
```fish
autoterm 'find all python files'
# or use alias
at 'find all python files'
```

**Features:**
- ✅ Command interface
- ✅ Context persistence
- ✅ Y/N confirmation prompt
- ✅ Native fish functions
- ⚠️ No double-tab (fish limitation)
- ⚠️ No interactive refinement UI

## Comparison Table

| Feature | ZSH | Bash | Fish |
|---------|-----|------|------|
| Double-tab activation | ✅ | ❌ | ❌ |
| Interactive mode | ✅ | ❌ | ❌ |
| Command generation | ✅ | ✅ | ✅ |
| Context persistence | ✅ | ✅ | ✅ |
| Conversation history | ✅ | ❌ | ❌ |
| In-line refinement | ✅ | ❌ | ❌ |
| Y/N confirmation | ✅ | ✅ | ✅ |
| Works in all terminals | ✅ | ✅ | ✅ |

## Why ZSH is Recommended

ZSH provides the best experience because:
1. **Double-tab activation** - Natural workflow
2. **Interactive mode** - Enter/Esc/Tab for control
3. **Advanced key bindings** - Custom keymap support
4. **Inline editing** - See and edit before executing
5. **Conversation UI** - Full history display

## Installation by Shell

### ZSH
```bash
make install-user
echo "source ~/.local/lib/autoterm/autoterm.zsh" >> ~/.zshrc
source ~/.zshrc
```

### Bash
```bash
make install-user
echo "source ~/.local/lib/autoterm/autoterm.bash" >> ~/.bashrc
source ~/.bashrc
```

### Fish
```bash
make install-user
echo "source ~/.local/lib/autoterm/autoterm.fish" >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

## Terminal Emulator Compatibility

AutoTerm works **identically** in all terminal emulators. The emulator doesn't affect functionality.

### Tested and Working:
- ✅ Ghostty (all versions)
- ✅ Kitty (all versions)
- ✅ Alacritty (all versions)
- ✅ iTerm2 (macOS)
- ✅ Terminal.app (macOS)
- ✅ Warp (all versions)
- ✅ Hyper (all versions)
- ✅ GNOME Terminal (Linux)
- ✅ Konsole (Linux)
- ✅ Terminator (Linux)
- ✅ Tilix (Linux)

### Requirements:
- Must support Unicode (for emoji icons)
- Must support ANSI colors (all modern terminals do)
- Must support 256 colors (optional, for better colors)

## Special Terminal Features

Some terminals have special features that work with AutoTerm:

### Ghostty
- Fast rendering of conversation history
- Smooth scrolling
- GPU-accelerated

### Kitty
- Fast rendering
- Image protocol (future feature)
- Split windows work perfectly

### Warp
- Blocks view works with AutoTerm
- AI assistant doesn't conflict
- Command history integration

### iTerm2
- Shell integration compatible
- Triggers can be added
- Badges work

## Future Plans

- [ ] **Nushell** support
- [ ] **Xonsh** support
- [ ] **PowerShell** support (Windows)
- [ ] **cmd.exe** support (Windows)
- [ ] Unified interactive mode for all shells
- [ ] Plugin system for custom shells

## Troubleshooting

### "Double-tab not working"
- Check your shell: `echo $SHELL`
- If not zsh, double-tab only works in zsh
- Use `autoterm` command instead

### "Command not found: autoterm"
- Check if backend is installed: `which autoterm-backend`
- Check if shell library is sourced: `type autoterm`
- Reload your shell: `source ~/.bashrc` or `source ~/.zshrc`

### "Works in iTerm2 but not Ghostty"
- This shouldn't happen - both should work identically
- Check shell (not terminal): `echo $SHELL`
- Ensure same shell configuration in both

### "Fish shows errors"
- Fish syntax is different - ensure you're sourcing `autoterm.fish`
- Check fish version: `fish --version` (requires 3.0+)

## Contributing Shell Support

Want to add support for another shell? See `CONTRIBUTING.md` for guidelines.

Key requirements:
1. Backend API compatibility (calls `autoterm-backend`)
2. Context management
3. User interaction (Y/N confirmation minimum)
4. Error handling
5. Documentation

Example shells to contribute:
- Nushell (Rust-based, modern)
- Xonsh (Python-based)
- Elvish (Go-based)
- Oil shell
- PowerShell (cross-platform)

