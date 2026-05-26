# Setup

## Prerequisites

### System

- macOS or Linux (Windows via WSL should work; not actively tested)
- Standard tools: `bash`, `git`, `rsync`

### GitHub access (REQUIRED for cloning your private config repo)

On a brand-new machine you almost certainly need to set up SSH access to GitHub before `clauderoam init` can clone your config repo. Symptom if you skip this:

```
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```

#### Recommended path: use `gh` CLI

```bash
brew install gh
gh auth login
```

When `gh auth login` asks _"Upload your SSH public key to your GitHub account?"_, **select "Add an SSH key"** (NOT "Skip", which is the default cursor position). `gh` will then generate a key, upload it to GitHub, and configure git to use SSH — all in one step.

#### Manual path (if you skipped the SSH key step or already authenticated)

```bash
# Generate a new key (no passphrase — convenient but the key is unprotected)
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519 -N ""

# Upload to GitHub via gh
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)"

# Confirm — answer "yes" to the host-trust prompt
ssh -T git@github.com
# Expected: "Hi <your-github-username>! You've successfully authenticated..."
```

### Git identity

If you've never used git on this machine:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## First-time install

```bash
git clone https://github.com/<you>/ClaudeRoam.git ~/clauderoam
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
clauderoam doctor
```

Reports symlink health, missing tools, and whether any sensitive files
accidentally ended up in the repo.

<p align="center">
  <img src="../.assets/doctor.gif" alt="clauderoam doctor output" width="800">
</p>

## What gets symlinked

The portable subset of `~/.claude/`:

- `CLAUDE.md` · `settings.json` · `keybindings.json`
- `agents/` · `skills/` · `commands/`

Everything else (`.credentials.json`, `sessions/`, `shell-snapshots/`,
`telemetry/`, …) stays machine-local and untouched.

## What `install` actually does

`clauderoam install` (called automatically by `init`) is safe to re-run:

1. Backs up your current `~/.claude/` to `~/.claude.bak.<timestamp>` if it
   has content
2. Preserves machine-local files (credentials, sessions, etc.) by copying
   them back from the backup
3. Symlinks the portable items from this repo into `~/.claude/`

Use `--dry-run` to preview without making changes:

```bash
clauderoam install --dry-run
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

## Putting `clauderoam` on your PATH (git-clone install only)

If you installed via `brew install` or the `curl | bash` installer, `clauderoam` is already on your `PATH` — skip this section.

If you cloned the source directly and want to run `clauderoam` from any directory, symlink the script into a PATH dir:

```bash
mkdir -p ~/.local/bin
ln -s ~/clauderoam/clauderoam ~/.local/bin/clauderoam

# Then anywhere:
clauderoam doctor
clauderoam push
```

Make sure `~/.local/bin` is on your `PATH` (add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` if not).
