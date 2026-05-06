# File Conventions

| Path | Purpose |
|---|---|
| `plan_YYYYMMDD.md` | Active audit — one at a time |
| `plan_proposal_YYYYMMDD_name.md` | Draft not yet active |
| `mitigations/NN_topic.md` | Per-item execution log |
| `completed_audits/` | Archived finished audits |
| `metrics/security_posture_YYYYMM.json` | Monthly scan metrics |
| `docs/` | Workflow reference files |
| `mitigations/` | Created by install.sh; its existence marks install complete |
| `.startup-required` | Marker — deleted after /audit menu is shown |

**Same-day merge:** If a second plan is created on the same date, append its items to the existing plan (continuing the item numbering), copy mitigations, update Summary. Keep the original filename.
