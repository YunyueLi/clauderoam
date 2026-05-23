---
description: Sync auto-memory, commit, and push your clauderoam repo. Use when you want to save your current Claude Code config to GitHub so other devices can pick it up.
---

Run `clauderoam push` from the user's clauderoam repo.

1. Locate the repo:
   ```bash
   # The symlink target tells us where the repo lives
   readlink ~/.claude/CLAUDE.md   # → /path/to/clauderoam/CLAUDE.md
   ```

2. Run the push command (it does sync + commit + push in one):
   ```bash
   cd "$(dirname "$(dirname "$(readlink ~/.claude/CLAUDE.md)")")"
   ./clauderoam push
   ```

3. Report the resulting commit SHA in one line.

If `clauderoam push` reports "Nothing to commit," tell the user that everything is already up to date.
