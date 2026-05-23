# Setup

## Prerequisites

- macOS or Linux (Windows via WSL should work but isn't tested)
- `git`, `rsync`, `bash` (all standard)
- Optional but recommended: [`gh`](https://cli.github.com/) for GitHub
  operations

## First-time install

```bash
# 1. Fork this repo on GitHub (so you have your own copy to push to).
#    On GitHub, click "Use this template" or "Fork".

# 2. Clone your fork
git clone git@github.com:<your-username>/claude-portable.git ~/claude-portable
cd ~/claude-portable

# 3. Personalize CLAUDE.md
#    Edit it with your name, language preference, workflow conventions.
$EDITOR CLAUDE.md

# 4. Activate (this symlinks into ~/.claude/)
./bootstrap.sh

# 5. Verify
./doctor.sh

# 6. Commit your personalized CLAUDE.md
git add CLAUDE.md
git commit -m "chore: personalize CLAUDE.md"
git push
```

## What `bootstrap.sh` actually does

It does **not** delete anything irreversibly. The flow:

1. Copies the entire existing `~/.claude/` to `~/.claude.bak.<timestamp>` (only
   if it had content)
2. Creates a fresh `~/.claude/` directory
3. Copies back machine/account-bound files (credentials, sessions, telemetry,
   etc.) from the backup
4. Symlinks the portable items (`CLAUDE.md`, `settings.json`, `agents/`,
   `skills/`, `commands/`) from this repo

Once you've verified things work, you can delete the backup:
```bash
rm -rf ~/.claude.bak.*
```

## Day-to-day commands

```bash
make help       # show all
make bootstrap  # (re)activate symlinks
make doctor     # verify health
make sync       # snapshot auto-memory into ./memory/
make push       # sync + commit + push
make status     # show repo + symlink state
```

## Uninstall

To go back to a vanilla setup:

```bash
# 1. Remove symlinks
rm ~/.claude/CLAUDE.md ~/.claude/settings.json
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands

# 2. (Optional) restore your pre-install backup
mv ~/.claude.bak.<timestamp>/* ~/.claude/
```
