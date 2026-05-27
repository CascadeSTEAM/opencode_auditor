#!/bin/bash

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$VAULT_DIR/opencode.json"

# Check if opencode.json exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "opencode.json not found, skipping test."
  exit 0
fi

# Validate the structure of JSON file using jq
if ! jq . "$CONFIG_FILE" > /dev/null; then
  echo "Invalid structure in opencode.json"
  exit 1
fi

# Verify expected key presence
EXPECTED_KEYS="model provider permission instructions"

for KEY in $EXPECTED_KEYS; do
  if ! jq -e ". | has(\"$KEY\")" "$CONFIG_FILE" > /dev/null; then
    echo "Missing '$KEY' in opencode.json"
    exit 1
  fi
done

echo "Validation tests for JSON configuration passed successfully"