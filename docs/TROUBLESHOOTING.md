# Troubleshooting Guide

Common issues and their solutions.

## Installation Issues

### Error: "pip could not find groq package"

**Symptom:**
```
ERROR: Could not find a version that satisfies the requirement groq>=0.4.0
```

**Solution:**
Force pip to use public PyPI:
```bash
pip3 install groq --index-url https://pypi.org/simple
```

**Why:** Your pip may be configured to use a custom package repository.

---

### Error: "autoterm-backend not found"

**Symptom:**
```
Error: autoterm-backend not found at /path/to/autoterm-backend
```

**Solutions:**

1. **Check installation:**
   ```bash
   which autoterm-backend
   ```

2. **Ensure PATH includes installation directory:**
   ```bash
   # For user installation
   export PATH="$HOME/.local/bin:$PATH"
   
   # Add to ~/.zshrc or ~/.bashrc permanently
   ```

3. **Reinstall:**
   ```bash
   make install-user
   ```

---

### Error: "Permission denied"

**Symptom:**
```
Permission denied: /usr/local/bin/autoterm-backend
```

**Solution:**
Use `sudo` for system installation or use user installation:
```bash
# System (requires sudo)
sudo make install

# User (no sudo needed)
make install-user
```

---

## API Key Issues

### Error: "Groq API key not found"

**Symptom:**
```
Error: Groq API key not found.
Run: autoterm-backend --setup
```

**Solutions:**

1. **Run setup:**
   ```bash
   autoterm-backend --setup
   ```

2. **Or set environment variable:**
   ```bash
   export GROQ_API_KEY='your-key-here'
   
   # Add to shell config for persistence
   echo 'export GROQ_API_KEY="your-key"' >> ~/.zshrc
   ```

3. **Check config file:**
   ```bash
   cat ~/.config/autoterm/config.json
   # Should contain: {"api_key": "..."}
   ```

---

### Error: "Connection test failed"

**Symptom:**
```
✗ Connection failed: 401 Unauthorized
```

**Causes & Solutions:**

1. **Invalid API key**
   - Get new key from https://console.groq.com
   - Run `autoterm-backend --setup` again

2. **Network issues**
   - Check internet connection
   - Check firewall settings
   - Try: `curl https://api.groq.com`

3. **API quota exceeded**
   - Check your Groq console for limits
   - Wait for quota reset
   - Upgrade Groq plan if needed

---

## Shell Integration Issues

### Double-tab not working (ZSH)

**Symptoms:**
- Pressing Tab twice does nothing
- Regular tab completion works

**Solutions:**

1. **Check if sourced:**
   ```bash
   grep autoterm ~/.zshrc
   # Should show: source /path/to/autoterm.zsh
   ```

2. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

3. **Check for conflicts:**
   ```bash
   # Check what Tab is bound to
   bindkey "^I"
   ```

4. **Test manually:**
   ```bash
   # Type this and press Tab twice:
   # find python files
   ```

---

### "Command not found: autoterm" (Bash/Fish)

**Symptom:**
```bash
autoterm: command not found
```

**Solutions:**

1. **Check if library is sourced:**
   ```bash
   # Bash
   grep autoterm ~/.bashrc
   
   # Fish
   grep autoterm ~/.config/fish/config.fish
   ```

2. **Source manually:**
   ```bash
   # Bash
   source ~/.local/lib/autoterm/autoterm.bash
   
   # Fish
   source ~/.local/lib/autoterm/autoterm.fish
   ```

3. **Reload shell:**
   ```bash
   # Bash
   source ~/.bashrc
   
   # Fish
   source ~/.config/fish/config.fish
   ```

---

### Context not persisting

**Symptom:**
- AI doesn't remember previous commands
- Each query starts fresh

**Solutions:**

1. **Check you're pressing Enter (not Esc):**
   - Enter = Execute and keep context
   - Esc = Cancel and clear context

2. **Clear and start fresh if needed:**
   ```bash
   # clear
   ```

3. **Check for errors:**
   - Look for error messages in output
   - Test backend directly:
     ```bash
     autoterm-backend "test query"
     ```

---

## Generation Issues

### Commands are incorrect or nonsensical

**Solutions:**

1. **Be more specific:**
   ```bash
   # Vague
   # find files
   
   # Better
   # find all python files modified today in src directory
   ```

2. **Use context:**
   ```bash
   # First query
   # find log files
   
   # Follow-up (AI remembers)
   # only from last week
   ```

3. **Try a different model:**
   Edit `bin/autoterm-backend` and change:
   ```python
   model="groq/compound-mini"
   # to
   model="llama-3.1-70b-versatile"
   ```

---

### AI generates dangerous commands

**Example:**
```bash
rm -rf /
```

**Solutions:**

1. **Always review before executing!**
   - AutoTerm shows you the command first
   - Press Esc if it looks wrong

2. **The AI is trained to be safe:**
   - Should suggest confirmation flags
   - Should avoid destructive operations
   - But always double-check!

3. **Report issues:**
   - If AI consistently generates bad commands
   - Open an issue with examples

---

### Slow response times

**Symptom:**
- Takes > 5 seconds to generate

**Solutions:**

1. **Check internet speed:**
   ```bash
   ping api.groq.com
   ```

2. **Try different model:**
   - `groq/compound-mini` (fastest)
   - `llama-3.1-8b-instant` (very fast)
   - `llama-3.1-70b-versatile` (slower but better)

3. **Check Groq status:**
   - Visit https://status.groq.com

---

## Terminal Emulator Issues

### Doesn't work in Ghostty/Kitty/etc.

**Important:** AutoTerm works in **ALL** terminal emulators!

**If it's not working:**

1. **Check your SHELL (not terminal):**
   ```bash
   echo $SHELL
   # Should be: /bin/zsh, /bin/bash, or /usr/bin/fish
   ```

2. **The terminal emulator doesn't matter:**
   - Ghostty, Kitty, iTerm2, etc. all work the same
   - The shell is what matters

3. **Test in different terminal:**
   - If it works in iTerm2 but not Ghostty
   - They're using different shell configs
   - Check: `echo $SHELL` in both

---

## File Permission Issues

### Error: "Permission denied: ~/.config/autoterm/config.json"

**Solution:**
```bash
chmod 600 ~/.config/autoterm/config.json
```

---

### Error: "Cannot write to /usr/local"

**Solution:**
Use sudo or install for user:
```bash
# Option 1: Use sudo
sudo make install

# Option 2: Install for user (no sudo)
make install-user
```

---

## Debugging

### Enable verbose output

Test the backend directly:
```bash
# Test connection
autoterm-backend --test

# Generate command manually
autoterm-backend "your query here"

# With context
autoterm-backend "your query" --context '[{"query":"prev","command":"prev cmd"}]'
```

---

### Check configuration

```bash
# Config file location
cat ~/.config/autoterm/config.json

# History
cat ~/.config/autoterm/history.json

# Shell config
grep autoterm ~/.zshrc  # or ~/.bashrc or fish config
```

---

### View logs

Currently AutoTerm doesn't have persistent logs, but you can:

```bash
# Run with error output
autoterm-backend "test" 2>&1 | tee debug.log
```

---

## Platform-Specific Issues

### macOS: "Operation not permitted"

**Solution:**
Grant terminal full disk access:
1. System Settings → Privacy & Security → Full Disk Access
2. Add your terminal emulator
3. Restart terminal

---

### Linux: "command not found" after user install

**Solution:**
Ensure `~/.local/bin` is in PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Still Having Issues?

1. **Check existing issues:**
   - https://github.com/yourusername/autoterm/issues

2. **Open a new issue:**
   - Include error messages
   - Include output of:
     ```bash
     echo $SHELL
     python3 --version
     which autoterm-backend
     cat ~/.config/autoterm/config.json  # Remove API key!
     ```

3. **Ask for help:**
   - GitHub Discussions
   - Include steps to reproduce

---

## Quick Fixes Checklist

- [ ] Reload shell: `source ~/.zshrc`
- [ ] Check API key: `autoterm-backend --test`
- [ ] Check PATH: `which autoterm-backend`
- [ ] Check shell: `echo $SHELL`
- [ ] Check sourced: `grep autoterm ~/.zshrc`
- [ ] Reinstall: `make install-user`
- [ ] Clear context: `# clear`

