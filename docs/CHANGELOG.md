# Changelog

All notable changes to AutoTerm will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-10

### Added
- Initial release of AutoTerm
- AI-powered command generation using Groq API
- Double-tab activation in zsh
- Context-aware conversation persistence throughout session
- Interactive refinement with conversation history
- Special commands (`# clear`, `# reset`)
- Context indicator showing number of previous commands
- Professional package structure (bin, lib, share, docs)
- Makefile for cross-platform installation
- Interactive installation script
- Uninstallation script
- Man page documentation
- Comprehensive README and guides
- Example queries collection
- Support for macOS and Linux
- User and system-wide installation modes
- Secure config file permissions (600)
- Command history (last 10 entries)

### Features
- Natural language to shell command translation
- groq/compound-mini model for ultra-fast responses
- Context preservation across multiple queries
- Visual conversation history display
- Refine workflow with Tab key
- Clean command output (removes markdown formatting)
- System context awareness (OS, shell, working directory)
- Safety-conscious command generation

### Security
- API keys stored with 600 permissions
- Config files in ~/.config/autoterm
- No hardcoded credentials

## [Unreleased]

### Planned
- Bash support
- Fish shell support
- Command explanation mode
- History search
- Favorite commands
- Plugin system
- Multiple AI model support
- Offline mode with local models
- Web UI for configuration
- Telemetry (opt-in)
- Auto-update mechanism

