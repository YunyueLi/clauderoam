# hero.tape — polished hero demo for README
# Aim: ~20s, tight, satisfying

Output .assets/hero.gif

Set Shell "bash"
Set FontSize 19
Set Width 1200
Set Height 680
Set Padding 24
Set Theme "Catppuccin Mocha"
Set TypingSpeed 50ms

# Setup (hidden — make it look like a brand-new machine)
Hide
Type "rm -rf /tmp/hero-data /tmp/hero-claude && mkdir -p /tmp/hero-claude"
Enter
Type "export CLAUDEROAM_DATA=/tmp/hero-data CLAUDE_HOME=/tmp/hero-claude PS1='\033[36m$\033[0m '"
Enter
Type "clear"
Enter
Show

# Act 1: install
Type "brew install YunyueLi/tap/clauderoam"
Enter
Sleep 1.2s
Type "# (already installed — would take ~10s on a fresh Mac)"
Enter
Sleep 800ms

# Act 2: init (one command does it all)
Type ""
Enter
Type "clauderoam init"
Enter
Sleep 1.5s
Type "Yunyue"
Sleep 300ms
Enter
Sleep 800ms
Type "zh"
Sleep 300ms
Enter
Sleep 4s

# Act 3: doctor proves it works
Type "clear"
Enter
Type "clauderoam doctor"
Enter
Sleep 3.5s

Sleep 1.5s
