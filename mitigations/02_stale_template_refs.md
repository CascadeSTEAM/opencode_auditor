# Mitigation: 02 — Stale mitigation_templates/ references

## Risk Assessment
- **Risk ID:** AUDIT-2026-002
- **Likelihood:** Medium
- **Impact:** Low
- **Risk Level:** Medium
- **SOC2 Control:** CC6.8

## Phase 1: Pre-Audit (Read-Only)
- [x] Found 4 references in docs/security-checklist.md: lines 108, 117, 119, 120

## Phase 2: Remediation
- **Commands:**
  Edit docs/security-checklist.md to replace all mitigation_templates/ references:
  - Line 108: "mitigation_templates/" → "mitigations/"
  - Line 117: entire line references "mitigation_templates/" — update notes
  - Line 119: same pattern
  - Line 120: same pattern
- **Expected result:** No stale directory references remain

## Phase 3: Verification
- [x] grep for "mitigation_templates" returns no results in docs/

## Resolution
- **Status:** Mitigated
- **Date:** 2026-05-06
- **Notes:** All 4 references in security-checklist.md replaced with mitigations/ paths.
