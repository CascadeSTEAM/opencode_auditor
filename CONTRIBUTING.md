# Contributing to Opencode Auditor

[About](docs/about.md) · [Conventions](docs/file-conventions.md) · [Startup](docs/startup-menu.md) · [Resolution](docs/resolution-workflow.md) · [Completion](docs/completion-workflow.md) · [SOC2](docs/soc2-controls.md) · [Checklist](docs/security-checklist.md) · [Monitoring](docs/continuous-monitoring.md) · [Branching](docs/branching-strategy.md) · [Versioning](docs/VERSIONING.md) · [CHANGELOG](CHANGELOG.md) · [CONTRIBUTING](CONTRIBUTING.md) · [SECURITY](SECURITY.md) · [CODE OF CONDUCT](CODE_OF_CONDUCT.md)

## Guiding Principle

Every user of this vault is a potential code collaborator. If you found a bug, have an idea, or improved something — share it.

## How to Contribute

### Issues

- **Bug reports:** Use the bug report template. Include vault version, OS, and steps to reproduce.
- **Feature requests:** Use the feature request template. Describe the problem and the proposed solution.
- **Security vulnerabilities:** Do NOT open a public issue. Report via SECURITY.md instead.

From your local vault, file issues directly:

```bash
gh issue create
```

### Pull Requests

1. Open an issue first (unless it's a trivial fix) so we agree on the approach.
2. Create a branch from `main` with a descriptive name:
   - `FIX/<issue-number>-<kebab-topic>` for bug fixes
   - `F/<kebab-topic>` for features
   - `DOC/<kebab-topic>` for documentation
3. Make your changes. Keep commits focused and present-tense.
4. Open a PR against `main`. Reference the issue in the body.
5. A maintainer will review. Address any feedback.

### Code Style

- Shell scripts: Bash, follow Google Shell Style Guide. Run `shellcheck` on every `.sh` file.
- Markdown: wrap at 80 chars, use `-` for unordered lists.
- Commit messages: present tense, concise. e.g. "Add passive scan notification" not "Added passive scan notification" or "Fixes issue where..."
- One concern per commit.

### What Needs Help

Check issues tagged `help wanted` or `good first issue`.
