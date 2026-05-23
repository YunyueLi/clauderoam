# Releasing

How to cut a new clauderoam release.

## TL;DR

```bash
./bump.sh 0.5.0
```

That command does everything below. Continue reading if you want to know what it does, or if you want to release manually.

## Prerequisites

- Clean working tree on `main`
- `gh` CLI authenticated and able to push to both `YunyueLi/clauderoam` and `YunyueLi/homebrew-tap`
- `$HOMEBREW_TAP_DIR` points at your local checkout of the tap (default: `~/Desktop/homebrew-tap`)
- The new version follows semver: `X.Y.Z`

## What `bump.sh` does

1. **Pre-flight** — verifies working tree clean, gh available, tap dir exists, tag doesn't already exist
2. **Bumps `VERSION`** in the `clauderoam` script
3. **Updates version badges** in `README.md` and `README.zh-CN.md`
4. **Commits** the bump (`chore: bump to v<X.Y.Z>`)
5. **Pushes** main
6. **Tags** `vX.Y.Z` and pushes the tag
7. **Creates a GitHub Release** with notes from `git log <prev-tag>..HEAD`
8. **Downloads** the tag tarball, computes sha256
9. **Uploads** `checksums.txt` as a release asset (used by `install.sh` for verification)
10. **Updates the Homebrew formula** — patches `url`, `sha256`, `version`
11. **Commits and pushes** the tap

## Dry run

Always do this first for a major release:

```bash
./bump.sh 0.5.0 --dry-run
```

Reports every action without changing anything. No commits, no pushes, no API calls.

## Manual release flow (without bump.sh)

If something goes wrong with the automation, here are the steps:

```bash
# 1. Bump version
sed -i '' 's/^readonly VERSION=.*/readonly VERSION="0.5.0"/' clauderoam
# Also update badges in README.md and README.zh-CN.md

# 2. Commit + push
git add clauderoam README.md README.zh-CN.md
git commit -m "chore: bump to v0.5.0"
git push

# 3. Tag + push tag
git tag -a v0.5.0 -m "v0.5.0"
git push origin v0.5.0

# 4. Create release
gh release create v0.5.0 --title "v0.5.0" --notes "..."

# 5. Compute checksum
curl -fsSL -o /tmp/clauderoam.tar.gz \
  "https://github.com/YunyueLi/clauderoam/archive/refs/tags/v0.5.0.tar.gz"
SHA=$(shasum -a 256 /tmp/clauderoam.tar.gz | awk '{print $1}')
echo "$SHA  clauderoam-0.5.0.tar.gz" > /tmp/checksums.txt

# 6. Upload checksums
gh release upload v0.5.0 /tmp/checksums.txt

# 7. Update formula
cd ~/Desktop/homebrew-tap
sed -i '' \
  -e "s|url \".*\"|url \"https://github.com/YunyueLi/clauderoam/archive/refs/tags/v0.5.0.tar.gz\"|" \
  -e "s|sha256 \".*\"|sha256 \"$SHA\"|" \
  -e "s|version \".*\"|version \"0.5.0\"|" \
  Formula/clauderoam.rb
git add Formula/clauderoam.rb
git commit -m "clauderoam: bump to v0.5.0"
git push
```

## After release

Run a quick smoke test:

```bash
brew update
brew upgrade clauderoam
clauderoam version    # should print the new version
```

If you find a bug post-release, cut a patch:

```bash
./bump.sh 0.5.1
```

## Version policy

- **Patch (`0.X.Y` → `0.X.Y+1`)**: bug fixes, doc updates, internal refactors that don't change user-visible behavior
- **Minor (`0.X.Y` → `0.X+1.0`)**: new subcommands, new flags, backwards-compatible additions
- **Major (`0.X.Y` → `1.0.0`)**: breaking changes to CLI surface or file layout

While in `0.x`, breaking changes can land in minor versions — but call them out clearly in release notes.
