# Security Posture Metrics

Monthly scan metrics stored as JSON files: `security_posture_YYYYMM.json`.

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `scan_date` | string | ISO 8601 date of scan |
| `scan_type` | string | `quick` or `full` |
| `lynis_hardening_index` | int | Lynis hardening index (0-100) |
| `rkhunter_warnings` | int | Number of rkhunter warnings |
| `duration` | int | Scan duration in seconds |
| `new_findings` | int | New findings vs prior scan |
