---
description: Pull latest changes across all your project repos in one place — your code, your claude-portable config, anywhere else you point this at.
---

The user is starting a session (often on a new device, or after time away)
and wants to make sure everything is up to date before working.

## Process

1. Find which repos to sync. Ask the user if they have a list, or look in
   `~/Desktop`, `~/projects`, `~/code` for `.git` directories:
   ```bash
   find ~/Desktop ~/projects ~/code -maxdepth 3 -name .git -type d 2>/dev/null | sed 's|/.git$||'
   ```

2. For each repo found, in parallel where safe:
   ```bash
   cd "<repo>"
   git fetch --all --quiet
   # Only fast-forward if there are no local changes
   if git diff --quiet && git diff --cached --quiet; then
     git pull --ff-only --quiet
   fi
   ```

3. Report a one-line summary per repo:
   - `✅ <repo>: up to date`
   - `⬇️  <repo>: pulled N commits`
   - `⚠️  <repo>: has local changes, skipped pull`
   - `❌ <repo>: error (<short reason>)`

4. **Always include `~/claude-portable`** in the sync (or wherever the user's
   claude-portable repo lives — check `readlink ~/.claude/CLAUDE.md`).

5. At the end, if any repo was skipped due to local changes, suggest
   `cd <repo> && git status` so the user can deal with them.
