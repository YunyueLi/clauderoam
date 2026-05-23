# Multi-device workflow

claude-portable's goal: **any device, any time, picking up exactly where you
left off**.

## What lives where

```
┌─────────────────────────────────────────────────────────────┐
│                          GitHub                              │
│  (source of truth, account-independent)                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📦 <you>/claude-portable (private fork)                    │
│     ├── CLAUDE.md          ← your preferences               │
│     ├── settings.json      ← permissions, hooks             │
│     ├── agents/                                              │
│     ├── commands/                                            │
│     ├── skills/                                              │
│     └── memory/            ← auto-memory snapshots          │
│                                                              │
│  📦 <you>/project-A (where actual work happens)             │
│     ├── src/...                                              │
│     ├── CLAUDE.md          ← project-specific conventions   │
│     └── .claude/                                             │
│                                                              │
│  📦 <you>/project-B  ...                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
        ▲                          ▲
        │ git clone +              │ Claude Code reads on every
        │ bootstrap.sh             │ session start
        │                          │
        ▼                          ▼
   ┌─────────────┐           ┌────────────────────┐
   │  Mac (work) │           │  Mac (laptop)      │
   │  Mac (home) │  ←synced→ │  Linux server      │
   │  iPhone     │           │  ...               │
   └─────────────┘           └────────────────────┘
```

## Adding a new device

```bash
# Same on every machine
git clone git@github.com:<you>/claude-portable.git ~/claude-portable
cd ~/claude-portable && ./bootstrap.sh
./restore-memory.sh   # optional, brings auto-memory back
```

## iPhone / iPad

Mobile devices can't run scripts, but they can:

1. **View past Claude conversations** — same account on the Claude iOS app
   syncs conversation history
2. **Trigger work remotely** — install the
   [Claude GitHub App](https://github.com/apps/claude) on your project
   repos; then in the GitHub iOS app, comment `@claude <task>` on any issue
   or PR. Claude runs in the cloud and pushes a commit.
3. **Code review on the go** — same `@claude review` pattern in PR comments

The point: **iPhone never holds state**. All persistent state is in GitHub.

## Keeping devices in sync

The flow you want to internalize:

| When | Where | Command |
|---|---|---|
| Start a session | Any device | `git pull` (in project repos AND claude-portable) |
| End a session | Any device | `git push` (project changes) |
| Periodically | Any Mac | `make push` (snapshot + push memory) |

Tip: add `make push` to a daily cron / Shortcut so memory snapshots happen
automatically.
