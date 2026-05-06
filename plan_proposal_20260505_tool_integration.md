# Plan Proposal — Tool Integration for SOC2 Audit Enhancement

**Date:** 2026-05-05
**Status:** Revised
**Premise:** Identify CLI tools that could improve depth AND automation of local Linux audits, with SOC2 mapping.

---

## Self-Critique (Performed Before Finalizing)

The first draft recommended OpenSCAP + auditd. Critique found:

- **OpenSCAP overlap with lynis is ~20%, not 50%.** The SECURITY_CHECKLIST.md is dominated by credential exposure checks (AWS keys, .env files, SSH keys, shell history). OpenSCAP checks OS config — core dumps, GRUB, password hashing, SSH daemon settings. These are the least actionable items in the checklist. Claiming it replaces "50%" is misleading.
- **OpenSCAP does not simplify the workflow.** It adds a new tool, a new scan, a new result format to parse, and new false positives to triage (server-focused CIS rules on a laptop). The existing 22 grep commands are actually simpler.
- **Ubuntu SSG content may not have a mature profile for 24.04.** If the profile doesn't exist or is incomplete, the entire recommendation collapses.
- **auditd adds maintenance burden, not simplification.** Audit trails need log rotation tuning, regular review, and correlation. On a single-laptop vault, the ROI of "evidence nobody reads" is dubious. The "medium" risk rating for log growth understates it — default Ubuntu auditd caps at 32MB total, which is ~1 day on an active dev machine.
- **The core question was "what simplifies things."** Neither recommended tool simplifies. Both deepen capability but add maintenance.

**Revised recommendation:** Only recommend tools that either (a) reduce manual effort or (b) provide unique coverage lynis cannot.

---

## Revised Proposal: Add 1 tool, configure 1 existing subsystem

### RECOMMENDED

#### 1. OpenSCAP — Only as an optional supplement, not a simplification tool

| Dimension | Assessment |
|-----------|-----------|
| Install | `sudo apt install openscap-scanner scap-security-guide` |
| Run | `oscap xccdf eval --profile cis_level1_server --report /tmp/oscap-report.html /usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml` |
| SOC2 | CC6.8, CC7.2 |
| Covers | OS hardening: kernel params, filesystem permissions, PAM config, service configuration |
| Misses | Credential exposure (AWS keys, .env, shell history), git secrets, rootkits, npm/pip deps — most of the current checklist |
| Value | Adds CIS benchmarking that lynis doesn't do. Catches drift in OS config over time (e.g., `umask` changed, world-readable files appeared). |

**Honest assessment:** OpenSCAP adds depth in a narrow area. It does NOT replace lynis, does NOT replace the checklist, and does NOT simplify the process. It's worth adding as an optional quarterly scan for OS config drift detection. Profile availability on Ubuntu 24.04 must be verified at install time (`oscap info /usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml | grep cis`).

#### 2. `auditd` — Worth configuring ONLY for specific high-value events

| Dimension | Assessment |
|-----------|-----------|
| Install | Already present. Enable: `sudo systemctl enable --now auditd` |
| Rules needed | Narrow rules, not the kitchen sink |
| SOC2 | CC7.3 |
| Value-add | Monitors `/etc/passwd`, `/etc/shadow`, `/etc/ssh/sshd_config` writes — catches config tampering between audits. This is unique coverage lynis/OpenSCAP cannot provide (they only take snapshots). |

**Honest assessment:** The original proposal suggested broad audit rules. Wrong move. Narrow rules (3-5 key files) give high-value signal with minimal noise and tiny log volume. `auditd` is worth it ONLY with scoped rules, not the default "log everything" approach. Log rotation must be configured at enable time.

---

### NOT RECOMMENDED (unchanged from first draft)

| Tool | Reason |
|------|--------|
| **clamav** | 500MB+ signatures, slow, low Linux laptop malware prevalence. Weak ROI. |
| **chkrootkit** | Overlaps 80% with rkhunter. Adds maintenance without new coverage. |
| **tailsnitch** | Tailscale not installed. Irrelevant. |
| **Wazuh agent** | Full SIEM. Overkill for single laptop. 500MB+ RAM, needs server. |
| **AIDE / Tripwire** | Already rejected in README.rst. File integrity low value vs. credential/config audit focus. |

---

## Proposed Vault Changes  
**Critique note:** This section was expanded from the original to address vault-root cleanliness concerns.

1. **Move `SECURITY_CHECKLIST.md` → `docs/security-checklist.md`** — The root directory should only contain top-level workflow files (AGENTS.md, README.md, startup.sh, plan files). Reference documents like the checklist belong in `docs/`. Update any references across the vault that point to the old path.

2. **Remove empty scaffolding dirs from `setup/`** — `setup/completed_audits/`, `setup/metrics/`, `setup/mitigations/` are all empty. They were left over from an earlier approach where `setup/` held scaffolding templates. The current `install.sh` creates these directories in the vault root via `mkdir -p` (line 153) — the copies in `setup/` are never read, never copied, and never used. They are dead weight. Delete all three.

3. Add OpenSCAP install and scan commands to `setup/skills/tools/SKILL.md` as optional supplement

4. Add narrow `auditd` rule set to `setup/skills/tools/SKILL.md` (5 rules max)

5. Add a note to `startup.sh` to check `auditd` status (one `systemctl is-active` check)

6. No changes to AGENTS.md menu flow. Tools are background supplements, not new workflow steps.

---

## Risk Assessment (Revised)

| Finding | Likelihood | Impact | Risk Level |
|---------|-----------|--------|------------|
| Ubuntu 24.04 SSG profile missing/incomplete | Medium | High | High |
| OpenSCAP false positives from server-focused CIS rules | High | Low | Low |
| OpenSCAP adds scan time with low incremental value | Medium | Low | Low |
| auditd log rotation not configured at enable | Medium | Medium | Medium |
| auditd narrow rules still insufficient for SOC2 evidence | Low | Medium | Low |
| Adding tools increases maintenance without simplification | High | Medium | Medium |

---

## Final Verdict

**OpenSCAP:** Add as quarterly optional supplement for OS config drift detection. Verify profile exists before recommending. Do NOT claim it simplifies the workflow — it deepens it.

**auditd:** Configure with 3-5 narrow rules for config tamper detection. Worth the 10-minute setup. Do NOT oversell as "SOC2 evidence" — it's a tamper alarm, not a compliance archive.

**Clamav, chkrootkit, tailsnitch, Wazuh, AIDE:** Skip. No credible ROI for this use case.
