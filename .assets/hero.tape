# hero.tape — 3-act before/empty/restored, focused on visible artifacts

Output .assets/hero.gif

Set Shell "bash"
Set FontSize 15
Set Width 980
Set Height 580
Set Padding 20
Set Framerate 24
Set Theme "Catppuccin Mocha"
Set TypingSpeed 25ms

# ─── Hidden setup ───────────────────────────────────────────────────────
Hide
Type "rm -rf /tmp/hero-mac /tmp/hero-new && mkdir -p /tmp/hero-mac/clauderoam/{agents,commands,skills,memory} /tmp/hero-mac/.claude /tmp/hero-new /tmp/hero-new/.claude"
Enter

# Build a realistic personal CLAUDE.md
Type "cat > /tmp/hero-mac/clauderoam/CLAUDE.md <<'EOF'"
Enter
Type "# My Claude Code Preferences"
Enter
Type ""
Enter
Type "## About me"
Enter
Type "- Name: Alex"
Enter
Type "- Preferred response language: en"
Enter
Type ""
Enter
Type "## Communication"
Enter
Type "- Be concise; lists over paragraphs"
Enter
Type "- Skip the trailing 'summary' — the diff is the summary"
Enter
Type "- No emojis unless I ask"
Enter
Type "EOF"
Enter

# Bring in real agents and commands
Type "cp /opt/homebrew/share/clauderoam/examples/agents/code-reviewer.md /tmp/hero-mac/clauderoam/agents/ && cp /opt/homebrew/share/clauderoam/examples/agents/git-helper.md /tmp/hero-mac/clauderoam/agents/ && cp /opt/homebrew/share/clauderoam/examples/commands/commit.md /tmp/hero-mac/clauderoam/commands/ && cp /opt/homebrew/share/clauderoam/examples/commands/pr.md /tmp/hero-mac/clauderoam/commands/ && cp /opt/homebrew/share/clauderoam/examples/commands/save.md /tmp/hero-mac/clauderoam/commands/ && cp /opt/homebrew/share/clauderoam/settings.json /tmp/hero-mac/clauderoam/"
Enter

# Wire the 'old Mac' symlinks
Type "CLAUDEROAM_DATA=/tmp/hero-mac/clauderoam CLAUDE_HOME=/tmp/hero-mac/.claude clauderoam install >/dev/null 2>&1"
Enter

# Set up a fake remote so 'git clone' in Act 3 has something to fetch
Type "cd /tmp/hero-mac/clauderoam && git init -q --initial-branch=main && git config user.email a@b.c && git config user.name t && git add -A && git commit -q -m init && git init -q --bare /tmp/hero-mac/remote.git && git remote add origin /tmp/hero-mac/remote.git && git push -q -u origin main"
Enter

# Switch to the 'old Mac' view
Type "cd /tmp/hero-mac && export HOME=/tmp/hero-mac && export PS1='\033[36mmy-mac\033[0m:~$ ' && clear"
Enter
Show

# ═══════════════ ACT 1 — what's on my current Mac ═══════════════
Type "# What's in my Claude Code setup right now?"
Enter
Sleep 800ms

Type "ls ~/.claude/"
Enter
Sleep 1.3s

Type ""
Enter
Type "head -8 ~/.claude/CLAUDE.md"
Enter
Sleep 2.6s

Type ""
Enter
Type "ls ~/.claude/agents/ ~/.claude/commands/"
Enter
Sleep 2.0s

# ═══════════════ ACT 2 — imagine a new Mac ═══════════════
Type ""
Enter
Type "# ──────────  Imagine a brand-new Mac. Everything gone.  ──────────"
Enter
Sleep 1s

Hide
Type "export HOME=/tmp/hero-new && cd /tmp/hero-new && export PS1='\033[33mnew-mac\033[0m:~$ '"
Enter
Show

Type "ls ~/.claude/"
Enter
Sleep 1.4s

# ═══════════════ ACT 3 — three commands restore everything ═══════════════
Type ""
Enter
Type "# Three commands:"
Enter
Sleep 700ms

Type "brew install YunyueLi/tap/clauderoam   "
Sleep 200ms
Type "# already installed in this demo"
Enter
Sleep 700ms

Type "git clone /tmp/hero-mac/remote.git ~/clauderoam"
Enter
Sleep 1.2s

Type "clauderoam install"
Enter
Sleep 2.0s

Type ""
Enter
Type "# Same artifacts. Back."
Enter
Sleep 500ms

Type "ls ~/.claude/ && head -8 ~/.claude/CLAUDE.md"
Enter
Sleep 3s
