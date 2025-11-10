# Quick Start Guide 🚀

## Installation (5 minutes)

1. **Run the setup script:**
   ```bash
   cd /Users/aditya/Workspace/autoterm
   ./setup.sh
   ```

2. **Enter your Groq API key when prompted**

3. **Restart your terminal or run:**
   ```bash
   source ~/.zshrc
   ```

## Usage

### Try it now!

Type this in your terminal:
```
# find all python files in this directory
```

Then press **Tab Tab** (press Tab twice quickly)

You should see:
- 🤖 A loading message
- The generated command
- Options: `[Enter: Execute | Esc: Cancel | Tab: Refine]`

### Key Bindings

- **Tab Tab** (after typing `#`): Generate command from AI
- **Enter**: Execute the command
- **Esc**: Cancel and return to prompt
- **Tab** (in suggestion mode): Refine with additional context

### Examples to Try

```bash
# show me the 10 largest files in my home directory
```

```bash
# create a git commit with all changes
```

```bash
# find all processes using more than 50% CPU
```

```bash
# compress all videos in this folder
```

## Tips

1. **Be specific**: The more context you give, the better the command
2. **Context is remembered**: Each query builds on previous ones in your session
3. **Refine iteratively**: Press Tab to see history and refine with full context
4. **Clear when needed**: Type `# clear` to start fresh
5. **Review before executing**: Always check the command before pressing Enter
6. **System-aware**: The AI knows your OS, shell, and current directory

## Context Magic ✨

The AI remembers all your queries! Try this:

```bash
# find python files
```
Press Tab Tab → Gets: `find . -name "*.py"`

Then type a new query (context automatically included):
```bash
# only in src directory
```
💭 Using context from 1 previous command(s)
Press Tab Tab → Gets: `find src -name "*.py"`

The AI understood you wanted to modify the previous find command!

## Troubleshooting

If something doesn't work:

1. **Check installation:**
   ```bash
   python3 /Users/aditya/Workspace/autoterm/ai_terminal.py --test
   ```

2. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

3. **Check API key:**
   ```bash
   cat ~/.config/autoterm/config.json
   ```

Enjoy! 🎉

