# Templates Skill — Audit Vault Document Formats

Load this skill when creating or updating audit plan files (`plan_*.md`) or mitigation task files (`mitigations/NN_topic.md`).

## Plan File Template (`plan_YYYYMMDD.md`)

```markdown
# Audit Plan — YYYY-MM-DD

**Premise:** <premise text>

## Summary

| Risk ID | Finding | Risk Level | SOC2 | Status |
|---------|---------|------------|------|--------|
| AUDIT-YYYY-001 | Title | Critical/High/Medium/Low | CCx.x | Open |

---

## CRITICAL

### AUDIT-YYYY-001 — Finding Title
- **Location:** <where found>
- **Issue:** <what's wrong>
- **Impact:** <why it matters>
- **Risk Assessment:**
  - Likelihood: High | Medium | Low
  - Impact: High | Medium | Low
  - Risk Level: Critical | High | Medium | Low
  - SOC2 Control: CCx.x
  - Compliance Status: Open | In Progress | Mitigated
- [ ] <action item>

---

## HIGH
...
```

## Mitigation File Template (`mitigations/NN_topic.md`)

```markdown
# Mitigation: NN — Topic

## Risk Assessment
- **Risk ID:** AUDIT-YYYY-NNN
- **Likelihood:** High | Medium | Low
- **Impact:** High | Medium | Low
- **Risk Level:** Critical | High | Medium | Low
- **SOC2 Control:** CCx.x

## Phase 1: Pre-Audit (Read-Only)
- [ ] Action 1: description
- [ ] Action 2: description

## Phase 2: Remediation
- **Commands:**
  ```bash
  
  ```
- **Expected result:** ...

## Phase 3: Verification
- [ ] Verify action 1 succeeded
- [ ] Verify action 2 succeeded

## Resolution
- **Status:** Mitigated | Accepted | Transferred
- **Date:** YYYY-MM-DD
- **Notes:** ...
```
