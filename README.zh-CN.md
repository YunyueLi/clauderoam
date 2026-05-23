<div align="center">

# clauderoam

### 让 Claude Code 配置漫游<br/>跨 Mac、跨账号、跨设备 —— 无需复制粘贴

[![CI](https://github.com/YunyueLi/clauderoam/actions/workflows/ci.yml/badge.svg)](https://github.com/YunyueLi/clauderoam/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-89e051)](clauderoam)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)]()
[![Version](https://img.shields.io/badge/version-0.4.0-orange)]()
[![Homebrew](https://img.shields.io/badge/homebrew-tap-FBB040)](https://github.com/YunyueLi/homebrew-tap)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[English](./README.md)  ·  [文档](./docs)  ·  [示例](./examples)  ·  [FAQ](./docs/faq.md)

</div>

---

> 在一台 Mac 上把 Claude Code 调成你想要的样子 → 换 Mac → 全没了。<br/>
> 换 Claude 账号 → 又全没了。<br/>
> **clauderoam 用两条命令 + 一组 symlink 修好这件事。**

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

`init` 会在 `~/clauderoam/` 创建你的配置 repo、个性化 `CLAUDE.md`、symlink 到 `~/.claude/`。每台新设备同样两条命令（前提是你已经把 repo push 到 GitHub）。

<details>
<summary>没装 Homebrew？用 git clone。</summary>

```bash
git clone https://github.com/YunyueLi/clauderoam.git ~/clauderoam
cd ~/clauderoam && ./clauderoam init
```

</details>

---

## 心智模型

Claude Code 每次启动都从**三个地方**读配置。clauderoam 管第一层，你的项目管第二层，第三层是当前对话。

```mermaid
flowchart TB
    classDef personal fill:#dbeafe,stroke:#3b82f6,color:#1e3a8a
    classDef project fill:#fef3c7,stroke:#f59e0b,color:#78350f
    classDef session fill:#e5e7eb,stroke:#6b7280,color:#1f2937

    A["<b>1. 个人层</b><br/>~/.claude/<br/><i>「我怎么干活」</i><br/><br/>偏好 · agent · slash 命令<br/>auto-memory · 快捷键"]:::personal
    B["<b>2. 项目层</b><br/>&lt;项目&gt;/CLAUDE.md + .claude/<br/><i>「这个项目怎么干活」</i><br/><br/>技术栈 · 测试命令 · 规范<br/>仅项目内可用的 agent"]:::project
    C["<b>3. 会话层</b><br/>当前对话<br/><i>「我们现在在做什么」</i>"]:::session

    A --> B --> C
```

> **判断准则**<br/>
> 跟着_你_跨项目走的 → **个人层**（clauderoam）<br/>
> 属于_这个代码库_的 → **项目 repo**<br/>
> 仅这次对话的 → 什么都不用做，对话记录里有

## clauderoam 装什么 vs 项目 repo 装什么

|  | clauderoam（个人） | 每个项目的 repo |
|---|---|---|
| **存在哪** | `~/clauderoam/` → `~/.claude/`（symlink） | `<项目>/CLAUDE.md` + `<项目>/.claude/` |
| **谁来编辑** | 你一个人 | 你和这个项目的所有贡献者 |
| **跟谁走** | 你的 Claude 账号和 GitHub 身份 | 代码库 |
| **生命周期** | 多年（你的职业生涯） | 项目的生命周期 |
| **举例** | "用中文回复" · "用 conventional commits" · 你的 `/commit` 命令 · 处处通用的 `code-reviewer` agent | "Python 3.12, `uv run pytest`" · "import 顺序：标准库、第三方、本地" · 只在这里有用的 `migration-checker` agent |

```mermaid
flowchart LR
    subgraph You["👤 你"]
      CR["📦 clauderoam<br/>(个人配置)"]
    end
    subgraph Projects["🏗️ 项目 repos"]
      P1["📦 my-blog<br/>+ CLAUDE.md"]
      P2["📦 startup-app<br/>+ CLAUDE.md"]
      P3["📦 ..."]
    end
    CR -.symlinks.-> CC["💻 ~/.claude/<br/>(Claude Code 读这里)"]
    P1 --> CC
    P2 --> CC
    P3 --> CC
```

在 `startup-app` 里打开 Claude Code 时，它加载**你的个人层 + startup-app 项目层**，组合使用。切换到 `my-blog`，同样的个人层 + my-blog 的项目层。两个上下文，零冲突。

## clauderoam 内部到底在做什么

它**不** copy、也**不** sync 文件。它用的是 **symlink**。

```
~/.claude/CLAUDE.md ────► ~/clauderoam/CLAUDE.md
                          （真文件，git 跟踪的版本）
```

改一个就是改另一个 —— 只有一份。没有"我忘了同步吗"的焦虑。

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

**换账号？** Symlink 不在乎你登的是哪个 Claude 账号。配置照常工作 —— 只有凭证文件（`~/.claude/.credentials.json`）会被替换，**这正是你想要的行为**。

唯一的例外是 **auto-memory** —— 因为是文件树结构，由 `clauderoam sync` 做真正的拷贝快照。见下方 [Memory](#memory) 部分。

## Memory

Claude Code 把项目级 memory 存在 `~/.claude/projects/<编码路径>/memory/`，每个项目独立：

```
~/.claude/projects/
├── -Users-you-Desktop-my-blog/
│   └── memory/
│       ├── MEMORY.md           ← 索引，始终加载
│       ├── user_xxx.md         ← 关于你的事实
│       ├── feedback_xxx.md     ← 你给过的纠正
│       └── project_xxx.md      ← 项目状态
│
├── -Users-you-Desktop-startup-app/
│   └── memory/  ← 跟 my-blog 的 memory 完全独立
│
└── -Users-you-Desktop-clauderoam/
    └── memory/
```

| 命令 | 作用 |
|---|---|
| `clauderoam sync` | 把每个项目的 `memory/` 拷贝进 clauderoam 仓库 |
| `clauderoam restore` | 反向：从仓库拷贝回 `~/.claude/projects/`。在新机器上自动重写用户名 |

## 安装

### macOS / Linux（Homebrew）

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

升级：`brew upgrade clauderoam`（只升级 CLI 本身，**绝不动你的配置 repo**）。

### 不用 Homebrew（curl）

```bash
curl -fsSL https://raw.githubusercontent.com/YunyueLi/clauderoam/main/install.sh | bash
clauderoam init
```

装到 `~/.local/bin/clauderoam` + `~/.local/share/clauderoam/`。会用 release manifest 验证 sha256。用 `CLAUDEROAM_PREFIX` 覆盖路径。

### 从源码安装（git clone）

```bash
git clone https://github.com/YunyueLi/clauderoam.git ~/clauderoam
cd ~/clauderoam
./clauderoam init
```

### 在第二台设备上

CLI 安装同上。要把你的配置带过来：

```bash
brew install YunyueLi/tap/clauderoam       # 或 git clone 安装 CLI
git clone <你的 clauderoam 配置 repo> ~/clauderoam
clauderoam install
```

## 命令

| 命令 | 作用 |
|---|---|
| `clauderoam init` | 交互式首次设置 —— 个性化 + 安装 |
| `clauderoam install` | 重建 symlink（幂等，改动前先备份） |
| `clauderoam doctor` | 验证 symlink 正确、敏感文件无泄漏 |
| `clauderoam sync` | 把 `~/.claude/projects/*/memory/` 快照到 `./memory/` |
| `clauderoam restore` | 恢复 memory（处理用户名变化） |
| `clauderoam push` | `sync` + `git commit` + `git push` |
| `clauderoam status` | 看仓库状态和当前 symlink |
| `clauderoam --dry-run` | 任何命令的预览模式 |

## 什么会被同步

| ✅ 同步到 git | ❌ 仅本机 |
|---|---|
| `CLAUDE.md` · `settings.json` · `keybindings.json` | `.credentials.json` —— 你的登录凭证 |
| `agents/` · `skills/` · `commands/` | `sessions/` · `shell-snapshots/` · `telemetry/` |
| `memory/`（快照） | `policy-limits.json` · `projects/` 运行时数据 |

## 示例

开箱即用的 [agents](./examples/agents) 和 [slash 命令](./examples/commands)：

- 🤖 `code-reviewer` — 聚焦的 diff 审查
- 🤖 `git-helper` — 谨慎的 commit/branch/PR 操作
- 🤖 `test-runner` — 自动找到一次改动该跑的测试
- 💬 `/commit` `/pr` `/sync` `/new-project` `/save`

安装一个：

```bash
cp examples/agents/code-reviewer.md agents/
./clauderoam push
```

## 文档

- [Setup](./docs/setup.md) — 安装、卸载、本机覆盖、加入 PATH
- [多设备工作流](./docs/multi-device.md) — 新 Mac、iPhone、iPad
- [换 Claude 账号](./docs/multi-account.md) — 迁移清单
- [自动同步](./docs/auto-sync.md) — 可选的自动 shell hook
- [发版流程](./docs/RELEASING.md) — 维护者用：怎么 cut release
- [上游 homebrew-core](./docs/HOMEBREW-CORE.md) — 什么时候 / 怎么申请
- [FAQ](./docs/faq.md)

<details>
<summary><b>📊 跟其他 Claude 同步项目怎么比</b></summary>

<br/>

| 项目 | ⭐ | 同步后端 | 自动同步 | Doctor | Memory 快照 | 多账号专注度 | 双语 | 技术栈 |
|---|---|---|---|---|---|---|---|---|
| **clauderoam** | — | git | 可选 shell hook | ✓ | ✓ + 用户名重写 | **✓ 专为此设计** | ✓ 中英 | 纯 bash |
| [renefichtmueller/claude-sync](https://github.com/renefichtmueller/claude-sync) | 16 | git · iCloud · Dropbox · Syncthing · rsync | ✓ | 隐式 | 手动 | ✗ | ✗ | TypeScript |
| [balingsisi/claude-sync-tool](https://github.com/balingsisi/claude-sync-tool) | 11 | git | watch 模式 | ✓ | ✗ | ✗ | ✗ | CLI |
| [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) | 9 | git | ✓ shell function | ✗ | ✗ | ✗ | ✗ | shell |
| [zircote/.claude](https://github.com/zircote/.claude) | 24 | git（fork 模式） | ✗ | ✗ | ✗ | ✗ | ✗ | dotfiles + 100+ agents |

**选 clauderoam** 如果你会换 Claude 账号、想要中英双语、偏爱零依赖，或想要换 Mac 后能正确恢复（自动重写用户名）的 memory 快照。

**选 renefichtmueller/claude-sync** 如果想要多种同步后端。

**选 zircote/.claude** 如果主要想要一个精心策划的 agent 库。

</details>

<details>
<summary><b>❓ FAQ</b></summary>

<br/>

**会不会搞坏 Claude Code？**<br/>
不会。Symlink 对 Claude Code 透明 —— 它读 `~/.claude/` 和之前一样。

**clauderoam 仓库该公开还是私有？**<br/>
同步 `memory/` 的话建议私有（可能含项目笔记）。否则公开也行，还能展示你的配置。

**`init` / `install` 会删东西吗？**<br/>
不会。它会先把 `~/.claude/` 拷贝到 `~/.claude.bak.<时间戳>`。可以 `--dry-run` 先预览。

**这是可移植的 Claude Code **二进制**吗？**<br/>
不是 —— 是可移植**配置**。要 U 盘版 Claude Code 看 [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable)。

**Linux / WSL 支持吗？**<br/>
应该支持，只用标准 Unix 工具。

**能有不同步的本机覆盖吗？**<br/>
可以：`~/.claude/settings.local.json` 和 `~/.claude/CLAUDE.local.md` 被 gitignore，跟共享版本一起加载。

**项目级 `CLAUDE.md` 怎么跟个人的协作？**<br/>
**组合**。个人层定默认，项目层在冲突处覆盖。详见上面 [心智模型](#心智模型) 部分。

**怎么撤销？**<br/>
删 `~/.claude/` 里的 symlink，从 `~/.claude.bak.<时间戳>` 恢复。详见 [docs/setup.md](./docs/setup.md)。

</details>

## 贡献

欢迎 Issue 和 PR —— 详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。保持小、保持 bash、保持可读。

## License

[MIT](./LICENSE) © YunyueLi 与贡献者们
