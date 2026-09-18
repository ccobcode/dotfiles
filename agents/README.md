# Agent preferences

`AGENTS.md` is the canonical global instruction file. The installer links it to:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`
- `~/.config/opencode/AGENTS.md`

`skills.lock` pins the Ponytail skills source. The installer links every pinned
skill into `~/.codex/skills` and `~/.claude/skills` while leaving bundled/system
skills untouched. OpenCode discovers the Claude-compatible directory directly,
so it does not receive duplicate skill definitions.
