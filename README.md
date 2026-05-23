<div align="center">

# clauderoam

### Your Claude Code config, anywhere.<br/>Across Macs. Across accounts. Without the copy-paste.

[![CI](https://github.com/YunyueLi/clauderoam/actions/workflows/ci.yml/badge.svg)](https://github.com/YunyueLi/clauderoam/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-89e051)](clauderoam)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)]()
[![Version](https://img.shields.io/badge/version-0.4.0-orange)]()
[![Homebrew](https://img.shields.io/badge/homebrew-tap-FBB040)](https://github.com/YunyueLi/homebrew-tap)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[中文](./README.zh-CN.md)  ·  [Docs](./docs)  ·  [Examples](./examples)  ·  [FAQ](./docs/faq.md)

<br/>

<img src=".assets/demo.gif" alt="clauderoam demo" width="800">

</div>

---

> Customize Claude Code on one Mac → switch Macs → lose everything.<br/>
> Switch Claude accounts → lose everything again.<br/>
> **clauderoam fixes that with two commands and a symlink farm.**

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

`init` creates your config repo at `~/clauderoam/`, personalizes your `CLAUDE.md`, and links it into `~/.claude/`. Same two commands on every other device — after pushing your repo to GitHub, of course.

<details>
<summary>Don't have Homebrew? Use git clone.</summary>

```bash
git clone https://github.com/YunyueLi/clauderoam.git ~/clauderoam
cd ~/clauderoam && ./clauderoam init
```

</details>

---

## Mental model

Claude Code reads config from **three places** every time it starts. clauderoam manages the first one. Your projects own the second. The third is the live conversation.

```mermaid
flowchart TB
    classDef personal fill:#dbeafe,stroke:#3b82f6,color:#1e3a8a
    classDef project fill:#fef3c7,stroke:#f59e0b,color:#78350f
    classDef session fill:#e5e7eb,stroke:#6b7280,color:#1f2937

    A["<b>1. Personal layer</b><br/>~/.claude/<br/><i>'How I work'</i><br/><br/>preferences · agents · slash commands<br/>auto-memory · keybindings"]:::personal
    B["<b>2. Project layer</b><br/>&lt;project&gt;/CLAUDE.md + .claude/<br/><i>'How this codebase works'</i><br/><br/>tech stack · test commands · conventions<br/>project-only agents"]:::project
    C["<b>3. Session layer</b><br/>This conversation<br/><i>'What we're doing right now'</i>"]:::session

    A --> B --> C
```

> **Rule of thumb**<br/>
> If it follows _you_ across projects → **personal** (clauderoam).<br/>
> If it belongs to _this codebase_ → **project repo**.<br/>
> If it's just for _this conversation_ → nothing, it'll be in the transcript.

## What's in clauderoam vs what's in each project

|  | clauderoam (personal) | Each project repo |
|---|---|---|
| **Lives at** | `~/clauderoam/` → `~/.claude/` (symlinks) | `<project>/CLAUDE.md` + `<project>/.claude/` |
| **Who edits it** | You, alone | You and any contributors to that project |
| **Travels with** | Your Claude account & GitHub identity | The codebase |
| **Lifetime** | Years (your career) | Lifetime of the project |
| **Examples** | "Reply in 中文" · "use conventional commits" · your `/commit` slash command · the `code-reviewer` agent you use everywhere | "Python 3.12, `uv run pytest`" · "import sort: stdlib, third-party, local" · a `migration-checker` agent only useful here |

```mermaid
flowchart LR
    subgraph You["👤 You"]
      CR["📦 clauderoam<br/>(personal config)"]
    end
    subgraph Projects["🏗️ Project repos"]
      P1["📦 my-blog<br/>+ CLAUDE.md"]
      P2["📦 startup-app<br/>+ CLAUDE.md"]
      P3["📦 ..."]
    end
    CR -.symlinks.-> CC["💻 ~/.claude/<br/>(Claude Code reads here)"]
    P1 --> CC
    P2 --> CC
    P3 --> CC
```

When you open `startup-app` in Claude Code, it loads **your personal layer + startup-app's project layer**, combined. Open `my-blog` next, same personal layer + my-blog's project layer. Two contexts, zero conflict.

## Project registry — pulling all your repos onto a new Mac

clauderoam doesn't sync project _code_ (each project is its own GitHub repo) but it does track **which projects you have** so a new machine can pull them in one command.

The list lives at `~/clauderoam/projects.tsv` — synced via git alongside your config.

```bash
clauderoam projects add        # register a project (interactive)
clauderoam projects list       # see the registry
clauderoam projects clone-all  # clone every registered project (skips existing)
clauderoam projects pull-all   # git pull each clean project
clauderoam projects status     # which projects are dirty / ahead / missing
clauderoam projects remove <name>
```

So the complete "set up a new Mac" flow becomes:

```bash
brew install YunyueLi/tap/clauderoam        # 1. install the CLI
git clone <your-clauderoam-repo> ~/clauderoam
clauderoam install                          # 2. personal config
clauderoam projects clone-all               # 3. all your projects
# 4. install per-project deps as needed (npm install / pip install / ...)
```

Four lines, full developer environment.

## What clauderoam actually does (under the hood)

It does **not** copy or sync files. It uses **symlinks**.

```
~/.claude/CLAUDE.md ────► ~/clauderoam/CLAUDE.md
                          (the real file, tracked in git)
```

Editing one *is* editing the other. There's only one copy. No "did I forget to sync" anxiety.

```mermaid
flowchart LR
    subgraph M1["💻 Mac A"]
      CC1["~/.claude/CLAUDE.md"] -.symlink.-> R1["~/clauderoam/CLAUDE.md"]
    end
    subgraph M2["💻 Mac B"]
      CC2["~/.claude/CLAUDE.md"] -.symlink.-> R2["~/clauderoam/CLAUDE.md"]
    end
    subgraph GH["📦 GitHub"]
      G["clauderoam repo"]
    end
    R1 <-->|git push/pull| G
    R2 <-->|git push/pull| G
```

**Switch accounts?** The symlink doesn't care which Claude account is signed in. Your config keeps working — only the credential file (`~/.claude/.credentials.json`) changes, which is exactly what you want.

The one exception is **auto-memory**, which is folder-tree based and gets snapshotted (real copy) by `clauderoam sync`. See [Memory](#memory) below.

## Memory

Claude Code stores per-project memory at `~/.claude/projects/<encoded-path>/memory/`. Each project gets its own bucket:

```
~/.claude/projects/
├── -Users-you-Desktop-my-blog/
│   └── memory/
│       ├── MEMORY.md           ← index, always loaded
│       ├── user_xxx.md         ← facts about you
│       ├── feedback_xxx.md     ← corrections you've given
│       └── project_xxx.md      ← project state
│
├── -Users-you-Desktop-startup-app/
│   └── memory/  ← totally independent from my-blog's memory
│
└── -Users-you-Desktop-clauderoam/
    └── memory/
```

| Command | What it does |
|---|---|
| `clauderoam sync` | Copy every project's `memory/` into the clauderoam repo |
| `clauderoam restore` | Reverse: copy from repo back to `~/.claude/projects/`. Rewrites the username if the new machine has a different `$USER` |

## Install

### macOS / Linux (Homebrew)

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

Updates: `brew upgrade clauderoam` (updates the CLI only — your config repo is yours and is never touched).

### Without Homebrew (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/YunyueLi/clauderoam/main/install.sh | bash
clauderoam init
```

Installs to `~/.local/bin/clauderoam` + `~/.local/share/clauderoam/`. Verifies sha256 against the release manifest. Override paths with `CLAUDEROAM_PREFIX`.

### From source (git clone)

```bash
git clone https://github.com/YunyueLi/clauderoam.git ~/clauderoam
cd ~/clauderoam
./clauderoam init
```

### On a second device

The CLI install is the same. To bring your config and all your project code:

```bash
brew install YunyueLi/tap/clauderoam        # or use install.sh / git clone
git clone <your-clauderoam-config-repo> ~/clauderoam
clauderoam install                          # personal config
clauderoam projects clone-all               # all your project repos
```

## Commands

| Command | What it does |
|---|---|
| `clauderoam init` | Interactive first-time setup — personalize and install |
| `clauderoam install` | Re-create the symlinks (idempotent, backs up first) |
| `clauderoam doctor` | Verify symlinks point right & no secrets are tracked |
| `clauderoam sync` | Snapshot `~/.claude/projects/*/memory/` into `./memory/` |
| `clauderoam restore` | Restore memory snapshots (handles username changes) |
| `clauderoam push` | `sync` + `git commit` + `git push` |
| `clauderoam status` | Show repo state and current symlinks |
| `clauderoam projects ...` | Manage your project registry — see [Project registry](#project-registry--pulling-all-your-repos-onto-a-new-mac) |
| `clauderoam --dry-run` | Preview any command without making changes |

## What gets synced

| ✅ Synced to git | ❌ Stays on the machine |
|---|---|
| `CLAUDE.md` · `settings.json` · `keybindings.json` | `.credentials.json` — your auth token |
| `agents/` · `skills/` · `commands/` | `sessions/` · `shell-snapshots/` · `telemetry/` |
| `memory/` (snapshots) | `policy-limits.json` · `projects/` runtime data |
| `projects.tsv` (project registry) | the project _code_ — that's each project's own git repo |

## Examples

Drop-in [agents](./examples/agents) and [slash commands](./examples/commands):

- 🤖 `code-reviewer` — focused diff review
- 🤖 `git-helper` — careful commit/branch/PR operations
- 🤖 `test-runner` — finds the right tests for a change
- 💬 `/commit` `/pr` `/sync` `/new-project` `/save`

Install one:

```bash
cp examples/agents/code-reviewer.md agents/
./clauderoam push
```

## Documentation

- [Setup](./docs/setup.md) — install, uninstall, machine-local overrides, PATH
- [Multi-device workflow](./docs/multi-device.md) — adding Macs, iPhone, iPad
- [Switching Claude accounts](./docs/multi-account.md) — the migration checklist
- [Auto-sync](./docs/auto-sync.md) — optional hands-off shell hook
- [Releasing](./docs/RELEASING.md) — for maintainers: how to cut a release
- [Upstreaming to homebrew-core](./docs/HOMEBREW-CORE.md) — when/how to apply
- [FAQ](./docs/faq.md)

<details>
<summary><b>📊 How clauderoam compares to other Claude sync projects</b></summary>

<br/>

| Project | ⭐ | Sync backend | Auto-sync | Doctor | Memory snapshots | Multi-account focus | Bilingual | Stack |
|---|---|---|---|---|---|---|---|---|
| **clauderoam** | — | git | optional shell hook | ✓ | ✓ + username rewriting | **✓ designed for it** | ✓ EN / 中文 | pure bash |
| [renefichtmueller/claude-sync](https://github.com/renefichtmueller/claude-sync) | 16 | git · iCloud · Dropbox · Syncthing · rsync | ✓ | implicit | manual | ✗ | ✗ | TypeScript |
| [balingsisi/claude-sync-tool](https://github.com/balingsisi/claude-sync-tool) | 11 | git | watch mode | ✓ | ✗ | ✗ | ✗ | CLI |
| [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) | 9 | git | ✓ shell function | ✗ | ✗ | ✗ | ✗ | shell |
| [zircote/.claude](https://github.com/zircote/.claude) | 24 | git (fork model) | ✗ | ✗ | ✗ | ✗ | ✗ | dotfiles + 100+ agents |

**Pick clauderoam** if you switch Claude accounts, want bilingual docs, prefer zero dependencies, or want memory snapshots that survive a username change.

**Pick renefichtmueller/claude-sync** if you want multiple sync backends (iCloud, Dropbox, Syncthing).

**Pick zircote/.claude** if you mostly want a curated agent library.

</details>

<details>
<summary><b>❓ FAQ</b></summary>

<br/>

**Will this break Claude Code?**<br/>
No. Symlinks are transparent — Claude Code reads `~/.claude/` exactly as before.

**Should the clauderoam repo be public or private?**<br/>
Private if you sync `memory/` (it may contain project notes). Otherwise public is fine and lets you show off your setup.

**Does `init` / `install` delete anything?**<br/>
No. It copies your current `~/.claude/` to `~/.claude.bak.<timestamp>` first. Run `--dry-run` to preview.

**Is this a portable Claude Code _binary_?**<br/>
No — it's portable **config**. For USB-drive Claude Code, see [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable).

**Linux? WSL?**<br/>
Should work. Pure bash, only standard Unix tools.

**Can I have machine-only overrides that don't sync?**<br/>
Yes: `~/.claude/settings.local.json` and `~/.claude/CLAUDE.local.md` are gitignored and loaded in addition to the shared versions.

**How do project `CLAUDE.md` files interact with my personal one?**<br/>
They _combine_. Personal sets defaults; project overrides where they conflict. See [Mental model](#mental-model) above.

**How do I undo everything?**<br/>
Remove the symlinks in `~/.claude/` and restore from `~/.claude.bak.<timestamp>`. See [docs/setup.md#uninstall](./docs/setup.md).

</details>

## Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md). Keep it small, keep it bash, keep it readable.

## License

[MIT](./LICENSE) © YunyueLi and contributors
