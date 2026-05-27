#!/bin/bash

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Run in a temp parent dir to avoid contaminating real vaults
TEST_PARENT=$(mktemp -d)
trap 'rm -rf "$TEST_PARENT"' EXIT

export PARENT_DIR="$TEST_PARENT"

# new-vault.sh expects to be run from repo root, so we're simulating
# by directly invoking it with a vault name argument
VAULT_NAME="test-vault"
echo "$VAULT_NAME" | bash "$VAULT_DIR/setup/new-vault.sh" "$VAULT_NAME" 2>/dev/null

# Verify vault was created
if [ ! -d "$TEST_PARENT/$VAULT_NAME" ]; then
  echo "Vault directory not created."
  exit 1
fi

# Verify symlinks
if [ ! -L "$TEST_PARENT/$VAULT_NAME/AGENTS.md" ]; then
  echo "AGENTS.md symlink missing."
  exit 1
fi

if [ ! -L "$TEST_PARENT/$VAULT_NAME/docs" ]; then
  echo "docs/ symlink missing."
  exit 1
fi

# Verify local directories
for d in audits audits/completed mitigations metrics .obsidian; do
  if [ ! -d "$TEST_PARENT/$VAULT_NAME/$d" ]; then
    echo "Missing directory: $d"
    exit 1
  fi
done

# Verify opencode.json exists and is valid JSON
if ! jq empty "$TEST_PARENT/$VAULT_NAME/opencode.json" 2>/dev/null; then
  echo "Invalid opencode.json"
  exit 1
fi

# Verify startup.sh exists and is executable
if [ ! -x "$TEST_PARENT/$VAULT_NAME/startup.sh" ]; then
  echo "startup.sh missing or not executable"
  exit 1
fi

echo "new-vault.sh tests passed successfully"
