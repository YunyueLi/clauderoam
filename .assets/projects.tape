# projects.tape — show real registry + the directories that actually appear after clone-all

Output .assets/projects.gif

Set Shell "bash"
Set FontSize 15
Set Width 980
Set Height 540
Set Padding 20
Set Framerate 24
Set Theme "Catppuccin Mocha"
Set TypingSpeed 25ms

# ─── Hidden setup ─────────────────────────────────────────────────────
Hide

Type "rm -rf /tmp/proj-mac /tmp/proj-new && mkdir -p /tmp/proj-mac/clauderoam /tmp/proj-new/Code /tmp/proj-new/clauderoam"
Enter

# Seed a realistic projects.tsv in the 'old' Mac
Type "cat > /tmp/proj-mac/clauderoam/projects.tsv <<'EOF'"
Enter
Type "my-blog\tgit@github.com:me/my-blog.git\t~/Code/my-blog"
Enter
Type "startup-app\tgit@github.com:me/startup-app.git\t~/Code/startup-app"
Enter
Type "experiment-x\tgit@github.com:me/experiment-x.git\t~/Code/experiment-x"
Enter
Type "EOF"
Enter

# Also seed the 'new' Mac's clauderoam dir with the same projects.tsv so clone-all sees it
Type "cp /tmp/proj-mac/clauderoam/projects.tsv /tmp/proj-new/clauderoam/"
Enter

# Make local bare repos to simulate the three GitHub repos, so clone-all actually succeeds
Type "for p in my-blog startup-app experiment-x; do mkdir -p /tmp/proj-mac/seeds/$p && cd /tmp/proj-mac/seeds/$p && git init -q --initial-branch=main && echo $p > README.md && git config user.email a@b.c && git config user.name t && git add -A && git commit -q -m init && git init -q --bare /tmp/proj-mac/remotes/$p.git && git remote add origin /tmp/proj-mac/remotes/$p.git && git push -q -u origin main >/dev/null 2>&1; done"
Enter

# Rewrite projects.tsv on the 'new' Mac to point at the local bare repos
Type "cat > /tmp/proj-new/clauderoam/projects.tsv <<EOF"
Enter
Type "my-blog\t/tmp/proj-mac/remotes/my-blog.git\t/tmp/proj-new/Code/my-blog"
Enter
Type "startup-app\t/tmp/proj-mac/remotes/startup-app.git\t/tmp/proj-new/Code/startup-app"
Enter
Type "experiment-x\t/tmp/proj-mac/remotes/experiment-x.git\t/tmp/proj-new/Code/experiment-x"
Enter
Type "EOF"
Enter

# Start in the 'my Mac' view
Type "cd /tmp/proj-mac && export HOME=/tmp/proj-mac && export CLAUDEROAM_DATA=/tmp/proj-mac/clauderoam && export PS1='\033[36mmy-mac\033[0m:~$ ' && clear"
Enter
Show

# ═══════════════ ACT 1 — what's in my registry ═══════════════
Type "# What projects do I care about?"
Enter
Sleep 700ms

Type "cat ~/clauderoam/projects.tsv | column -t"
Enter
Sleep 3.5s

# ═══════════════ ACT 2 — new Mac, empty workspace ═══════════════
Type ""
Enter
Type "# ──────────  On a new Mac. ~/Code/ is empty.  ──────────"
Enter
Sleep 900ms

Hide
Type "export HOME=/tmp/proj-new && cd /tmp/proj-new && export CLAUDEROAM_DATA=/tmp/proj-new/clauderoam && export PS1='\033[33mnew-mac\033[0m:~$ '"
Enter
Show

Type "ls ~/Code/"
Enter
Sleep 1.4s

# ═══════════════ ACT 3 — one command, real directories appear ═══════════════
Type ""
Enter
Type "clauderoam projects clone-all"
Enter
Sleep 3.5s

Type ""
Enter
Type "ls ~/Code/"
Enter
Sleep 2s

Sleep 800ms
