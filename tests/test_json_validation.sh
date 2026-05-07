#!/bin/bash

# Relative path to config file (adjust as needed)
CONFIG_FILE=./config.json

# Check if config.json exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "config.json not found, skipping test."
  exit 0
fi

# Validate the structure of JSON file using jq
if ! jq . "$CONFIG_FILE" > /dev/null; then
  echo "Invalid structure in config.json"
  exit 1
fi

# Verify expected key presence (example)
EXPECTED_KEYS="keyA keyB"

for KEY in $EXPECTED_KEYS; do
  if ! jq -e ". | has(""$KEY")" "$CONFIG_FILE" > /dev/null; then
    echo "Missing '$KEY' in config.json"
    exit 1
  fi
done

echo "Validation tests for JSON configuration passed successfully"