# My Claude Code Preferences

> Symlinked to `~/.claude/CLAUDE.md`. Claude Code loads this on every session start.
> Edit this file, then `git commit && git push` from your claude-portable fork.

<!--
  This is YOUR personal preferences file. Replace the sections below with
  your own info. Anything written here applies to every Claude Code session
  on every machine that runs `bootstrap.sh`.
-->

## About me

- Name: _your name here_
- Preferred language: _e.g., English / 中文 / 日本語_
- Role: _e.g., backend engineer, student, indie hacker_

## Communication style

- Be concise; prefer lists/tables over long paragraphs
- State assumptions explicitly; say "I don't know" when uncertain
- Don't add emojis unless I ask
- No trailing summary section at the end of every reply

## Workflow preferences

- Use **conventional commits** (`feat:`, `fix:`, `chore:` …)
- For any new project, create `CLAUDE.md` and `.claude/settings.json` at the start
- Confirm before destructive ops: `rm -rf`, force push, `reset --hard`, dropping tables
- Prefer editing existing files over creating new ones
- No comments unless they explain WHY (not WHAT)

## Tech stack defaults

<!-- Fill in your preferences. Project-level CLAUDE.md overrides these. -->

- Languages I use most: _e.g., TypeScript, Python, Go_
- Default test runner: _e.g., vitest, pytest, go test_
- Default formatter: _e.g., prettier, ruff, gofmt_

## Cross-device / cross-account conventions

- Project code → always push to GitHub, never local-only
- Personal config → this repo (claude-portable fork)
- Project-specific config → that project's own `CLAUDE.md` + `.claude/`
- Long discussions → claude.ai/code (account-bound; capture important
  outcomes into project CLAUDE.md or auto-memory so they survive an account change)

## Auto-memory rules

- Save: durable preferences, corrections, lessons learned across sessions
- Don't save: ephemeral task state, account-bound info (subscription, billing),
  anything already in project CLAUDE.md or git history
