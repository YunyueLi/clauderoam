# claude-portable

**Your Claude Code config, in git. Account-agnostic. Device-agnostic. 5 minutes to restore on any machine.**

[中文文档](./README.zh-CN.md) · [Setup](./docs/setup.md) · [Multi-device](./docs/multi-device.md) · [Multi-account](./docs/multi-account.md) · [FAQ](./docs/faq.md)

---

## The problem

You customize Claude Code over time — preferences in `CLAUDE.md`, custom
subagents, slash commands, hooks, auto-memory. Then:

- You switch Macs and it's all gone
- You switch Claude accounts and account-bound state vanishes with it
- You want the same setup on your work laptop and your home one

Most of this state isn't synced anywhere. It just sits in `~/.claude/` on
one machine.

## The fix

Put the portable parts of `~/.claude/` in a git repo, symlink them back in.
Standard dotfiles pattern, but tuned for Claude Code:

- Knows which files are portable vs. machine/account-bound
- Includes scripts to snapshot and restore auto-memory across devices
- Safe `bootstrap.sh` that backs up everything before changing anything
- A `doctor.sh` to verify the setup is healthy

## Quick start

```bash
# 1. Use this repo as a template on GitHub (top right "Use this template")
#    or fork it. Then clone YOUR copy.
git clone git@github.com:<you>/claude-portable.git ~/claude-portable
cd ~/claude-portable

# 2. Personalize CLAUDE.md
$EDITOR CLAUDE.md

# 3. Activate
./bootstrap.sh

# 4. Verify
./doctor.sh
```

That's it. From now on, edits to `~/.claude/CLAUDE.md` *are* edits to the repo
file (it's a symlink). Commit and push, and any other device that runs
`bootstrap.sh` picks them up.

## What's portable, what isn't

| Portable (in this repo) | Stays local (gitignored) |
|---|---|
| `CLAUDE.md` — your preferences | `.credentials.json` — your auth token |
| `settings.json` — permissions, hooks | `sessions/` — conversation logs |
| `agents/` — custom subagents | `shell-snapshots/` — shell state |
| `skills/` — custom skills | `projects/` — per-project runtime data |
| `commands/` — slash commands | `telemetry/` — usage stats |
| `keybindings.json` | `policy-limits.json` — account limits |
| `memory/` — snapshotted auto-memory | |

## Daily workflow

```bash
make help       # show all commands
make bootstrap  # (re)activate symlinks
make doctor     # health check
make sync       # snapshot auto-memory → ./memory/
make push       # sync + commit + push
make status     # show repo + symlink state
```

## Adding to a second device

```bash
git clone git@github.com:<you>/claude-portable.git ~/claude-portable
cd ~/claude-portable && ./bootstrap.sh
./restore-memory.sh   # optional: bring auto-memory back too
```

## Architecture

```
GitHub (source of truth, account-independent)
   │
   │  <you>/claude-portable
   │    ├── CLAUDE.md, settings.json
   │    ├── agents/, commands/, skills/
   │    └── memory/
   ▼
~/claude-portable (cloned)
   │
   │  bootstrap.sh creates symlinks
   ▼
~/.claude/CLAUDE.md  ────► ~/claude-portable/CLAUDE.md
~/.claude/agents/    ────► ~/claude-portable/agents/
~/.claude/commands/  ────► ~/claude-portable/commands/
   ...
```

Claude Code reads `~/.claude/` as normal. It doesn't know (or care) that the
files are symlinks.

## Examples

The [`examples/`](./examples) folder has working agents and slash commands
you can copy in:

- `code-reviewer` agent — focused diff review
- `/new-project` — scaffold a new GitHub repo with CLAUDE.md
- `/save` — sync memory and push everything

## FAQ

See [docs/faq.md](./docs/faq.md). Highlights:

- **Will this break Claude Code?** No, symlinks are transparent.
- **Public or private repo?** Private if you sync `memory/`; otherwise public is fine.
- **What about Linux / WSL?** Should work — only standard Unix tools used.
- **How do I undo?** `bootstrap.sh` backs up everything first; restore the backup.

## Status

Built for Claude Code (CLI, desktop app, IDE extensions). Tested on
macOS 14+. PRs welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

[MIT](./LICENSE)
