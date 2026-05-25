# doctor.tape — show the health-check output

Output .assets/doctor.gif

Set Shell "bash"
Set FontSize 18
Set Width 1100
Set Height 620
Set Padding 22
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms

# Setup: install clauderoam into a temp env so doctor has stuff to check
Hide
Type "rm -rf /tmp/doc-data /tmp/doc-claude && mkdir -p /tmp/doc-claude"
Enter
Type "export CLAUDEROAM_DATA=/tmp/doc-data CLAUDE_HOME=/tmp/doc-claude PS1='$ '"
Enter
Type "echo -e 'demo-user\nen' | clauderoam init >/dev/null 2>&1"
Enter
Type "clear"
Enter
Show

Type "# how do I know everything is wired up correctly?"
Enter
Sleep 700ms
Type "clauderoam doctor"
Enter
Sleep 4s
