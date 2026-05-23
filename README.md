# claude-portable

**Your Claude Code config, in git. Survives Mac switches AND Claude account switches.**

[中文文档](./README.zh-CN.md) · [Setup](./docs/setup.md) · [Multi-device](./docs/multi-device.md) · [Multi-account](./docs/multi-account.md) · [FAQ](./docs/faq.md)

> ⚠️  This is portable **config**, not a portable Claude Code **binary**. If you're
> looking for a USB-drive Claude Code distribution, you want
> [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable)
> or similar — not this.

---

## The problem nobody else solves: switching Claude accounts

Most "sync ~/.claude" projects assume you keep the same Claude account forever.
Real life isn't like that:

- You're a contractor and your client gives you a new Claude account
- Your company upgrades you from individual to Team
- You leave a job and the account goes with it
- You want a personal account separate from your work account

When you switch, you lose **every** custom slash command, every subagent, every
preference, every remembered fact. claude-portable is built around this
specific moment: a new account, a 5-minute restore, zero loss.

## How it works

Standard dotfiles pattern, specialized for Claude Code:

1. The portable subset of `~/.claude/` (CLAUDE.md, agents, skills, commands,
   memory snapshots) lives in this git repo
2. `bootstrap.sh` symlinks everything into `~/.claude/`
3. Claude Code reads `~/.claude/` as normal — symlinks are transparent to it
4. Switch accounts? The symlinks still point at git, so config survives.
   Only credentials (which *should* change) get replaced.

## Quick start

```bash
# 1. "Use this template" on GitHub (or fork). Then clone YOUR copy:
git clone git@github.com:<you>/claude-portable.git ~/claude-portable
cd ~/claude-portable

# 2. Personalize CLAUDE.md
$EDITOR CLAUDE.md

# 3. Activate
./bootstrap.sh

# 4. Verify
./doctor.sh
```

That's it. Edits to `~/.claude/CLAUDE.md` *are* edits to the repo file.
Commit, push, and any other device that runs `bootstrap.sh` picks them up.

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

Want zero-friction sync? See [auto-sync](./docs/auto-sync.md) for an optional
shell function that pulls before every Claude Code session and pushes after.

## Adding to a second device

```bash
git clone git@github.com:<you>/claude-portable.git ~/claude-portable
cd ~/claude-portable && ./bootstrap.sh
./restore-memory.sh   # optional: bring auto-memory back, with smart username rewriting
```

## How it compares to alternatives

Honest comparison — this space has several good projects. Pick the one that
matches your needs:

| Project | Stars | Sync | Auto-sync | Doctor | Memory snapshots | Multi-account | Bilingual | Stack |
|---|---|---|---|---|---|---|---|---|
| **claude-portable** (this) | — | git | optional shell hook | ✅ | ✅ + username rewriting | ✅ **focus** | ✅ EN/中文 | pure bash |
| [renefichtmueller/claude-sync](https://github.com/renefichtmueller/claude-sync) | 16 | **5 backends** (git, iCloud, Dropbox, Syncthing, rsync) | ✅ | implicit | manual | ❌ | ❌ | TypeScript |
| [balingsisi/claude-sync-tool](https://github.com/balingsisi/claude-sync-tool) | 11 | git | watch mode | ✅ | ❌ | ❌ | ❌ | CLI tool |
| [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) | 9 | git | ✅ shell function | ❌ | ❌ | ❌ | ❌ | shell |
| [zircote/.claude](https://github.com/zircote/.claude) | 24 | git (fork model) | ❌ | ❌ | ❌ | ❌ | ❌ | personal dotfiles + 100+ agents |

**Pick `claude-portable` if**: you switch Claude accounts, want bilingual docs,
prefer pure bash with zero deps, or specifically want memory snapshots that
survive a username change on a new Mac.

**Pick `renefichtmueller/claude-sync` if**: you want multiple sync backends
(iCloud, Dropbox, Syncthing) without a self-hosted git repo.

**Pick `zircote/.claude` if**: you want a curated agent library more than a
sync framework.

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

The [`examples/`](./examples) folder has working agents and commands ready
to copy in:

- `code-reviewer` — focused diff review
- `git-helper` — branch/commit/PR conventions enforced
- `test-runner` — locate and run the right tests for a change
- `/new-project` — scaffold a GitHub repo with CLAUDE.md
- `/save` — sync memory and push everything
- `/commit` — propose a conventional commit message from staged diff
- `/sync` — `git pull` across all your project repos in one go

## FAQ

See [docs/faq.md](./docs/faq.md). Highlights:

- **Will this break Claude Code?** No, symlinks are transparent.
- **Public or private repo?** Private if you sync `memory/`; otherwise public is fine.
- **What about Linux / WSL?** Should work — only standard Unix tools used.
- **How do I undo?** `bootstrap.sh` backs up everything first; restore the backup.
- **What if I want auto-sync on every session?** See [docs/auto-sync.md](./docs/auto-sync.md).

## Status

Built for Claude Code (CLI, desktop app, IDE extensions). Tested on
macOS 14+. PRs welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

[MIT](./LICENSE)
