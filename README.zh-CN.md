# claude-portable

**把 Claude Code 配置放进 git。换 Mac 不丢，换 Claude 账号也不丢。**

[English](./README.md) · [安装](./docs/setup.md) · [多设备](./docs/multi-device.md) · [换账号](./docs/multi-account.md) · [FAQ](./docs/faq.md)

> ⚠️  这是可移植的**配置**，不是可移植的 Claude Code **二进制**。
> 如果你要的是 U 盘版 Claude Code，请看
> [`SonnyTaylor/claude-code-portable`](https://github.com/SonnyTaylor/claude-code-portable) 之类项目。

---

## 别人都没解决的问题：换 Claude 账号

大多数「同步 ~/.claude」的项目都默认你一辈子用同一个 Claude 账号。
现实不是这样：

- 你是外包，客户给你开了新的 Claude 账号
- 你公司从个人版升级到 Team
- 你换工作了，账号留在前公司
- 你想把个人账号和工作账号分开

一旦换账号，你会**丢掉每一个** 自定义 slash 命令、每一个 subagent、
每一条偏好、每一条被记住的事实。claude-portable 就是为这个时刻设计的：
新账号，5 分钟恢复，零丢失。

## 工作原理

经典的 dotfiles 套路，针对 Claude Code 做了优化：

1. 把 `~/.claude/` 里可移植的子集（CLAUDE.md、agents、skills、commands、
   memory 快照）放进 git 仓库
2. `bootstrap.sh` 把它们 symlink 进 `~/.claude/`
3. Claude Code 正常读取 `~/.claude/` —— symlink 对它透明
4. 换账号？Symlink 还指向 git，配置不丢。只有凭证（**本来就该换的东西**）
   会被替换

## 快速开始

```bash
# 1. 在 GitHub 上 "Use this template"（或 fork）。然后克隆你自己的副本：
git clone git@github.com:<你>/claude-portable.git ~/claude-portable
cd ~/claude-portable

# 2. 编辑 CLAUDE.md 写自己的偏好
$EDITOR CLAUDE.md

# 3. 激活
./bootstrap.sh

# 4. 验证
./doctor.sh
```

到此结束。编辑 `~/.claude/CLAUDE.md` 就等于编辑仓库文件（它是个 symlink）。
`git push` 之后，任何跑过 `bootstrap.sh` 的设备都能同步。

## 什么可移植，什么不能

| 可移植（进仓库） | 仅本机（gitignore） |
|---|---|
| `CLAUDE.md` — 个人偏好 | `.credentials.json` — 登录凭证 |
| `settings.json` — 权限、hook | `sessions/` — 对话历史 |
| `agents/` — 自定义 subagent | `shell-snapshots/` — shell 状态 |
| `skills/` — 自定义 skill | `projects/` — 项目运行时数据 |
| `commands/` — slash 命令 | `telemetry/` — 用量统计 |
| `keybindings.json` | `policy-limits.json` — 账号额度 |
| `memory/` — auto-memory 快照 | |

## 日常命令

```bash
make help       # 列出所有
make bootstrap  # 重新激活 symlink
make doctor     # 健康检查
make sync       # 快照 auto-memory → ./memory/
make push       # sync + commit + push
make status     # 看仓库 + symlink 状态
```

想要零摩擦自动同步？见 [docs/auto-sync.md](./docs/auto-sync.md)，
里面有可选的 shell 函数，每次启动 Claude Code 前自动 pull，结束后自动 push。

## 添加到第二台设备

```bash
git clone git@github.com:<你>/claude-portable.git ~/claude-portable
cd ~/claude-portable && ./bootstrap.sh
./restore-memory.sh   # 可选：把 auto-memory 也恢复回来（含智能用户名重写）
```

## 与同类项目对比

诚实对比 —— 这个领域已经有几个不错的项目，按需选：

| 项目 | Stars | 同步方式 | 自动同步 | Doctor | Memory 快照 | 多账号 | 双语 | 技术栈 |
|---|---|---|---|---|---|---|---|---|
| **claude-portable**（本项目） | — | git | 可选 shell hook | ✅ | ✅ + 用户名重写 | ✅ **主打** | ✅ 中英 | 纯 bash |
| [renefichtmueller/claude-sync](https://github.com/renefichtmueller/claude-sync) | 16 | **5 种后端**（git/iCloud/Dropbox/Syncthing/rsync） | ✅ | 隐式 | 手动 | ❌ | ❌ | TypeScript |
| [balingsisi/claude-sync-tool](https://github.com/balingsisi/claude-sync-tool) | 11 | git | watch 模式 | ✅ | ❌ | ❌ | ❌ | CLI 工具 |
| [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) | 9 | git | ✅ shell function | ❌ | ❌ | ❌ | ❌ | shell |
| [zircote/.claude](https://github.com/zircote/.claude) | 24 | git（fork 模式） | ❌ | ❌ | ❌ | ❌ | ❌ | 个人 dotfiles + 100+ agents |

**选 claude-portable 如果**：你会换 Claude 账号、想要中英双语文档、偏爱纯 bash
零依赖，或者特别需要换 Mac 后能正确恢复（自动重写用户名路径）的 memory 快照。

**选 renefichtmueller/claude-sync 如果**：你想要多种同步后端（iCloud、
Dropbox、Syncthing），不想自己托管 git 仓库。

**选 zircote/.claude 如果**：你更想要一个精心策划的 agent 库，而非同步框架。

## 架构

```
GitHub（真理之源，与 Claude 账号无关）
   │
   │  <你>/claude-portable
   │    ├── CLAUDE.md, settings.json
   │    ├── agents/, commands/, skills/
   │    └── memory/
   ▼
~/claude-portable（克隆下来）
   │
   │  bootstrap.sh 创建 symlink
   ▼
~/.claude/CLAUDE.md  ────► ~/claude-portable/CLAUDE.md
~/.claude/agents/    ────► ~/claude-portable/agents/
~/.claude/commands/  ────► ~/claude-portable/commands/
   ...
```

Claude Code 正常读取 `~/.claude/`，并不知道（也不在乎）那些是 symlink。

## 示例

[`examples/`](./examples) 目录里有可以直接复用的 agent 和 slash 命令：

- `code-reviewer` — 聚焦的 diff 审查
- `git-helper` — 强制执行分支/提交/PR 规范
- `test-runner` — 自动找到一次改动该跑的测试
- `/new-project` — 一键创建新 GitHub repo + CLAUDE.md
- `/commit` — 基于 staged diff 提议 conventional commit 消息
- `/pr` — 用规范模板开 PR
- `/sync` — 一次性 pull 所有项目 repo
- `/save` — 同步 memory 并推送 claude-portable 变更

## FAQ

详见 [docs/faq.md](./docs/faq.md)。重点：

- **会不会搞坏 Claude Code？** 不会，symlink 对 Claude Code 透明
- **仓库公开还是私有？** 同步 `memory/` 的话建议私有；否则公开也没问题
- **支持 Linux / WSL 吗？** 应该支持 —— 只用标准 Unix 工具
- **怎么撤销？** `bootstrap.sh` 改动前已经全量备份，还原备份即可
- **怎么自动同步？** 见 [docs/auto-sync.md](./docs/auto-sync.md)

## 状态

为 Claude Code（CLI、桌面 App、IDE 扩展）打造。macOS 14+ 测试通过。
欢迎 PR —— 详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## License

[MIT](./LICENSE)
