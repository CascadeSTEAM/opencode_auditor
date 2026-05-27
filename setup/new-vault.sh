#!/usr/bin/env bash
# new-vault.sh — Create a named audit vault under ~/opencode-auditor/
# Usage: bash setup/new-vault.sh [name]
#   If name is omitted, defaults to audit-$(hostname)
# Must be run from the toolkit repo root.

set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="${PARENT_DIR:-$(cd "$TOOLKIT_DIR/.." && pwd)}"
mkdir -p "$PARENT_DIR"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
fail()  { echo -e "${RED}✗${NC} $1"; }

# --- Determine vault name ---
DEFAULT_NAME="audit-$(hostname)"
VAULT_NAME="${1:-}"
while [[ -z "$VAULT_NAME" ]]; do
  read -rp "Name this vault [$DEFAULT_NAME]: " input
  VAULT_NAME="${input:-$DEFAULT_NAME}"
done

VAULT_DIR="$PARENT_DIR/$VAULT_NAME"

if [[ -d "$VAULT_DIR" ]]; then
  warn "Vault '$VAULT_NAME' already exists at $VAULT_DIR"
  read -rp "Re-scaffold it? Existing audits/mitigations/data will be preserved. [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy] ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# --- Create vault structure ---
echo "Creating vault '$VAULT_NAME' at $VAULT_DIR ..."
mkdir -p "$VAULT_DIR"

# Symlink AGENTS.md and docs/ from the toolkit
ln -snf "../repo/AGENTS.md" "$VAULT_DIR/AGENTS.md"
ln -snf "../repo/docs"      "$VAULT_DIR/docs"

# Local data directories (never tracked)
mkdir -p "$VAULT_DIR/audits/completed"
mkdir -p "$VAULT_DIR/mitigations"
mkdir -p "$VAULT_DIR/metrics"
mkdir -p "$VAULT_DIR/.obsidian/plugins"

# Copy startup.sh from toolkit
cp "$TOOLKIT_DIR/startup.sh" "$VAULT_DIR/startup.sh"
chmod +x "$VAULT_DIR/startup.sh"

# Create .startup-required marker
touch "$VAULT_DIR/.startup-required"

# Generate vault-local opencode.json
cat > "$VAULT_DIR/opencode.json" <<- VAULTJSON
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "opencode/big-pickle",
  "provider": {
    "opencode": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "OpenCode Zen",
      "options": {
        "baseURL": "https://opencode.ai/zen/v1",
        "apiKey": "{env:OPENCODE_API_KEY}"
      },
      "models": {
        "big-pickle": {
          "name": "Big Pickle",
          "tools": true,
          "limit": {
            "context": 200000,
            "output": 8192
          }
        }
      }
    }
  },
  "permission": {
    "bash": "ask",
    "edit": "ask",
    "write": "ask"
  },
  "instructions": [
    "AGENTS.md"
  ]
}
VAULTJSON

echo ""
echo "=== Vault created ==="
echo "  Path: $VAULT_DIR"
echo "  Usage: audit"
echo "    or:  cd $VAULT_DIR && opencode"
echo ""
info "AGENTS.md linked from toolkit (always fresh via symlink)"
info "docs/ linked from toolkit"
info "audits/ mitigations/ metrics/ are private — never tracked"
echo ""
echo "To create another vault: bash $TOOLKIT_DIR/setup/new-vault.sh"
