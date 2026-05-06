# Security Audit Checklist

**Purpose:** Quick-scan reference and finding generator for `audits/plan_YYYYMMDD.md`. Use this checklist to identify findings, then complete the Risk Assessment before any mitigation begins.

**⚠️ Mandatory:** A Risk Assessment (Likelihood, Impact, Risk Level) must be completed for each finding before mitigation can start.

---

## Risk Assessment Framework

For each finding identified in the checklist, complete the following assessment before creating mitigation tasks:

```
Finding: [Title from checklist]

Risk Assessment:
- Risk ID: AUDIT-YYYY-NNN
- Likelihood: High | Medium | Low
- Impact: High | Medium | Low
- Risk Level: Critical | High | Medium | Low
- Control Objective: CC6.1 | CC6.8 | CC7.2 | CC7.3 | CC7.4 | CC9.1
- Compliance Status: Open | In Progress | Mitigated
```

**Risk Level Matrix:**
| Likelihood \ Impact | High | Medium | Low |
|---------------------|------|--------|-----|
| High | Critical | High | Medium |
| Medium | High | Medium | Low |
| Low | Medium | Low | Low |

---

## Checklist Items

### CRITICAL

| # | Item | SOC2 | Quick Command |
|---|------|------|---------------|
| 1 | AWS credentials in environment | CC6.1 | `grep -r "AWS_ACCESS_KEY\|AWS_SECRET" ~/.aws/ ~/.bashrc ~/.zshrc 2>/dev/null` |
| 2 | SSH root login enabled | CC6.1 | `sshd -T 2>/dev/null \| grep -i permitrootlogin` |
| 3 | KeePass keyfile exposure | CC6.1 | `find ~ -name "*.kdbx" -o -name "*keyfile*" 2>/dev/null` |

### HIGH

| # | Item | SOC2 | Quick Command |
|---|------|------|---------------|
| 4 | Environment files with secrets | CC6.1 | `find ~ -name ".env*" 2>/dev/null \| grep -v "node_modules\|\.git" \| head -20` |
| 5 | SSH keys without passphrase | CC6.1 | `ssh-keygen -l -f ~/.ssh/id_* 2>/dev/null \| grep -v "\.pub" \| grep -i "unprotected"` |
| 6 | Git repos with secrets in history | CC6.1 | `find ~ -name ".git" -exec sh -c 'cd "$1" && git log --all -S "password\|secret\|key" --oneline' _ {} \; 2>/dev/null \| head -10` |
| 7 | Security tools not installed | CC7.2 | `which lynis rkhunter 2>/dev/null \|\| echo "Tools not installed"` |
| 8 | GRUB bootloader no password | CC6.1 | `grep -r "set superusers\|password" /etc/grub.d/ /boot/grub/ 2>/dev/null` |
| 9 | Weak password hashing | CC6.1 | `grep ENCRYPT_METHOD /etc/login.defs && grep -i "rounds\|sha512" /etc/pam.d/common-password /etc/pam.d/system-auth 2>/dev/null` |
| 10 | Unnecessary services running | CC6.8 | `systemctl list-units --type=service --state=running \| head -20` |

### MEDIUM

| # | Item | SOC2 | Quick Command |
|---|------|------|---------------|
| 11 | Shell history with secrets | CC6.1 | `grep -i "password\|secret\|key\|token" ~/.bash_history ~/.zsh_history 2>/dev/null \| head -10` |
| 12 | Temp files with sensitive data | CC6.8 | `ls -la /tmp/ \| grep $(whoami) && find ~/.cache -type f -exec grep -l "password\|key" {} \; 2>/dev/null \| head -5` |
| 13 | Core dumps enabled | CC6.8 | `ulimit -c && cat /proc/sys/kernel/core_pattern` |
| 14 | No continuous monitoring | CC7.3 | `crontab -l 2>/dev/null \| grep -i "lynis\|rkhunter\|security"` |
| 15 | No metrics tracking | CC7.3 | `ls -la ~/Projects/audit/metrics/*.json 2>/dev/null \|\| echo "No metrics files"` |
| 16 | World-readable files | CC6.1 | `find ~ -perm -o=r -type f 2>/dev/null \| grep -v "\.git\|node_modules\|cache" \| head -10` |

### LOW

| # | Item | SOC2 | Quick Command |
|---|------|------|---------------|
| 17 | Duplicate/backup directories | CC6.8 | `find ~ -type d \( -name "*backup*" -o -name "*old*" \) 2>/dev/null \| grep -v "\.git\|node_modules" \| head -10` |
| 18 | Hidden files review | CC6.8 | `ls -la ~ \| grep "^-" \| grep "^\." \| head -20` |
| 19 | LWP::UserAgent config | CC6.8 | `find ~ -name "*lwp*" 2>/dev/null && echo $PERL_LWP_SSL_VERIFY_HOSTNAME` |
| 20 | Plaintext credential files | CC6.1 | `find ~ -type f \( -name "*password*" -o -name "*credential*" \) 2>/dev/null \| grep -v "\.git\|gpg\|kdbx" \| head -10` |
| 21 | File permissions issues | CC6.1 | `find ~ -perm -o=w -type d 2>/dev/null \| head -5 && ls -ld ~` |
| 22 | System artifacts cleanup | CC6.8 | `du -sh ~/.cache/* 2>/dev/null \| sort -h \| tail -10` |

---

## Workflow

### Step 1: Run Checklist
Execute the Quick Command for each item. Record findings:

```
Finding #N: [Item name]
- Location: [where found]
- Issue: [what's wrong]
- Output: [paste command output]
```

### Step 2: Complete Risk Assessment
For each finding, fill out the Risk Assessment Framework (see above):
- Assign Risk ID (AUDIT-YYYY-NNN)
- Determine Likelihood (High/Medium/Low)
- Determine Impact (High/Medium/Low)
- Calculate Risk Level using the matrix
- Map to SOC2 Control Objective
- Set Compliance Status to "Open"

### Step 3: Generate Plan
Use the plan template to create `audits/plan_YYYYMMDD.md`:
- Summary table with all findings (sorted by Risk Level: Critical → High → Medium → Low)
- Detailed sections for each priority level
- Each finding includes: Location, Issue, Impact, SOC2 Risk Assessment

### Step 4: Create Mitigations
Iterate over plan items → create specific mitigation files in `mitigations/NN_topic.md`

### Step 5: Execute Mitigations
Follow the mitigation plan phases (read-only audit → action → verification) for each item.

---

## Notes

- Checklist items map to `mitigations/` for detailed remediation
- Risk Assessment is mandatory before any mitigation begins (SOC2 compliance)
- Commands are designed for quick scanning; use `mitigations/NN_topic.md` for detailed remediation
