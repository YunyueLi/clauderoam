# Show HN

Submit to: https://news.ycombinator.com/submit

## Title (max 80 chars)

```
Show HN: Clauderoam – Your Claude Code config, anywhere
```

> Alternative if the above feels too generic:
> `Show HN: A small CLI that makes Claude Code config survive Mac switches and account switches`

## URL

```
https://github.com/YunyueLi/clauderoam
```

## Text (optional but recommended for Show HN)

```
Hi HN,

I switch between two Macs and last month moved to a new Claude account. Every time, I lost the Claude Code customization I'd built up — CLAUDE.md preferences, custom subagents, slash commands, auto-memory. Each was tied to one machine and one account.

I wrote clauderoam to fix it. It's a small bash CLI that:

  - Symlinks the portable parts of ~/.claude/ from a git repo, so editing in either place is the same file.
  - Snapshots Claude Code's per-project auto-memory with username rewriting so it survives moves between Macs with different home directories.
  - Tracks a registry of your project repos so a new machine can `clauderoam projects clone-all` and have everything ready.
  - Ships via `brew install YunyueLi/tap/clauderoam` or a curl|bash one-liner with checksum verification.

I looked at existing options first (renefichtmueller/claude-sync, balingsisi/claude-sync-tool, elizabethfuentes12/claude-code-dotfiles). They all assume single account + single device. clauderoam's wedge is the account-switch case and bilingual docs (中文 + EN).

The whole thing is ~500 lines of bash. Pure shell, no daemon, no Python, no Node. shellcheck-clean.

I'd love feedback on: the data/CLI separation model, the projects registry design, anything that feels over-engineered for a dotfiles tool.

Repo: https://github.com/YunyueLi/clauderoam
```

## After posting

- Reply to early comments within the first 30 minutes — HN's algorithm rewards engagement
- Don't ask people to upvote (mods will penalize)
- If someone reports a real bug, fix and tag a new release the same day if possible
