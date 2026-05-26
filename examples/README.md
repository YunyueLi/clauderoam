# Examples

Working agents and slash commands you can copy into the active folders to
start using right away.

## Agents

| File | What it does |
|---|---|
| [`agents/code-reviewer.md`](./agents/code-reviewer.md) | Reviews the current diff for correctness bugs and style issues |
| [`agents/git-helper.md`](./agents/git-helper.md) | Careful git operations — staging, committing, branching, conflicts |
| [`agents/test-runner.md`](./agents/test-runner.md) | Detects the test framework and runs the right tests for a change |

## Slash commands

| Command | What it does |
|---|---|
| [`/new-project`](./commands/new-project.md) | Scaffold a GitHub repo with CLAUDE.md and `.claude/settings.json` |
| [`/commit`](./commands/commit.md) | Propose a conventional-commit message from staged diff, then commit |
| [`/pr`](./commands/pr.md) | Open a PR for the current branch with a structured title and body |
| [`/sync`](./commands/sync.md) | `git pull` across all your project repos in one go |
| [`/save`](./commands/save.md) | Sync auto-memory and push your ClaudeRoam config repo |

## How to install an example

```bash
# Copy into the live folder (these are symlinked from ~/.claude/ already)
cp examples/agents/git-helper.md agents/
cp examples/commands/commit.md commands/

# Commit so it syncs to all your devices
git add agents/git-helper.md commands/commit.md
git commit -m "feat: add git-helper agent and /commit"
git push
```

Restart Claude Code (or run `/reload` if your version supports it). Then:
- Agents are invoked automatically when their description matches the task
- Slash commands are typed: `/commit`, `/pr`, `/sync`, etc.

## Writing your own

- **Agents** — frontmatter with `name`, `description`, optional `tools`.
  Body is the system prompt. See <https://docs.claude.com/en/docs/claude-code/sub-agents>
- **Skills** — folder with a `SKILL.md` inside. See
  <https://docs.claude.com/en/docs/claude-code/skills>
- **Commands** — markdown file in `commands/`. Filename = command name.
  Frontmatter with `description`. Body is the instructions Claude will follow.
