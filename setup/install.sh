#!/usr/bin/env bash
# Audit Vault install script
# Merges vault permissions into ~/.config/opencode/opencode.json
# and installs skills into ~/.config/opencode/skills/
# Safe to re-run — will not clobber existing config keys.

set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GLOBAL_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
GLOBAL_CONFIG="$GLOBAL_CONFIG_DIR/opencode.json"
SKILLS_DIR="$GLOBAL_CONFIG_DIR/skills"

echo "=== Audit Vault Installer ==="
echo "Vault:  $VAULT_DIR"
echo "Config: $GLOBAL_CONFIG"
echo ""

# --- Require jq ---
if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required but not installed."
  echo "  Ubuntu/Debian: sudo apt install jq"
  echo "  Arch:          sudo pacman -S jq"
  echo "  Fedora:        sudo dnf install jq"
  echo "  macOS:         brew install jq"
  exit 1
fi

# --- Create global config dir if needed ---
mkdir -p "$GLOBAL_CONFIG_DIR"

# --- Create empty global config if it doesn't exist ---
if [[ ! -f "$GLOBAL_CONFIG" ]]; then
  echo '{ "$schema": "https://opencode.ai/config.json" }' > "$GLOBAL_CONFIG"
  echo "Created $GLOBAL_CONFIG"
fi

# --- Validate existing config is parseable ---
if ! jq empty "$GLOBAL_CONFIG" 2>/dev/null; then
  echo "ERROR: $GLOBAL_CONFIG exists but is not valid JSON."
  echo "Fix it manually or back it up and delete it, then re-run."
  exit 1
fi

# --- Show what will be merged ---
echo "Merging into $GLOBAL_CONFIG:"
echo '  permission.bash  = "ask"'
echo '  permission.edit  = "ask"'
echo '  permission.write = "ask"'
echo ""

# --- Backup existing config ---
BACKUP="$GLOBAL_CONFIG.bak.$(date +%Y%m%d_%H%M%S)"
cp "$GLOBAL_CONFIG" "$BACKUP"
echo "Backup saved: $BACKUP"

# --- Merge permissions (existing keys win for everything except permission block) ---
# Strategy: deep-merge permission block; all other existing keys are preserved
jq --argjson perms '{
  "bash":  "ask",
  "edit":  "ask",
  "write": "ask"
}' '
  .permission = (.permission // {} | . + $perms)
' "$GLOBAL_CONFIG" > /tmp/opencode_merged.json

mv /tmp/opencode_merged.json "$GLOBAL_CONFIG"
echo "✓ Permissions merged"

# --- Register vault AGENTS.md as instruction (relative path in vault-local opencode.json) ---
echo ""
echo "Registering vault AGENTS.md as instruction..."
LOCAL_CONFIG="$VAULT_DIR/opencode.json"
if [[ -f "$LOCAL_CONFIG" ]]; then
  jq --arg agents "AGENTS.md" '
    .instructions = (.instructions // [] | if index($agents) then . else . + [$agents] end)
  ' "$LOCAL_CONFIG" > /tmp/opencode_instructions.json && \
  mv /tmp/opencode_instructions.json "$LOCAL_CONFIG"
  echo "  ✓ AGENTS.md registered in $LOCAL_CONFIG"
else
  echo "  SKIP — no opencode.json at vault root. Create one manually."
fi

# --- Setup OpenCode Zen provider with Big Pickle as default ---
echo ""
echo "Setting up OpenCode Zen provider (big-pickle default)..."

jq --argjson opencode '{
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
}' '
  .model = (.model // "opencode/big-pickle") |
  .provider.opencode = (.provider.opencode // $opencode)
' "$GLOBAL_CONFIG" > /tmp/opencode_zen.json

mv /tmp/opencode_zen.json "$GLOBAL_CONFIG"

if jq -e '.model == "opencode/big-pickle"' "$GLOBAL_CONFIG" >/dev/null 2>&1; then
  echo "  ✓ Default model: opencode/big-pickle"
else
  echo "  ✓ Default model already set to: $(jq -r '.model // "unset"' "$GLOBAL_CONFIG") (preserved)"
fi

if jq -e '.provider.opencode' "$GLOBAL_CONFIG" >/dev/null 2>&1; then
  echo "  ✓ OpenCode Zen provider configured"
else
  echo "  ✗ Failed to add OpenCode Zen provider"
fi

# --- Install skills globally ---
echo ""
echo "Installing skills to $SKILLS_DIR ..."

for skill in templates tools; do
  SRC="$VAULT_DIR/setup/skills/$skill/SKILL.md"
  DST="$SKILLS_DIR/$skill"

  # If source not in vault, try to copy from existing global install (idempotent)
  if [[ ! -f "$SRC" ]]; then
    if [[ -f "$DST/SKILL.md" ]]; then
      echo "  SKIP $skill — already installed at $DST/SKILL.md"
    else
      echo "  SKIP $skill — source not found: $SRC"
    fi
    continue
  fi

  mkdir -p "$DST"

  if [[ -f "$DST/SKILL.md" ]]; then
    cp "$DST/SKILL.md" "$DST/SKILL.md.bak.$(date +%Y%m%d_%H%M%S)"
    echo "  Backed up existing $skill skill"
  fi

  cp "$SRC" "$DST/SKILL.md"
  echo "  ✓ Installed skill: $skill → $DST/SKILL.md"
done

# --- Create vault scaffold ---
echo ""
echo "Creating vault scaffold in $VAULT_DIR ..."

# Create directory structure (mitigations/ existence = install-complete marker)
mkdir -p "$VAULT_DIR/mitigations" "$VAULT_DIR/completed_audits" "$VAULT_DIR/metrics"
mkdir -p "$VAULT_DIR/docs"
mkdir -p "$VAULT_DIR/.obsidian/plugins"

echo "✓ mitigations/ completed_audits/ metrics/ created"
echo "✓ docs/ created"

# Copy startup.sh and make executable
if [[ -f "$VAULT_DIR/startup.sh" ]]; then
  chmod +x "$VAULT_DIR/startup.sh"
  echo "✓ startup.sh made executable"
fi

# Create .startup-required marker
touch "$VAULT_DIR/.startup-required"
echo "✓ .startup-required marker created"

# --- Setup Obsidian config ---
echo ""
echo "Setting up Obsidian configuration..."

# Create basic Obsidian config files if they don't exist
if [[ ! -f "$VAULT_DIR/.obsidian/app.json" ]]; then
  echo '{}' > "$VAULT_DIR/.obsidian/app.json"
fi

if [[ ! -f "$VAULT_DIR/.obsidian/appearance.json" ]]; then
  echo '{}' > "$VAULT_DIR/.obsidian/appearance.json"
fi

if [[ ! -f "$VAULT_DIR/.obsidian/core-plugins.json" ]]; then
  cat > "$VAULT_DIR/.obsidian/core-plugins.json" << 'EOF'
{
  "file-explorer": true,
  "global-search": true,
  "switcher": true,
  "graph": true,
  "backlink": true,
  "canvas": true,
  "outgoing-link": true,
  "tag-pane": true,
  "footnotes": false,
  "properties": true,
  "page-preview": true,
  "daily-notes": true,
  "templates": true,
  "note-composer": true,
  "command-palette": true,
  "slash-command": false,
  "editor-status": true,
  "bookmarks": true,
  "markdown-importer": false,
  "zk-prefixer": false,
  "random-note": false,
  "outline": true,
  "word-count": true,
  "slides": false,
  "audio-recorder": false,
  "workspaces": false,
  "file-recovery": true,
  "publish": false,
  "sync": true,
  "bases": true,
  "webviewer": false
}
EOF
fi

# Create community-plugins.json with opencode-obsidian enabled
if [[ ! -f "$VAULT_DIR/.obsidian/community-plugins.json" ]]; then
  cat > "$VAULT_DIR/.obsidian/community-plugins.json" << 'EOF'
[
  "opencode-obsidian"
]
EOF
  echo "✓ community-plugins.json created with opencode-obsidian"
else
  # Check if opencode-obsidian is already in the list
  if ! grep -q "opencode-obsidian" "$VAULT_DIR/.obsidian/community-plugins.json" 2>/dev/null; then
    # Add opencode-obsidian to the array
    jq '. += ["opencode-obsidian"]' "$VAULT_DIR/.obsidian/community-plugins.json" > /tmp/plugins.json && \
      mv /tmp/plugins.json "$VAULT_DIR/.obsidian/community-plugins.json"
    echo "✓ opencode-obsidian added to community-plugins.json"
  fi
fi

# --- Install opencode-obsidian plugin ---
echo ""
echo "Installing opencode-obsidian plugin..."

PLUGIN_DIR="$VAULT_DIR/.obsidian/plugins/opencode-obsidian"
PLUGIN_INSTALLED=false

# Download release artifacts from growlf fork
if command -v curl &>/dev/null; then
  echo "  Downloading plugin from GitHub release..."
  mkdir -p "$PLUGIN_DIR"
  
  # Download main.js, manifest.json, and styles.css from latest release
  if curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/main.js" -o "$PLUGIN_DIR/main.js" 2>&1 && \
     curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/manifest.json" -o "$PLUGIN_DIR/manifest.json" 2>&1 && \
     curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/styles.css" -o "$PLUGIN_DIR/styles.css" 2>&1; then
    if [[ -f "$PLUGIN_DIR/main.js" ]]; then
      echo "  ✓ Plugin downloaded from growlf/opencode-obsidian release"
      PLUGIN_INSTALLED=true
    fi
  else
    echo "  ✗ Download failed - check network or release availability"
    echo "    URL: https://github.com/growlf/opencode-obsidian/releases/latest"
  fi
fi

# Final check
if [[ "$PLUGIN_INSTALLED" != true ]]; then
  echo "  WARNING: Plugin installation failed."
  echo "  Please install manually via Obsidian Community Plugins or BRAT."
  echo "  Plugin: https://github.com/growlf/opencode-obsidian"
  echo "  Release URL: https://github.com/growlf/opencode-obsidian/releases/latest"
else
  # Create plugin data.json with defaults
  if [[ ! -f "$PLUGIN_DIR/data.json" ]]; then
    cat > "$PLUGIN_DIR/data.json" << 'EOF'
{
  "port": 14096,
  "hostname": "127.0.0.1",
  "autoStart": true,
  "opencodePath": "opencode",
  "projectDirectory": "",
  "startupTimeout": 45000,
  "defaultViewLocation": "main",
  "injectWorkspaceContext": false,
  "maxNotesInContext": 20,
  "maxSelectionLength": 2000,
  "customCommand": "",
  "useCustomCommand": false
}
EOF
    echo "  ✓ Plugin data.json created with defaults"
  fi
  
  # Enable plugin in Obsidian config
  # Obsidian enables plugins by adding them to enabled-plugins.json or similar
  # For community plugins, we need to ensure it's in community-plugins.json
  if [[ -f "$VAULT_DIR/.obsidian/community-plugins.json" ]]; then
    # Check if already enabled
    if ! grep -q "opencode-obsidian" "$VAULT_DIR/.obsidian/community-plugins.json" 2>/dev/null; then
      jq '. += ["opencode-obsidian"]' "$VAULT_DIR/.obsidian/community-plugins.json" > /tmp/plugins.json && \
        mv /tmp/plugins.json "$VAULT_DIR/.obsidian/community-plugins.json"
    fi
  else
    echo '["opencode-obsidian"]' > "$VAULT_DIR/.obsidian/community-plugins.json"
  fi
  echo "  ✓ Plugin registered in community-plugins.json"
  echo ""
  echo "  NOTE: You may need to enable the plugin in Obsidian:"
  echo "    1. Open Obsidian Settings > Community Plugins"
  echo "    2. Find 'OpenCode' in the list"
  echo "    3. Toggle it on"
fi

# Create basic workspace.json if it doesn't exist
if [[ ! -f "$VAULT_DIR/.obsidian/workspace.json" ]]; then
  cat > "$VAULT_DIR/.obsidian/workspace.json" << 'EOF'
{
  "main": {
    "id": "audit-vault-main",
    "type": "split",
    "children": [
      {
        "id": "audit-tabs",
        "type": "tabs",
        "children": [
          {
            "id": "audit-leaf",
            "type": "leaf",
            "state": {
              "type": "markdown",
              "state": {
                "file": "AGENTS.md",
                "mode": "source",
                "source": false
              },
              "icon": "lucide-file",
              "title": "AGENTS.md"
            }
          }
        ]
      }
    ],
    "direction": "vertical"
  },
  "left": {
    "id": "audit-left",
    "type": "split",
    "children": [
      {
        "id": "audit-files",
        "type": "tabs",
        "children": [
          {
            "id": "audit-explorer",
            "type": "leaf",
            "state": {
              "type": "file-explorer",
              "state": {
                "sortOrder": "alphabetical",
                "autoReveal": false
              },
              "icon": "lucide-folder-closed",
              "title": "Files"
            }
          }
        ]
      }
    ]
  }
}
EOF
  echo "✓ workspace.json created"
fi

# --- Done ---
echo ""
echo "=== Install complete ==="
echo ""
echo "To verify merged config:"
echo "  cat $GLOBAL_CONFIG | jq .permission"
echo ""
echo "To undo permissions later:"
echo "  jq 'del(.permission)' $GLOBAL_CONFIG > /tmp/oc.json && mv /tmp/oc.json $GLOBAL_CONFIG"
