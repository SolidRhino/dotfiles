# Style and Conventions

## Editor Config (.editorconfig)
- Charset: UTF-8
- Line endings: LF
- Default indent: tabs, size 2
- YAML/JSON: spaces, size 2
- TOML: spaces, size 2
- Insert final newline: yes
- Trim trailing whitespace: yes

## YAML (.yamllint.yaml)
- Max line length: 120 (warning, not error)
- Document start (`---`) disabled
- Truthy values: `true` / `false` only

## Shell Scripts
- All scripts use `#!/bin/bash` (never `#!/bin/sh`)
- All scripts use `set -eufo pipefail`
- Scripts should fail loudly on critical errors
- Plain `.sh` files are shellchecked directly
- Representative `.sh.tmpl` scripts are rendered and shellchecked in CI
- CI shellchecks plain scripts: `.install-op-and-age.sh`, `run_before_00-write-age-identity.sh`, `run_once_after_25-setup-op-gh-plugin.sh`, `executable_oscar-update`
- Scripts use numeric prefixes for ordering (`before_10`, `after_20`, etc.)
- Scripts that depend on tools should guard with `command -v <tool>` checks where appropriate

## Chezmoi Templates
- Machine conditionals use `.chezmoi.os`, `.osid`, `.personal`, `.headless`, `.ephemeral`, `.hostname`
- Secrets in templates: `onepasswordRead`
- Secrets in scripts: `op read` is allowed in chezmoi scripts and bootstrap helpers
- Never use `op read` in Fish config files

## Ephemeral Gating
- Scripts that should not run on CI/Codespaces/containers are wrapped in `{{ if not .ephemeral -}} ... {{ end -}}`
- The shebang and `set -eufo pipefail` stay inside the template guard
- Ephemeral-gated scripts include Rust/mise install, cargo install, mise tools, default shell, and Fish completion regeneration

## Package / Bootstrap Layout
- Package declarations live in `home/.chezmoidata/packages.yaml`
- Linux repo bootstrap is consolidated in `home/.chezmoiscripts/linux/run_onchange_before_10-setup-package-repos.sh.tmpl`
- Linux package install is handled in `home/.chezmoiscripts/linux/run_onchange_before_20-install-packages.sh.tmpl`
- Arch uses `yay` for normal package installation; `yay` must not be run with `sudo`
- Cargo packages use crate names in `packages.yaml`
- Cargo install flow prefers `cargo-binstall` and falls back to `cargo install --locked`

## Fish Config
- Modular layout: `conf.d/` loads alphabetically
- `aliases.fish` is for tool replacements/navigation
- `abbreviations.fish` is for workflow shortcuts
- Fish abbreviations are preferred over aliases for workflow shortcuts
- `reload` uses `exec fish`
- `EDITOR`/`VISUAL` in `path.fish` cascades `nvim -> vim -> vi`

## mise Config
- `home/dot_config/mise/config.toml.tmpl` is a Go template
- Use OS guards for darwin-only tools
- Version policy:
  - `latest` for fast-moving dev tools
  - `lts` for ecosystem runtimes with long support windows
  - major pins like `ruby = "4"` to track the current stable line without full pin churn
- `[settings.ruby] compile = false` prefers precompiled Ruby when available

## Age Encryption / 1Password Bootstrap
- Chezmoi decrypts `.age` files using `~/.config/chezmoi/age-key.txt`
- Current transition state:
  - preferred path: local `hooks.read-source-state.pre` hook calling `.install-op-and-age.sh`
  - fallback path: `home/.chezmoiscripts/run_before_00-write-age-identity.sh`
- Both paths validate `AGE-SECRET-KEY-` and use atomic replacement when writing key material
- Age public key is hardcoded in `.chezmoi.toml.tmpl`
- Encrypted files use the `encrypted_` prefix

## Topgrade / Docker / Mackup
- `home/dot_config/topgrade.toml.tmpl` defines custom topgrade commands
- Colima is the macOS container runtime; no Docker Desktop
- When adding a file to chezmoi, also update Mackup ignore settings if Mackup could otherwise manage it

## CHANGELOG
- Never run `git-cliff` locally; GitHub Actions updates `CHANGELOG.md`
