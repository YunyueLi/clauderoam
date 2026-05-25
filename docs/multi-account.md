# Switching Claude accounts

You'll need to switch accounts at some point — joining a Team plan, moving from personal to work, leaving an organization, getting a contractor account. Here's how to do it without losing your setup.

## What survives an account switch

Everything in your `clauderoam` repo:

- `CLAUDE.md` (your preferences)
- `settings.json` · `keybindings.json`
- `agents/` · `skills/` · `commands/`
- `memory/` (snapshotted auto-memory)

The symlinks in `~/.claude/` themselves survive too — they point at repo files on disk, not at account state.

## What you lose (and there's no fix)

- Conversation history on claude.ai/code (account-bound, lives on Anthropic's servers)
- Connector authorizations — reconnect GitHub etc. on the new account
- Account-specific usage / billing data

## What gets replaced (correctly)

- `~/.claude/.credentials.json` — overwritten when you sign in with the new account. This is correct behavior; you don't want the old account's token.

## Migration checklist

```bash
# 1. Before signing out of the old account: snapshot and push
clauderoam push     # sync + commit + push

# 2. Sign out and back in on Claude Code with the new account
#    (Desktop app: Settings → Account → Sign out)

# 3. Verify everything still works
clauderoam doctor

# 4. Reconnect GitHub Connector
#    claude.ai/code → Connectors → GitHub → Authorize

# 5. (Optional) Restore memory if it got cleared
clauderoam restore
```

## Why this matters

Without clauderoam, switching accounts means losing every customization you've built up — your `CLAUDE.md`, your agents, your slash commands, your remembered facts. With clauderoam, that surface area is just "files in a git repo." Accounts become interchangeable.
