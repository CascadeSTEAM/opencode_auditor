# Changelog

[About](docs/about.md) · [Conventions](docs/file-conventions.md) · [Startup](docs/startup-menu.md) · [Resolution](docs/resolution-workflow.md) · [Completion](docs/completion-workflow.md) · [SOC2](docs/soc2-controls.md) · [Checklist](docs/security-checklist.md) · [Monitoring](docs/continuous-monitoring.md) · [Branching](docs/branching-strategy.md) · [Versioning](docs/VERSIONING.md) · [CHANGELOG](CHANGELOG.md) · [CONTRIBUTING](CONTRIBUTING.md) · [SECURITY](SECURITY.md) · [CODE OF CONDUCT](CODE_OF_CONDUCT.md)

## 2026-05-28

### Changed

- **docs-restructure:** Streamlined README to quick-start + doc index (253→83 lines). Moved duplicate content into dedicated docs: purpose/features to new `docs/about.md`, directory structure/vaults/updates/Obsidian into `docs/file-conventions.md`, security tools table into `docs/security-checklist.md`, compliance summary into `docs/soc2-controls.md`. Added consistent nav bar at top of all 10 doc files and README linking every doc to each other. Added `docs/about.md` to AGENTS.md reference table. Fixed stale vault naming `audit-*` → `~/opencode-auditor/` in file-conventions.md and stale changelog example range in VERSIONING.md.

## 2026-05-27

### Fixed

- **audit**: ANSI escape codes (`\033[1m`, `\033[0m`) printed literally in "Found existing vault" prompt. Changed color variables to `$'...'` quoting so bash interprets escape sequences at definition time. (`audit:17`)
- **ci**: `shellcheck` workflow only triggered on `**.sh` files, silently skipping extensionless scripts like `audit`. Removed the path filter so shellcheck runs on every PR. (`.github/workflows/shellcheck.yml`)

### Added (2026-05-28)

- **cve-scanning**: CVE and CERT vulnerability scanning added to audit plans. New tool commands for cvescan, osv-scanner, debsecan, CISA KEV, and Ubuntu USN in `setup/skills/tools/SKILL.md`. CVE/CERT findings section and USN advisory summary table added to plan template `setup/skills/templates/SKILL.md`. Monthly CVE scan step added to `docs/continuous-monitoring.md`. (`#21`, PR #32)
- **grub-hardening**: Safe GRUB bootloader hardening workflow with password safeguards. Lockout warning and recovery instructions in `docs/security-checklist.md`. Complete mitigation template in `setup/skills/templates/SKILL.md` with VM/cloud skip, alphanumeric passphrase generation, dual-storage at `/root/` + terminal, explicit YES confirmation gate, and live USB recovery. GRUB hardening commands in `setup/skills/tools/SKILL.md`. (`#22`, PR #33)
