---
description: Sync auto-memory, commit all changes in claude-portable, and push to GitHub.
---

The user wants to save their current Claude Code config (preferences, agents,
commands, memory) to GitHub so other devices can pick it up.

Run these steps in order. If any step fails, stop and report the error.

1. Go to the claude-portable repo:
   ```bash
   cd ~/claude-portable  # or wherever the repo lives
   ```
   (If the user isn't sure where it is, look for the path that `~/.claude/CLAUDE.md`
   resolves to — `readlink ~/.claude/CLAUDE.md`.)

2. Snapshot auto-memory:
   ```bash
   ./sync-memory.sh
   ```

3. Show what changed:
   ```bash
   git status --short
   git diff --stat
   ```

4. If there's nothing to commit, say so and stop.

5. Otherwise, ask the user for a short commit message (or propose one based on
   the diff), then:
   ```bash
   git add .
   git commit -m "<message>"
   git push
   ```

6. Confirm done with one line including the commit SHA.
