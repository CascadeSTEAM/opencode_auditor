# Audit Vault — System Security Audit & Remediation Tracking

## Note for Public Repo Users
This vault is sanitized for public use. System-specific data is in `.private/` (gitignored).
See `mitigations/templates/` for shareable examples.

## Purpose

This vault provides a **menu-driven security audit framework** for Linux laptops used by DevSecOps professionals. It combines:
- Point-in-time security audits with SOC2 compliance tracking
- Automated security tool integration (lynis, rkhunter, fail2ban, firewalld)
- Remediation tracking with verification and resolution menus
- 30-day holding period for safe deletions

## Quick Start

### First Time Setup

1. **Run the setup script** (installs OpenCode if missing, merges permissions to global config):
   ```bash
   cd /path/to/your/audit-vault
   bash setup/install.sh
   ```
   - Automatically checks for OpenCode and installs via `curl -fsSL https://opencode.ai/install | bash` if missing
   - Merges permissions (`bash`, `edit`, `write` = "ask") to `~/.config/opencode/opencode.json`
   - Copies skills to `~/.config/opencode/skills/`

3. **Launch OpenCode** (terminal-based AI agent):
   ```bash
   cd /path/to/your/audit-vault
   opencode
   ```

4. **Or open in Obsidian** (the install script scaffolds `.obsidian/` config and installs the opencode-obsidian plugin). Open Obsidian, choose **"Open folder as vault"**, and select this directory.

5. OpenCode reads `AGENTS.md` automatically and shows the **Startup Menu**:
   - `Quick Scan (Recommended)` — Run lynis + rkhunter + quick checks (~5 min)
   - `Full Audit` — Generate complete audit plan with default premise
   - `View Dashboard` — Show security posture trends (if metrics/ exists)
   - `Wait` — Do nothing for now

### Running an Audit

1. Select `Quick Scan` (recommended for fast check) or `Full Audit`
2. OpenCode scans system and generates `plan_YYYYMMDD.md`
3. For each issue, choose: `Mitigate`, `Accept`, or `Transfer`
4. Execute mitigations with phase-based menus (Safety → Action → Verify)
5. After all items resolved, choose: `Archive now`, `Review again`, `Create new audit`

### Continuous Monitoring

1. On startup, select `Quick Scan` for immediate security check
2. Tools run automatically: lynis, rkhunter, fail2ban, firewalld
3. View results in security dashboard (`metrics/security_posture_YYYYMM.json`)
4. Weekly cron job runs automated scans (lynis + rkhunter)
5. Monthly full audit with trending comparison

## Directory Structure

```
Audit/
├── setup/                  # First-run setup files (can ignore after setup)
│   ├── INSTALL.md
│   ├── install.sh
│   ├── opencode.fragment.json
│   └── skills/
│       ├── templates/
│       │   └── SKILL.md
│       └── tools/
│           └── SKILL.md
├── AGENTS.md              # Agent instructions (workflow, menus, SOC2)
├── README.md               # This file (setup & usage)
├── plan_YYYYMMDD.md        # Active audit (one at a time)
├── mitigations/            # Individual task files (NN_topic.md)
│   ├── 01_aws_credentials.md
│   ├── 02_keepass_key.md
│   └── ...
├── completed_audits/       # Finished audits (archived)
│   └── plan_20260505.md
├── metrics/                # Security posture trends
│   ├── security_posture_202605.json
│   └── README.md
└── plan_proposal_*.md      # Enhancement proposals (optional)
```

## Replication on Another System

### Setup Steps

1. **Copy vault** to new system (or use Obsidian Sync):
   ```bash
   cp -r /path/to/Audit ~/Audit
   ```

2. **Run setup script** (installs OpenCode if missing, merges permissions):
   ```bash
   cd ~/Audit
   bash setup/install.sh
   ```
   - Checks for OpenCode and installs if missing (via `curl -fsSL https://opencode.ai/install | bash`)
   - Merges permissions (`bash`, `edit`, `write` = "ask") to `~/.config/opencode/opencode.json`
   - Copies skills to `~/.config/opencode/skills/`
   - Creates vault directories if missing

3. **Launch OpenCode** (terminal-based AI agent):
    ```bash
    cd ~/Audit
    opencode
    ```

4. **Or open in Obsidian** — Open Obsidian, choose **"Open folder as vault"**, and select this directory. The `.obsidian/` config and opencode-obsidian plugin are installed by `install.sh`.

5. **First run**: OpenCode reads `AGENTS.md` and shows Startup Menu

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

## Workflow Summary

### Menu Flow (Automatic — Using Pop-up Question Tool)
```
Startup → Quick Scan | Full Audit | View Dashboard | Wait
         ↓
Plan Created → Review Plan or Start Mitigations
         ↓
For Each Issue → Mitigate | Accept | Transfer
         ↓
If Mitigate → Phase1 (Safety) → Phase2 (Action) → Phase3 (Verify)
         ↓
After Each Phase → Continue | Re-run | Stop
         ↓
All Items Done → Archive Now | Review Again | New Audit
```

### Resolution Options
- **Mitigate** — Execute detailed plan with safety audits and verification
- **Accept** — Document why risk is acceptable (no action needed)
- **Transfer** — Assign to another person/system

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

✅ **Menu-driven** — Never auto-proceeds without user input (uses pop-up question tool)
✅ **SOC2 aligned** — Compliance tracking built-in
✅ **Safety first** — Safety audits before destructive actions
✅ **30-day holding** — Safe deletion with rollback option
✅ **Verification** — Each phase verified before continuing
✅ **Documentation** — Full execution logs in `mitigations/`
✅ **Continuous monitoring** — Weekly/monthly automated scans

## Migration Notes

- All file paths are absolute (use `$HOME` or `~` in commands)
- Backup location: `/media/netyeti/Backups/latest/home/`
- Holding area: `~/.unused_holding/` (30-day wait)
- Cron reminders set for holding review
- **Combine same-day plans**: If multiple plans created same day, merge into one file (see AGENTS.md rule #8)

## Troubleshooting

**Q: OpenCode doesn't show menus?**
- Check OpenCode is installed: `opencode --version`
- Verify you're in the correct directory: `pwd` (should show `/path/to/Audit`)
- Ensure `AGENTS.md` exists in vault root

**Q: Edit tool fails repeatedly?**
- AGENTS.md has Process Fix: Use `write` tool after 2 failures

**Q: How to start over?**
- Move `plan_*.md` files to `completed_audits/`:
  ```bash
  mv plan_*.md completed_audits/
  ```
- Restart OpenCode — Startup Menu will appear

**Q: Where are completed audits?**
- Archived in `completed_audits/` directory

**Q: Setup script fails?**
- Ensure `jq` is installed: `sudo pacman -S jq` (Arch) or `sudo apt install jq` (Ubuntu)
- Check `setup/install.sh` has execute permission: `chmod +x setup/install.sh`

---
**Created**: 2026-05-05
**Version**: 3.0 (Updated for OpenCode standalone + setup/ structure)
**Setup**: See `setup/INSTALL.md` for detailed first-run instructions
