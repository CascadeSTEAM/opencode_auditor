# Audit Vault — System Security Audit & Remediation Tracking

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shellcheck](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/shellcheck.yml)
[![Check Markdown Links](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/markdown-links.yml/badge.svg)](https://github.com/CascadeSTEAM/opencode_auditor/actions/workflows/markdown-links.yml)

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to file issues, submit PRs, and code style. Follows the [Contributor Covenant](CODE_OF_CONDUCT.md).

This is a toolkit + named vaults for conversational Linux security audits. For the full background, see [About](docs/about.md).

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh | bash
```

Creates `~/opencode-auditor/` with the toolkit and a named vault. Installs OpenCode if needed.

- **Review first:** `curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh -o bootstrap.sh && less bootstrap.sh && bash bootstrap.sh`
- **Pin version:** Replace `main` with a tag. See [VERSIONING.md](docs/VERSIONING.md).
- **Non-interactive:** `YES=1 bash bootstrap.sh`

### After Install

```bash
audit
```

Launches OpenCode in your vault. Say **"Audit my system"** to start. For a remote machine: `audit user@remote-host`

### Manual Install

```bash
mkdir -p ~/opencode-auditor
git clone https://github.com/CascadeSTEAM/opencode_auditor.git ~/opencode-auditor/repo
bash ~/opencode-auditor/repo/setup/install.sh
bash ~/opencode-auditor/repo/setup/new-vault.sh
```

### Examples

```bash
audit                                                  # Full security audit for this machine
opencode -p "Scan ~ for exposed AWS keys and secrets in git history"
opencode -p "Run lynis + rkhunter, show me results"
opencode -p "Show metrics from audits/completed/ and metrics/"
opencode -p "Walk me through mitigating the SSH root login finding"
```

Each session produces `audits/plan_YYYYMMDD.md` with per-finding risk assessments mapped to SOC2 controls.

## Documentation

| Doc | Description |
|-----|-------------|
| [About](docs/about.md) | Project purpose, background, key features |
| [File Conventions](docs/file-conventions.md) | Directory structure, tracking policy, vaults, Obsidian |
| [Startup Menu](docs/startup-menu.md) | Interactive menu when launching an audit |
| [Resolution Workflow](docs/resolution-workflow.md) | Mitigate, Accept, Defer, Transfer, Skip, Explain |
| [Completion Workflow](docs/completion-workflow.md) | Archiving finished audit plans |
| [SOC2 Controls](docs/soc2-controls.md) | Control codes and compliance tracking |
| [Security Checklist](docs/security-checklist.md) | Risk assessment framework, checklist, tools |
| [Continuous Monitoring](docs/continuous-monitoring.md) | Weekly/monthly scan schedule, metrics schema |
| [Branching Strategy](docs/branching-strategy.md) | PR workflow for core code changes |
| [VERSIONING](docs/VERSIONING.md) | Versioning scheme, bump rules, release criteria |
| [CHANGELOG](CHANGELOG.md) | Release history |
| [CONTRIBUTING](CONTRIBUTING.md) | How to file issues, submit PRs, code style |
| [SECURITY](SECURITY.md) | Security policy and reporting |
| [CODE OF CONDUCT](CODE_OF_CONDUCT.md) | Community standards |

## Troubleshooting

**OpenCode unresponsive?** — Check `opencode --version`, verify `pwd` is a vault directory, `ls -la AGENTS.md` is a symlink.

**Edit tool fails repeatedly?** — Use `write` after 2 failures (per AGENTS.md process fix).

**Start over?** — `mv audits/plan_*.md audits/completed/` then restart OpenCode.

**Setup fails?** — Ensure `jq` is installed.

**Update toolkit?** — `git -C ~/opencode-auditor/repo pull` — AGENTS.md and docs update automatically via symlinks.

---

**Version:** 4.0 (Toolkit + named vaults)
