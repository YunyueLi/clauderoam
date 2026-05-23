---
description: Scaffold a new GitHub repo with CLAUDE.md and .claude/settings.json, ready for cross-device development.
---

The user wants to start a new project. Walk them through these steps:

1. **Ask** for:
   - Project name (kebab-case)
   - One-line description
   - Visibility (public / private)
   - Primary language/framework

2. **Create the repo** locally and on GitHub:
   ```bash
   mkdir -p ~/Desktop/<project-name>
   cd ~/Desktop/<project-name>
   git init -b main
   gh repo create <project-name> --<public|private> --source=. --description "..."
   ```

3. **Scaffold required files**:
   - `README.md` — project description, quick start
   - `.gitignore` — appropriate for the language
   - `CLAUDE.md` — project conventions:
     ```markdown
     # <project-name>

     ## Tech stack
     - <language/framework>

     ## Commands
     - dev: ...
     - test: ...
     - build: ...

     ## Conventions
     - Commit format: conventional commits
     - Branch naming: <name>/<short-description>
     ```
   - `.claude/settings.json` — project-specific permissions

4. **First commit & push**:
   ```bash
   git add .
   git commit -m "chore: initial project setup"
   git push -u origin main
   ```

5. **Suggest next steps**:
   - Install Claude GitHub App on the repo: <https://github.com/apps/claude>
   - On iPhone: use the GitHub app to `@claude` in issues for remote tasks
