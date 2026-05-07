# AGENTS.md — Audit Vault

## Starting an audit

When the user asks about auditing their system, checking security, reviewing past results, or anything clearly related to operating the vault — including but not limited to "run an audit", "scan my system", "security check", "view dashboard", "resume last audit", "show me metrics":

1. Run `./startup.sh` and note the results
2. Read `docs/startup-menu.md` for menu definitions
3. Present the appropriate menu via the Question tool (active audit exists vs. none)

For the menu options that open workflows (Resume, Quick Scan, Full Audit, etc.), read the relevant file in `docs/` for detailed instructions.

## Hard Rules

- `bash`, `edit`, `write` require approval — never work around it
- Never log secrets. If output contains tokens/keys/passwords: redact `[REDACTED]`, advise rotation
- If `edit` fails twice on same file, use `write` (full rewrite). Never third `edit`
- After every `write` or `edit`, use `read` to verify the change landed
- One active audit at a time — no new `audits/plan_*.md` while any existing one has unchecked `- [ ]` items
- **One active change at a time** — no new FIX/FEAT/DOC branch from us while any open PR exists. Merge or close the current PR before starting the next issue. External contributor PRs are exempt — rebase ours to resolve conflicts if needed.
- **Automatic branching:** Before modifying any tracked file (anything not in `.gitignore`), check current branch. If on `main`, create a feature/fix/doc branch first (`F/`, `FIX/`, or `DOC/` prefix). See `docs/branching-strategy.md` for conventions. If only touching gitignored/local-only files (plans, mitigations, metrics), no branch needed.

## Self-Critique Enforcement

Before presenting ANY proposal, plan, or recommendation:

1. `todowrite` a checklist with "Self-critique complete" item at top
2. Find flaws, wrong assumptions, over-engineering
3. Fix what you find
4. Mark critique complete
5. Include a brief **Critique:** note in the proposal

## Plan Creation

- Filename: `audits/plan_YYYYMMDD.md`
- Default premise: *"Find security issues on this local Linux system. Prioritize by: exploitability first, then impact, then remediation effort."*
- Every finding: Risk ID (`AUDIT-YYYY-NNN`), Likelihood, Impact, Risk Level, SOC2 Control, Compliance Status
- Create `mitigations/NN_topic.md` for each finding at the same time
- See `setup/skills/templates/SKILL.md` for plan/mitigation format templates

## Core Code Bug Workflow

When a bug or security issue is discovered in **core vault code** (tracked files not in `.gitignore` — e.g. bootstrap.sh, setup/, docs/, AGENTS.md, opencode.json, startup.sh):

1. **Scope check** — Is this a system security finding (auditd, ports, SSH, .env, etc.)? If yes, log locally only. If it affects a tracked core file, proceed.
2. **Create GitHub issue** — Run `gh issue create --title "FIX: short description" --body "What, where, impact"` to track it in the upstream repo.
3. **Create connected branch** — `git checkout -b FIX/<issue-number>-<kebab-topic>` from main.
4. **Propose plan for self-critique** — Present the proposed fix (what files, what changes, risks) with a self-critique focused on weak points and failures. Ask the user: "Can you critique/review the plan?"
5. **Iterate on feedback** — User responds to each point (accept/reject/discuss/clarify). Revise the plan and repeat step 4 as needed.
6. **Wait for approval** — Do NOT write code until all points are settled and the user explicitly approves.
7. **Implement fix** — On the FIX/ branch, commit the fix with present-tense messages.
8. **Open PR** — Push the branch, open a PR referencing the issue. The issue auto-closes on merge.
9. **Wait for merge** — Do NOT start the next issue until the current PR is merged. One active change at a time. External contributor PRs are exempt — rebase ours to resolve conflicts if needed.

> System security scan findings (auditd, ports, .env exposure, etc.) never generate GitHub issues. They are logged in `audits/plan_*.md` and remain local-only per existing policy. See `docs/branching-strategy.md` for branch naming rules.

## Docs Reference

| File | Content |
|---|---|
| `docs/startup-menu.md` | Menu definitions for the audit startup menu |
| `docs/resolution-workflow.md` | Mitigate/Accept/Transfer/Defer/Skip flows |
| `docs/completion-workflow.md` | Archive flow after all items resolved |
| `docs/soc2-controls.md` | SOC2 control code table |
| `docs/file-conventions.md` | File path purposes, tracking policy |
| `docs/continuous-monitoring.md` | Weekly/monthly monitoring schedule |
| `docs/branching-strategy.md` | PR workflow and branch naming for core code |
