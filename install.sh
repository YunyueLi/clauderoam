#!/usr/bin/env bash
# install.sh — one-liner installer for clauderoam.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YunyueLi/ClaudeRoam/main/install.sh | bash
#
# Environment:
#   CLAUDEROAM_VERSION   Version to install (default: latest)
#   CLAUDEROAM_PREFIX    Install prefix (default: $HOME/.local)
#   CLAUDEROAM_NO_VERIFY If set, skip sha256 verification
#   CLAUDEROAM_FORCE     If set, reinstall even if already at latest
#
# Installs:
#   <PREFIX>/bin/clauderoam
#   <PREFIX>/share/clauderoam/{CLAUDE.md,settings.json,agents/,skills/,commands/,examples/}

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────────────
REPO="YunyueLi/ClaudeRoam"
VERSION="${CLAUDEROAM_VERSION:-latest}"
PREFIX="${CLAUDEROAM_PREFIX:-$HOME/.local}"

# ── Pretty output ───────────────────────────────────────────────────────────
if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
  C_BOLD='\033[1m'; C_DIM='\033[2m'
  C_RED='\033[31m'; C_GRN='\033[32m'; C_YEL='\033[33m'; C_BLU='\033[34m'
  C_RST='\033[0m'
else
  C_BOLD=''; C_DIM=''; C_RED=''; C_GRN=''; C_YEL=''; C_BLU=''; C_RST=''
fi

step() { printf '%b\n' "${C_BOLD}${C_BLU}▸${C_RST} ${C_BOLD}$*${C_RST}"; }
ok()   { printf '%b\n' "  ${C_GRN}✓${C_RST} $*"; }
info() { printf '%b\n' "  ${C_DIM}$*${C_RST}"; }
err()  { printf '%b\n' "  ${C_RED}✗${C_RST} $*" >&2; }

# ── Pre-flight checks ───────────────────────────────────────────────────────
for tool in curl tar bash; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    err "Required tool not found: $tool"
    exit 1
  fi
done

# ── Detect existing install ─────────────────────────────────────────────────
INSTALLED_VERSION=""
INSTALLED_AT=""
if command -v clauderoam >/dev/null 2>&1; then
  INSTALLED_AT="$(command -v clauderoam)"
  INSTALLED_VERSION="$(clauderoam version 2>/dev/null | awk '{print $2}')"
fi

if [ -n "$INSTALLED_VERSION" ]; then
  step "Existing install detected"
  info "Found clauderoam $INSTALLED_VERSION at $INSTALLED_AT"
  if [ "$INSTALLED_AT" != "$PREFIX/bin/clauderoam" ]; then
    info "(installed via a different method — Homebrew?)"
  fi
fi

# ── Resolve version ─────────────────────────────────────────────────────────
step "Resolving version"
if [ "$VERSION" = "latest" ]; then
  VERSION="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -1)"
  if [ -z "$VERSION" ]; then
    err "Could not detect latest version. Pass CLAUDEROAM_VERSION=x.y.z to install a specific one."
    exit 1
  fi
fi

if [ -n "$INSTALLED_VERSION" ] && [ "$INSTALLED_VERSION" = "$VERSION" ] && [ -z "${CLAUDEROAM_FORCE:-}" ]; then
  ok "Already at v$VERSION — nothing to do"
  info "Set CLAUDEROAM_FORCE=1 to reinstall anyway"
  exit 0
fi

if [ -n "$INSTALLED_VERSION" ]; then
  ok "Upgrading v$INSTALLED_VERSION → v$VERSION"
else
  ok "Installing clauderoam v$VERSION"
fi

# ── Download ────────────────────────────────────────────────────────────────
step "Downloading"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

TARBALL_URL="https://github.com/$REPO/archive/refs/tags/v${VERSION}.tar.gz"
TARBALL="$TMPDIR/clauderoam.tar.gz"
curl -fsSL -o "$TARBALL" "$TARBALL_URL"
ok "Got $(basename "$TARBALL_URL")"

# ── Verify checksum (if available) ──────────────────────────────────────────
if [ -z "${CLAUDEROAM_NO_VERIFY:-}" ]; then
  step "Verifying checksum"
  CHECKSUMS_URL="https://github.com/$REPO/releases/download/v${VERSION}/checksums.txt"
  if curl -fsSL -o "$TMPDIR/checksums.txt" "$CHECKSUMS_URL" 2>/dev/null; then
    expected="$(grep "clauderoam-${VERSION}.tar.gz\| v${VERSION}\.tar\.gz" "$TMPDIR/checksums.txt" | awk '{print $1}' | head -1)"
    if [ -n "$expected" ]; then
      actual="$(shasum -a 256 "$TARBALL" | awk '{print $1}')"
      if [ "$expected" = "$actual" ]; then
        ok "sha256: $actual"
      else
        err "Checksum mismatch!"
        err "  expected: $expected"
        err "  actual:   $actual"
        exit 1
      fi
    else
      info "checksums.txt found but no entry for this tarball — skipping verify"
    fi
  else
    info "No checksums.txt published for v${VERSION} — skipping verify"
    info "(set CLAUDEROAM_NO_VERIFY=1 to silence this notice)"
  fi
fi

# ── Extract ─────────────────────────────────────────────────────────────────
step "Extracting"
tar -xzf "$TARBALL" -C "$TMPDIR"
SRC_DIR="$TMPDIR/clauderoam-${VERSION}"
[ -d "$SRC_DIR" ] || { err "Unexpected tarball layout: $SRC_DIR not found"; exit 1; }
ok "OK"

# ── Install ─────────────────────────────────────────────────────────────────
step "Installing to $PREFIX"
mkdir -p "$PREFIX/bin" "$PREFIX/share/clauderoam"

# Binary
install -m 0755 "$SRC_DIR/clauderoam" "$PREFIX/bin/clauderoam"
ok "$PREFIX/bin/clauderoam"

# Starter files
for item in CLAUDE.md settings.json agents skills commands examples; do
  if [ -e "$SRC_DIR/$item" ]; then
    rm -rf "$PREFIX/share/clauderoam/$item"
    cp -R "$SRC_DIR/$item" "$PREFIX/share/clauderoam/$item"
  fi
done
ok "$PREFIX/share/clauderoam/"

# ── PATH check ──────────────────────────────────────────────────────────────
echo
if ! command -v clauderoam >/dev/null 2>&1 || [ "$(command -v clauderoam)" != "$PREFIX/bin/clauderoam" ]; then
  step "PATH note"
  case ":$PATH:" in
    *":$PREFIX/bin:"*)
      info "$PREFIX/bin is on your PATH but clauderoam resolves elsewhere."
      info "Check 'command -v clauderoam' to see where."
      ;;
    *)
      printf '%b\n' "  ${C_YEL}!${C_RST} $PREFIX/bin is not on your \$PATH yet."
      printf '%b\n' "    Add this to your shell profile (~/.zshrc or ~/.bashrc):"
      printf '\n      %sexport PATH="%s/bin:$PATH"%s\n\n' "$C_BOLD" "$PREFIX" "$C_RST"
      printf '    Then reload: %sexec $SHELL%s\n\n' "$C_BOLD" "$C_RST"
      ;;
  esac
fi

# ── Done ────────────────────────────────────────────────────────────────────
step "Done"
ok "clauderoam $VERSION installed"
echo
info "Next: run ${C_BOLD}clauderoam init${C_RST}"
info "Docs: https://github.com/$REPO"
