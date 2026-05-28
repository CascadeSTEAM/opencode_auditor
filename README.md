# Audit Vault — System Security Audit & Remediation Tracking

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shellcheck](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/shellcheck.yml)
[![Check Markdown Links](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/markdown-links.yml/badge.svg)](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/markdown-links.yml)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to file issues, submit PRs, and code style guidelines. This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.

## About This Project

This vault is a **demonstration project** — a real tool I actually use and support — showing what [OpenCode](https://opencode.ai) can do with a bit of chatting and a little knowledge. It's free, it's open source, and I hope people enjoy it and use it in good health.

It was created as an example for the [Cascade STEAM AI Workshop](https://cascadesteam.org/), and has evolved into a genuine daily-driver security audit framework for my own systems.

## Purpose

This vault provides a **conversational security audit framework** for Linux laptops. It combines:
- Point-in-time security audits with SOC2 style compliance tracking
- Automated security tool integration (lynis, rkhunter, fail2ban, firewalld)
- Interactive remediation with verification and rollback
- 30-day holding period for safe deletions
- Risk assessment reporting

## How It Works — Toolkit & Named Vaults

The project is split into two parts:

**Toolkit** (`repo/`) — Git-controlled template that provides the agent instructions, workflow docs, skills, and install scripts. This is the upstream source of truth.

**Named vaults** (`audit-*/`) — Per-system private workspaces that hold your actual audit data. Each vault symlinks AGENTS.md and docs/ from the toolkit, keeping them always fresh. Your audit plans, mitigations, and metrics stay entirely local and private.

This means:
- `git pull` in the toolkit updates AGENTS.md and docs for **all** vaults instantly
- Each machine/user gets their own vault — never shared, never tracked
- Audit data is immune to upstream changes

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh | bash
```

This creates `~/opencode-auditor/` with:
- `repo/` — the toolkit (git clone, refreshed each run)
- `audit-$(hostname)/` — your first vault (you choose the name)

The bootstrap script installs OpenCode if needed, clones the toolkit, scaffolds a named vault, and configures global permissions.

**Review before running:** Download and inspect first:
```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh -o bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```

**Pin to a specific version:** Replace `main` with any tag. See `docs/VERSIONING.md` for the versioning scheme.

**Non-interactive:** `YES=1 bash bootstrap.sh`

### After Install

```bash
audit
```

The `audit` command checks for an existing vault for this machine, creates one if needed, and launches OpenCode. Available from any directory after running `setup/install.sh` (symlinked to `~/.local/bin/`).

To audit a remote machine instead:
```bash
audit user@remote-host
```

OpenCode reads AGENTS.md and walks you through the workflow conversationally. Just start with **"Audit my system"**.

### Examples

```bash
# Start a full security audit for this machine
audit

# Quick credential exposure check
opencode -p "Scan ~ for exposed AWS keys, .env files, and secrets in git history"

# Check security tool status
opencode -p "Run lynis quick audit and rkhunter, show me the results"

# View security posture trend
opencode -p "Show me the metrics from audits/completed/ and metrics/"

# Remediate a specific finding
opencode -p "Walk me through mitigating the SSH root login finding"
```

Each session produces a dated plan file (`audits/plan_YYYYMMDD.md`) with per-finding risk assessments mapped to SOC2 controls. Issues are resolved through interactive conversation: Mitigate, Accept, Transfer, Defer, or Skip, with discussion mode always available to ask questions before deciding.

### Viewing in Obsidian

All vault data is plain markdown — you can browse audits, mitigations, and metrics in any editor. For a richer view, open the vault in [Obsidian](https://obsidian.md):

1. Launch Obsidian
2. Select **Open folder as vault** → pick your vault directory (e.g. `~/opencode-auditor/audit-$(hostname)`)
3. The **opencode-obsidian** plugin is pre-configured — it adds a ribbon icon to launch OpenCode and a command palette entry

You'll see three folders in the file explorer:
- `audits/` — audit plan files (open items and completed)
- `mitigations/` — per-finding remediation logs
- `metrics/` — scan history for posture trending

To view multiple vaults, use Obsidian's **Manage vaults** dialog to switch between them, or open separate Obsidian windows.

### Creating Named Vaults

Create vaults for different machines or purposes:

```bash
# Audit another machine (creates audit-<hostname> vault automatically)
audit user@other-machine

# Or create a vault with a custom name
bash ~/opencode-auditor/repo/setup/new-vault.sh
# Prompts for a name — defaults to audit-$(hostname)
# Then: cd ~/opencode-auditor/NAME && opencode
```

For individual audit sessions (auditing the same machine again next week), just run `audit` again — it detects the existing vault and asks to reuse it.

Each vault is self-contained — its audit plans, mitigations, and metrics are independent.

### Updating the Toolkit

```bash
cd ~/opencode-auditor/repo && git pull
```

That's it. AGENTS.md and docs/ in all vaults are symlinked — they update immediately. The next time you run opencode in any vault, `startup.sh` checks for template config changes and offers to apply them.

### Manual Install

```bash
mkdir -p ~/opencode-auditor
git clone https://github.com/CascadeSTEAM/opencode_auditor.git ~/opencode-auditor/repo
bash ~/opencode-auditor/repo/setup/install.sh
bash ~/opencode-auditor/repo/setup/new-vault.sh
```

## Directory Structure

```
~/opencode-auditor/
├── repo/                        # Toolkit (git clone)
│   ├── AGENTS.md                # Template instructions (symlinked by vaults)
│   ├── docs/                    # Workflow reference (symlinked by vaults)
│   ├── audit                    # Launch/create vault from anywhere (symlinked to PATH)
│   ├── bootstrap.sh             # Entry point — ensures opencode, clones, creates vault
│   ├── opencode.json            # Template config example
│   ├── setup/
│   │   ├── install.sh           # Global setup — permissions, skills, provider
│   │   ├── new-vault.sh         # Scaffolds a named vault with symlinks
│   │   ├── setup-rustdesk-unattended.sh
│   │   └── skills/              # Skill definitions (templates, tools, install)
│   ├── tests/                   # Test suite
│   └── .github/                 # CI workflows
│
├── audit-zephyr/                # Named vault (default: audit-$(hostname))
│   ├── AGENTS.md ──> ../repo/AGENTS.md    # Symlink — always fresh
│   ├── docs/     ──> ../repo/docs/        # Symlink — always fresh
│   ├── opencode.json                       # Local config (own copy)
│   ├── startup.sh                          # Copied from toolkit
│   ├── audits/                             # Local audit plans
│   │   └── completed/
│   ├── mitigations/                        # Local remediation logs
│   ├── metrics/                            # Local scan metrics
│   └── .obsidian/                          # Local Obsidian config
│
└── audit-personal/              # Another named vault
    └── ...
```

## Resolution Options

When a finding is identified, you can:
- **Mitigate** — Walk through a structured plan with safety audit, action, and verification phases
- **Accept** — Document why the risk is acceptable (no action needed)
- **Transfer** — Assign to another person or system
- **Defer** — Skip for now, keep tracking — revisit on next session
- **Skip** — Mark as skipped with a reason
- **Discuss** — Type your own response at any prompt to ask questions and understand the finding before deciding

## Security Tools Integration

| Tool | Purpose | Risk |
|------|---------|------|
| lynis | System hardening audit | ✅ Low |
| rkhunter | Rootkit detection | ✅ Low |
| fail2ban | SSH intrusion prevention | ✅ Low |
| firewalld | Dynamic firewall (already installed) | ✅ Low |
| git-secrets | Prevent AWS cred commits | ✅ Low |
| npm audit | Node.js dependency check | ✅ Low |
| pip-audit | Python dependency check | ✅ Low |

**Not recommended for laptop**: AIDE (too heavy), CIS benchmarks (breaks things), NIST CSF (org-level)

## SOC2 Compliance

Each audit item includes:
- **Risk ID**: AUDIT-YYYY-NNN
- **Likelihood/Impact**: High/Medium/Low
- **Control Objective**: CC6.1, CC6.8, CC7.2, etc.
- **Compliance Status**: Open → In Progress → Mitigated

## Key Features

✅ **Conversational** — OpenCode walks you through audits step by step, asking before any action
✅ **SOC2 aligned** — Compliance tracking built-in
✅ **Safety first** — Safety audits before destructive actions
✅ **30-day holding** — Safe deletion with rollback option
✅ **Verification** — Each phase verified before continuing
✅ **Documentation** — Full execution logs in `mitigations/`
✅ **Continuous monitoring** — Weekly/monthly automated scans

## Troubleshooting

**Q: OpenCode doesn't respond as expected?**
- Check OpenCode is installed: `opencode --version`
- Verify you're in the vault directory: `pwd` (should show e.g. `~/opencode-auditor/audit-zephyr`)
- Ensure `AGENTS.md` exists — it should be a symlink to `../repo/AGENTS.md`
- Run `ls -la AGENTS.md` to verify

**Q: Edit tool fails repeatedly?**
- AGENTS.md has Process Fix: Use `write` tool after 2 failures

**Q: How to start over?**
- Move `audits/plan_*.md` files to `audits/completed/`:
  ```bash
  mv audits/plan_*.md audits/completed/
  ```
- Restart OpenCode — it will pick up AGENTS.md automatically

**Q: Where are completed audits?**
- Archived in `audits/completed/` inside your vault

**Q: Setup script fails?**
- Ensure `jq` is installed: `sudo pacman -S jq` (Arch) or `sudo apt install jq` (Ubuntu)
- Check toolkit is cloned correctly: `ls ~/opencode-auditor/repo`

**Q: How do I update my vault after the toolkit has changes?**
- `git -C ~/opencode-auditor/repo pull` — AGENTS.md and docs update automatically via symlinks
- Next `startup.sh` run checks for template config changes and offers to apply them

---
**Version**: 4.0 (Toolkit + named vaults — private per-system audit data, public template via git)
