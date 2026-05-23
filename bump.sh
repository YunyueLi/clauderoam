#!/usr/bin/env bash
# bump.sh — cut a new clauderoam release end-to-end.
#
# Usage:
#   ./bump.sh <new-version>          # e.g. ./bump.sh 0.5.0
#   ./bump.sh <new-version> --dry-run
#
# What it does:
#   1. Validates working tree is clean
#   2. Updates VERSION in clauderoam script + README badges
#   3. Commits the bump
#   4. Tags vX.Y.Z and pushes (tag + main)
#   5. Creates GitHub Release with notes auto-generated from commits
#   6. Generates and uploads checksums.txt as a release asset
#   7. Updates the Homebrew formula (url, sha256, version) and pushes
#
# Required:
#   - Clean working tree in clauderoam repo
#   - $HOMEBREW_TAP_DIR points at the homebrew-tap checkout (default: ~/Desktop/homebrew-tap)
#   - gh CLI authenticated with push access to both repos

set -euo pipefail

# ── Args ────────────────────────────────────────────────────────────────────
DRY_RUN=0
NEW_VERSION=""
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    -h|--help)
      sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) NEW_VERSION="$arg" ;;
  esac
done

if [ -z "$NEW_VERSION" ]; then
  echo "Usage: ./bump.sh <new-version> [--dry-run]" >&2
  exit 2
fi

if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Version must be X.Y.Z" >&2
  exit 2
fi

# ── Config ──────────────────────────────────────────────────────────────────
REPO="YunyueLi/clauderoam"
TAP_REPO="YunyueLi/homebrew-tap"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TAP_DIR="${HOMEBREW_TAP_DIR:-$HOME/Desktop/homebrew-tap}"
TAG="v$NEW_VERSION"

# ── Pretty output ───────────────────────────────────────────────────────────
C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
C_RED=$'\033[31m'; C_GRN=$'\033[32m'; C_YEL=$'\033[33m'; C_BLU=$'\033[34m'
C_RST=$'\033[0m'
step() { printf '\n%s▸%s %s%s\n' "$C_BOLD$C_BLU" "$C_RST" "$C_BOLD" "$*$C_RST"; }
ok()   { printf '  %s✓%s %s\n' "$C_GRN" "$C_RST" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YEL" "$C_RST" "$*" >&2; }
err()  { printf '  %s✗%s %s\n' "$C_RED" "$C_RST" "$*" >&2; }
info() { printf '  %s%s%s\n' "$C_DIM" "$*" "$C_RST"; }

run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '  %s[dry-run]%s %s\n' "$C_DIM" "$C_RST" "$*"
  else
    # Intentional: $@ may contain shell composition (&&, ||, redirects)
    # shellcheck disable=SC2294
    eval "$@"
  fi
}

# ── Pre-flight ──────────────────────────────────────────────────────────────
step "Pre-flight checks"

if [ ! -f "$SCRIPT_DIR/clauderoam" ]; then
  err "Not in a clauderoam repo (no clauderoam script found)"; exit 1
fi
cd "$SCRIPT_DIR"

if [ ! -d "$TAP_DIR" ]; then
  err "Homebrew tap not found at $TAP_DIR"
  info "Set HOMEBREW_TAP_DIR=/path/to/homebrew-tap or check it out there"
  exit 1
fi
ok "Tap at $TAP_DIR"

if [ -n "$(git status --porcelain)" ]; then
  err "Working tree is not clean. Commit or stash first."
  git status --short
  exit 1
fi
ok "Working tree clean"

CURRENT_VERSION="$(grep -E '^readonly VERSION=' clauderoam | sed 's/.*"\(.*\)".*/\1/')"
ok "Current version: $CURRENT_VERSION"
ok "New version: $NEW_VERSION"

if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
  err "Already at version $NEW_VERSION"; exit 1
fi

if git tag --list | grep -qx "$TAG"; then
  err "Tag $TAG already exists"; exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  err "gh CLI not found"; exit 1
fi
ok "gh available"

# ── Bump in clauderoam repo ─────────────────────────────────────────────────
step "Updating VERSION in clauderoam script"
run "sed -i.bak 's/^readonly VERSION=.*/readonly VERSION=\"$NEW_VERSION\"/' clauderoam && rm -f clauderoam.bak"
ok "clauderoam VERSION = $NEW_VERSION"

step "Updating README version badges"
for f in README.md README.zh-CN.md; do
  if [ -f "$f" ]; then
    run "sed -i.bak 's|version-[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+|version-$NEW_VERSION|g' \"$f\" && rm -f \"$f.bak\""
    ok "$f"
  fi
done

step "Committing bump"
run "git add clauderoam README.md README.zh-CN.md 2>/dev/null || true"
run "git commit -m \"chore: bump to v$NEW_VERSION\""
run "git push"

# ── Tag + Release ───────────────────────────────────────────────────────────
step "Tagging $TAG"
SINCE_TAG="$(git describe --tags --abbrev=0 2>/dev/null || echo "")"
if [ -n "$SINCE_TAG" ]; then
  NOTES="$(git log --pretty="- %s" "$SINCE_TAG..HEAD" | grep -v "chore: bump to" || true)"
else
  NOTES="Initial release."
fi
[ -n "$NOTES" ] || NOTES="No notable changes."

run "git tag -a \"$TAG\" -m \"$TAG\""
run "git push origin \"$TAG\""
ok "Tag pushed"

step "Creating GitHub Release"
RELEASE_BODY=$'## Changes\n\n'"$NOTES"$'\n\n## Install\n\n```bash\nbrew install YunyueLi/tap/clauderoam\n```\n\nOr without Homebrew:\n\n```bash\ncurl -fsSL https://raw.githubusercontent.com/'"$REPO"$'/main/install.sh | bash\n```'
if [ "$DRY_RUN" = 1 ]; then
  printf '  %s[dry-run]%s gh release create %s\n' "$C_DIM" "$C_RST" "$TAG"
  info "Release notes preview:"
  printf '%s\n' "$RELEASE_BODY" | sed 's/^/    /'
else
  gh release create "$TAG" --repo "$REPO" --title "$TAG" --notes "$RELEASE_BODY"
  ok "Release published"
fi

# ── Checksums ───────────────────────────────────────────────────────────────
step "Computing checksums"
TARBALL_URL="https://github.com/$REPO/archive/refs/tags/$TAG.tar.gz"
TMP_TAR="$(mktemp -d)/clauderoam-$NEW_VERSION.tar.gz"

# Wait for GitHub to propagate the tag tarball (eventual consistency)
for i in 1 2 3 4 5; do
  if curl -fsSL -o "$TMP_TAR" "$TARBALL_URL" 2>/dev/null; then break; fi
  info "Tarball not yet available (attempt $i/5), waiting 3s..."
  sleep 3
done
[ -s "$TMP_TAR" ] || { err "Could not fetch $TARBALL_URL"; exit 1; }

SHA256="$(shasum -a 256 "$TMP_TAR" | awk '{print $1}')"
ok "sha256: $SHA256"

CHECKSUMS_FILE="$(dirname "$TMP_TAR")/checksums.txt"
printf '%s  clauderoam-%s.tar.gz\n' "$SHA256" "$NEW_VERSION" > "$CHECKSUMS_FILE"

if [ "$DRY_RUN" = 1 ]; then
  printf '  %s[dry-run]%s upload checksums.txt to release\n' "$C_DIM" "$C_RST"
else
  gh release upload "$TAG" "$CHECKSUMS_FILE" --repo "$REPO"
  ok "Uploaded checksums.txt"
fi

# ── Update Homebrew tap ─────────────────────────────────────────────────────
step "Updating Homebrew tap"
FORMULA="$TAP_DIR/Formula/clauderoam.rb"
[ -f "$FORMULA" ] || { err "Formula not found at $FORMULA"; exit 1; }

# Atomic sed for url + sha256 + version
if [ "$DRY_RUN" = 1 ]; then
  info "Would update:"
  info "  url    → $TARBALL_URL"
  info "  sha256 → $SHA256"
  info "  version → $NEW_VERSION"
else
  sed -i.bak \
    -e "s|url \".*\"|url \"$TARBALL_URL\"|" \
    -e "s|sha256 \".*\"|sha256 \"$SHA256\"|" \
    -e "s|version \".*\"|version \"$NEW_VERSION\"|" \
    "$FORMULA" && rm -f "$FORMULA.bak"
  ok "Formula updated"

  ( cd "$TAP_DIR"
    git add Formula/clauderoam.rb
    git commit -m "clauderoam: bump to v$NEW_VERSION"
    git push
  )
  ok "Tap pushed"
fi

# ── Done ────────────────────────────────────────────────────────────────────
step "Done"
echo
ok "Release v$NEW_VERSION cut"
info "  GitHub: https://github.com/$REPO/releases/tag/$TAG"
info "  Tap:    https://github.com/$TAP_REPO"
echo
info "Users can now run:"
info "  brew upgrade clauderoam"
info "  or fresh install: brew install YunyueLi/tap/clauderoam"
