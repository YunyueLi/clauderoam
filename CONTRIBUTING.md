# Contributing

Thanks for thinking about contributing! This project is small on purpose —
contributions that keep it that way are the most welcome.

## Ways to help

- **Examples** — useful agents, slash commands, or skills others can copy
- **Docs** — clearer setup instructions, missing FAQ entries, translations
- **Bug fixes** — `bootstrap.sh` / `doctor.sh` / `sync-memory.sh` corner cases
- **Compatibility** — Linux distros, WSL, edge cases on macOS

## Ways to NOT help (please)

- Don't add a config-management framework on top — keep it as shell scripts
- Don't add features that require running a daemon or modifying the shell
- Don't add account-specific or commercial-product-specific logic

## Workflow

1. Fork the repo
2. Create a branch: `git checkout -b feat/your-thing`
3. Make the change. If it touches a script, `./doctor.sh` should still pass.
4. Commit using conventional commits: `feat:`, `fix:`, `docs:`, `chore:`
5. Open a PR with a 1-3 sentence summary and (if it's a script change) a
   description of how you tested it

## Style

- Bash: `set -euo pipefail` at the top of every script
- Markdown: wrap at ~80 chars where reasonable; use sentence case for headings
- Keep messages user-facing-friendly (no jargon, explain what's happening)

## Code of conduct

Be kind. Assume good intent. If you spot a problem, open an issue before
opening a PR for non-trivial changes — discussion first saves time.
