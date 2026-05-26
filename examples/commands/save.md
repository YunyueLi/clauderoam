---
description: Sync auto-memory, commit, and push your ClaudeRoam config repo. Use when you want to save your current Claude Code config to GitHub so other devices can pick it up.
---

Run `clauderoam push`. It does sync + commit + push in one shot, resolving the data repo automatically (via `$CLAUDEROAM_DATA` or the default `~/clauderoam`).

Then report the resulting commit SHA in one line.

If the output contains "Nothing to commit", tell the user everything is already up to date.
