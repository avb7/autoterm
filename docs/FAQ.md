# Frequently Asked Questions (FAQ)

## General Questions

### What is AutoTerm?

AutoTerm is an AI-powered terminal assistant that translates natural language queries into executable shell commands. Instead of remembering complex command syntax, you simply describe what you want to do.

### Is it free?

Yes! AutoTerm is open source (MIT License). You'll need a Groq API key, which has a free tier.

### What's a Groq API key?

Groq is an AI inference platform that provides ultra-fast AI models. Sign up at [console.groq.com](https://console.groq.com) for a free API key.

### Does it work on Windows?

Not yet. Currently supports macOS and Linux. Windows support (WSL, PowerShell) is planned for future releases.

---

## Installation Questions

### Which installation method should I use?

- **User installation** (`make install-user`) - Recommended for most users, no sudo needed
- **System installation** (`sudo make install`) - If you want all users to have access

### Can I install without sudo?

Yes! Use `make install-user` to install to `~/.local/`

### Do I need to install groq separately?

The installation script (`install.sh` or `make install`) automatically installs the groq Python package. If it fails, install manually:
```bash
pip3 install groq --index-url https://pypi.org/simple
```

---

## Usage Questions

### What shells are supported?

- **zsh** - Full support with double-tab activation ✅
- **bash** - Command mode (`autoterm query`) ✅
- **fish** - Command mode (`autoterm query`) ✅
- **nushell, xonsh** - Not yet supported

### What terminal emulators work?

**All of them!** Ghostty, Kitty, iTerm2, Alacritty, Warp, Terminal.app, etc.

The terminal emulator is just the window - AutoTerm cares about your **shell**, not your terminal.

### Why double-tab and not single-tab?

Single-tab is used for standard shell completion. Double-tab avoids conflicts and provides a clear, intentional trigger for AI assistance.

### Can I use a different activation key?

Yes! Edit `lib/autoterm.zsh` and change the key binding. For example, to use Ctrl+Space:
```zsh
bindkey "^ " autoterm-tab-handler  # Ctrl+Space
```

### How do I clear the context?

Type `# clear` or `# reset` and press Tab Tab.

---

## Features Questions

### Does it remember previous commands?

Yes! Context persists throughout your terminal session. Each query includes information from previous queries and commands.

### Can I refine commands?

Yes! After seeing a generated command, press **Tab** to see conversation history and refine with additional context.

### Can it execute commands automatically?

In zsh, you press Enter to execute. In bash/fish, it asks Y/N for confirmation. The command is never executed without your explicit approval.

### Does it work offline?

No, it requires an internet connection to call the Groq API.

### Can I use a different AI model?

Yes! Edit `bin/autoterm-backend` and change the model:
```python
model="groq/compound-mini"          # Default (fastest)
model="llama-3.1-70b-versatile"    # Slower but more capable
model="llama-3.1-8b-instant"       # Fast alternative
```

---

## Security Questions

### Is my API key safe?

Yes:
- Stored in `~/.config/autoterm/config.json` with 600 permissions (user read/write only)
- Never logged or transmitted except to Groq API
- Can also use environment variable: `GROQ_API_KEY`

### What data is sent to Groq?

Only:
- Your query text
- Previous queries/commands (for context)
- System information (OS, shell, working directory)

No files, passwords, or sensitive data are sent unless you explicitly include them in your query.

### Can it access my files?

The AI backend only generates commands - it doesn't access your files directly. Commands are shown to you before execution.

### What if it generates a dangerous command?

- **Always review commands before executing!**
- The AI is trained to avoid destructive operations
- You must explicitly press Enter to execute
- Press Esc to cancel

---

## Technical Questions

### How does it work?

1. You type `# query` and press Tab Tab
2. ZSH integration detects the trigger
3. Query + context sent to Python backend
4. Backend calls Groq API
5. AI generates command
6. Command shown to you for review
7. You choose to execute (Enter), cancel (Esc), or refine (Tab)

### What AI model does it use?

Default is `groq/compound-mini` (ultra-fast). Can be changed to other Groq models.

### How fast is it?

Typically < 1 second, thanks to Groq's fast inference infrastructure.

### Does it use ChatGPT/OpenAI?

No, it uses Groq's models which are faster and more cost-effective for this use case.

### Can I self-host the AI?

Not currently, but local model support is planned for future releases.

---

## Comparison Questions

### How is this different from Warp's AI?

- **AutoTerm**: Works in ANY terminal, shell-integrated, open source
- **Warp**: Built into Warp terminal only, closed source

### How is this different from GitHub Copilot CLI?

- **AutoTerm**: Faster (Groq), context-persistent, simpler installation
- **Copilot CLI**: Requires GitHub Copilot subscription, uses OpenAI

### How is this different from Bash-it/Oh-My-Zsh?

Those are shell frameworks with aliases and completions. AutoTerm uses AI to generate commands from natural language - completely different approach.

---

## Troubleshooting Questions

### Double-tab isn't working

See [Troubleshooting Guide](TROUBLESHOOTING.md#double-tab-not-working-zsh)

Quick check:
```bash
grep autoterm ~/.zshrc
source ~/.zshrc
```

### Commands are wrong or nonsensical

- Be more specific in your queries
- Use context (ask follow-up questions)
- Try a different model (see above)

### It's slow

- Check internet connection
- Try faster model (`groq/compound-mini`)
- Check Groq status: https://status.groq.com

---

## Future Features

### Will you support Windows?

Yes, planned for future releases (WSL and PowerShell).

### Will you support bash interactive mode?

Possibly, but bash has limitations compared to zsh. We're exploring options.

### Will you add command explanations?

Yes! Planned feature to explain what generated commands do.

### Will you support local/offline AI?

Yes, planned to support local models like Ollama in future releases.

### Will you add a GUI?

Possibly a web-based config UI, but the main interface will always be terminal-first.

---

## Contributing Questions

### How can I contribute?

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Areas we need help:
- Shell support (nushell, xonsh, PowerShell)
- Testing on different platforms
- Documentation improvements
- Bug reports and fixes

### Can I add support for my favorite shell?

Yes! See `lib/autoterm.bash` and `lib/autoterm.fish` as examples. PRs welcome!

### How do I report bugs?

Open an issue on GitHub with:
- Your environment (OS, shell, Python version)
- Steps to reproduce
- Expected vs actual behavior
- Error messages

---

## Miscellaneous

### Why "AutoTerm"?

Short for "Automatic Terminal" - AI makes terminal use more automatic!

### Is the name final?

Maybe! If you have better ideas, let us know in Discussions.

### Can I use this in production scripts?

Not recommended. AutoTerm is for interactive use. For scripts, use explicit commands.

### Can I train it on my commands?

Not yet, but custom training/fine-tuning is a planned feature.

### Does it work with tmux/screen?

Yes! Works perfectly in multiplexers.

### Does it work over SSH?

Yes! Just install AutoTerm on the remote machine.

---

Still have questions? Check the [full documentation](README.md) or ask in [GitHub Discussions](https://github.com/yourusername/autoterm/discussions)!

