#!/usr/bin/env bash
# restore-memory.sh — Restore auto-memory from this repo to ~/.claude/projects/
#
# Run this after bootstrap.sh on a new machine/account.
#
# ⚠️  Project directory names are derived from absolute paths and include the
#    username. When restoring on a machine with a different username, this
#    script rewrites the username portion automatically.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_BASE="$REPO_DIR/memory"
DST_BASE="${CLAUDE_HOME:-$HOME/.claude}/projects"

if [ ! -d "$SRC_BASE" ] || [ -z "$(ls -A "$SRC_BASE" 2>/dev/null)" ]; then
  echo "==> No memory snapshots in repo — nothing to restore"
  exit 0
fi

mkdir -p "$DST_BASE"
CURRENT_PREFIX="-Users-$USER"

echo "==> Restoring auto-memory → $DST_BASE"
echo "    Current user prefix: $CURRENT_PREFIX"
echo

restored=0
skipped=0
for proj_dir in "$SRC_BASE"/*/; do
  [ -d "$proj_dir" ] || continue
  proj_name="$(basename "$proj_dir")"

  # README.md in memory/ is not a project — skip
  if [ "$proj_name" = "README.md" ] || [ "$proj_name" = "memory" ]; then
    continue
  fi

  if [[ "$proj_name" == README* ]] || [[ ! "$proj_name" == -* ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  if [[ "$proj_name" == "$CURRENT_PREFIX"* ]]; then
    new_name="$proj_name"
    echo "    $proj_name"
  elif [[ "$proj_name" == -Users-* ]]; then
    # Rewrite "-Users-<olduser>-..." → "-Users-<currentuser>-..."
    suffix="${proj_name#-Users-}"           # olduser-rest
    suffix="${suffix#*-}"                   # rest
    new_name="$CURRENT_PREFIX-$suffix"
    echo "    🔁 $proj_name → $new_name (rewrote username)"
  else
    echo "    ⚠️  skip $proj_name (unrecognized format)"
    skipped=$((skipped + 1))
    continue
  fi

  dst="$DST_BASE/$new_name/memory"
  mkdir -p "$dst"
  rsync -a "$proj_dir/" "$dst/"
  restored=$((restored + 1))
done

echo
echo "==> Restored $restored project(s)${skipped:+, skipped $skipped}"
