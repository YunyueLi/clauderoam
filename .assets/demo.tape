# vhs tape — record clauderoam in action
#
# Build:  vhs .assets/demo.tape

Output .assets/demo.gif

Set Shell "bash"
Set FontSize 18
Set Width 1100
Set Height 600
Set Padding 22
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms

# Hidden setup
Hide
Type "rm -rf /tmp/cr-demo /tmp/cr-demo-claude && mkdir -p /tmp/cr-demo-claude /tmp/cr-demo"
Enter
Type "export CLAUDEROAM_DATA=/tmp/cr-demo CLAUDE_HOME=/tmp/cr-demo-claude PS1='$ '"
Enter
Type "clear"
Enter
Show

# Step 1: install
Type "# install via Homebrew"
Enter
Sleep 500ms
Type "brew install YunyueLi/tap/clauderoam"
Enter
Sleep 1s
Type "# (already installed)"
Enter
Sleep 800ms
Type "clear"
Enter

# Step 2: init
Type "# create your config repo + symlink into ~/.claude/"
Enter
Sleep 500ms
Type "echo -e 'Demo User\nen' | clauderoam init"
Enter
Sleep 3.5s
Type "clear"
Enter

# Step 3: doctor
Type "# health check"
Enter
Sleep 400ms
Type "clauderoam doctor"
Enter
Sleep 2.5s
Type "clear"
Enter

# Step 4: projects
Type "# track project repos you want on every Mac"
Enter
Sleep 500ms
Type "echo -e 'octocat\nhttps://github.com/octocat/Hello-World.git\n~/projects/octocat' | clauderoam projects add"
Enter
Sleep 1.5s
Type "clauderoam projects list"
Enter
Sleep 2.5s

# Closer
Type "# brew install YunyueLi/tap/clauderoam"
Enter
Sleep 2s
