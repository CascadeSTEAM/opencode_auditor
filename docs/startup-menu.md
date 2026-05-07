# Startup Menu

Use the Question tool to present this menu when the user asks about auditing — after running `./startup.sh`.

> **Passive scans:** All scans are read-only. Nothing is installed, modified, or removed until you specifically review and approve a remediation. See `setup/skills/tools/SKILL.md` for the exact commands run.

> **Custom input:** At any menu, type your own response instead of picking an option. This enters discussion mode — ask questions, explore options, or get clarification before deciding.

## If active audit exists

```
question([{ header: "Audit Vault", question: "An active audit plan exists. What would you like to do?",
  options: [
    { label: "Resume active audit (Recommended)", description: "Continue unchecked items in order of priority" },
    { label: "View full plan",                    description: "Show the complete plan file first" },
    { label: "Quick Scan",                        description: "Passive read-only scan — lynis + rkhunter + quick checks (~5 min)" },
    { label: "Full Audit",                        description: "Passive read-only — comprehensive plan with SOC2 mapping" },
    { label: "View Dashboard",                    description: "Security trends from metrics/" },
    { label: "Wait",                              description: "Do nothing — user will direct" }
  ]
}])
```

## No active audit

```
question([{ header: "Audit Vault", question: "What would you like to do?",
  options: [
    { label: "Quick Scan (Recommended)", description: "Passive read-only scan — lynis + rkhunter + quick checks (~5 min)" },
    { label: "Full Audit",               description: "Passive read-only — comprehensive plan with SOC2 mapping" },
    { label: "View Dashboard",           description: "Security trends from metrics/" },
    { label: "Wait",                     description: "Do nothing — user will direct" }
  ]
}])
```
