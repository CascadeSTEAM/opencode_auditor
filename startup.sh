#!/usr/bin/env bash
# Audit Vault — startup health check
# Run this to check vault state. No destructive actions, no prompts.
# Exit 0 = healthy, 1 = missing files/dirs need repair

set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLKIT_DIR="$(cd "$VAULT_DIR/../repo" && pwd 2>/dev/null || echo "")"
MISSING=false

# --- 1. Vault structure ---
echo "=== VAULT HEALTH ==="

for d in mitigations audits/completed audits metrics; do
  if [[ -d "$VAULT_DIR/$d" ]]; then
    echo "dir_$d: ok"
  else
    echo "dir_$d: MISSING — creating"
    mkdir -p "$VAULT_DIR/$d"
  fi
done

# --- 2. Active audit scan ---
ACTIVE_PLAN=$(grep -rls -- "- \[ \]" "$VAULT_DIR"/audits/plan_*.md 2>/dev/null | sort -r | head -1 || true)
if [[ -n "$ACTIVE_PLAN" ]]; then
  echo "active_plan: $(basename "$ACTIVE_PLAN")"
  TOTAL=$(grep -c -- "- \[ \]" "$ACTIVE_PLAN" 2>/dev/null || echo 0)
  echo "open_items: $TOTAL"
else
  echo "active_plan: none"
  echo "open_items: 0"
fi

# --- 3. Security tools ---
echo "=== TOOLS CHECK ==="
for tool in lynis rkhunter jq; do
  if command -v "$tool" &>/dev/null; then
    echo "tool_$tool: installed"
  else
    echo "tool_$tool: missing"
  fi
done

if systemctl is-active --quiet auditd 2>/dev/null; then
  echo "tool_auditd: active"
else
  echo "tool_auditd: inactive"
fi

# --- 4. Vault startup marker ---
echo "=== MARKER ==="
if [[ -f "$VAULT_DIR/.startup-required" ]]; then
  echo "startup_required: yes"
else
  echo "startup_required: no"
fi

# --- 5. Template change detection ---
echo "=== TEMPLATE CHECK ==="
if [[ -n "$TOOLKIT_DIR" && -f "$TOOLKIT_DIR/opencode.json" && -f "$VAULT_DIR/opencode.json" ]]; then
  TEMPLATE_KEYS=$(jq -r 'paths(scalars) | join(".")' "$TOOLKIT_DIR/opencode.json" | sort)
  VAULT_KEYS=$(jq -r 'paths(scalars) | join(".")' "$VAULT_DIR/opencode.json" | sort)
  NEW_KEYS=$(comm -23 <(echo "$TEMPLATE_KEYS") <(echo "$VAULT_KEYS") || true)

  if [[ -n "$NEW_KEYS" ]]; then
    echo "template_update: new config keys available"
    echo ""
    echo "The template has new settings not in this vault:"
    # shellcheck disable=SC2001
    echo "$NEW_KEYS" | sed 's/^/  + /'
    echo ""
    echo "To apply: cp $TOOLKIT_DIR/opencode.json $VAULT_DIR/opencode.json"
    echo "(Your existing settings will be lost. Merge manually if needed.)"
  else
    echo "template_update: none"
  fi
else
  echo "template_update: skipped (toolkit not found)"
fi

# --- Exit ---
if [[ "$MISSING" == true ]]; then
  echo "=== RESULT: MISSING FILES ==="
  echo "Run 'mkdir -p audits/completed mitigations metrics' to fix."
  exit 1
fi

echo "=== RESULT: HEALTHY ==="
exit 0
