# Continuous Monitoring

[About](about.md) · [Conventions](file-conventions.md) · [Startup](startup-menu.md) · [Resolution](resolution-workflow.md) · [Completion](completion-workflow.md) · [SOC2](soc2-controls.md) · [Checklist](security-checklist.md) · [Monitoring](continuous-monitoring.md) · [Branching](branching-strategy.md) · [Versioning](VERSIONING.md)

- **Weekly:** lynis quick scan + rkhunter → update `metrics/security_posture_YYYYMM.json`
- **Monthly:**
  - Full audit with comparison to prior month's metrics
  - CVE scan (cvescan + osv-scanner + debsecan) → update `metrics/security_posture_YYYYMM.json`
  - CISA KEV + USN advisory check

## Metrics Schema

Fields: `scan_date`, `scan_type`, `lynis_hardening_index`, `rkhunter_warnings`, `cve_count`, `cvescan_findings`, `osv_scanner_findings`, `max_cvss`, `kev_count`, `duration`, `new_findings`
