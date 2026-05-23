---
description: Open a pull request for the current branch, with a well-structured title and body.
---

The user wants to turn the current branch into a PR.

1. **Verify ready**:
   ```bash
   git status --short              # working tree clean?
   git branch --show-current       # not on main/master?
   git log main..HEAD --oneline    # what's actually in this PR?
   ```
   If working tree has uncommitted changes, ask whether to commit first.
   If on main/master, stop and tell the user.

2. **Push if needed**:
   ```bash
   git push -u origin HEAD
   ```

3. **Draft the PR title** — under 70 chars, imperative, no period at the
   end. Format: `<type>: <summary>` matching the conventional-commit convention
   from `CLAUDE.md`.

4. **Draft the PR body** with this structure:
   ```markdown
   ## Summary
   - <1-3 bullet points on what changed and why>

   ## Test plan
   - [ ] <how to verify the change>
   - [ ] <edge case tested>
   ```

5. **Show title + body to the user** and ask "looks good?"

6. **On approval**:
   ```bash
   gh pr create --title "<title>" --body "$(cat <<'EOF'
   <body>
   EOF
   )"
   ```

7. **Return the PR URL** so the user can click through.
