# Auto-sync (optional)

By default, claude-portable doesn't auto-sync — you decide when to `make push`.
But if you'd rather have it just happen, this page shows two zero-friction
options.

## Option A: Shell wrapper around `claude`

Add this to `~/.zshrc` (or `~/.bashrc`):

```bash
# Wraps the `claude` CLI: pull before, push after
claude() {
  local repo="$HOME/claude-portable"   # adjust path if needed
  if [ -d "$repo/.git" ]; then
    ( cd "$repo" && git pull --quiet --ff-only 2>/dev/null ) || true
  fi
  command claude "$@"
  local exit_code=$?
  if [ -d "$repo/.git" ]; then
    (
      cd "$repo"
      ./sync-memory.sh >/dev/null 2>&1 || true
      if ! git diff --quiet || ! git diff --cached --quiet; then
        git add -A
        git commit -m "auto: sync $(date +%Y-%m-%d_%H:%M)" --quiet
        git push --quiet 2>/dev/null || true
      fi
    ) &
  fi
  return $exit_code
}
```

**What it does**:
- Before launching `claude`: `git pull` the latest from your remote
- After `claude` exits: snapshot memory, commit any changes, push to remote (in background, doesn't block your prompt)

**Caveats**:
- If you run `claude` 10 times an hour, you'll get 10 commits an hour. Use
  `make push` manually instead if you prefer fewer, meaningful commits.
- The background push silences errors. If you suspect it's failing, run
  `make push` to see the real error.

## Option B: macOS LaunchAgent (every N minutes)

Create `~/Library/LaunchAgents/com.user.claude-portable.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.claude-portable</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>-c</string>
      <string>cd "$HOME/claude-portable" &amp;&amp; ./sync-memory.sh &amp;&amp; git add -A &amp;&amp; (git diff --cached --quiet || git commit -m "auto: $(date +%F_%H:%M)") &amp;&amp; git push</string>
    </array>
    <key>StartInterval</key>
    <integer>1800</integer>  <!-- every 30 minutes -->
    <key>StandardOutPath</key>
    <string>/tmp/claude-portable.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/claude-portable.err</string>
  </dict>
</plist>
```

Load it:

```bash
launchctl load ~/Library/LaunchAgents/com.user.claude-portable.plist
```

Disable:

```bash
launchctl unload ~/Library/LaunchAgents/com.user.claude-portable.plist
```

## Option C: don't auto-sync

Honestly fine. Run `make push` at the end of a work session. Two-second habit.
