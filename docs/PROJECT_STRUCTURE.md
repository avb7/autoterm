# AutoTerm Project Structure

This document explains the organization of the AutoTerm codebase.

## Directory Layout

```
autoterm/
├── bin/                      # Executable programs
│   └── autoterm-backend      # Python backend (AI command generator)
│
├── lib/                      # Library files
│   └── autoterm.zsh         # ZSH shell integration
│
├── docs/                     # Documentation (all MD files)
│   ├── INDEX.md             # Documentation index
│   ├── README.md            # Complete documentation
│   ├── QUICKSTART.md        # Quick start guide
│   ├── INSTALL.md           # Installation instructions
│   ├── SHELL_SUPPORT.md     # Shell & terminal compatibility
│   ├── TROUBLESHOOTING.md   # Troubleshooting guide
│   ├── FAQ.md               # Frequently asked questions
│   ├── CONTRIBUTING.md      # Contribution guidelines
│   ├── CHANGELOG.md         # Version history
│   └── PROJECT_STRUCTURE.md # This file
│
├── examples/                 # Example files
│   └── example-queries.txt  # Sample queries to try
│
├── tests/                    # Test files
│   └── test_basic.py        # Basic tests
│
├── share/                    # Shared data (used at runtime)
│   └── autoterm/            # AutoTerm specific shared files
│
├── install.sh               # Interactive installation script
├── uninstall.sh             # Uninstallation script
├── Makefile                 # Build and installation automation
├── autoterm.1               # Man page (Unix manual)
├── VERSION                  # Version file
├── LICENSE                  # MIT License
├── README.md                # Main README (project overview)
├── CHANGELOG.md             # Version history
├── CONTRIBUTING.md          # Contribution guidelines
└── .gitignore              # Git ignore rules
```

## File Descriptions

### Core Components

**`bin/autoterm-backend`**
- Python script that interfaces with Groq API
- Handles command generation
- Manages configuration and history
- Entry point: `autoterm-backend --setup`, `autoterm-backend --test`

**`lib/autoterm.zsh`**
- ZSH shell integration
- Implements key bindings (double-tab detection)
- Manages context and state
- Provides interactive mode
- Sourced by user's `~/.zshrc`

### Installation Files

**`Makefile`**
- Standard Unix build system
- Targets: `install`, `install-user`, `uninstall`, `test`, `clean`
- Handles cross-platform installation (macOS/Linux)
- Manages file permissions

**`install.sh`**
- Interactive installation script
- User-friendly prompts
- Dependency checking
- API key setup
- Configuration file management

**`uninstall.sh`**
- Clean uninstallation
- Option to preserve config
- Removes from `.zshrc`

### Documentation

**`README.md`**
- Project overview
- Quick start guide
- Feature highlights
- Installation instructions

**`docs/README.md`**
- Comprehensive documentation
- All features explained
- Advanced usage

**`docs/QUICKSTART.md`**
- Get started in 5 minutes
- Essential commands
- Common use cases

**`docs/INSTALL.md`**
- Detailed installation guide
- Troubleshooting
- Manual installation steps

**`autoterm.1`**
- Unix man page
- Command reference
- Available via `man autoterm`

### Configuration Files

**`VERSION`**
- Single source of truth for version
- Used by Makefile and scripts

**`LICENSE`**
- MIT License text
- Open source license

**`.gitignore`**
- Git ignore patterns
- Excludes build artifacts, configs, old files

**`CHANGELOG.md`**
- Version history
- Release notes
- Breaking changes

**`CONTRIBUTING.md`**
- How to contribute
- Development setup
- Code style guide

## Installation Paths

### System-Wide Installation (`sudo make install`)

```
/usr/local/
├── bin/
│   └── autoterm-backend
├── lib/
│   └── autoterm/
│       └── autoterm.zsh
├── share/
│   ├── autoterm/
│   │   └── examples/
│   ├── doc/
│   │   └── autoterm/
│   └── man/
│       └── man1/
│           └── autoterm.1
```

### User Installation (`make install-user`)

```
~/.local/
├── bin/
│   └── autoterm-backend
├── lib/
│   └── autoterm/
│       └── autoterm.zsh
└── share/
    ├── autoterm/
    │   └── examples/
    ├── doc/
    │   └── autoterm/
    └── man/
        └── man1/
            └── autoterm.1
```

### User Configuration

```
~/.config/autoterm/
├── config.json      # API key (permissions: 600)
└── history.json     # Command history (last 10)
```

### Shell Configuration

```
~/.zshrc             # Sources lib/autoterm.zsh
```

## Build Process

1. **Development**: Edit files in `bin/`, `lib/`, `docs/`
2. **Testing**: `make test` (runs tests in `tests/`)
3. **Installation**: `make install` or `make install-user`
   - Copies files to appropriate locations
   - Sets correct permissions
   - Installs Python dependencies
4. **Configuration**: User runs `autoterm-backend --setup`
5. **Usage**: Source in shell, use `# query` + Tab Tab

## Cross-Platform Compatibility

### macOS
- Uses `/usr/local` for system installs
- Uses `~/.local` for user installs
- Homebrew-compatible structure

### Linux
- Follows FHS (Filesystem Hierarchy Standard)
- Compatible with most distributions
- Works with package managers (future)

### Common to Both
- POSIX-compliant shell scripts
- Python 3.7+ compatibility
- Standard Unix file permissions
- XDG Base Directory Specification for config

## Development Workflow

1. Clone repository
2. Edit `bin/autoterm-backend` or `lib/autoterm.zsh`
3. Test with `make install-user` (doesn't require sudo)
4. Iterate
5. Update docs and version
6. Create PR

## Version Management

- **VERSION** file: Single source of truth
- Update in three places:
  1. `VERSION` file
  2. `bin/autoterm-backend` (VERSION constant)
  3. `lib/autoterm.zsh` (comment header)
  4. `Makefile` (VERSION variable)
  5. `CHANGELOG.md`

## Dependencies

### Runtime
- Python 3.7+
- zsh shell
- groq Python package

### Development
- make
- sed, grep (for Makefile)
- git (for version control)

### Optional
- pytest (for running tests)
- man (for viewing man page)

## Notes

- Old files (`ai_terminal.py`, `autoterm.zsh`, `setup.sh`) are preserved for reference but ignored by git
- The new structure follows Unix/Linux packaging standards
- All paths are configurable via PREFIX variable
- Designed for easy packaging (Homebrew, apt, etc.)

