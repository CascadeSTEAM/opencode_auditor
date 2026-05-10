# Resolution Workflow

For each unchecked item in the audit plan, present this question:

```
question([{ header: "Item #N — [PRIORITY] — Title", question: "How to resolve?",
  options: [
    { label: "Mitigate",       description: "Create and execute a remediation plan" },
    { label: "Explain",        description: "Show the mitigation details — risk, plan, status" },
    { label: "Accept risk",    description: "Document why this risk is acceptable" },
    { label: "Transfer",       description: "Assign to another party or system" },
    { label: "Defer",          description: "Skip for now, keep tracking — revisit later" },
    { label: "Skip for now",   description: "Return to this item later in the session" }
  ]
}])
```

> **Custom input:** At any question, type your own response to ask questions, discuss the finding, or understand risks better. The agent will treat this as discussion mode — answering your questions, explaining context, and re-presenting the options afterward.

## Discussion Mode

When a user enters custom text instead of picking a preset option:

1. Answer their question or clarify the issue
2. Provide relevant context (risk, impact, remediation effort, alternatives)
3. Re-present the resolution options:
   ```
    question([{ header: "Item #N — [PRIORITY] — Title", question: "Now how would you like to proceed?",
      options: [
        { label: "Mitigate",       description: "Create and execute a remediation plan" },
        { label: "Explain",        description: "Show the mitigation details — risk, plan, status" },
        { label: "Accept risk",    description: "Document why this risk is acceptable" },
        { label: "Transfer",       description: "Assign to another party or system" },
        { label: "Defer",          description: "Skip for now, keep tracking — revisit later" },
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

## Defer

Mark `- [ ] Deferred: <reason if any>` — item stays unchecked, will be re-presented on next resume.

## Skip

Mark `- [ ] Skipped: <reason>` — revisit later.

## Explain

1. Look up the corresponding mitigation file: `mitigations/NN_topic.md` (where NN matches the finding number)
2. If the file exists, present a summary:
   ```
   **Finding:** <title from plan>
   **Risk Level:** <level>
   **Remediation:** <phases from mitigation file>
   **Status:** <current status>
   ```
3. If the file does not exist, inform the user and offer to create one: "No mitigation file yet — would you like to create one?" (routes to the Mitigate flow)
4. After presenting, re-present the resolution options so the user can decide how to proceed.
