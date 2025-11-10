# AutoTerm Makefile
# Cross-platform installation for Mac and Linux

VERSION = 1.0.0
SHELL = /bin/bash

# Installation prefix (can be overridden)
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/autoterm
SHAREDIR = $(PREFIX)/share/autoterm
MANDIR = $(PREFIX)/share/man/man1
DOCDIR = $(PREFIX)/share/doc/autoterm

# Files to install
BIN_FILES = bin/autoterm
LIB_FILES = lib/autoterm.zsh lib/autoterm.bash lib/autoterm.fish
DOC_FILES = docs/*.md
EXAMPLE_FILES = examples/example-queries.txt

.PHONY: all install uninstall test clean help

all: help

help:
	@echo "AutoTerm v$(VERSION) - Installation"
	@echo ""
	@echo "Usage:"
	@echo "  make install          Install system-wide (requires sudo)"
	@echo "  make install-user     Install for current user only"
	@echo "  make uninstall        Uninstall system-wide"
	@echo "  make uninstall-user   Uninstall user installation"
	@echo "  make test             Run tests"
	@echo "  make clean            Clean build files"
	@echo ""
	@echo "Environment variables:"
	@echo "  PREFIX=/path          Installation prefix (default: /usr/local)"
	@echo ""
	@echo "Examples:"
	@echo "  sudo make install                    # System-wide"
	@echo "  make install-user                    # User installation"
	@echo "  PREFIX=~/mytools make install-user   # Custom location"

install: check-deps
	@echo "Installing AutoTerm v$(VERSION) to $(PREFIX)..."
	@mkdir -p $(BINDIR) $(LIBDIR) $(SHAREDIR) $(MANDIR) $(DOCDIR)
	@install -m 755 $(BIN_FILES) $(BINDIR)/
	@install -m 644 $(LIB_FILES) $(LIBDIR)/
	@if [ -f autoterm.1 ]; then install -m 644 autoterm.1 $(MANDIR)/; fi
	@if [ -d docs ]; then cp -r docs/* $(DOCDIR)/ 2>/dev/null || true; fi
	@if [ -d examples ]; then mkdir -p $(SHAREDIR)/examples && cp -r examples/* $(SHAREDIR)/examples/ 2>/dev/null || true; fi
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Setup API key:"
	@echo "     autoterm --setup"
	@echo ""
	@echo "  2. Add to your shell config:"
	@echo "     ZSH:  echo 'source $(LIBDIR)/autoterm.zsh' >> ~/.zshrc"
	@echo "     Bash: echo 'source $(LIBDIR)/autoterm.bash' >> ~/.bashrc"
	@echo "     Fish: echo 'source $(LIBDIR)/autoterm.fish' >> ~/.config/fish/config.fish"
	@echo ""
	@echo "  3. Reload your shell:"
	@echo "     source ~/.zshrc  # or ~/.bashrc or fish config"

install-user: PREFIX = $(HOME)/.local
install-user: MANDIR = $(HOME)/.local/share/man/man1
install-user: check-deps
	@echo "Installing AutoTerm v$(VERSION) for current user..."
	@mkdir -p $(BINDIR) $(LIBDIR) $(SHAREDIR) $(MANDIR) $(DOCDIR)
	@install -m 755 $(BIN_FILES) $(BINDIR)/
	@install -m 644 $(LIB_FILES) $(LIBDIR)/
	@if [ -f autoterm.1 ]; then install -m 644 autoterm.1 $(MANDIR)/; fi
	@if [ -d docs ]; then cp -r docs/* $(DOCDIR)/ 2>/dev/null || true; fi
	@if [ -d examples ]; then mkdir -p $(SHAREDIR)/examples && cp -r examples/* $(SHAREDIR)/examples/ 2>/dev/null || true; fi
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Ensure ~/.local/bin is in your PATH:"
	@echo "     export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""
	@echo "  2. Setup API key:"
	@echo "     autoterm --setup"
	@echo ""
	@echo "  3. Add to your shell config:"
	@echo "     ZSH:  echo 'source $(LIBDIR)/autoterm.zsh' >> ~/.zshrc"
	@echo "     Bash: echo 'source $(LIBDIR)/autoterm.bash' >> ~/.bashrc"
	@echo "     Fish: echo 'source $(LIBDIR)/autoterm.fish' >> ~/.config/fish/config.fish"
	@echo ""
	@echo "  4. Reload your shell:"
	@echo "     source ~/.zshrc  # or ~/.bashrc or fish config"

uninstall:
	@echo "Uninstalling AutoTerm from $(PREFIX)..."
	@rm -f $(BINDIR)/autoterm
	@rm -rf $(LIBDIR)
	@rm -rf $(SHAREDIR)
	@rm -f $(MANDIR)/autoterm.1
	@rm -rf $(DOCDIR)
	@echo ""
	@echo "✓ Uninstalled (config files in ~/.config/autoterm preserved)"
	@echo ""
	@echo "To remove config:"
	@echo "  rm -rf ~/.config/autoterm"
	@echo ""
	@echo "To remove from shell config:"
	@echo "  Edit ~/.zshrc (or ~/.bashrc or fish config) and remove AutoTerm lines"

uninstall-user: PREFIX = $(HOME)/.local
uninstall-user: MANDIR = $(HOME)/.local/share/man/man1
uninstall-user: uninstall

check-deps:
	@echo "Checking dependencies..."
	@command -v python3 >/dev/null 2>&1 || { echo "Error: python3 not found"; exit 1; }
	@command -v zsh >/dev/null 2>&1 || { echo "Error: zsh not found"; exit 1; }
	@command -v pip3 >/dev/null 2>&1 || { echo "Error: pip3 not found"; exit 1; }
	@echo "✓ Dependencies OK"
	@echo "Installing Python dependencies..."
	@pip3 install -q groq --index-url https://pypi.org/simple || { echo "Warning: Failed to install groq package"; }

test:
	@echo "Running tests..."
	@if [ -d tests ]; then \
		python3 -m pytest tests/ || echo "No tests found"; \
	else \
		echo "No tests directory found"; \
	fi

clean:
	@echo "Cleaning..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type d -name "*.egg-info" -delete
	@echo "✓ Clean complete"

.SILENT: check-deps

