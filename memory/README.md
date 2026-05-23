# memory/

Snapshots of Claude Code's per-project auto-memory, organized by project.
Populated by `sync-memory.sh`, restored by `restore-memory.sh`.

Directory layout:
```
memory/
  -Users-<you>-Desktop-<project>/
    MEMORY.md              # index file (always loaded)
    user_*.md              # info about you
    feedback_*.md          # workflow corrections
    project_*.md           # project state
    reference_*.md         # external system pointers
```

⚠️  Project directory names embed the absolute path (with `/` replaced by `-`).
`restore-memory.sh` rewrites the username portion when restoring to a different
machine.
