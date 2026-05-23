#!/usr/bin/env bash
# bootstrap.sh — Activate this claude-portable repo into ~/.claude/
#
# What it does:
#   1. Backs up your existing ~/.claude/ to ~/.claude.bak.<timestamp>
#   2. Preserves account/machine-bound files (credentials, sessions, etc.)
#   3. Symlinks portable items from this repo into ~/.claude/
#
# Usage:
#   ./bootstrap.sh             # Activate
#   ./bootstrap.sh --dry-run   # Show what would happen, change nothing
#   ./bootstrap.sh --help      # Show this help
#
# Idempotent: safe to re-run.

set -euo pipefail

# -----------------------------------------------------------------------------
# Args & help
# -----------------------------------------------------------------------------
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --help|-h)
      awk '/^# / { sub(/^# ?/, ""); print; next } /^#$/ { print ""; next } /^[^#]/ { exit }' "$0" | tail -n +2
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Run with --help for usage." >&2
      exit 2
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Config
# -----------------------------------------------------------------------------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# Items to symlink from repo → ~/.claude/
LINK_ITEMS=(
  "CLAUDE.md"
  "settings.json"
  "agents"
  "skills"
  "commands"
  "keybindings.json"
)

# Items that MUST stay on the machine (never linked from repo)
PRESERVE_ITEMS=(
  ".credentials.json"
  "policy-limits.json"
  "telemetry"
  "sessions"
  "shell-snapshots"
  "session-env"
  "projects"
  "backups"
  "plans"
  "todos"
  "statsig"
  ".last-cleanup"
  "settings.local.json"
  "CLAUDE.local.md"
)

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "    [dry-run] $*"
  else
    "$@"
  fi
}

log()  { echo "==> $*"; }
warn() { echo "    ⚠️  $*" >&2; }
info() { echo "    $*"; }

# -----------------------------------------------------------------------------
# Sanity checks
# -----------------------------------------------------------------------------
if [ "$REPO_DIR" = "$CLAUDE_DIR" ]; then
  echo "Error: repo and target are the same path. Move the repo elsewhere." >&2
  exit 1
fi

log "claude-portable bootstrap"
info "Repo:   $REPO_DIR"
info "Target: $CLAUDE_DIR"
[ "$DRY_RUN" = 1 ] && info "(dry run — no changes will be made)"
echo

# -----------------------------------------------------------------------------
# Step 1: Back up existing ~/.claude/
# -----------------------------------------------------------------------------
BACKUP_DIR=""
if [ -d "$CLAUDE_DIR" ] && [ -n "$(ls -A "$CLAUDE_DIR" 2>/dev/null)" ]; then
  BACKUP_DIR="$HOME/.claude.bak.$TIMESTAMP"
  log "Backing up existing config → $BACKUP_DIR"
  run cp -R "$CLAUDE_DIR" "$BACKUP_DIR"
fi

run mkdir -p "$CLAUDE_DIR"

# -----------------------------------------------------------------------------
# Step 2: Restore preserved items from backup
# -----------------------------------------------------------------------------
if [ -n "$BACKUP_DIR" ]; then
  log "Preserving machine/account-bound items"
  for item in "${PRESERVE_ITEMS[@]}"; do
    if [ -e "$BACKUP_DIR/$item" ] && [ ! -e "$CLAUDE_DIR/$item" ]; then
      run cp -R "$BACKUP_DIR/$item" "$CLAUDE_DIR/$item"
      info "kept $item"
    fi
  done
fi

# -----------------------------------------------------------------------------
# Step 3: Create symlinks
# -----------------------------------------------------------------------------
log "Creating symlinks"
linked=0
for item in "${LINK_ITEMS[@]}"; do
  src="$REPO_DIR/$item"
  dst="$CLAUDE_DIR/$item"

  if [ ! -e "$src" ]; then
    info "skip $item (not in repo)"
    continue
  fi

  if [ -L "$dst" ] || [ -e "$dst" ]; then
    run rm -rf "$dst"
  fi

  run ln -s "$src" "$dst"
  info "linked $item"
  linked=$((linked + 1))
done

echo
log "Done ✅  ($linked items linked)"

if [ -n "$BACKUP_DIR" ]; then
  echo
  info "Original config backed up at: $BACKUP_DIR"
  info "Once you've confirmed things work, you can delete it."
fi

cat <<EOF

Next steps:
  1. Restart Claude Code so it loads the new config
  2. Edit CLAUDE.md to add your personal preferences, then commit & push
  3. (Optional) ./restore-memory.sh to bring auto-memory back from the repo
  4. (Optional) ./doctor.sh to verify everything is wired correctly
EOF
