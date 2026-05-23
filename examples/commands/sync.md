---
description: Pull latest changes across all the user's project repos in one place — code, clauderoam config, anywhere else relevant.
---

The user is starting a session (often on a new device, or after time away) and wants everything up to date.

## Process

1. Find candidate repos. Ask if the user has a list, or scan common locations:
   ```bash
   find ~/Desktop ~/projects ~/code -maxdepth 3 -name .git -type d 2>/dev/null | sed 's|/.git$||'
   ```

2. For each repo:
   ```bash
   cd "<repo>"
   git fetch --all --quiet
   if git diff --quiet && git diff --cached --quiet; then
     git pull --ff-only --quiet
   fi
   ```

3. Report one line per repo:
   - `✅ <repo>: up to date`
   - `⬇️  <repo>: pulled N commits`
   - `⚠️  <repo>: has local changes, skipped pull`
   - `❌ <repo>: error (<short reason>)`

4. **Always include the user's clauderoam repo** — find it via `readlink ~/.claude/CLAUDE.md`.

5. If any repo was skipped due to local changes, suggest `cd <repo> && git status` so the user can deal with them.
