# About

[About](about.md) · [Conventions](file-conventions.md) · [Startup](startup-menu.md) · [Resolution](resolution-workflow.md) · [Completion](completion-workflow.md) · [SOC2](soc2-controls.md) · [Checklist](security-checklist.md) · [Monitoring](continuous-monitoring.md) · [Branching](branching-strategy.md) · [Versioning](VERSIONING.md) · [CHANGELOG](../CHANGELOG.md) · [CONTRIBUTING](../CONTRIBUTING.md) · [SECURITY](../SECURITY.md) · [CODE OF CONDUCT](../CODE_OF_CONDUCT.md)

This vault is a **demonstration project** — a real tool I actually use and support — showing what [OpenCode](https://opencode.ai) can do with a bit of chatting and a little knowledge. It's free, it's open source, and I hope people enjoy it and use it in good health.

It was created as an example for the [Cascade STEAM AI Workshop](https://cascadesteam.org/), and has evolved into a genuine daily-driver security audit framework for my own systems.

## Purpose

This vault provides a **conversational security audit framework** for Linux laptops. It combines:

- Point-in-time security audits with SOC2 style compliance tracking
- Automated security tool integration (lynis, rkhunter, fail2ban, firewalld)
- Interactive remediation with verification and rollback
- 30-day holding period for safe deletions
- Risk assessment reporting

## Key Features

- **Conversational** — OpenCode walks you through audits step by step, asking before any action
- **SOC2 aligned** — Compliance tracking built-in
- **Safety first** — Safety audits before destructive actions
- **30-day holding** — Safe deletion with rollback option
- **Verification** — Each phase verified before continuing
- **Documentation** — Full execution logs in `mitigations/`
- **Continuous monitoring** — Weekly/monthly automated scans
