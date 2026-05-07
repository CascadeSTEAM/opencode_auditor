#!/bin/bash

# Relative path to install.sh (adjust as needed)
INSTALL_SCRIPT=./install.sh

# Check if install.sh exists
if [ ! -f "" ]; then
echo "install.sh not found, skipping test."
exit 0
fi

# Run shellcheck on install.sh to validate syntax and potential issues
shellcheck ""
