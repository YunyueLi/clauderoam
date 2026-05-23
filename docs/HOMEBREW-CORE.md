# Upstreaming to homebrew-core

Right now clauderoam ships through a personal tap: `YunyueLi/homebrew-tap`. Users install with:

```bash
brew install YunyueLi/tap/clauderoam
```

If/when the project meets [Homebrew's notability requirements](https://docs.brew.sh/Acceptable-Formulae#niche-or-self-submitted-stuff), we can submit it to `homebrew-core` so it works as:

```bash
brew install clauderoam
```

## Are we ready?

Homebrew-core has [strict acceptance criteria](https://docs.brew.sh/Acceptable-Formulae). The relevant ones:

| Requirement | Status |
|---|---|
| Notable: 30+ forks, 30+ watchers, 75+ stars on GitHub | ⏳ Not yet |
| Stable: at least one tagged release | ✓ v0.4.0 |
| Builds from a versioned tarball (not HEAD-only) | ✓ |
| Not a personal config or wrapper for trivial work | ✓ has substance |
| Compatible license | ✓ MIT |
| Maintainer commitment | ✓ |
| Reasonable upstream activity | ⏳ Still very new |

**Bottom line**: we need real users (stars, forks) before submitting. Realistic timeline: a few months minimum.

## Submission process (for when we're ready)

1. **Fork Homebrew/homebrew-core** on GitHub

2. **Add the formula** at `Formula/c/clauderoam.rb`. Use the same content as our tap formula, with one change — remove `version "..."` if the URL already encodes the version (homebrew-core prefers inferred versions).

3. **Lint locally**:
   ```bash
   brew audit --new --strict clauderoam
   brew style clauderoam
   brew test clauderoam
   ```

4. **Open a PR** to homebrew-core. Title: `clauderoam <version> (new formula)`.

5. **Address reviewer feedback**. Common requests:
   - Use `keg_only` if appropriate (unlikely here)
   - Add livecheck stanza for auto-updating
   - Reduce `caveats` (they prefer minimal hand-holding)
   - Remove redundant `depends_on` (bash, rsync are usually system-provided)

6. **Once merged**: users on stock Homebrew can run `brew install clauderoam` without tapping.

## Living with both

After upstreaming, we'd:

- Keep the tap formula updated as a backup / for power users
- Recommend the canonical `brew install clauderoam` in README
- Mention the tap only as a fallback

## Why not skip the tap and just submit?

Two reasons:

1. **homebrew-core is permanent** — once a formula is in core, removing it requires a deprecation cycle. The tap lets us iterate without baggage.
2. **You can't submit unknown software** — homebrew-core wants tools the community already uses. The tap is how we build that audience.

## Alternatives we could explore

- **`brew tap homebrew/cask` for a `.cask`** — but clauderoam is a CLI, not a GUI app
- **Linuxbrew compatibility** — already supported (no platform-specific code)
- **Nix package** — if there's demand from the Nix community
