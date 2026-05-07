# File Conventions

## Tracking Policy

Core vault code is tracked in git. Audit output (plans, mitigations, metrics) is **local only** — immune to check-ins.

| Path | Git | Purpose |
|------|-----|---------|
| `audits/plan_YYYYMMDD.md` | Ignored | Active audit — one at a time |
| `audits/plan_proposal_YYYYMMDD_name.md` | Ignored | Draft not yet active |
| `mitigations/NN_topic.md` | Ignored | Per-item execution log |
| `audits/completed/` | Ignored | Archived finished audits |
| `metrics/security_posture_YYYYMM.json` | Ignored | Monthly scan metrics |
| `docs/` | Tracked | Workflow reference files |
| `mitigations/.gitkeep` | Tracked | Directory placeholder (dir created by install.sh) |
| `.startup-required` | Ignored | Marker — deleted after startup menu is shown |

**Same-day merge:** If a second plan is created on the same date, append its items to the existing plan (continuing the item numbering), copy mitigations, update Summary. Keep the original filename.
