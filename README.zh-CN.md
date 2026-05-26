<div align="center">

<img src=".assets/banner.svg" alt="ClaudeRoam — Your Claude Code config, anywhere" width="100%">

<br/>

[![CI](https://github.com/YunyueLi/ClaudeRoam/actions/workflows/ci.yml/badge.svg)](https://github.com/YunyueLi/ClaudeRoam/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-89e051)]()
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)]()
[![Version](https://img.shields.io/badge/version-0.5.2-orange)]()
[![Homebrew](https://img.shields.io/badge/homebrew-tap-FBB040)](https://github.com/YunyueLi/homebrew-tap)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[English](./README.md)  ·  [文档](./docs)  ·  [示例](./examples)  ·  [FAQ](./docs/faq.md)

<br/>

<img src=".assets/hero.gif" alt="brew install YunyueLi/tap/clauderoam → clauderoam init → clauderoam doctor" width="900">

</div>

---

## 为什么有这个东西

上个月买了台新 MacBook，本来兴致勃勃要折腾，结果发现整个上午要花在重装重配 Claude Code 上：

- 几周里反复调教出来的 `CLAUDE.md`
- 自己写的 7 个 subagent（code review、git 操作、跑测试…）
- 跟我思维方式匹配的 commit / PR slash 命令
- 在十来个项目里积累出来的 auto-memory

这些东西全在老 Mac 的 `~/.claude/` 里 —— 不在 git，不在 GitHub，绑死在那台机器、那个 Claude 账号上。

两周后又因为接外包要切到客户的 Claude 账号 —— 同样的故事，几小时调出来的东西又一次清零。

**ClaudeRoam** 就是第二次清零之后写出来的。本质就是把可移植的 Claude Code 状态放进一个 git repo，symlink 回 `~/.claude/`，Claude Code 照常读取。没有 daemon、没有后台服务、不用复制粘贴 —— 就是 dotfiles，只不过专门为 Claude Code 做了优化。

## 它具体帮你做什么

5 类 Claude Code 自定义，平时只活在一台 Mac 上：

| 东西 | 例子 |
|---|---|
| **你的偏好** | "用中文回复"、"别写总结段落"、"用 conventional commits" |
| **自定义 subagent** | 你的 `code-reviewer`、`git-helper`、`test-runner` |
| **Slash 命令** | `/commit`、`/pr`、`/save` |
| **项目清单** | 哪些 GitHub repo 你希望每台 Mac 上都有 |
| **auto-memory** | Claude 跨 session 记住的关于你的事 |

ClaudeRoam 让这些东西跟着**你**走，不跟着机器走。4 个具体场景：

| 场景 | 你做什么 | 结果 |
|---|---|---|
| **新 Mac 一键还原** | 4 行命令（[见 Install](#install)） | Claude Code 认得你、用你的风格、有你写的 agent、项目代码到位。约 5 分钟。 |
| **换 Claude 账号** | 旧账号登出、新账号登入 | 只有 `.credentials.json` 被替换（这正是想要的）。偏好、agent、命令、memory：原封不动。 |
| **iPhone 上派活** | issue 里写 `@claude 帮我修 README §3 的 typo` | Claude 通过 [GitHub @claude bot](https://github.com/apps/claude) 在云端跑、开 PR。**iPhone 上不存任何状态**。 |
| **多台 Mac 并发** | 每台 Mac 的 LaunchAgent 每 30 分钟 push 一次 | v0.5.2+ 自动 resolve memory-only 分叉。**你不会看到 "manual fix required" 错误**。 |

---

## Install

### 先决条件（每台新 Mac 都先做这步）

不做这步，后面 `git clone` 会报 `Permission denied (publickey)`。

| 需要 | 怎么装 |
|---|---|
| [Homebrew](https://brew.sh/) | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| [`gh`](https://cli.github.com/) CLI | `brew install gh` |
| GitHub SSH key | 跑 `gh auth login`，**走到 "Upload your SSH public key" 那步选 "Add an SSH key"**（光标默认停在 Skip，不要按 enter） |
| Git 身份 | `git config --global user.name "..."` 和 `user.email "..."` |

如果不小心选了 Skip，3 条命令补救：

```bash
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519 -N ""
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)"
ssh -T git@github.com   # 第一次问 yes/no 选 yes，看到 "Hi <用户名>!" 就通了
```

### 第一台 Mac（创建你的配置 repo）

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

`init` 会创建 `~/clauderoam/`、个性化 `CLAUDE.md`、symlink 到 `~/.claude/`。然后把这个新 repo push 到你的 GitHub。

### 之后每台 Mac（用你已有的配置 repo）

```bash
brew install YunyueLi/tap/clauderoam
git clone git@github.com:<你>/clauderoam-config.git ~/clauderoam
clauderoam install
clauderoam projects clone-all   # 顺便把所有已注册项目 repo 拉下来
```

<details>
<summary>没装 Homebrew？用 curl 或 git clone。</summary>

```bash
# curl 一键安装（带 sha256 校验）
curl -fsSL https://raw.githubusercontent.com/YunyueLi/ClaudeRoam/main/install.sh | bash

# 或 git clone 源码
git clone https://github.com/YunyueLi/ClaudeRoam.git ~/ClaudeRoam-src
cd ~/ClaudeRoam-src && ./clauderoam init
```

</details>

## 日常怎么用

**99% 的时间：什么都不用做。** LaunchAgent 后台每 30 分钟跑一次 `clauderoam push`（[一键装见 docs/auto-sync.md](./docs/auto-sync.md)），你的自定义自动落到 GitHub。

只有这几件事需要你主动做：

| 你想… | 怎么做 |
|---|---|
| 加一个 slash 命令或 agent | 跟 Claude Code 说："帮我加个 `/refactor` 命令，干 XX"。Claude 会把文件写到 `~/.claude/commands/` 然后跑 `clauderoam push` |
| 改偏好 | 编辑 `~/.claude/CLAUDE.md`（或让 Claude 改），然后 `clauderoam push` |
| 看同步状态 | `clauderoam status` |
| 体检 | `clauderoam doctor` |
| 升级 ClaudeRoam 本身 | `brew upgrade clauderoam` |

---

## 它内部到底在做什么

### 3 层配置 Claude Code 同时读

每次 Claude Code 启动都从**三个地方**读配置。ClaudeRoam 管第一层。

<p align="center">
  <img src=".assets/diagrams/mental-model.svg" alt="Claude Code 启动时读取的三层配置：个人层（ClaudeRoam 管）、项目层、会话层" width="100%">
</p>

> **判断口诀**
> - 跟着_你_跨项目走的 → **个人层**（ClaudeRoam）
> - 属于_这个代码库_的 → **项目 repo**
> - 只是_这次对话_的 → 不用存，在 transcript 里

### 个人配置 vs 项目配置

|  | ClaudeRoam（个人） | 每个项目的 repo |
|---|---|---|
| **位置** | `~/clauderoam/` → `~/.claude/`（symlink） | `<project>/CLAUDE.md` + `<project>/.claude/` |
| **谁改** | 只有你 | 你和这个项目的所有协作者 |
| **跟着谁走** | 你这个人（跨 Mac、跨账号） | 跟着代码库 |
| **例子** | "用中文回复" · `code-reviewer` agent · `/commit` slash 命令 | "Python 3.12 + pytest" · 项目专属 build 命令 · `migration-checker` agent |

<p align="center">
  <img src=".assets/diagrams/personal-vs-project.svg" alt="ClaudeRoam（个人配置）和项目 repo 都汇入 ~/.claude/，Claude Code 从这里读" width="100%">
</p>

在 Project A 里打开 Claude Code → 个人层 + Project A 项目层组合加载。切到 Project B → 同样的个人层 + Project B 项目层。两个 context 互不冲突。

### Symlink，不是同步

ClaudeRoam 不 copy 文件，用 **symlink**。

```
~/.claude/CLAUDE.md ────► ~/clauderoam/CLAUDE.md
                          （真文件，git 跟踪）
```

改一边就是改另一边。**只有一份**。没有"我是不是忘了同步"这种问题。

<p align="center">
  <img src=".assets/diagrams/multi-device-sync.svg" alt="两台 Mac 各自把 ~/.claude/ symlink 到 ~/clauderoam/，通过 git push/pull 同步到同一个 GitHub repo" width="100%">
</p>

换 Claude 账号不影响这一切。Symlink 不依赖你登的哪个账号 —— 只有 `.credentials.json` 被替换（这正确），其他都不动。

唯一的例外是 **auto-memory**：它是文件树（不是单文件），所以走 `clauderoam sync` 拷贝快照，不走 symlink。见下面 [Memory](#memory)。

## 多设备 push，自动处理冲突

两台 Mac 都定时跑 `clauderoam push`？两边都会产生 memory 快照 commit，必然分叉。`clauderoam push`（v0.5.2+）自动 reconcile，处理 4 种情况：

<p align="center">
  <img src=".assets/diagrams/push-state-machine.svg" alt="clauderoam push 状态机：fetch 后 4 种情况 —— at-or-ahead 直接 push、能 FF 就 FF、memory-only 分叉自动 resolve、其他分叉拒绝并 exit 1" width="100%">
</p>

memory 快照来自 `~/.claude/projects/`，每次 sync 重新生成 —— last-writer-wins 是它的正确语义。但手动改的 `CLAUDE.md` 或自定义 agent 不一样，丢了就是丢了 —— 所以 push 在这两种文件分叉时拒绝自动处理。

## Memory

Claude Code 把项目级 memory 存在 `~/.claude/projects/<编码路径>/memory/`，每个项目独立。两条命令通过 git 来回搬：

| 命令 | 干啥 |
|---|---|
| `clauderoam sync` | 把每个项目的 `memory/` 快照到 ClaudeRoam repo |
| `clauderoam restore` | 反向。如果新机器 `$USER` 不同，自动改写用户名部分 |

用户名重写很关键：Mac A 上你的项目在 `/Users/you-a/Desktop/...`，Mac B 在 `/Users/you-b/Desktop/...`。不改写的话，从 A 还原到 B 后 memory 里的路径就指向不存在的地方了。

## 项目清单

ClaudeRoam 不同步项目_代码_（每个项目自己是 GitHub repo），但它跟踪**你有哪些项目**，让新机器一条命令把它们拉回来。

清单存在 `~/clauderoam/projects.tsv` —— 和你的配置一起走 git。

```bash
clauderoam projects add        # 注册一个项目（交互式）
clauderoam projects list       # 看清单
clauderoam projects clone-all  # 拉所有已注册项目（已存在的跳过）
clauderoam projects pull-all   # 给每个干净的项目 git pull
clauderoam projects status     # 哪些项目脏 / 领先 / 没拉
clauderoam projects remove <name>
```

<p align="center">
  <img src=".assets/projects.gif" alt="老 Mac 的 projects.tsv → 新 Mac clauderoam projects clone-all → ~/Code/ 出现所有项目目录" width="900">
</p>

## 在哪些场景生效

| 平台 | 状态 | 说明 |
|---|---|---|
| **Claude Code 桌面 App**（macOS / Linux / Windows） | ✅ 全部生效 | 读 `~/.claude/`，ClaudeRoam symlink 到里面 |
| **Claude Code CLI**（终端） | ✅ 全部生效 | 同样的 `~/.claude/` 机制 |
| **VS Code / JetBrains** 扩展 | ✅ 全部生效 | 同样的 `~/.claude/` 机制 |
| **[claude.ai/code](https://claude.ai/code)**（浏览器版） | ⚠️ 只能项目级 | 每个会话都是隔离的沙箱，没有持久的 `~/.claude/`。变通：把 `clauderoam-config` repo 作为项目打开，它的 `CLAUDE.md` 会被加载 —— 但 `auto` 模式和跨项目 memory 仍然没有 |
| **Claude iOS / Android** App | ➖ 不适用 | 纯聊天客户端。手机上做云端任务请用 [GitHub @claude bot](https://github.com/apps/claude) |

> "云端工作流"这个词有两层含义，ClaudeRoam 只解决其中一种 —— 见 [FAQ](#-faq)。

---

## Reference

### 命令

| 命令 | 干啥 |
|---|---|
| `clauderoam init` | 交互式首次安装（个性化 + install） |
| `clauderoam install` | (重新) 创建 symlink（幂等，先备份） |
| `clauderoam doctor` | 检查 symlink 是否正确、是否有敏感文件进 git |
| `clauderoam sync` | 把 `~/.claude/projects/*/memory/` 快照到 `./memory/` |
| `clauderoam restore` | 反向恢复 memory（处理用户名差异） |
| `clauderoam push` | `sync` + `git commit` + `git push`（带冲突自动 resolve） |
| `clauderoam status` | 看 repo 和 symlink 状态 |
| `clauderoam projects ...` | 管理项目清单 — 见 [项目清单](#项目清单) |
| `clauderoam --dry-run` | 任意命令前加这个 = 预览，不实际改 |

### 什么会同步

| ✅ 进 git | ❌ 留在本机 |
|---|---|
| `CLAUDE.md` · `settings.json` · `keybindings.json` | `.credentials.json` —— 你的登录 token |
| `agents/` · `skills/` · `commands/` | `sessions/` · `shell-snapshots/` · `telemetry/` |
| `memory/`（快照） | `policy-limits.json` · `projects/` 运行时数据 |
| `projects.tsv`（项目清单） | 项目_代码_本身 —— 那是每个项目自己的 git repo |

### 示例

可以直接复制使用的 [agent](./examples/agents) 和 [slash 命令](./examples/commands)：

- 🤖 `code-reviewer` —— 聚焦的 diff 审查
- 🤖 `git-helper` —— 标准化的 commit/branch/PR 流程
- 🤖 `test-runner` —— 找到一次改动对应的测试并跑
- 💬 `/commit` `/pr` `/sync` `/new-project` `/save`

装一个：

```bash
cp examples/agents/code-reviewer.md agents/
clauderoam push
```

## 出问题怎么办

| 症状 | 含义 | 修复 |
|---|---|---|
| Claude Code 不认得你 / 偏好没生效 | `~/.claude/` 里的 symlink 断了或被删了 | `clauderoam install` |
| `clauderoam push` 报 `Permission denied (publickey)` | 这台 Mac 没在 GitHub 上注册 SSH key | 见[先决条件](#%E5%85%88%E5%86%B3%E6%9D%A1%E4%BB%B6%E6%AF%8F%E5%8F%B0%E6%96%B0-mac-%E9%83%BD%E5%85%88%E5%81%9A%E8%BF%99%E6%AD%A5) |
| `clauderoam push` 报 `[rejected] (fetch first)` | 本地 commit 跟远端分叉了，且分叉里有非 memory 的改动（memory-only 分叉 v0.5.2 会自动 resolve） | `cd ~/clauderoam && git status` 手工处理 |
| GIF 不播 / 看不到刚 push 的内容 | GitHub CDN 缓存（≤5 分钟） | 等一下或硬刷页面 |
| 不知道现在状态如何 | | `clauderoam doctor` —— 彩色完整体检 |

---

## 文档

- [Setup](./docs/setup.md) —— 安装、卸载、本机覆盖
- [Multi-device workflow](./docs/multi-device.md) —— 多设备协作（含 iPhone/iPad）
- [Switching Claude accounts](./docs/multi-account.md) —— 换账号迁移清单
- [Auto-sync](./docs/auto-sync.md) —— 可选的自动 sync hook / LaunchAgent
- [Releasing](./docs/RELEASING.md) —— 给维护者：怎么发版
- [Upstreaming to homebrew-core](./docs/HOMEBREW-CORE.md) —— 什么时候、怎么申请
- [FAQ](./docs/faq.md)

<details>
<summary><b>📊 跟同类项目对比</b></summary>

<br/>

| 项目 | ⭐ | 同步方式 | 自动同步 | Doctor | Memory 快照 | 多账号 | 双语 | 技术栈 |
|---|---|---|---|---|---|---|---|---|
| **ClaudeRoam** | — | git | 可选 shell hook | ✓ | ✓ + 用户名重写 | **✓ 专为此设计** | ✓ 中英 | 纯 bash |
| [renefichtmueller/claude-sync](https://github.com/renefichtmueller/claude-sync) | 16 | git · iCloud · Dropbox · Syncthing · rsync | ✓ | 隐式 | 手动 | ✗ | ✗ | TypeScript |
| [balingsisi/claude-sync-tool](https://github.com/balingsisi/claude-sync-tool) | 11 | git | watch 模式 | ✓ | ✗ | ✗ | ✗ | CLI |
| [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) | 9 | git | ✓ shell function | ✗ | ✗ | ✗ | ✗ | shell |
| [zircote/.claude](https://github.com/zircote/.claude) | 24 | git（fork 模式） | ✗ | ✗ | ✗ | ✗ | ✗ | dotfiles + 100+ agents |

**选 ClaudeRoam** 如果你会换 Claude 账号、想要中英双语、偏爱零依赖、或想要在换 Mac 时正确恢复（带用户名重写）的 memory 快照。

**选 renefichtmueller/claude-sync** 如果你想要多种同步后端（iCloud、Dropbox、Syncthing）。

**选 zircote/.claude** 如果你更想要一个精心策划的 agent 库。

</details>

<details>
<summary><b>❓ FAQ</b></summary>

<br/>

**会不会搞坏 Claude Code？**<br/>
不会。Symlink 对 Claude Code 透明 —— 它照常读 `~/.claude/`。

**你的 ClaudeRoam 配置 repo 该公开还是私有？**<br/>
如果同步 `memory/` 建议私有（可能含项目笔记）。否则公开也行，还能 show off 你的配置。

**`init` / `install` 会删什么吗？**<br/>
不会。你现有的 `~/.claude/` 在动手之前被拷到 `~/.claude.bak.<时间戳>`。想先看会做什么用 `--dry-run`。

**这是便携的 Claude Code _二进制_吗？**<br/>
不是 —— 是便携的**配置**。要 U 盘版 Claude Code 看 [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable)。

**支持 Linux / WSL 吗？**<br/>
应该支持。纯 bash，只用标准 Unix 工具。

**能不能有"只在这台机器"的覆盖？**<br/>
可以：`~/.claude/settings.local.json` 和 `~/.claude/CLAUDE.local.md` 是 gitignore 的，会在共享版**之外**额外加载。

**项目里的 `CLAUDE.md` 跟我个人的怎么交互？**<br/>
**叠加**。个人层是默认，项目层覆盖冲突的部分。

<a name="cloud"></a>**"云端工作流" —— 意思是我应该用 claude.ai/code 吗？**<br/>
"云端"有两层含义：(1) 数据和配置存 GitHub，不绑死在一台 Mac（← ClaudeRoam 解决这个），或者 (2) Claude Code 跑在浏览器里、不装本地（← 那是 claude.ai/code 的活，它有 ClaudeRoam 改不了的限制：没 `auto` 模式、没用户级配置、没跨 session memory）。要"跟着你到处走"，你要的是 (1)，加每台 Mac 上的桌面 Claude Code。手机或临时用别人的电脑场景，用 [@claude GitHub bot](https://github.com/apps/claude) 异步派活。

**怎么完全撤销？**<br/>
删 `~/.claude/` 里的 symlink，从 `~/.claude.bak.<时间戳>` 还原。见 [docs/setup.md](./docs/setup.md)。

</details>

## 贡献

欢迎 issue 和 PR —— 见 [CONTRIBUTING.md](./CONTRIBUTING.md)。保持小、保持 bash、保持可读。

## License

[MIT](./LICENSE) © YunyueLi 和贡献者
