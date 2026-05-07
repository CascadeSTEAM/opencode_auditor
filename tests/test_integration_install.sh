#!/bin/bash

# Check if install.sh exists
if [ ! -f /home/netyeti/Audit/install.sh ]; then
echo "install.sh not found, skipping test."
exit 0
fi

# Create a temporary directory for testing
mkdir -p /tmp/integration_test_install
cd /tmp/integration_test_install

# Run install.sh in this sandbox environment
/home/netyeti/Audit/install.sh

# Verify the installation steps (e.g., check for created files or configurations)
if [ ! -d "$HOME/.local/bin" ]; then
echo "Installation failed: .local/bin directory not found."
exit 1
fi

echo "Integration tests for install.sh passed successfully"