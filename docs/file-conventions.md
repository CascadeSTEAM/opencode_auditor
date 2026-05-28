# File Conventions

[About](about.md) · [Conventions](file-conventions.md) · [Startup](startup-menu.md) · [Resolution](resolution-workflow.md) · [Completion](completion-workflow.md) · [SOC2](soc2-controls.md) · [Checklist](security-checklist.md) · [Monitoring](continuous-monitoring.md) · [Branching](branching-strategy.md) · [Versioning](VERSIONING.md) · [CHANGELOG](../CHANGELOG.md) · [CONTRIBUTING](../CONTRIBUTING.md) · [SECURITY](../SECURITY.md) · [CODE OF CONDUCT](../CODE_OF_CONDUCT.md)

## Toolkit & Named Vaults

The project is split into two parts:

**Toolkit** (`repo/`) — Git-controlled template that provides the agent instructions, workflow docs, skills, and install scripts. This is the upstream source of truth.

**Named vaults** (`~/opencode-auditor/`) — Per-system private workspaces that hold your actual audit data. Each vault symlinks AGENTS.md and docs/ from the toolkit, keeping them always fresh. Your audit plans, mitigations, and metrics stay entirely local and private.

This means:
- `git pull` in the toolkit updates AGENTS.md and docs for **all** vaults instantly
- Each machine/user gets their own vault — never shared, never tracked
- Audit data is immune to upstream changes

## Directory Structure

```
~/opencode-auditor/
├── repo/                        # Toolkit (git clone)
│   ├── AGENTS.md                # Template instructions (symlinked by vaults)
│   ├── docs/                    # Workflow reference (symlinked by vaults)
│   ├── audit                    # Launch/create vault from anywhere (symlinked to PATH)
│   ├── bootstrap.sh             # Entry point — ensures opencode, clones, creates vault
│   ├── opencode.json            # Template config example
│   ├── setup/
│   │   ├── install.sh           # Global setup — permissions, skills, provider
│   │   ├── new-vault.sh         # Scaffolds a named vault with symlinks
│   │   ├── setup-rustdesk-unattended.sh
│   │   └── skills/              # Skill definitions (templates, tools, install)
│   ├── tests/                   # Test suite
│   └── .github/                 # CI workflows
│
├── audit-zephyr/                # Named vault (default: audit-$(hostname))
│   ├── AGENTS.md -> ../repo/AGENTS.md    # Symlink — always fresh
│   ├── docs/     -> ../repo/docs/        # Symlink — always fresh
│   ├── opencode.json                       # Local config (own copy)
│   ├── startup.sh                          # Copied from toolkit
│   ├── audits/                             # Local audit plans
│   │   └── completed/
│   ├── mitigations/                        # Local remediation logs
│   ├── metrics/                            # Local scan metrics
│   └── .obsidian/                          # Local Obsidian config
│
└── audit-personal/              # Another named vault
    └── ...
```

## Tracking Policy

| Path (in vault) | Git | Purpose |
|-----------------|-----|---------|
| `AGENTS.md` | Symlinked -> `../repo/AGENTS.md` | Agent instructions — always fresh via toolkit |
| `docs/` | Symlinked -> `../repo/docs/` | Workflow reference — always fresh via toolkit |
| `audits/plan_YYYYMMDD.md` | Ignored | Active audit — one at a time |
| `audits/plan_proposal_YYYYMMDD_name.md` | Ignored | Draft not yet active |
| `mitigations/NN_topic.md` | Ignored | Per-item execution log |
| `audits/completed/` | Ignored | Archived finished audits |
| `metrics/security_posture_YYYYMM.json` | Ignored | Monthly scan metrics |
| `.startup-required` | Ignored | Marker — deleted after startup menu is shown |
| `mitigations/.gitkeep` | Tracked | Directory placeholder |

**Same-day merge:** If a second plan is created on the same date, append its items to the existing plan (continuing the item numbering), copy mitigations, update Summary. Keep the original filename.

## Creating Named Vaults

Create vaults for different machines or purposes:

```bash
# Audit another machine (creates audit-<hostname> vault automatically)
audit user@other-machine

# Or create a vault with a custom name
bash ~/opencode-auditor/repo/setup/new-vault.sh
# Prompts for a name — defaults to audit-$(hostname)
# Then: cd ~/opencode-auditor/NAME && opencode
```

For individual audit sessions (auditing the same machine again next week), just run `audit` again — it detects the existing vault and asks to reuse it. Each vault is self-contained — its audit plans, mitigations, and metrics are independent.

## Updating the Toolkit

```bash
cd ~/opencode-auditor/repo && git pull
```

AGENTS.md and docs/ in all vaults are symlinked — they update immediately. The next time you run opencode in any vault, `startup.sh` checks for template config changes and offers to apply them.

## Viewing in Obsidian

All vault data is plain markdown — you can browse audits, mitigations, and metrics in any editor. For a richer view, open the vault in [Obsidian](https://obsidian.md):

1. Launch Obsidian
2. Select **Open folder as vault** -> pick your vault directory (e.g. `~/opencode-auditor/audit-$(hostname)`)
3. The **opencode-obsidian** plugin is pre-configured — it adds a ribbon icon to launch OpenCode and a command palette entry

Three folders appear in the file explorer:
- `audits/` — audit plan files (open items and completed)
- `mitigations/` — per-finding remediation logs
- `metrics/` — scan history for posture trending

To view multiple vaults, use Obsidian's **Manage vaults** dialog to switch between them, or open separate Obsidian windows.
