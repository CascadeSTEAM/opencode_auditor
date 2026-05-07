# Branching Strategy

**Adopted:** 2026-05-06 (pre-v1.0)
**Goal:** Stabilize core code through PR-based collaboration before v1.0 release.

## Workflow

All changes to **core vault code** (bootstrap.sh, setup/, docs/, AGENTS.md, .gitignore, opencode.json, startup.sh, README.md) follow this flow:

```
feature/fix branch → PR into main → squash-merge → tag release
```

### 1. Create a Branch

```bash
git checkout -b PREFIX/issue-number-kebab-topic
```

| Prefix | Purpose | Example |
|--------|---------|---------|
| `F/` | Feature | `F/csv-export` |
| `FIX/` | Bug fix on tracked core code | `FIX/42-startup-flags` |
| `DOC/` | Documentation | `DOC/api-ref-update` |

For `FIX/` branches, the issue number is the GitHub issue that describes the bug. Create the issue first via `gh issue create`, then create the branch referencing it.

See the **Core Code Bug Workflow** in `AGENTS.md` for the full flow: scope check → create issue → create branch → propose plan → iterate on feedback → wait for approval → fix → PR → merge → next issue.

### 2. Commit on the Branch

- Keep commits small and focused
- Use present-tense descriptions
- Reference related issues if any

### 3. Open a Pull Request

- Title: `[TYPE] Brief summary`
- Body: What changed, why, any risks
- Request review from available contributors, or use GitHub Copilot code review

### 4. Squash-Merge to `main`

- Clean, single commit per feature/fix
- Message format: `T/topic-description: short summary`

### 5. Tag a Release

After merge, tag `main` with the next version:

```bash
git tag -a vMAJOR.MINOR.PATCH -m "description"
git push origin vMAJOR.MINOR.PATCH
```

See `VERSIONING.md` for bump rules.

## What Gets a Branch

| Tracked in git | Uses branch/PR |
|----------------|----------------|
| bootstrap.sh | Yes |
| setup/ | Yes |
| docs/ | Yes |
| AGENTS.md | Yes |
| opencode.json | Yes |
| startup.sh | Yes |
| .gitignore | Yes |
| .gitkeep placeholders | Yes |

| **Not tracked** (local only) | No PR needed |
|-----------------------------|--------------|
| `audits/plan_*.md` | — |
| `mitigations/*.md` | — |
| `metrics/*.json` | — |
| `.startup-required` | — |

Scan output and remediation files live outside git — they are immune to check-ins and cannot contaminate the core codebase.

## Pre-1.0 Convention

- `main` is the active development branch
- No direct commits to `main` (branch + PR only)
- Tags use `v0.MINOR.PATCH` until v1.0
- v1.0 is tagged when the release criteria in `VERSIONING.md` are met

## Automatic Enforcement

The agent (per `AGENTS.md` Hard Rules) checks the branch before every core-file edit. If on `main`, it branches first. This applies automatically to all tracked files — gitignored content (plans, mitigations, metrics) is exempt and can be modified on any branch.
