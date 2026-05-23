#!/usr/bin/env bash
# doctor.sh — Verify your claude-portable installation is wired up correctly
#
# Checks:
#   - ~/.claude/ exists
#   - Expected items are symlinks to this repo
#   - Symlinks point to existing files
#   - Required tools are installed
#   - Sensitive files are NOT inside the repo
#
# Exit 0 if healthy, 1 otherwise.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"

PASS=0
FAIL=0
WARN=0

ok()   { echo "  ✓ $*"; PASS=$((PASS + 1)); }
bad()  { echo "  ✗ $*"; FAIL=$((FAIL + 1)); }
warn() { echo "  ! $*"; WARN=$((WARN + 1)); }

section() { echo; echo "── $* ──"; }

# -----------------------------------------------------------------------------
section "Environment"
# -----------------------------------------------------------------------------
if [ -d "$CLAUDE_DIR" ]; then
  ok "$CLAUDE_DIR exists"
else
  bad "$CLAUDE_DIR not found (run bootstrap.sh first)"
fi

for tool in git rsync; do
  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool installed"
  else
    bad "$tool not installed"
  fi
done

if command -v gh >/dev/null 2>&1; then
  ok "gh (GitHub CLI) installed"
else
  warn "gh not installed (optional, useful for creating GitHub repos)"
fi

# -----------------------------------------------------------------------------
section "Symlinks"
# -----------------------------------------------------------------------------
LINK_ITEMS=(CLAUDE.md settings.json agents skills commands)
for item in "${LINK_ITEMS[@]}"; do
  dst="$CLAUDE_DIR/$item"
  src="$REPO_DIR/$item"

  if [ ! -e "$src" ]; then
    warn "$item: not in repo (skipping)"
    continue
  fi

  if [ ! -L "$dst" ]; then
    if [ -e "$dst" ]; then
      bad "$item: exists but is NOT a symlink ($dst)"
    else
      bad "$item: missing ($dst)"
    fi
    continue
  fi

  target="$(readlink "$dst")"
  if [ "$target" = "$src" ]; then
    ok "$item → $target"
  else
    bad "$item points to $target (expected $src)"
  fi
done

# -----------------------------------------------------------------------------
section "Safety: no secrets in repo"
# -----------------------------------------------------------------------------
SENSITIVE=(.credentials.json policy-limits.json sessions shell-snapshots)
for item in "${SENSITIVE[@]}"; do
  if [ -e "$REPO_DIR/$item" ]; then
    bad "$item is inside the repo — should be gitignored & local-only"
  else
    ok "$item not in repo"
  fi
done

if [ -d "$REPO_DIR/.git" ]; then
  # Check that nothing dangerous is tracked
  tracked_bad=$(cd "$REPO_DIR" && git ls-files | grep -E '(\.credentials\.json|policy-limits\.json|sessions/|shell-snapshots/)' || true)
  if [ -n "$tracked_bad" ]; then
    bad "Sensitive paths are tracked in git:"
    echo "$tracked_bad" | sed 's/^/      /'
  else
    ok "Nothing sensitive is tracked in git"
  fi
fi

# -----------------------------------------------------------------------------
section "Summary"
# -----------------------------------------------------------------------------
echo "  $PASS passed, $FAIL failed, $WARN warning(s)"
echo

if [ $FAIL -gt 0 ]; then
  echo "❌ Issues found. Run ./bootstrap.sh to fix link issues."
  exit 1
else
  echo "✅ Healthy."
  exit 0
fi
