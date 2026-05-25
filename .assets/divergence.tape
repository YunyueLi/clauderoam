# divergence.tape — v0.5.2's killer feature: auto-resolve memory-only divergence

Output .assets/divergence.gif

Set Shell "bash"
Set FontSize 17
Set Width 1200
Set Height 700
Set Padding 22
Set Theme "Catppuccin Mocha"
Set TypingSpeed 35ms

# Setup: stage a fake 2-Mac scenario via a local bare remote
Hide
Type "rm -rf /tmp/div-demo && mkdir -p /tmp/div-demo /tmp/div-claude"
Enter
Type "cd /tmp/div-demo"
Enter
Type "git init -q --bare --initial-branch=main remote.git"
Enter
Type "git init -q --initial-branch=main local"
Enter
Type "cd local && git config user.email a@b.c && git config user.name 'Mac A'"
Enter
Type "mkdir -p memory && echo init > CLAUDE.md && git add -A && git commit -q -m init"
Enter
Type "git remote add origin /tmp/div-demo/remote.git && git push -q -u origin main"
Enter
Type "git clone -q /tmp/div-demo/remote.git /tmp/div-demo/rwork"
Enter
Type "cd /tmp/div-demo/rwork && git config user.email b@b.c && git config user.name 'Mac B'"
Enter
Type "mkdir -p memory/proj-a && echo 'mac-A memory' > memory/proj-a/MEMORY.md"
Enter
Type "git add -A && git commit -q -m 'sync from Mac A' && git push -q"
Enter
Type "cd /tmp/div-demo/local && mkdir -p memory/proj-b && echo 'mac-B memory' > memory/proj-b/MEMORY.md"
Enter
Type "git add -A && git commit -q -m 'sync from Mac B'"
Enter
Type "export CLAUDEROAM_DATA=/tmp/div-demo/local CLAUDE_HOME=/tmp/div-claude PS1='$ '"
Enter
Type "clear"
Enter
Show

Type "# Two Macs both ran 'clauderoam push' within 30 minutes."
Enter
Sleep 600ms
Type "# Their sync commits diverged. v0.5.1 would fail here."
Enter
Sleep 800ms
Type "# v0.5.2 auto-resolves:"
Enter
Sleep 800ms
Type ""
Enter
Type "clauderoam push"
Enter
Sleep 5s
