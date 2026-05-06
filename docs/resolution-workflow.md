# Resolution Workflow

For each unchecked item in the audit plan, present this question:

```
question([{ header: "Item #N — [PRIORITY] — Title", question: "How to resolve?",
  options: [
    { label: "Mitigate",       description: "Create and execute a remediation plan" },
    { label: "Accept risk",    description: "Document why this risk is acceptable" },
    { label: "Transfer",       description: "Assign to another party or system" },
    { label: "Skip for now",   description: "Return to this item later in the session" }
  ]
}])
```

## Mitigate

1. Run self-critique via `todowrite`
2. Generate full plan: all phases, all commands, expected outputs
3. Present complete plan — require explicit user "Accept" before execution
4. Execute Phase 1 (read-only audit only — no changes)
5. After each phase, ask:

```
question([{ header: "Phase N complete", question: "Continue?",
  options: [
    { label: "Next phase (Recommended)", description: "Proceed with plan as written" },
    { label: "Re-run this phase",        description: "Output looked wrong" },
    { label: "Stop and review",          description: "Pause here" }
  ]
}])
```

6. On completion: mark `[x] Mitigated: → mitigations/NN_topic.md` in plan

## Accept

Ask for reason → mark `- [ ] Accepted: <reason>` (intentionally not `[x]`; tracked, not resolved)

## Transfer

Ask who/what is responsible → mark `- [ ] Transferred: <who> — <reason>`

## Skip

Mark `- [ ] Skipped: <reason>` — revisit later.
