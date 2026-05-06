# INSTALL.md — Audit Vault First-Run Setup

This file is for **humans and the agent on first run only**. After setup is complete, `mitigations/` exists and this file is ignored by the agent.

> **About `opencode.json` in the vault root**
> The vault ships with an `opencode.json` at its root. This works fine — it does NOT break access to the free Big Pickle model via OpenCode Zen, as long as `"model": "opencode/big-pickle"` and the `opencode` provider are set. Instructions use a relative path (`"AGENTS.md"`) so the config travels with the vault across machines. Permissions and skills are installed into your global config by `install.sh`.

---

## What You Need

| Tool | Purpose | Required? |
|---|---|---|
| OpenCode | AI agent (terminal/desktop/IDE) | Yes |
| lynis | System hardening audit | Recommended |
| rkhunter | Rootkit detection | Recommended |
| fail2ban | SSH brute-force prevention | Recommended |
| firewalld | Dynamic firewall | Recommended |

OpenCode is **not** an Obsidian plugin. It runs in your terminal, desktop app, or IDE. See https://opencode.ai/docs/ to install it.

---

## Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh | bash
```

This single command clones the repo, runs `install.sh`, and optionally installs security tools.

**Review before running:**
```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh -o bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```

**With install path:**
```bash
INSTALL_DIR=/path/to/vault bash <(curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh)
```

---

## Manual Install Steps

### Step 1 — Clone the vault

```bash
git clone https://github.com/CascadeSTEAM/opencode_auditor.git ~/Projects/audit
cd ~/Projects/audit
```

### Step 2 — Install OpenCode

```bash
# Arch Linux
sudo pacman -S opencode

# Homebrew (macOS/Linux)
brew install anomalyco/tap/opencode

# npm
npm i -g opencode-ai@latest

# Direct install script
curl -fsSL https://opencode.ai/install | bash
```

Verify: `opencode --version`

### Step 3 — Merge permissions into your global OpenCode config

```bash
bash setup/install.sh
```

What `install.sh` does:
1. Creates `~/.config/opencode/` if it doesn't exist
2. Merges the vault's permission settings into your global `opencode.json` using `jq`
3. Registers `AGENTS.md` as a relative-path instruction in your vault-local `opencode.json` (portable across machines)
4. Installs the `templates` and `tools` skills into `~/.config/opencode/skills/`

**What the permissions do:** OpenCode will show an approval dialog before executing any shell command or writing any file. This applies globally — which is sensible, and you can always approve quickly for trusted sessions.

To review what will be merged before running:

```bash
cat opencode.fragment.json
```

To undo later (remove the `permission` block from your global config):

```bash
jq 'del(.permission)' ~/.config/opencode/opencode.json > /tmp/oc.json \
  && mv /tmp/oc.json ~/.config/opencode/opencode.json
```

### Step 5 — Install recommended security tools

```bash
# Detect OS
cat /etc/os-release | grep "^ID="
```

**Ubuntu / Debian:**
```bash
sudo apt update && sudo apt install lynis rkhunter fail2ban firewalld
```

**Fedora:**
```bash
sudo dnf install lynis rkhunter fail2ban firewalld
```

**Arch:**
```bash
sudo pacman -S lynis rkhunter fail2ban firewalld
```

**macOS:**
```bash
brew install lynis
# rkhunter and fail2ban have limited macOS support
```

Verify:
```bash
for tool in lynis rkhunter fail2ban firewalld; do
  command -v $tool && echo "✓ $tool" || echo "✗ $tool MISSING"
done
```

---

## Step 4 — Launch OpenCode or Open in Obsidian

**Option A — OpenCode (terminal-based AI agent):**

```bash
cd /path/to/your/audit-vault
opencode
```

OpenCode reads `AGENTS.md` automatically. On first message it runs the startup sequence.

**Option B — Obsidian (note-taking UI):**

The install script already scaffolds `.obsidian/` config and downloads the opencode-obsidian plugin. Just open Obsidian, select **"Open folder as vault"**, and pick this directory.

> `install.sh` already created `audits/completed/`, `mitigations/`, and `metrics/` — nothing else needed.

---

## File Structure After Setup

```
~/.config/opencode/
├── opencode.json          ← your existing global config + merged permissions
└── skills/
    ├── templates/
    │   └── SKILL.md
    └── tools/
        └── SKILL.md

your-vault/
├── AGENTS.md
├── opencode.json          ← vault-local config (relative paths, travels with vault)
├── INSTALL.md
├── install.sh
├── opencode.fragment.json
├── setup/
│   └── skills/
│       ├── templates/
│       │   └── SKILL.md
│       └── tools/
│           └── SKILL.md
├── mitigations/           ← created by install.sh
├── audits/completed/      ← created by install.sh
└── metrics/               ← created by install.sh
```

---

## Transferring to a New System

1. Copy or clone the vault directory (`AGENTS.md`, `INSTALL.md`, `install.sh`, `opencode.fragment.json`, `setup/skills/`, and your audit history)
2. Run `bash setup/install.sh` on the new system
3. Launch OpenCode

Your audit history travels with the vault. The only thing installed outside it is the merged global config entry and the skills in `~/.config/opencode/` — `install.sh` handles both.
