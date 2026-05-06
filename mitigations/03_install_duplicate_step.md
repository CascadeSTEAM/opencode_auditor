# Mitigation: 03 — INSTALL.md duplicate Step 4

## Risk Assessment
- **Risk ID:** AUDIT-2026-003
- **Likelihood:** Low
- **Impact:** Low
- **Risk Level:** Low
- **SOC2 Control:** CC6.8

## Phase 1: Pre-Audit (Read-Only)
- [x] Found duplicate "Step 4" at lines 100 and 137
- [x] Found duplicate "4. Launch OpenCode" at lines 191-192

## Phase 2: Remediation
- **Commands:**
  Edit setup/INSTALL.md:
  - Line 100: "Step 4 — Install" → "Step 5 — Install"
  - Line 137: "Step 4 — Launch" → (no change needed, becomes Step 4)
  - Line 191-192: Remove second "4. Launch OpenCode"
- **Expected result:** Sequential step numbering, no duplicates

## Phase 3: Verification
- [x] READ through INSTALL.md — steps are 1-5 sequential, no duplicates

## Resolution
- **Status:** Mitigated
- **Date:** 2026-05-06
- **Notes:** Step 4 = Launch OpenCode, Step 5 = Install tools. Duplicate "4. Launch OpenCode" removed. Also fixed growlf → CascadeSTEAM repo URLs.
