# CLAUDE.md

Chezmoi dotfiles repo (macOS + Linux).

## Read This First

- Serena memories are the primary source of detailed project context and conventions
- Read all project Serena memories before making changes
- Use `CLAUDE.md` only for short, repo-wide rules that must stay highly visible
- Do not duplicate detailed conventions from Serena memories here unless they are truly critical

## Critical Rules

- `home/` is the chezmoi root — all managed files live there and map to `$HOME`
- All scripts use `#!/bin/bash` and `set -eufo pipefail` — never `#!/bin/sh`
- Never use `op read` in Fish config — use `onepasswordRead` in `.tmpl` files instead
- `op read` is allowed in chezmoi scripts because they run at apply time, not shell startup
- Age public key is hardcoded in `.chezmoi.toml.tmpl` — only the private key requires 1Password access
- Scripts should fail loudly on errors, not silently swallow them

## Source of Truth

- Detailed conventions, package nuances, platform differences, validation steps, and workflow notes live in Serena memories
- If `CLAUDE.md` and Serena memory ever overlap, prefer keeping the detail in Serena memory and keeping `CLAUDE.md` minimal
