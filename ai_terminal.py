#!/usr/bin/env python3
"""
AI Terminal Assistant - Main backend script
Interfaces with Groq API to generate terminal commands
"""

import os
import sys
import json
import argparse
from pathlib import Path
from groq import Groq

# Configuration
CONFIG_DIR = Path.home() / ".config" / "autoterm"
CONFIG_FILE = CONFIG_DIR / "config.json"
HISTORY_FILE = CONFIG_DIR / "history.json"

def load_config():
    """Load configuration from file or environment"""
    config = {}
    
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, 'r') as f:
            config = json.load(f)
    
    # Environment variable takes precedence
    if 'GROQ_API_KEY' in os.environ:
        config['api_key'] = os.environ['GROQ_API_KEY']
    
    return config

def save_config(config):
    """Save configuration to file"""
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

def load_history():
    """Load query history"""
    if HISTORY_FILE.exists():
        with open(HISTORY_FILE, 'r') as f:
            return json.load(f)
    return []

def save_history(history):
    """Save query history"""
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(HISTORY_FILE, 'w') as f:
        json.dump(history[-10:], f, indent=2)  # Keep last 10 entries

def get_system_context():
    """Get system information for context"""
    import platform
    return f"""You are a terminal command assistant. Generate ONLY the terminal command needed, nothing else.

System: {platform.system()} {platform.release()}
Shell: {os.environ.get('SHELL', 'unknown')}
Working Directory: {os.getcwd()}

Rules:
1. Output ONLY the command, no explanations, no markdown, no code blocks
2. Use Unix/Linux/macOS commands appropriate for the system
3. Be concise and practical
4. If multiple commands are needed, separate with && or ;
5. Always consider safety - avoid destructive commands without confirmation flags"""

def generate_command(query, context_history=None, client=None):
    """Generate a terminal command using Groq API"""
    
    messages = [
        {"role": "system", "content": get_system_context()}
    ]
    
    # Add context from previous queries if available
    if context_history and len(context_history) > 0:
        for entry in context_history[-3:]:  # Last 3 exchanges
            messages.append({"role": "user", "content": entry['query']})
            messages.append({"role": "assistant", "content": entry['command']})
    
    # Add current query
    messages.append({"role": "user", "content": query})
    
    try:
        # Use Groq's compound-mini model (ultra-fast and efficient)
        chat_completion = client.chat.completions.create(
            messages=messages,
            model="groq/compound-mini",  # Ultra-fast compound model
            temperature=0.3,  # Lower temperature for more deterministic outputs
            max_tokens=150,
            top_p=0.9,
        )
        
        command = chat_completion.choices[0].message.content.strip()
        
        # Clean up the response - remove any markdown formatting
        if command.startswith('```'):
            lines = command.split('\n')
            command = '\n'.join([l for l in lines if not l.startswith('```')])
            command = command.strip()
        
        return command
        
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        return None

def main():
    parser = argparse.ArgumentParser(description='AI Terminal Command Generator')
    parser.add_argument('query', nargs='?', help='Query to generate command for')
    parser.add_argument('--setup', action='store_true', help='Setup API key')
    parser.add_argument('--context', type=str, help='JSON string with context history')
    parser.add_argument('--test', action='store_true', help='Test the connection')
    
    args = parser.parse_args()
    
    # Setup mode
    if args.setup:
        print("Setting up AI Terminal Assistant")
        api_key = input("Enter your Groq API key: ").strip()
        config = {'api_key': api_key}
        save_config(config)
        print(f"Configuration saved to {CONFIG_FILE}")
        return
    
    # Load configuration
    config = load_config()
    
    if 'api_key' not in config:
        print("Error: Groq API key not found. Run with --setup or set GROQ_API_KEY environment variable", file=sys.stderr)
        sys.exit(1)
    
    # Initialize Groq client
    client = Groq(api_key=config['api_key'])
    
    # Test mode
    if args.test:
        try:
            result = generate_command("list files in current directory", client=client)
            if result:
                print(f"✓ Connection successful! Test command: {result}")
            else:
                print("✗ Connection failed", file=sys.stderr)
                sys.exit(1)
        except Exception as e:
            print(f"✗ Connection failed: {e}", file=sys.stderr)
            sys.exit(1)
        return
    
    if not args.query:
        print("Error: No query provided", file=sys.stderr)
        sys.exit(1)
    
    # Parse context if provided
    context_history = []
    if args.context:
        try:
            context_history = json.loads(args.context)
        except:
            pass
    
    # Generate command
    command = generate_command(args.query, context_history, client)
    
    if command:
        # Save to history
        history = load_history()
        history.append({
            'query': args.query,
            'command': command
        })
        save_history(history)
        
        # Output the command
        print(command)
    else:
        sys.exit(1)

if __name__ == '__main__':
    main()

