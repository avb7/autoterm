# Installation Guide

## Quick Install (Recommended)

```bash
cd /Users/aditya/Workspace/autoterm
./setup.sh
```

## Manual Installation

If the setup script fails due to pip configuration issues, follow these steps:

### 1. Install Python Dependencies Manually

If you encounter AWS CodeArtifact or custom repository errors:

```bash
# Force pip to use public PyPI
pip3 install groq --index-url https://pypi.org/simple

# Or if you prefer, use pip with --user flag
pip3 install --user groq --index-url https://pypi.org/simple
```

### 2. Setup API Key

```bash
python3 ai_terminal.py --setup
```

Enter your Groq API key when prompted. Get one free at: https://console.groq.com

### 3. Test Connection

```bash
python3 ai_terminal.py --test
```

You should see: `✓ Connection successful!`

### 4. Add to Shell

Add this line to your `~/.zshrc`:

```bash
source /Users/aditya/Workspace/autoterm/autoterm.zsh
```

### 5. Reload Shell

```bash
source ~/.zshrc
```

## Troubleshooting

### Error: "401 Error, Credentials not correct"

This means your pip is configured to use a custom package repository (like AWS CodeArtifact).

**Solution 1:** Force PyPI usage:
```bash
pip3 install groq --index-url https://pypi.org/simple
```

**Solution 2:** Temporarily disable custom pip config:
```bash
# Check your pip config
pip3 config list

# Unset custom index (if set)
pip3 config unset global.index-url

# Install groq
pip3 install groq

# Re-set your custom index if needed
```

**Solution 3:** Use a virtual environment:
```bash
cd /Users/aditya/Workspace/autoterm
python3 -m venv venv
source venv/bin/activate
pip install groq
deactivate

# Then modify autoterm.zsh to use: venv/bin/python3 instead of python3
```

### Error: "Module 'groq' not found"

Make sure the package is installed in the correct Python environment:

```bash
python3 -m pip install groq --index-url https://pypi.org/simple
```

### Error: "API key not found"

Run setup again:
```bash
python3 ai_terminal.py --setup
```

Or set it as environment variable in `~/.zshrc`:
```bash
export GROQ_API_KEY='your-api-key-here'
```

### Tab completion not working

1. Make sure autoterm.zsh is sourced:
   ```bash
   grep autoterm ~/.zshrc
   ```

2. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

3. Test manually:
   ```bash
   python3 /Users/aditya/Workspace/autoterm/ai_terminal.py "list files"
   ```

## Alternative: Direct API Usage

If you want to avoid the groq package entirely, you can modify `ai_terminal.py` to use direct HTTP requests:

```python
import requests

def generate_command(query, context_history=None, api_key=None):
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json',
    }
    
    data = {
        'model': 'llama-3.1-70b-versatile',
        'messages': messages,
        'temperature': 0.3,
        'max_tokens': 150,
    }
    
    response = requests.post(
        'https://api.groq.com/openai/v1/chat/completions',
        headers=headers,
        json=data
    )
    
    return response.json()['choices'][0]['message']['content'].strip()
```

Then install only `requests`:
```bash
pip3 install requests --index-url https://pypi.org/simple
```

## Verification

After installation, verify everything works:

```bash
# In your terminal, type:
# find python files

# Press Tab twice
# You should see a command suggestion!
```

