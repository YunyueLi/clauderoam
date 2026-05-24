# FAQ

### Why symlinks instead of copying?

So editing `~/.claude/CLAUDE.md` *is* editing the repo file — there's only one copy. No "did I remember to sync" question.

### Will this break Claude Code?

No. Claude Code reads `~/.claude/CLAUDE.md` and friends the same way whether they're real files or symlinks. The only thing `clauderoam install` changes is how the files are stored.

### Public or private repo?

Private if you sync `memory/` — snapshots can include notes about projects you'd rather not share. If you scrub memory or don't sync it, public is fine and lets you show off your setup.

### What about `~/.claude/projects/` and `~/.claude/sessions/`?

These are *runtime* state — conversation logs, shell snapshots, telemetry. They're huge, machine-specific, and have no value on another device. They're in `.gitignore` and `clauderoam install` keeps them local-only.

### Does `clauderoam install` delete anything?

No. Your existing `~/.claude/` is copied to `~/.claude.bak.<timestamp>` before any changes. Run `--dry-run` first if you want to preview.

### Can I have machine-specific overrides?

Yes:

- `~/.claude/settings.local.json` — settings unique to this machine (gitignored)
- `~/.claude/CLAUDE.local.md` — preferences unique to this machine (gitignored)

Both are loaded **in addition to** the shared versions.

### How is this different from dotfiles?

It *is* dotfiles, specialized for Claude Code. Same pattern (symlink from a git repo) used for `.zshrc`, `.vimrc`, etc.

### Why not just use Claude's cloud memory feature?

The cloud memory on claude.ai is account-bound and not exportable. clauderoam gives you a version-controlled, portable, account-independent alternative. You can use both.

### Does this work with CLI, desktop app, and IDE extensions?

Yes — they all read the same `~/.claude/` directory.

### Does this work with claude.ai/code (the web version)?

**Partially, and not in the way you'd want.**

claude.ai/code spins up a fresh Linux sandbox per project. There's no persistent `~/.claude/` to symlink into, no cross-project user-level config, and `auto` mode isn't available there (only `acceptEdits` and `plan`). So clauderoam's core trick — symlinking your personal config into Claude Code's read path — has no place to land.

The closest workaround: **open your `clauderoam-config` repo in claude.ai/code as the project**. The web version will read that repo's `CLAUDE.md` like any project file, so your preferences are visible for that one session. But it won't carry over to other projects you open next.

**Bottom line:** clauderoam is built for local Claude Code (desktop / CLI / IDE extensions). If your main interface is the web, the gains are smaller and you'll still re-introduce yourself every session.

### Does "cloud workflow" mean I should switch to claude.ai/code?

Not necessarily. "Cloud" can mean two things:

1. **Data and config live in GitHub, not pinned to one Mac.** ← clauderoam solves this. Your customization is in git; any new Mac that runs Claude Code can `clauderoam install` and have your full setup in a minute.
2. **Claude Code runs in a browser, no local install needed.** ← That's claude.ai/code, and it has its own limits (no auto mode, no user-level config, no persistent memory).

For most "I want my Claude Code to follow me" use cases, you actually want meaning #1, with the desktop app on each machine you switch between. That's the supported clauderoam workflow.

For mobile or someone-else's-computer scenarios where local install isn't possible, use the [GitHub @claude bot](https://github.com/apps/claude) for async work via issues and PRs.

### What if I'm not on macOS?

The CLI is bash with standard tools (`git`, `rsync`, `cp`, `ln`). Should work on Linux and WSL. No macOS-specific behavior.

### Is this a portable Claude Code binary?

No — it's portable **config**. For a USB-drive Claude Code distribution, see [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable) or similar projects.

### How do I undo everything?

```bash
rm ~/.claude/CLAUDE.md ~/.claude/settings.json
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands

# Restore your pre-install backup
mv ~/.claude.bak.<timestamp>/* ~/.claude/
```
