# new-mac.tape — "fresh Mac to fully working" end-to-end demo
# Aim: ~55s, the full "I just got a new MacBook" story

Output .assets/new-mac.gif

Set Shell "bash"
Set FontSize 17
Set Width 1300
Set Height 760
Set Padding 24
Set Theme "Catppuccin Mocha"
Set TypingSpeed 38ms

# Setup
Hide
Type "rm -rf /tmp/newmac && mkdir -p /tmp/newmac/claude"
Enter
Type "export CLAUDEROAM_DATA=/tmp/newmac/clauderoam CLAUDE_HOME=/tmp/newmac/claude PS1='\033[36mnew-mac:~$\033[0m '"
Enter
# Pre-seed a 'remote' clauderoam-config so 'clone' has something to pull
Type "rm -rf /tmp/newmac/fake-remote.git /tmp/newmac/seed && mkdir -p /tmp/newmac/seed && cd /tmp/newmac/seed && git init -q -b main && echo -e '# My Claude Code Preferences\\n\\n- Name: Yunyue\\n- Language: 中文' > CLAUDE.md && cp /opt/homebrew/share/clauderoam/settings.json . && mkdir -p agents commands skills memory && cp /opt/homebrew/share/clauderoam/examples/agents/code-reviewer.md agents/ && cp /opt/homebrew/share/clauderoam/examples/agents/git-helper.md agents/ && cp /opt/homebrew/share/clauderoam/examples/commands/commit.md commands/ && cp /opt/homebrew/share/clauderoam/examples/commands/pr.md commands/ && cp /opt/homebrew/share/clauderoam/examples/commands/save.md commands/ && printf 'my-blog\\thttps://github.com/example/my-blog.git\\t/tmp/newmac/Code/my-blog\\nstartup-app\\thttps://github.com/example/startup-app.git\\t/tmp/newmac/Code/startup-app\\n' > projects.tsv && git config user.email a@b.c && git config user.name t && git add -A && git commit -q -m init && cd /tmp/newmac && git init -q --bare fake-remote.git && cd seed && git remote add origin /tmp/newmac/fake-remote.git && git push -q -u origin main >/dev/null 2>&1"
Enter
Type "cd ~ && clear"
Enter
Show

# Act 1: brand new Mac, nothing installed
Type "# Brand new Mac. Just got it set up."
Enter
Sleep 600ms
Type "# Step 1: install clauderoam"
Enter
Type "brew install YunyueLi/tap/clauderoam"
Enter
Sleep 1s
Type "# (already installed)"
Enter
Sleep 600ms

# Act 2: pull personal config
Type ""
Enter
Type "# Step 2: pull my personal config"
Enter
Type "git clone -q /tmp/newmac/fake-remote.git /tmp/newmac/clauderoam"
Enter
Sleep 800ms
Type "clauderoam install"
Enter
Sleep 3s

# Act 3: doctor confirms
Type "clear"
Enter
Type "# All my preferences, agents, commands — restored:"
Enter
Sleep 400ms
Type "ls /tmp/newmac/claude/agents /tmp/newmac/claude/commands"
Enter
Sleep 3s

# Act 4: projects clone-all
Type "clear"
Enter
Type "# Step 3: pull all my project repos"
Enter
Type "clauderoam projects clone-all --dry-run"
Enter
Sleep 3.5s

# Closer
Type "clear"
Enter
Type "# Total: 3 commands. Full dev environment, all preferences,"
Enter
Type "# all custom agents, all known projects — restored."
Enter
Sleep 1s
Type "# Time elapsed on a real Mac: ~2 minutes."
Enter
Sleep 2.5s
