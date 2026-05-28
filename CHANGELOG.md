# Changelog

## 2026-05-27

### Fixed

- **audit**: ANSI escape codes (`\033[1m`, `\033[0m`) printed literally in "Found existing vault" prompt. Changed color variables to `$'...'` quoting so bash interprets escape sequences at definition time. (`audit:17`)
- **ci**: `shellcheck` workflow only triggered on `**.sh` files, silently skipping extensionless scripts like `audit`. Removed the path filter so shellcheck runs on every PR. (`.github/workflows/shellcheck.yml`)
