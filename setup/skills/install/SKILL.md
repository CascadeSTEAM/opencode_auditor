---
name: vault-install
description: Complete first-time Audit Vault setup — OS detection, security tool installation, Obsidian config, vault scaffold.
---

# Install Skill — Post-Clone Setup

Load this skill when completing an Audit Vault first-time setup. Detect the target OS and handle each step accordingly.

## 1. OS Detection

```bash
cat /etc/os-release 2>/dev/null || sw_vers 2>/dev/null
```

## 2. Install Security Tools

### Ubuntu / Debian
```bash
sudo apt update && sudo apt install -y lynis rkhunter fail2ban firewalld
```

### Fedora
```bash
sudo dnf install -y lynis rkhunter fail2ban firewalld
```

### Arch Linux
```bash
sudo pacman -S --noconfirm lynis rkhunter fail2ban firewalld
```

### macOS (partial)
```bash
brew install lynis
# rkhunter and fail2ban have limited macOS support
```

## 3. Configure Obsidian

Create `.obsidian/` config files in the vault directory:

### app.json
```json
{}
```

### appearance.json
```json
{}
```

### core-plugins.json
```json
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
```

### community-plugins.json
```json
["opencode-obsidian"]
```

### Download opencode-obsidian plugin
```bash
PLUGIN_DIR=".obsidian/plugins/opencode-obsidian"
mkdir -p "$PLUGIN_DIR"
curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/main.js" -o "$PLUGIN_DIR/main.js"
curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/manifest.json" -o "$PLUGIN_DIR/manifest.json"
curl -fsSL "https://github.com/growlf/opencode-obsidian/releases/latest/download/styles.css" -o "$PLUGIN_DIR/styles.css"
```

### Create plugin data.json
```json
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
```

## 4. Create Vault Scaffold

```bash
mkdir -p audits/completed mitigations metrics
```

## 5. Verify

```bash
ls -la mitigations/ audits/completed/ metrics/ .obsidian/plugins/opencode-obsidian/
```

After completing setup, inform the user the vault is ready and offer to opencode or launch Obsidian.
