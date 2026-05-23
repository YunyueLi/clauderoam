# memory/

Snapshots of Claude Code's per-project auto-memory, organized by project. Populated by `clauderoam sync`, restored by `clauderoam restore`.

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

⚠️  Project directory names embed the absolute path (`/` replaced by `-`). `clauderoam restore` rewrites the username portion automatically when restoring on a machine with a different username.
