# Auto-sync (optional)

By default, clauderoam doesn't auto-sync — you choose when to `clauderoam push`. If you want it hands-off, here are two patterns.

## Option A: shell wrapper around `claude`

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
# Pull before each Claude Code session; push after.
claude() {
  local repo="$HOME/clauderoam"
  [ -d "$repo/.git" ] && ( cd "$repo" && git pull --quiet --ff-only ) 2>/dev/null || true

  command claude "$@"
  local code=$?

  if [ -d "$repo/.git" ]; then
    (
      cd "$repo"
      ./clauderoam sync >/dev/null 2>&1 || true
      if ! git diff --quiet || ! git diff --cached --quiet; then
        git add -A
        git commit -m "auto: sync $(date +%F_%H:%M)" --quiet
        git push --quiet
      fi
    ) &
  fi
  return $code
}
```

**Trade-off**: every `claude` invocation creates a commit if anything changed. If that's too noisy, skip it and run `clauderoam push` manually at the end of a session.

## Option B: macOS LaunchAgent (cron-like)

Create `~/Library/LaunchAgents/com.user.clauderoam.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.clauderoam</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>-lc</string>
      <string>$HOME/clauderoam/clauderoam push</string>
    </array>
    <key>StartInterval</key>
    <integer>1800</integer>
    <key>StandardOutPath</key>
    <string>/tmp/clauderoam.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/clauderoam.err</string>
  </dict>
</plist>
```

```bash
launchctl load   ~/Library/LaunchAgents/com.user.clauderoam.plist   # enable
launchctl unload ~/Library/LaunchAgents/com.user.clauderoam.plist   # disable
```

Runs `clauderoam push` every 30 minutes.

## Option C: don't auto-sync

Run `clauderoam push` at the end of a session. Two-second habit, fewer noisy commits.
