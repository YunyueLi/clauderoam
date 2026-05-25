# projects.tape — show the project registry workflow

Output .assets/projects.gif

Set Shell "bash"
Set FontSize 18
Set Width 1100
Set Height 580
Set Padding 22
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms

# Setup (hidden)
Hide
Type "rm -rf /tmp/proj-demo && mkdir -p /tmp/proj-demo-claude && cd /tmp"
Enter
Type "export CLAUDEROAM_DATA=/tmp/proj-demo CLAUDE_HOME=/tmp/proj-demo-claude PS1='$ ' && clear"
Enter
Type "echo 'CLAUDE.md' > /tmp/init-cr.sh && echo 'mkdir -p /tmp/proj-demo && cd /tmp/proj-demo && git init -q && echo demo > CLAUDE.md && touch settings.json && mkdir -p agents commands skills memory' >> /tmp/init-cr.sh && bash /tmp/init-cr.sh && clear"
Enter
Show

Type "# register projects you want available on every Mac"
Enter
Sleep 600ms
Type "echo -e 'my-blog\ngit@github.com:you/my-blog.git\n~/Code/my-blog' | clauderoam projects add"
Enter
Sleep 2s
Type "echo -e 'startup-app\ngit@github.com:you/startup-app.git\n~/Code/startup-app' | clauderoam projects add"
Enter
Sleep 2s

Type "clear"
Enter
Type "# see what's registered"
Enter
Sleep 400ms
Type "clauderoam projects list"
Enter
Sleep 2.5s

Type "clear"
Enter
Type "# check status (which projects are cloned / clean / missing)"
Enter
Sleep 500ms
Type "clauderoam projects status"
Enter
Sleep 3s

Type "clear"
Enter
Type "# new Mac? one command pulls them all"
Enter
Sleep 500ms
Type "clauderoam projects clone-all --dry-run"
Enter
Sleep 3s

Sleep 1.5s
