# Mitigation: 04 — README directory tree mismatch

## Risk Assessment
- **Risk ID:** AUDIT-2026-004
- **Likelihood:** Low
- **Impact:** Low
- **Risk Level:** Low
- **SOC2 Control:** CC6.8

## Phase 1: Pre-Audit (Read-Only)
- [x] Directory tree shows setup/INSTALL.md and setup/opencode.fragment.json as root-level
- [x] Lists nonexistent example files (01_aws_credentials.md, etc.)
- [x] Missing docs/VERSIONING.md

## Phase 2: Remediation
- **Commands:**
  Edit README.md directory tree section to match actual layout:
  - Keep setup/ as a subdirectory under Audit/
  - Keep docs/ accurate with VERSIONING.md listed
  - Remove example mitigations files that don't exist
- **Expected result:** Directory tree accurately reflects on-disk structure

## Phase 3: Verification
- [x] Visual comparison: tree in README matches `ls -R`

## Resolution
- **Status:** Mitigated
- **Date:** 2026-05-06
- **Notes:** Directory tree now shows all root files (opencode.json, startup.sh, bootstrap.sh), real docs/ contents, empty mitigations/, accurate completed_audits/.
