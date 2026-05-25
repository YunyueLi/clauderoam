# X / Twitter thread

7 tweets. Lead with the GIF. Attach `.assets/hero.gif` to tweet 1.

## Thread

**Tweet 1** (with `.assets/hero.gif` attached)

```
Your Claude Code config — agents, slash commands, memory — lives on one Mac. Switch machines or switch Claude accounts, you lose it all.

I built ClaudeRoam to fix that.

brew install YunyueLi/tap/clauderoam ↓
```

**Tweet 2**

```
The model is dotfiles, specialized for Claude Code:

• git repo holds the portable bits (CLAUDE.md, agents, commands, memory)
• symlinks back into ~/.claude/
• Claude Code reads them as usual — symlinks are transparent

So your config "follows you" instead of being tied to one machine.
```

**Tweet 3**

```
The trick most "sync ~/.claude" tools miss: Claude account switches.

When you change accounts, your credentials file gets replaced — that's correct. But all your customization survives because it's in your own git repo, not Anthropic's servers.

This was the original itch.
```

**Tweet 4**

```
Auto-memory is folder-tree, not a single file, so it can't symlink cleanly.

`clauderoam sync` snapshots it.
`clauderoam restore` brings it back — and rewrites the username portion of the paths when you move to a Mac with a different $USER.

Small detail; matters a lot.
```

**Tweet 5**

```
And because "cross-device" was the original need, there's a project registry:

clauderoam projects add        # register a repo
clauderoam projects clone-all  # new Mac, one command pulls every project

3 lines on a new Mac and you're working again.
```

**Tweet 6**

```
Other choices worth knowing about:

• renefichtmueller/claude-sync — multiple backends (iCloud, Dropbox, Syncthing)
• balingsisi/claude-sync-tool — watch mode
• zircote/.claude — 100+ curated agents

ClaudeRoam's wedge: account-switching focus, 中文 docs, zero deps.
```

**Tweet 7**

```
Install:
  brew install YunyueLi/tap/clauderoam
  clauderoam init

Or curl|bash:
  https://github.com/YunyueLi/clauderoam#install

MIT, ~500 lines of pure bash. Issues + PRs welcome.

https://github.com/YunyueLi/clauderoam
```

## After posting

- Pin the thread on your profile
- Quote-tweet it 24h later with any reactions / metrics
- Reply to questions in the thread, not in DMs — it grows the conversation
