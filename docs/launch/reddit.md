# Reddit

Best subreddits: **r/ClaudeAI** (primary), **r/commandline**, **r/programming** (cross-post carefully — they downvote low-effort).

## Title

```
I built a small CLI to keep my Claude Code config in sync across Macs (and Claude account switches)
```

> Alternatives:
> - `ClaudeRoam: your Claude Code config in git, survives Mac switches AND Claude account switches`
> - `Tired of losing my Claude Code customization every time I switch Macs — here's what I built`

## Body

```markdown
Hi all,

Quick context: I work across two Macs and recently moved to a different Claude account. Every time, I lost the customization I'd built up — `CLAUDE.md` preferences, custom subagents, slash commands, auto-memory. Either tied to one machine, or wiped when the account changed.

**ClaudeRoam** is a small bash CLI that fixes that:

- The portable subset of `~/.claude/` lives in a git repo. `clauderoam install` symlinks it back, so Claude Code reads it normally.
- `clauderoam sync` snapshots auto-memory; `clauderoam restore` brings it back on a new Mac, rewriting the username portion of paths so it works across different `$USER` values.
- `clauderoam projects` tracks the GitHub repos you want on every machine, so `clauderoam projects clone-all` sets up a new Mac.

The account-switch case is the wedge — most other tools (`renefichtmueller/claude-sync`, `balingsisi/claude-sync-tool`, `elizabethfuentes12/claude-code-dotfiles`) assume one account forever. ClaudeRoam was designed for the day you switch.

### Install

    brew install YunyueLi/tap/clauderoam
    clauderoam init

Or `curl -fsSL https://raw.githubusercontent.com/YunyueLi/ClaudeRoam/main/install.sh | bash`.

### Stack

Pure bash, shellcheck-clean, ~500 lines. CI runs shellcheck + a smoke test on every push.

### Repo + docs

https://github.com/YunyueLi/ClaudeRoam (MIT)

Honest about competitors in the README — see the comparison table.

Happy to answer questions or take feedback. What would you want a tool like this to do that it doesn't?
```

## After posting

- Check back in 1h, 4h, 24h for comments
- If r/programming, expect at least one "isn't this just dotfiles?" comment. Answer: yes, specialized for Claude Code with auto-memory and project-registry handling.
- If r/ClaudeAI, focus replies on "how does Anthropic's stuff change this" — folks there care about that
