# File Conventions

## Tracking Policy

**Two directories** make up the audit vault:

- **Toolkit** (`repo/`) — git-controlled template. AGENTS.md, docs/, setup/, tests. Never contains audit data.
- **Named vault** (`audit-*/`) — local-only workspace. AGENTS.md and docs/ are symlinked from the toolkit. All audit output is local-only, never tracked.

| Path (in vault) | Git | Purpose |
|-----------------|-----|---------|
| `AGENTS.md` | Symlinked → `../repo/AGENTS.md` | Agent instructions — always fresh via toolkit |
| `docs/` | Symlinked → `../repo/docs/` | Workflow reference — always fresh via toolkit |
| `audits/plan_YYYYMMDD.md` | Ignored | Active audit — one at a time |
| `audits/plan_proposal_YYYYMMDD_name.md` | Ignored | Draft not yet active |
| `mitigations/NN_topic.md` | Ignored | Per-item execution log |
| `audits/completed/` | Ignored | Archived finished audits |
| `metrics/security_posture_YYYYMM.json` | Ignored | Monthly scan metrics |
| `.startup-required` | Ignored | Marker — deleted after startup menu is shown |
| `mitigations/.gitkeep` | Tracked | Directory placeholder |

**Same-day merge:** If a second plan is created on the same date, append its items to the existing plan (continuing the item numbering), copy mitigations, update Summary. Keep the original filename.
