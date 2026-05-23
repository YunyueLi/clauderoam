# Switching Claude accounts

Sometimes you need to move to a different Claude account — switching
plans, moving from personal to work, leaving an organization. Here's
what's portable and what isn't.

## What survives an account switch

✅ Everything in your claude-portable repo:
- `CLAUDE.md` (your preferences)
- `settings.json`
- `agents/`, `skills/`, `commands/`
- `memory/` (snapshotted auto-memory)

## What you lose

❌ Account-bound state that lives on Anthropic's servers:
- Conversation history on claude.ai/code (web UI)
- Connector authorizations (you'll need to reconnect GitHub etc.)
- Account-specific usage/billing data

❌ Local credentials:
- `~/.claude/.credentials.json` (gets replaced when the new account signs in)

## Migration checklist

1. **Before logging out of the old account**:
   ```bash
   cd ~/claude-portable
   ./sync-memory.sh   # capture current auto-memory
   git add -A
   git commit -m "chore: pre-account-switch snapshot"
   git push
   ```

2. **Switch accounts** in Claude Code (Mac app: Settings → Account → Sign out,
   then sign in with new account)

3. **Verify symlinks still work**:
   ```bash
   ./doctor.sh
   ```
   The symlinks themselves survive — they point to repo files, not account state.

4. **Reconnect GitHub** in Claude Code Web (claude.ai/code → Connectors)

5. **Optional: restore auto-memory** if it got cleared:
   ```bash
   ./restore-memory.sh
   ```

## Why this matters

Without claude-portable, switching accounts means losing every customization
you've built up — your CLAUDE.md, your agents, your slash commands, your
remembered preferences. With it, that surface area is just "files in a git
repo", and accounts are interchangeable.
