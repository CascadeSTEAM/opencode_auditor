# Tools Skill — Security Tool Install and Run Reference

> **All scans below are read-only.** No system changes, no installations, no modifications. The commands only inspect and report. If a finding needs remediation, it will be presented for your review and approval before any change is made.

Load this skill before running or recommending any security audit tool.

## Install Commands

### Arch Linux
```bash
sudo pacman -S lynis rkhunter fail2ban firewalld
```

### Ubuntu/Debian
```bash
sudo apt install lynis rkhunter fail2ban firewalld
```

### Fedora
```bash
sudo dnf install lynis rkhunter fail2ban firewalld
```

### macOS (partial)
```bash
brew install lynis
# rkhunter and fail2ban have limited macOS support
```

## Tool Run Commands

### lynis — System Hardening Audit
```bash
sudo lynis audit system --quick 2>/dev/null | tail -30
```
Look for `Hardening index` line. Index < 70 indicates room for improvement.

### rkhunter — Rootkit Detection
```bash
sudo rkhunter --check --skip-keypress --quiet 2>/dev/null
```
Check `/var/log/rkhunter.log` for `Warning` lines.

### fail2ban — SSH Intrusion Prevention
```bash
sudo fail2ban-client status sshd 2>/dev/null
```
Shows currently banned IPs and jail status.

### firewalld — Dynamic Firewall
```bash
sudo firewall-cmd --list-all 2>/dev/null
```
Check which services/ports are open.

### OpenSCAP — OS Config Compliance (Optional, Quarterly)
```bash
# Install
sudo apt install openscap-scanner scap-security-guide

# Verify profile exists
oscap info /usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml 2>/dev/null | grep -A1 "cis_level1_server"

# Run CIS Level 1 scan
sudo oscap xccdf eval --profile cis_level1_server \
  --results /tmp/oscap-results.xml \
  --report /tmp/oscap-report.html \
  /usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml
```
Open report with `xdg-open /tmp/oscap-report.html`. Expect false positives from server-focused rules. Triage before acting.

### auditd — Config Tamper Detection (Continuous)
```bash
# Enable
sudo systemctl enable --now auditd

# Add narrow rules (5 high-value files only)
printf -- "-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k sudoers
-w /etc/ssh/sshd_config -p wa -k ssh
-w /etc/audit/audit.rules -p wa -k audit-config" | sudo tee /etc/audit/rules.d/99-vault.rules

# Restart to load rules
sudo systemctl restart auditd

# Verify active
sudo auditctl -l | head -10

# Test: a write to /etc/passwd should appear in logs
sudo ausearch -k identity --start recent | tail -5
```
**WARNING:** Default log rotation caps at 32MB (~1 day on active dev). Adjust `/etc/audit/auditd.conf`: `max_log_file=50`, `num_logs=4`, `space_left_action=SYSLOG`. Without this, auditd will stop logging or fill `/var`.

### Additional Checks
```bash
# Open ports
ss -tlnp 2>/dev/null

# Listening services
systemctl list-units --type=service --state=running

# World-readable sensitive files
find /home -perm /o+r -type f -name "*.key" -o -name "*.pem" -o -name "*.kdbx" 2>/dev/null
```
