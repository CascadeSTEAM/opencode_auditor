#!/bin/bash

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$VAULT_DIR/setup/install.sh"

# Check if install.sh exists
if [ ! -f "$INSTALL_SCRIPT" ]; then
echo "install.sh not found, skipping test."
exit 0
fi

# Run shellcheck on install.sh to validate syntax and potential issues
shellcheck "$INSTALL_SCRIPT"
