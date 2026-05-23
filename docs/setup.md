# Setup

## Prerequisites

- macOS or Linux (Windows via WSL should work; not actively tested)
- Standard tools: `bash`, `git`, `rsync`
- Optional: [`gh`](https://cli.github.com/) for GitHub operations

## First-time install

```bash
git clone https://github.com/<you>/clauderoam.git ~/clauderoam
cd ~/clauderoam
./clauderoam init
```

`init` asks for your name and preferred response language, writes a
personalized `CLAUDE.md`, and creates the symlinks into `~/.claude/` in one
shot. Restart Claude Code and your config is live.

Commit your personalized `CLAUDE.md` to sync it to all your devices:

```bash
git add CLAUDE.md
git commit -m "chore: personalize CLAUDE.md"
git push
```

## Verify

```bash
./clauderoam doctor
```

Reports symlink health, missing tools, and whether any sensitive files
accidentally ended up in the repo.

## What gets symlinked

The portable subset of `~/.claude/`:

- `CLAUDE.md` · `settings.json` · `keybindings.json`
- `agents/` · `skills/` · `commands/`

Everything else (`.credentials.json`, `sessions/`, `shell-snapshots/`,
`telemetry/`, …) stays machine-local and untouched.

## What `install` actually does

`./clauderoam install` (called automatically by `init`) is safe to re-run:

1. Backs up your current `~/.claude/` to `~/.claude.bak.<timestamp>` if it
   has content
2. Preserves machine-local files (credentials, sessions, etc.) by copying
   them back from the backup
3. Symlinks the portable items from this repo into `~/.claude/`

Use `--dry-run` to preview without making changes:

```bash
./clauderoam install --dry-run
```

## Machine-local overrides

Two files are ignored by git, so they stay on the local machine only:

- `~/.claude/settings.local.json` — settings unique to this Mac
- `~/.claude/CLAUDE.local.md` — preferences unique to this Mac

Both are loaded **in addition to** the shared versions.

## Uninstall

```bash
# Remove the symlinks
rm ~/.claude/CLAUDE.md ~/.claude/settings.json ~/.claude/keybindings.json
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands

# Restore your pre-install backup
mv ~/.claude.bak.<timestamp>/* ~/.claude/
```

## Putting `clauderoam` on your PATH (optional)

So you can run it from anywhere:

```bash
ln -s ~/clauderoam/clauderoam ~/.local/bin/clauderoam   # any dir on your PATH
# then anywhere:
clauderoam doctor
clauderoam push
```
