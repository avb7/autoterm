# Contributing to AutoTerm

Thank you for considering contributing to AutoTerm! 🎉

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/yourusername/autoterm/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, zsh version, Python version)
   - Relevant logs or error messages

### Suggesting Features

1. Check [existing feature requests](https://github.com/yourusername/autoterm/issues?q=is%3Aissue+label%3Aenhancement)
2. Create a new issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach (if you have ideas)

### Pull Requests

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test thoroughly on both macOS and Linux (if possible)
5. Update documentation if needed
6. Commit with clear messages
7. Push to your fork
8. Create a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/autoterm.git
cd autoterm

# Create a development environment
python3 -m venv venv
source venv/bin/activate
pip install groq

# Test your changes
make install-user
```

### Code Style

- **Python**: Follow PEP 8
- **Shell**: Follow Google Shell Style Guide
- **Comments**: Write clear, concise comments
- **Documentation**: Update relevant docs

### Testing

Currently, AutoTerm has basic tests. We welcome contributions to improve test coverage!

```bash
# Run tests
make test
```

### Documentation

- Update README.md for major features
- Update man page (autoterm.1) for command changes
- Add examples to examples/example-queries.txt
- Update CHANGELOG.md

### Commit Messages

Use clear, descriptive commit messages:

```
feat: add bash shell support
fix: resolve double-tab timing issue
docs: update installation guide
test: add unit tests for context management
```

### Questions?

Feel free to ask questions by:
- Opening a [Discussion](https://github.com/yourusername/autoterm/discussions)
- Creating an issue
- Reaching out to maintainers

## Code of Conduct

Be respectful, inclusive, and constructive. We're all here to make AutoTerm better!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for making AutoTerm better! 🚀

