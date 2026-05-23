#!/usr/bin/env bash
# sync-memory.sh — Snapshot Claude Code's per-project auto-memory into this repo
#
# Auto-memory lives at ~/.claude/projects/<encoded-path>/memory/.
# This script copies all non-empty memory directories into ./memory/ so they
# can be version-controlled and restored on a new machine/account.
#
# Usage: ./sync-memory.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_BASE="${CLAUDE_HOME:-$HOME/.claude}/projects"
DST_BASE="$REPO_DIR/memory"

if [ ! -d "$SRC_BASE" ]; then
  echo "==> $SRC_BASE not found — nothing to sync"
  exit 0
fi

mkdir -p "$DST_BASE"

echo "==> Syncing auto-memory → repo"
count=0
for proj_dir in "$SRC_BASE"/*/; do
  [ -d "$proj_dir" ] || continue
  memory_dir="$proj_dir/memory"
  [ -d "$memory_dir" ] || continue
  [ -n "$(ls -A "$memory_dir" 2>/dev/null)" ] || continue

  proj_name="$(basename "$proj_dir")"
  dst="$DST_BASE/$proj_name"
  mkdir -p "$dst"

  rsync -a --delete "$memory_dir/" "$dst/"
  echo "    $proj_name"
  count=$((count + 1))
done

echo
echo "==> Synced $count project(s)"
[ "$count" -gt 0 ] && echo "Next: git add memory && git commit -m 'sync memory' && git push"
