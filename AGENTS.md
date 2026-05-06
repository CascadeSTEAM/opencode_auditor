# AGENTS.md — Audit Vault

<!-- v4.1 | /audit command replaces mandatory startup; workflows moved to docs/ -->

## /audit command

When user types `/audit`:

1. Run `./startup.sh` and note the results
2. Read `docs/startup-menu.md` for menu definitions
3. Present the appropriate menu (active audit exists vs. none)
4. Delete `.startup-required` if present

For the menu options that open workflows (Resume, Quick Scan, Full Audit, etc.), read the relevant file in `docs/` for detailed instructions.

## Hard Rules

- `bash`, `edit`, `write` require approval — never work around it
- Never log secrets. If output contains tokens/keys/passwords: redact `[REDACTED]`, advise rotation
- If `edit` fails twice on same file, use `write` (full rewrite). Never third `edit`
- After every `write` or `edit`, use `read` to verify the change landed
- One active audit at a time — no new `plan_*.md` while any existing one has unchecked `- [ ]` items

## Self-Critique Enforcement

Before presenting ANY proposal, plan, or recommendation:

1. `todowrite` a checklist with "Self-critique complete" item at top
2. Find flaws, wrong assumptions, over-engineering
3. Fix what you find
4. Mark critique complete
5. Include a brief **Critique:** note in the proposal

## Plan Creation

- Filename: `plan_YYYYMMDD.md`
- Default premise: *"Find security issues on this local Linux system. Prioritize by: exploitability first, then impact, then remediation effort."*
- Every finding: Risk ID (`AUDIT-YYYY-NNN`), Likelihood, Impact, Risk Level, SOC2 Control, Compliance Status
- Create `mitigations/NN_topic.md` for each finding at the same time
- See `setup/skills/templates/SKILL.md` for plan/mitigation format templates

## Docs Reference

| File | Content |
|---|---|
| `docs/startup-menu.md` | Menu definitions for /audit |
| `docs/resolution-workflow.md` | Mitigate/Accept/Transfer/Skip flows |
| `docs/completion-workflow.md` | Archive flow after all items resolved |
| `docs/soc2-controls.md` | SOC2 control code table |
| `docs/file-conventions.md` | File path purposes, tracking policy |
| `docs/continuous-monitoring.md` | Weekly/monthly monitoring schedule |
| `docs/branching-strategy.md` | PR workflow and branch naming for core code |
