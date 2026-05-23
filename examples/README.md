# Examples

Working examples you can copy into the active folders (`agents/`, `commands/`,
`skills/`) to start using right away.

| Type | File | What it does |
|---|---|---|
| Agent | `agents/code-reviewer.md` | Reviews the current diff for bugs and style issues |
| Command | `commands/new-project.md` | `/new-project` scaffolds a new GitHub repo with CLAUDE.md |
| Command | `commands/save.md` | `/save` commits and pushes the current claude-portable changes |

## How to install an example

```bash
# Copy into the live folder
cp examples/agents/code-reviewer.md agents/

# Commit so it syncs to all your devices
git add agents/code-reviewer.md
git commit -m "feat: add code-reviewer agent"
git push
```

## Writing your own

- **Agents** — see <https://docs.claude.com/en/docs/claude-code/sub-agents>
- **Skills** — see <https://docs.claude.com/en/docs/claude-code/skills>
- **Commands** — any markdown file in `commands/` becomes a `/slash-command`
