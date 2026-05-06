# Mitigation: 01 — Bootstrap URL references stale tag

## Risk Assessment
- **Risk ID:** AUDIT-2026-001
- **Likelihood:** High
- **Impact:** Medium
- **Risk Level:** High
- **SOC2 Control:** CC6.8

## Phase 1: Pre-Audit (Read-Only)
- [x] Found bootstrap.sh references v0.6.0 (line 4-5) instead of v0.7.6
- [x] Found README references v0.7.4 (line 21, 28) instead of v0.7.6
- [x] Latest tag verified: v0.7.6

## Phase 2: Remediation
- **Commands:**
  Edit bootstrap.sh lines 4-5: replace v0.6.0 with v0.7.6
  Edit README.md lines 21, 28: replace v0.7.4 with v0.7.6
- **Expected result:** All example URLs point to latest tag

## Phase 3: Verification
- [x] Verify bootstrap.sh shows v0.7.6
- [x] Verify README.md shows v0.7.6

## Resolution
- **Status:** Mitigated
- **Date:** 2026-05-06
- **Notes:** v0.7.7 tag created. All example URLs updated to v0.7.7. Also fixed growlf/opencode_audito → CascadeSTEAM/opencode_auditor repo references and stale "Replace v0.6.0" comment.
