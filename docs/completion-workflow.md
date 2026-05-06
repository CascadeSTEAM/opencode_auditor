# Completion Workflow

When all items in an audit plan are resolved:

1. Verify every `mitigations/*.md` has completed Verification + Resolution sections
2. Ask user to confirm a 30-day holding reminder in crontab
3. Update the plan Summary table (✅ + SOC2 compliance status per item)
4. Ask:

```
question([{ header: "Audit Complete", question: "Archive this plan?",
  options: [
    { label: "Archive now (Recommended)", description: "Move to audits/completed/" },
    { label: "Review again",              description: "Walk through items once more" },
    { label: "Create new audit",          description: "Start a fresh plan" }
  ]
}])
```
