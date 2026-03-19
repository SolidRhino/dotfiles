# CLAUDE.md

Chezmoi dotfiles repo (macOS + Linux). See Serena memories for full conventions.

## Critical Rules

- `home/` is the chezmoi root — all managed files live here, mapping to `$HOME`
- All scripts use `#!/bin/bash` and `set -eufo pipefail` — never `#!/bin/sh`
- **Never** use `op read` in Fish config — bake secrets via `onepasswordRead` in `.tmpl` files
- `op read` IS allowed in chezmoi scripts (they run at apply time, not shell startup)
- Age public key is hardcoded in `.chezmoi.toml.tmpl` — only the private key needs 1Password auth
- Scripts should fail loudly on errors, not silently swallow them
