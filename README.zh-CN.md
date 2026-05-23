# claude-portable

**把 Claude Code 配置放进 git。账号无关、设备无关。任意机器 5 分钟恢复完整环境。**

[English](./README.md) · [安装](./docs/setup.md) · [多设备](./docs/multi-device.md) · [换账号](./docs/multi-account.md) · [FAQ](./docs/faq.md)

---

## 问题

你慢慢积累了一套 Claude Code 配置 —— `CLAUDE.md` 里的偏好、自定义 subagent、
slash 命令、hook、自动记忆。然后：

- 换 Mac，全没了
- 换 Claude 账号，账号绑定的状态跟着消失
- 想在工作电脑和家里电脑保持同一套配置

这些状态默认不会同步到任何地方，只是孤零零地躺在某一台机器的 `~/.claude/` 里。

## 解决方案

把 `~/.claude/` 里**可移植**的部分放进 git 仓库，再 symlink 回去。
就是经典的 dotfiles 套路，但针对 Claude Code 做了优化：

- 自动区分哪些文件可移植、哪些是机器/账号绑定的
- 自带脚本，跨设备快照和恢复 auto-memory
- 安全的 `bootstrap.sh`，改动前先全量备份
- `doctor.sh` 一键体检

## 快速开始

```bash
# 1. 在 GitHub 上把这个仓库作为 template 使用（右上角 "Use this template"）
#    或者 fork。然后克隆你自己的副本。
git clone git@github.com:<你>/claude-portable.git ~/claude-portable
cd ~/claude-portable

# 2. 编辑 CLAUDE.md 写自己的偏好
$EDITOR CLAUDE.md

# 3. 激活
./bootstrap.sh

# 4. 验证
./doctor.sh
```

到此结束。从现在起，编辑 `~/.claude/CLAUDE.md` 就等于编辑仓库里的文件
（它是个 symlink）。`git push` 之后，任何跑过 `bootstrap.sh` 的设备都能同步到。

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
make help       # 列出所有命令
make bootstrap  # 重新激活 symlink
make doctor     # 健康检查
make sync       # 快照 auto-memory 到 ./memory/
make push       # sync + commit + push 一条龙
make status     # 看仓库状态和 symlink 状态
```

## 添加新设备

```bash
git clone git@github.com:<你>/claude-portable.git ~/claude-portable
cd ~/claude-portable && ./bootstrap.sh
./restore-memory.sh   # 可选：把 auto-memory 也恢复回来
```

## 架构

```
GitHub（真理之源，与 Claude 账号无关）
   │
   │  <你>/claude-portable
   │    ├── CLAUDE.md, settings.json
   │    ├── agents/, commands/, skills/
   │    └── memory/
   ▼
~/claude-portable（clone 下来）
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

[`examples/`](./examples) 目录里有可以直接拿来用的 agent 和 slash 命令：

- `code-reviewer` agent — 聚焦的 diff 审查
- `/new-project` — 一键创建新 GitHub repo + CLAUDE.md
- `/save` — 同步 memory 并推送所有变更

## FAQ

详见 [docs/faq.md](./docs/faq.md)。重点：

- **会不会搞坏 Claude Code？** 不会，symlink 对 Claude Code 透明。
- **仓库公开还是私有？** 同步 `memory/` 的话建议私有；否则公开也没问题。
- **支持 Linux / WSL 吗？** 应该支持 —— 只用标准 Unix 工具。
- **怎么撤销？** `bootstrap.sh` 改动前已经全量备份，直接还原备份即可。

## 状态

为 Claude Code（CLI、桌面 App、IDE 扩展）打造。macOS 14+ 测试通过。
欢迎 PR —— 详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## License

[MIT](./LICENSE)
