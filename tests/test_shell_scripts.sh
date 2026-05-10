#!/bin/bash
# Shellcheck and basic integrity tests for install.sh and bootstrap.sh

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

shellcheck "$VAULT_DIR/setup/install.sh"
echo 'Checking shell script: install.sh'

shellcheck "$VAULT_DIR/bootstrap.sh"
echo 'Checking shell script: bootstrap.sh'