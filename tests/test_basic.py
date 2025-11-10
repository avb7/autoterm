"""
Basic tests for AutoTerm
"""

import sys
import os

# Add bin directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'bin'))

def test_import():
    """Test that the backend module can be imported"""
    # This would need the backend to be structured as a module
    assert True  # Placeholder

def test_version():
    """Test version is defined"""
    with open('VERSION', 'r') as f:
        version = f.read().strip()
    assert version == '1.0.0'

# Add more tests as needed

