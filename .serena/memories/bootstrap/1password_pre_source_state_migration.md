# 1Password Pre-Source-State Bootstrap Migration

## Status
In progress, implemented locally but not committed yet.

## Files changed
- `.install-op-and-age.sh` (new)
- `home/.chezmoiscripts/run_before_00-write-age-identity.sh`
- `README.md`
- `.github/workflows/lint.yml`
- plan docs also exist in `docs/plans/2026-03-24-1password-bootstrap-design.md` and `docs/plans/2026-03-24-1password-bootstrap.md`

## What changed
- Added a repo-root bootstrap helper intended for a local `hooks.read-source-state.pre` hook.
- Helper behavior:
  - exits immediately in CI
  - exits if existing age key looks valid
  - installs `op` on macOS/Linux when possible
  - supports privilege escalation via root or sudo
  - validates key contents before replacing the target file
  - handles Homebrew fallback paths on macOS
- Converted `run_before_00-write-age-identity.sh` into a fallback path only.
- Fallback script now uses atomic temp-file writes and validates age-key contents.
- README now documents `chezmoi init` -> append local hook config -> `chezmoi apply`.
- README includes notes for existing machines, duplicate hook-table edge case, unsupported Linux, macOS/Homebrew expectation, and Arch stale package DB.
- CI now shellchecks `.install-op-and-age.sh` and runs `CI=1 bash .install-op-and-age.sh`.
- Added comments in workflow noting duplicated matrix/template allowlists must stay in sync.

## Verification already run
- `shellcheck .install-op-and-age.sh`
- `shellcheck home/.chezmoiscripts/run_before_00-write-age-identity.sh`
- `CI=1 bash .install-op-and-age.sh`
- workflow YAML parsed successfully

## Review feedback already incorporated
- Avoid overwriting existing `~/.config/chezmoi/chezmoi.toml` in docs
- Warn about duplicate `[hooks.read-source-state.pre]` section
- Harden helper for sudo/root handling
- Improve distro detection with command checks and `ID_LIKE`
- Avoid `pacman -Sy`
- Validate `op read` output before installing key
- Make fallback script atomic and validate existing key
- Fix brew fallback path handling by exporting PATH and tracking `OP_BIN`

## Suggested commit split
1. `feat: add pre-source-state 1Password bootstrap helper`
2. `fix: harden fallback age key hydration`
3. `docs: document pre-source-state 1Password bootstrap`
4. `ci: validate bootstrap helper in lint workflow`
