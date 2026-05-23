---
description: Propose a conventional-commit message from the currently staged diff, then commit.
---

The user wants to commit what's currently staged. Help them craft a good
message and commit.

1. Show what's about to be committed:
   ```bash
   git diff --cached --stat
   ```

2. If nothing is staged, run `git status` and ask which files to stage.

3. Read the actual diff:
   ```bash
   git diff --cached
   ```

4. Propose a commit message:
   - Format: `<type>(<scope>): <subject>` where type ∈
     {feat, fix, chore, docs, refactor, test, perf, style, build, ci}
   - Subject: imperative, under 70 chars
   - If the change is multi-faceted, add a body with bullet points

5. Show the proposed message to the user and ask "looks good?" — wait for
   confirmation. Don't commit without it.

6. On approval:
   ```bash
   git commit -m "<message>"
   ```
   (Use a heredoc if the message has multiple lines.)

7. Show the resulting `git log -1 --oneline` so they see the new commit.
