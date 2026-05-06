# Tools Skill — Security Tool Install and Run Reference

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

### Additional Checks
```bash
# Open ports
ss -tlnp 2>/dev/null

# Listening services
systemctl list-units --type=service --state=running

# World-readable sensitive files
find /home -perm /o+r -type f -name "*.key" -o -name "*.pem" -o -name "*.kdbx" 2>/dev/null
```
