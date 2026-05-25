# 中文社区发帖（V2EX / 即刻 / 小红书 / 微信群）

中文圈跟英文圈的关注点很不一样：
- 不太在意 "Show HN-style" 的礼貌开场
- 关心**实际能不能用**、**会不会被封号**、**官方态不态度**
- 长贴 > 短贴（在乎"分享得是不是有干货"）

## V2EX（推荐版块：分享创造 / 程序员 / Claude）

### 标题

```
[分享] ClaudeRoam：让 Claude Code 的配置跨 Mac 跨账号漫游
```

### 正文

```markdown
背景：我同时用两台 Mac，前段时间还换了一次 Claude 账号。每次都把之前调好的 CLAUDE.md、自定义 subagent、slash 命令、auto-memory 全丢了 —— 这些东西默认只存在某一台机器的 ~/.claude/ 里，换设备/换账号全归零。

写了个小工具叫 **ClaudeRoam**（claude + roam，漫游的意思）。

## 它做什么

1. 把 ~/.claude/ 里可移植的部分（CLAUDE.md、agents、commands、skills、memory 快照）放进一个 git 仓库
2. `clauderoam install` 用 symlink 把这些文件接回 ~/.claude/ —— 对 Claude Code 完全透明
3. 换 Mac 时跑一次 `clauderoam install`，配置就还原了；换账号时，登录凭证会被替换（这是对的），但你的所有自定义都还在
4. `clauderoam projects` 子命令还能管理你想在每台 Mac 上都拉下来的项目 repo 清单

## 跟同类工具的区别

GitHub 上已经有几个类似项目（renefichtmueller/claude-sync、balingsisi/claude-sync-tool 等），但都假设你**永远用同一个 Claude 账号**。我的项目专门为「换账号」这个场景设计 —— 这是现实里真会发生的事（公司从个人版升级到 Team、外包接客户的账号、离职、等等）。

另外是 README 中英双语，纯 bash（500 行），没有 daemon、没有 Python/Node 依赖。

## 安装

```bash
brew install YunyueLi/tap/clauderoam
clauderoam init
```

或者一键 curl|bash：

```bash
curl -fsSL https://raw.githubusercontent.com/YunyueLi/clauderoam/main/install.sh | bash
```

## 链接

GitHub: https://github.com/YunyueLi/clauderoam

文档里有中英双语 README、安装说明、和与同类项目的诚实对比。MIT 协议。

## FAQ 预答

- 会不会搞坏 Claude Code？不会，symlink 对它透明
- 私有 repo 还是公开？如果同步 memory 建议私有，否则公开也行
- 支持 Linux 吗？理论支持，纯 bash 工具
- 跟 Anthropic 官方有关系吗？没有，这是社区项目

欢迎反馈～
```

## 即刻 / 小红书 / 微信群（短版）

```
做了一个小工具叫 ClaudeRoam ↓

Claude Code 默认把配置存在本机 ~/.claude/，换 Mac / 换账号就全丢了。

ClaudeRoam 用 git + symlink 把这些配置变成跟你走的，新 Mac 上两行命令就能恢复：

  brew install YunyueLi/tap/clauderoam
  clauderoam init

也能管理"我有哪些项目"的清单，新 Mac 一键 git clone 全部。

500 行纯 bash，开源（MIT）：
https://github.com/YunyueLi/clauderoam

中英文档，欢迎试用反馈。
```

## 发帖后

- V2EX 评论区会问得很细，准备好答"为什么不用 chezmoi" "和 .files 有什么区别" 这类问题
- 小红书重点是好看的截图/封面 —— 可以截 `clauderoam doctor` 的彩色输出当封面
- 别同一天在多个群发同样内容，会被打 spam
