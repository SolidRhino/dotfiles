# CLAUDE.md

Chezmoi dotfiles repo (macOS + Linux). See Serena memories for full conventions.

## Critical Rules

- `home/` is the chezmoi root — all managed files live here, mapping to `$HOME`
- **Never** use `op read` at shell startup or in Fish config — bake secrets via `onepasswordRead` in `.tmpl` files at `chezmoi apply` time only
- All scripts use `set -eufo pipefail`
- Secrets require `op` authenticated at `chezmoi apply` time
