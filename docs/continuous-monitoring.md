# Continuous Monitoring

- **Weekly:** lynis quick scan + rkhunter → update `metrics/security_posture_YYYYMM.json`
- **Monthly:** Full audit with comparison to prior month's metrics

## Metrics Schema

Fields: `scan_date`, `scan_type`, `lynis_hardening_index`, `rkhunter_warnings`, `duration`, `new_findings`
