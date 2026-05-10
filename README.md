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

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/v0.7.7/bootstrap.sh | bash
```

This clones the vault to `~/Projects/audit`, runs all setup (permissions, skills, Obsidian config), and optionally installs security tools.

**Review before running:** Download and inspect first:
```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/v0.7.7/bootstrap.sh -o bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```

**Custom install directory:** `INSTALL_DIR=/path/to/vault bash bootstrap.sh`

**Non-interactive:** `YES=1 bash bootstrap.sh`

**Pin to a specific version:** Replace `v0.7.7` with any tag. See `docs/VERSIONING.md` for the versioning scheme. Use `main` for the development branch.

After install: `cd ~/Projects/audit && opencode`

### Manual Install

```bash
git clone https://github.com/CascadeSTEAM/opencode_auditor.git ~/Projects/audit
cd ~/Projects/audit
bash setup/install.sh
```

Then `opencode` from the vault directory. OpenCode reads `AGENTS.md` automatically and walks you through the workflow conversationally. Just start opencode and start with "Audit my system" - it's that easy.

### Examples

```bash
# Start a full security audit
cd ~/Projects/audit && opencode
# Then type: audit my system

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

## Directory Structure

```
Audit/
├── persistance/            # Persistent AI knowledge
│   ├── skills/             # Teaching & communication skills
│   └── docs_reports/       # OpenCode capability reference
├── setup/                  # First-run setup files
│   ├── INSTALL.md
│   ├── install.sh
│   ├── opencode.fragment.json
│   ├── setup-rustdesk-unattended.sh
│   ├── skills/
│   │   ├── install/
│   │   │   └── SKILL.md
│   │   ├── templates/
│   │   │   └── SKILL.md
│   │   └── tools/
│   │       └── SKILL.md
│   └── .obsidian/          # Obsidian config templates
├── tests/                  # Test suite
│   ├── test_harness.sh
│   ├── test_integration_bootstrap.sh
│   ├── test_integration_install.sh
│   ├── test_json_validation.sh
│   ├── test_shell_install.sh
│   └── test_shell_scripts.sh
├── AGENTS.md              # Agent instructions (workflow, SOC2)
├── README.md              # This file (setup & usage)
├── opencode.json          # Vault-local OpenCode config
├── startup.sh             # Startup health check
├── bootstrap.sh           # Single-command install script
├── audits/                # Active and completed audit plans
│   └── completed/         # Archived finished audits
├── mitigations/           # Individual task files (NN_topic.md)
├── metrics/               # Security posture trends
│   └── README.md
└── docs/                  # Workflow reference files
    ├── VERSIONING.md
    ├── branching-strategy.md
    ├── startup-menu.md
    ├── resolution-workflow.md
    ├── completion-workflow.md
    ├── file-conventions.md
    ├── soc2-controls.md
    ├── continuous-monitoring.md
    └── security-checklist.md
```

## Replication on Another System

### Setup Steps

1. **Copy vault** to new system (or use Obsidian Sync):
   ```bash
   cp -r /path/to/Audit ~/Projects/audit
   ```

2. **Run setup script** (installs OpenCode if missing, merges permissions):
   ```bash
   cd ~/Projects/audit
   bash setup/install.sh
   ```
   - Checks for OpenCode and installs if missing (via `curl -fsSL https://opencode.ai/install | bash`)
   - Merges permissions (`bash`, `edit`, `write` = "ask") to `~/.config/opencode/opencode.json`
   - Copies skills to `~/.config/opencode/skills/`
   - Creates vault directories if missing

 3. **Launch OpenCode** (terminal-based AI agent):
     ```bash
     cd ~/Projects/audit
     opencode
    ```

4. **Or open in Obsidian** — Open Obsidian, choose **"Open folder as vault"**, and select this directory. The `.obsidian/` config and opencode-obsidian plugin are installed by `install.sh`.

5. **First run**: OpenCode reads `AGENTS.md` and walks through the workflow

6. **Install security tools** (optional, for automation):
   ```bash
   # Detect OS
   cat /etc/os-release | grep "^ID="
   
   # Ubuntu/Debian
   sudo apt install lynis rkhunter fail2ban git-secrets
   
   # Fedora
   sudo dnf install lynis rkhunter fail2ban firewalld
   
   # Arch
   sudo pacman -S lynis rkhunter fail2ban firewalld
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
- Verify you're in the vault directory: `pwd` (should show the vault root, e.g. `~/Projects/audit`)
- Ensure `AGENTS.md` exists in vault root

**Q: Edit tool fails repeatedly?**
- AGENTS.md has Process Fix: Use `write` tool after 2 failures

**Q: How to start over?**
- Move `audits/plan_*.md` files to `audits/completed/`:
  ```bash
  mv audits/plan_*.md audits/completed/
  ```
- Restart OpenCode — it will pick up AGENTS.md automatically

**Q: Where are completed audits?**
- Archived in `audits/completed/` directory

**Q: Setup script fails?**
- Ensure `jq` is installed: `sudo pacman -S jq` (Arch) or `sudo apt install jq` (Ubuntu)
- Check `setup/install.sh` has execute permission: `chmod +x setup/install.sh`

---
**Created**: 2026-05-05
**Version**: 3.0 (Updated for OpenCode standalone + setup/ structure)
**Setup**: See `setup/INSTALL.md` for detailed first-run instructions
