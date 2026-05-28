---
name: vault-templates
description: Audit plan and mitigation file format templates for audit_plan_YYYYMMDD.md and mitigations/NN_topic.md.
---

# Templates Skill — Audit Vault Document Formats

Load this skill when creating or updating audit plan files (`audits/plan_*.md`) or mitigation task files (`mitigations/NN_topic.md`).

## Plan File Template (`audits/plan_YYYYMMDD.md`)

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

---

## CVE / CERT Findings

### AUDIT-YYYY-NNN — CVE Identifier (CVE-YYYY-NNNNN)
- **Source:** cvescan | osv-scanner | debsecan | CISA KEV
- **Package:** <package name>
- **Fixed Version:** <version>
- **Risk Assessment:**
  - Likelihood: High | Medium | Low *(KEV entries default to High)*
  - Impact: High | Medium | Low
  - Risk Level: Critical | High | Medium | Low
  - SOC2 Control: CC7.1
  - CVSS: <score> (<vector>)
- **CISA KEV:** Yes | No *(actively exploited in the wild)*
- [ ] <action: upgrade package / apply mitigation / document acceptance>

---

## USN / Advisory Summary

| USN ID | Title | Affected Packages | Priority |
|--------|-------|-------------------|----------|
| USN-YYYY-NNNN | <title> | <pkg1, pkg2> | Critical/High/Medium |
```

---

## GRUB Bootloader Hardening — Safe Mitigation Template

Use this template when a GRUB password mitigation is required.

### ⚠️ Critical Safety Checks (Run First)

```bash
# 1. Skip on cloud/VM — GRUB passwords are pointless in virtualized environments
if systemd-detect-virt --quiet; then
  echo "ERROR: VM/container detected. GRUB hardening skipped — no security benefit."
  exit 1
fi

# 2. Check if already configured
if grep -qr "set superusers\|password" /etc/grub.d/ /boot/grub/ 2>/dev/null; then
  echo "GRUB password already configured. Nothing to do."
  exit 0
fi
```

### Phase 1: Pre-Audit (Read-Only)
- [ ] Run safety checks (VM detection, existing config check)
- [ ] Confirm this is a **physical machine** with local console access
- [ ] Confirm you have a **live USB** available for recovery if needed
- [ ] Read the full workflow below before proceeding

### Phase 2: Password Generation & Storage

```bash
# Generate a short alphanumeric passphrase (easy to type at GRUB prompt)
GRUB_PASS=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
echo ""

# ╔══════════════════════════════════════════════════════════════╗
# ║  GRUB PASSWORD: $GRUB_PASS              ║
# ║  SAVE THIS NOW — you will need it at every boot.            ║
# ║  Write it on paper. Save it in your password manager.       ║
# ║  Do NOT rely on a single digital copy.                      ║
# ╚══════════════════════════════════════════════════════════════╝
echo ""

# Save to /root/ (safe: not in encrypted home, root-read-only)
# If /root/ is encrypted, use a plaintext partition or removable media
echo "GRUB password for $(hostname): $GRUB_PASS" | \
  sudo tee /root/.grub-password-$(hostname) > /dev/null
sudo chmod 600 /root/.grub-password-$(hostname)

# Display again as confirmation
echo "Password saved to: /root/.grub-password-$(hostname) (chmod 600)"
echo ""
echo ">> CONFIRM: Have you recorded this password in at least TWO places?"
echo ">> Type YES to continue or anything else to abort"
read -r CONFIRM
if [ "$CONFIRM" != "YES" ]; then
  echo "Aborted. Run this mitigation again when ready."
  exit 1
fi
```

### Phase 3: Apply GRUB Configuration

```bash
# Generate the PBKDF2 hash (requires interactive input via expect or manual)
# NOTE: This step is interactive. If run in a script, use expect or manual input.
echo "Run the following step manually:"
echo "  1. grub-mkpasswd-pbkdf2"
echo "     (enter the password above when prompted twice)"
echo "  2. Copy the resulting PBKDF2 hash"
echo "  3. Edit /etc/grub.d/40_custom:"
echo "     set superusers=\"admin\""
echo "     password_pbkdf2 admin <PBKDF2_HASH>"
echo "  4. Run: sudo update-grub"
echo ""
echo "WARNING: update-grub validates syntax but cannot catch a wrong password."
echo "Do NOT reboot until you have verified the config."
```

### Phase 4: Verification
- [ ] Verify `/etc/grub.d/40_custom` contains the correct superusers and hash
- [ ] Run `sudo update-grub` and confirm no errors
- [ ] Verify the password file exists: `cat /root/.grub-password-$(hostname)`
- [ ] Run `sudo grep -r "password\|superusers" /boot/grub/` to confirm the password is in the boot config
- [ ] **Do NOT reboot yet.** If unsure, test by reviewing the generated config in `/boot/grub/grub.cfg`

### Recovery (If Locked Out)

If you reboot and cannot authenticate:

1. Boot from a **live USB** (Ubuntu installer in "Try Ubuntu" mode)
2. Mount your root partition:
   ```bash
   sudo mount /dev/sdXY /mnt
   sudo mount /dev/sdXZ /mnt/boot   # if separate boot partition
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   ```
3. Chroot and reset GRUB:
   ```bash
   sudo chroot /mnt
   # Remove the password lines from /etc/grub.d/40_custom
   sed -i '/set superusers\|password_pbkdf2/d' /etc/grub.d/40_custom
   update-grub
   ```
4. Reboot into the now-unlocked system, or repeat Phase 2-3 with a saved password.

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
- **Status:** Mitigated | Accepted | Transferred | Deferred | Skipped
- **Date:** YYYY-MM-DD
- **Notes:** ...
```
