# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please do **not** open a public issue.

Report it privately via GitHub's private vulnerability reporting:

https://github.com/CascadeSTEAM/opencode_auditor/security/advisories/new

You can also reach out directly to the maintainer (see commit history for contact).

We will acknowledge receipt within 48 hours and provide a timeline for a fix.

## Scope

This covers:
- The core vault code (AGENTS.md, bootstrap.sh, setup/, docs/, startup.sh)
- Any security tool configuration files shipped with the vault
- The GitHub Actions CI/CD configuration

Out of scope:
- System audit findings (open ports, outdated packages, etc.) — these are logged locally in `audits/plan_*.md`
- Third-party security tools (lynis, rkhunter, fail2ban, etc.) — report to their respective projects
