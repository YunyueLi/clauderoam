# Auto-sync (optional)

By default, clauderoam doesn't auto-sync — you choose when to `clauderoam push`. If you want it hands-off, here are two patterns.

## Option A: shell wrapper around `claude`

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
# Pull before each Claude Code session; push after.
claude() {
  local repo="${CLAUDEROAM_DATA:-$HOME/clauderoam}"
  [ -d "$repo/.git" ] && ( cd "$repo" && git pull --quiet --ff-only ) 2>/dev/null || true

  command claude "$@"
  local code=$?

  if [ -d "$repo/.git" ] && command -v clauderoam >/dev/null; then
    ( clauderoam push >/dev/null 2>&1 ) &
  fi
  return $code
}
```

**Trade-off**: every `claude` invocation creates a commit if anything changed. If that's too noisy, skip it and run `clauderoam push` manually at the end of a session.

## Option B: macOS LaunchAgent (cron-like, every 30 min)

LaunchAgents don't inherit your shell `PATH`, so we need to point at `clauderoam` explicitly. The block below detects the right path at install time.

### One-command install

Paste this whole block into your terminal:

```bash
CLAUDEROAM_BIN="$(command -v clauderoam)"
if [ -z "$CLAUDEROAM_BIN" ]; then
  echo "clauderoam not on PATH — install it first" >&2
  exit 1
fi

PLIST="$HOME/Library/LaunchAgents/com.user.clauderoam.plist"
mkdir -p "$(dirname "$PLIST")"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.clauderoam</string>
    <key>ProgramArguments</key>
    <array>
      <string>$CLAUDEROAM_BIN</string>
      <string>push</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
    <key>StartInterval</key>
    <integer>1800</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/clauderoam.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/clauderoam.err</string>
  </dict>
</plist>
EOF

launchctl unload "$PLIST" 2>/dev/null  # safe if not previously loaded
launchctl load "$PLIST"
echo "✓ installed and loaded"
echo "  Logs: tail -f /tmp/clauderoam.log /tmp/clauderoam.err"
```

### Verify

```bash
launchctl list | grep clauderoam       # should show your job
sleep 3 && cat /tmp/clauderoam.log     # RunAtLoad=true triggers first run immediately
```

### Disable

```bash
launchctl unload ~/Library/LaunchAgents/com.user.clauderoam.plist
rm ~/Library/LaunchAgents/com.user.clauderoam.plist   # optional, removes config too
```

Runs `clauderoam push` every 30 minutes.

## Option C: don't auto-sync

Run `clauderoam push` at the end of a session. Two-second habit, fewer noisy commits.

---

### Why the `PATH` block?

`clauderoam push` internally calls `git`, `rsync`, `gh` and others. LaunchAgents run with a minimal environment that often doesn't include `/opt/homebrew/bin`. The `EnvironmentVariables.PATH` ensures those tools are findable.
