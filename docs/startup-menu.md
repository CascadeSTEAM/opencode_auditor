# Startup Menu

Present when user types `/audit` — after running `./startup.sh`.

## If active audit exists

```
question([{ header: "Audit Vault", question: "An active audit plan exists. What would you like to do?",
  options: [
    { label: "Resume active audit (Recommended)", description: "Continue unchecked items in order of priority" },
    { label: "View full plan",                    description: "Show the complete plan file first" },
    { label: "Quick Scan",                        description: "lynis + rkhunter + quick checks (~5 min)" },
    { label: "Full Audit",                        description: "Comprehensive plan with SOC2 mapping" },
    { label: "View Dashboard",                    description: "Security trends from metrics/" },
    { label: "Wait",                              description: "Do nothing — user will direct" }
  ]
}])
```

## No active audit

```
question([{ header: "Audit Vault", question: "What would you like to do?",
  options: [
    { label: "Quick Scan (Recommended)", description: "lynis + rkhunter + quick checks (~5 min)" },
    { label: "Full Audit",               description: "Comprehensive plan with SOC2 mapping" },
    { label: "View Dashboard",           description: "Security trends from metrics/" },
    { label: "Wait",                     description: "Do nothing — user will direct" }
  ]
}])
```
