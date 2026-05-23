# FAQ

### Why symlinks instead of copying files?

So that editing `~/.claude/CLAUDE.md` and editing the repo file are the same
action. No "did I forget to sync" question — there's only one copy.

### Will this break Claude Code?

No. Claude Code reads `~/.claude/CLAUDE.md` etc. regardless of whether it's a
real file or a symlink. The only thing `bootstrap.sh` changes is how those
files are stored.

### Should the repo be public or private?

**Private** is the safer default — `memory/` may contain notes about projects
you'd rather not share. If you keep memory out (or scrub it), public is fine
and lets you show off your setup.

### What about `~/.claude/projects/` and `~/.claude/sessions/`?

These are *runtime* state — conversation logs, shell snapshots, telemetry.
They're huge, machine-specific, and have no value on another device. They're
in `.gitignore` and `bootstrap.sh` keeps them local-only.

### Does `bootstrap.sh` delete my existing config?

No. It backs up `~/.claude/` to `~/.claude.bak.<timestamp>` before changing
anything. You can always restore it.

### Can I have machine-specific overrides?

Yes:
- `~/.claude/settings.local.json` — machine-only settings (gitignored)
- `~/.claude/CLAUDE.local.md` — machine-only preferences (gitignored)

Both files are loaded by Claude Code in addition to the shared versions.

### How is this different from dotfiles?

It is dotfiles, specialized for Claude Code. The same pattern (symlink from a
git repo) used for `.zshrc`, `.vimrc`, etc.

### Why not just use Claude's cloud memory feature?

The cloud memory (the one on claude.ai) is account-bound and not exportable.
This repo gives you a version-controlled, portable, account-independent
alternative. Use both if you want.

### Does this work with the Claude Code CLI, desktop app, and IDE extensions?

Yes — they all read the same `~/.claude/` directory.

### What if I'm not on macOS?

The scripts use `bash`, `rsync`, `cp`, `ln` — should work on any Unix-like
system (Linux, WSL). The only macOS-specific behavior is none.

### How do I undo everything?

```bash
rm ~/.claude/CLAUDE.md ~/.claude/settings.json
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands

# Restore your pre-install backup
mv ~/.claude.bak.<timestamp>/* ~/.claude/
```
