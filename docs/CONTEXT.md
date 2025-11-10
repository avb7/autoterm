# Context Management

AutoTerm remembers your conversation throughout your terminal session, allowing you to build commands iteratively.

## How Context Works

### Context Persistence

Every time you generate a command, AutoTerm remembers:
- Your query
- The generated command

This context is used for subsequent queries, allowing the AI to understand refinements like:
- "now sort by size"
- "only in src directory"
- "exclude hidden files"

### Example Session

```bash
# First query
# find python files
→ find . -name "*.py"

# Second query (AI remembers first)
# only in src directory
💭 Using context from 1 previous command(s)
→ find src -name "*.py"

# Third query (AI remembers both)
# show line counts
💭 Using context from 2 previous command(s)
→ find src -name "*.py" -exec wc -l {} \;
```

## Clearing Context

There are **three ways** to clear context:

### Method 1: Special Query (ZSH)

Type the special command and press Tab Tab:

```bash
# clear
[Press Tab Tab]
→ 🔄 Context cleared! Starting fresh.

# or
# reset
[Press Tab Tab]
→ 🔄 Context cleared! Starting fresh.
```

### Method 2: Direct Command (All Shells)

Use the `--clear` option:

```bash
autoterm --clear
→ ✓ Context history cleared
```

This clears both:
- In-memory context (current session)
- Saved history file (~/.config/autoterm/history.json)

### Method 3: Cancel with Esc (ZSH)

In ZSH interactive mode, pressing **Esc** clears context:

```bash
# find large files
[Tab Tab]
→ Command: find . -type f -size +100M
[Press Esc]
→ Context cleared, back to normal prompt
```

## Context Storage

### In-Memory (Per Session)

Context is stored in shell variables:
- `AUTOTERM_CONTEXT` - Array of previous query/command pairs
- `AUTOTERM_QUERY` - Last query
- `AUTOTERM_LAST_CMD` - Last generated command

**Cleared when:**
- You type `# clear` or `# reset`
- You run `autoterm --clear`
- You press Esc to cancel (ZSH)
- You close the terminal

### On Disk (Persistent)

Last 10 queries saved to:
```
~/.config/autoterm/history.json
```

**Used for:**
- Reference (you can view it)
- Not currently used for context (may be in future)

**Cleared with:**
```bash
autoterm --clear
# or manually:
rm ~/.config/autoterm/history.json
```

## Context Limits

### How Much Context is Sent?

**Last 3 exchanges** are sent to the AI:

```bash
Query 1 + Command 1
Query 2 + Command 2  
Query 3 + Command 3  ← These 3 are sent
Query 4 (current)    ← Your new query
```

Older exchanges are kept in memory but not sent to the AI (to avoid token limits).

### Token Limits

Each context exchange adds ~50-200 tokens depending on:
- Query length
- Command complexity

With 3 exchanges max, you stay well within API limits while maintaining useful context.

## When Context is Maintained

### ✅ Context Persists When:

1. **Pressing Enter** to execute a command:
   ```bash
   # find files
   [Tab Tab] [Enter]  ← Context kept
   # now sort them     ← Can build on previous
   ```

2. **Using command mode** (bash/fish):
   ```bash
   autoterm find files
   autoterm now sort them  ← Remembers previous
   ```

3. **Refining in ZSH** (pressing Tab):
   ```bash
   [Tab Tab] → Command shown
   [Press Tab] → Refine with history
   # add more details  ← Full context available
   ```

### ❌ Context Clears When:

1. **Pressing Esc** in ZSH:
   ```bash
   [Tab Tab] → Command shown
   [Press Esc] → Context cleared
   ```

2. **Using clear command**:
   ```bash
   # clear
   [Tab Tab]
   ```

3. **Running autoterm --clear**:
   ```bash
   autoterm --clear
   ```

4. **Starting new shell session**:
   ```bash
   exit      ← All context lost
   # new terminal session
   ```

## Best Practices

### Building Complex Commands

Use context to build iteratively:

```bash
# Step 1: Basic query
# find log files

# Step 2: Add time filter
# from last week

# Step 3: Add size filter  
# larger than 10MB

# Step 4: Add action
# compress them
```

Each query builds on previous ones!

### Starting Fresh

Clear context when switching tasks:

```bash
# Working with python files...
# find python files
# count lines
# ...

# Now switching to logs - clear context
# clear

# Now work with logs
# find error logs
# ...
```

### Viewing Context (Manual)

Check what's stored:

```bash
# View history file
cat ~/.config/autoterm/history.json

# In ZSH, press Tab after a command to see conversation history:
[Tab] → Shows full history
```

## Context in Different Shells

### ZSH (Full Context Features)

- ✅ Visual conversation history display
- ✅ Press Tab to see history and refine
- ✅ Special commands (`# clear`)
- ✅ Esc to cancel and clear
- ✅ Context indicator shows count

### Bash/Fish (Basic Context)

- ✅ Context persistence between commands
- ✅ `autoterm --clear` to clear
- ❌ No visual history display
- ❌ No Esc to clear (not applicable)

## Troubleshooting

### Context Not Working

**Symptom:** AI doesn't remember previous commands

**Solutions:**

1. **Check you're accepting commands:**
   - Press Enter, not Esc
   - Esc clears context!

2. **Verify context is being used:**
   ```bash
   # Should see this line:
   💭 Using context from N previous command(s)
   ```

3. **Check history file:**
   ```bash
   cat ~/.config/autoterm/history.json
   # Should contain recent queries
   ```

### Context Cleared Accidentally

**If you pressed Esc by accident:**
- No way to restore (it's intentional)
- Retype your queries to rebuild context

**Prevention:**
- Use Enter to execute
- Only use Esc when you want to cancel AND clear

### Context Too Long

**Symptom:** Responses are slow or truncated

**Solution:**
- Clear context: `autoterm --clear`
- AutoTerm only sends last 3 exchanges
- But if those 3 are very long, clear and start fresh

## Advanced Usage

### Manual Context Management

You can manually manage context by editing the history file:

```bash
# Backup context
cp ~/.config/autoterm/history.json ~/autoterm-backup.json

# Clear and restore later
autoterm --clear
# ... do some work ...
cp ~/autoterm-backup.json ~/.config/autoterm/history.json
```

### Programmatic Context

Advanced users can pass context to the backend:

```bash
python3 bin/autoterm "your query" --context '[{"query":"prev","command":"cmd"}]'
```

This is used internally by the shell integrations.

## Privacy Note

Context data stays local:
- In-memory during session
- Saved to ~/.config/autoterm/history.json
- Only sent to Groq API when generating commands
- Not logged or shared elsewhere

**To completely clear:**
```bash
autoterm --clear
rm -rf ~/.config/autoterm/
```

## Summary

| Action | Command | Clears Memory | Clears File |
|--------|---------|---------------|-------------|
| Special query | `# clear` + Tab Tab | ✅ | ❌ |
| Direct command | `autoterm --clear` | ✅ | ✅ |
| Cancel (Esc) | Press Esc | ✅ | ❌ |
| Exit terminal | `exit` | ✅ | ❌ |

**Recommendation:** Use `autoterm --clear` for a complete fresh start.

