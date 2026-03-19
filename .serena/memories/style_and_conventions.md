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
- All scripts use `#!/bin/bash` shebang (never `#!/bin/sh` — POSIX sh doesn't support `pipefail`)
- All scripts use `set -eufo pipefail` (strict mode)
- Scripts should fail loudly on errors — never silently swallow failures with `2>/dev/null` on critical operations
- Scripts are only shellchecked if they are plain `.sh` (not `.sh.tmpl`) — templates have chezmoi/Go template syntax that shellcheck doesn't understand
- CI shellchecks: `run_before_00-write-age-identity.sh`, `run_once_after_25-setup-op-gh-plugin.sh`, `executable_oscar-update`
- Scripts use numeric prefixes for ordering (e.g., `before_10`, `after_20`)
- Scripts that depend on external tools should guard with `command -v <tool>` checks

## Chezmoi Templates (Go templates)
- Machine conditionals: `{{- if eq .chezmoi.os "darwin" }}` for macOS-only
- Use `.personal`, `.headless`, `.ephemeral`, `.hostname`, `.osid` variables
- Secrets in templates: use `onepasswordRead` at template render time
- Secrets in scripts: `op read` is allowed in chezmoi scripts (they run at apply time, not shell startup)
- Never use `op read` in Fish config files (slow / unreliable when 1Password locked)

## Ephemeral Gating
- Scripts that should not run on CI/Codespaces/containers are wrapped in `{{ if not .ephemeral -}}` ... `{{ end -}}`
- The shebang and `set -eufo pipefail` go INSIDE the guard (they are part of the rendered script)
- Scripts gated on ephemeral: `run_once_after_10-install-rust.sh.tmpl`, `run_once_after_19-install-mise.sh.tmpl`, `run_onchange_after_20-install-cargo-packages.sh.tmpl`, `run_onchange_after_21-install-mise-tools.sh.tmpl`, `run_onchange_after_30-set-default-shell.sh.tmpl`, `run_onchange_after_40-fish-update-completions.sh.tmpl`
- Scripts gated on headless: Atuin login (`not .headless`)
- Scripts with runtime TTY check (no template gate needed): `run_once_after_25-setup-op-gh-plugin.sh`

## AUR Support (Arch Linux)
- yay is used instead of pacman for all Arch package installs — yay wraps pacman and also handles AUR
- yay must NOT be run with `sudo` — it handles privilege escalation internally
- `linux/run_onchange_before_15-install-aur-helper.sh.tmpl` bootstraps yay: installs `git base-devel` via pacman, builds yay with `makepkg -si --noconfirm --rmdeps` (--rmdeps removes go after build), then removes git + base-devel (reinstalled by yay in before_20)
- AUR packages go in `packages.aur` in `packages.yaml`; currently empty scaffold (`aur: []`)
- The Arch install command: `yay -S --noconfirm --needed {{ concat .packages.aur .packages.pacman (...) }}`

## Package Naming
- `packages.common` uses Homebrew/dnf names
- Known apt differences handled in `packages.apt`:
  - `fd` → `fd-find`
  - `gh` → comes from dedicated repo script (not packages.apt)
- Known pacman differences in `packages.pacman`:
  - `gh` → `github-cli`
  - `tree-sitter-cli` → `tree-sitter`
- `1password-cli` explicitly listed for apt, dnf, pacman; macOS uses cask

## Fish Completions
- Tool completions live in `home/dot_config/fish/completions/`
- Use `{{ output "tool" "completion" "fish" -}}` in a `.tmpl` file to auto-generate at apply time (e.g. `mise.fish.tmpl`)
- `usage-cli` (cargo) is required for `mise completion fish` to work — already in `packages.cargo`
- Use `run_onchange_after_40-fish-update-completions.sh.tmpl` to regenerate man-page completions; triggered by a `# Packages: {{ concat .packages.cargo .packages.common | join ", " }}` comment so it reruns when packages change

## Fish Config
- Modular layout: `conf.d/` files load alphabetically
- No `op read` calls in Fish config (slow / unreliable when 1Password locked)
- Homebrew shellenv handled in `homebrew.fish.tmpl` (macOS only)
- **File separation**: `aliases.fish` = tool replacements + navigation only (eza, bat, rg, nvim, lg, `..`, reload); `abbreviations.fish` = all workflow shortcuts (git, docker, chezmoi, topgrade)
- Fish abbreviations (inline-expanding) are preferred over aliases for workflow shortcuts
- `reload` alias uses `exec fish` (restarts shell entirely, ensuring all conf.d/ files reload)
- `EDITOR`/`VISUAL` in `path.fish` uses cascading fallback: nvim → vim → vi

## mise Config
- `home/dot_config/mise/config.toml.tmpl` — Go template for OS-specific tools
- Use `{{- if eq .chezmoi.os "darwin" }}` for macOS-only tools

## Cargo Package Naming
- Cargo crate name ≠ binary name in some cases: `git-delta` installs the `delta` binary
- Always use the crate name in `packages.cargo` in `packages.yaml`

## Age Encryption
- Chezmoi decrypts `.age` files using `~/.config/chezmoi/age-key.txt` (written by `run_before_00-write-age-identity.sh` from 1Password: `op://Private/chezmoi-age/private`)
- Age **private** key: fetched fresh on every `chezmoi apply` via `op read` in `run_before_00` (plain `run_before_*`, not `run_once_*`). If `op` is missing → warning + exit 0; if `op read` fails → error + exit 1.
- Age **public** key (recipient): hardcoded directly in `.chezmoi.toml.tmpl` — it's not sensitive and avoids requiring 1Password auth just to render the chezmoi config
- Encrypted files use the `encrypted_` prefix in chezmoi source
- After apply, `run_after_50-extract-archive.sh.tmpl` extracts the decrypted archive if a JetBrains product is installed; skips otherwise (tar.gz stays on disk)
- `.chezmoiignore` conditionally excludes `x7k9m2p.tar.gz` via `stat (joinPath .chezmoi.homeDir ...)` — when no JetBrains dir exists, chezmoi ignores the file entirely (re-evaluated on every apply)

## Custom Mackup App Configs
- `home/dot_mackup/*.cfg.tmpl` — custom Mackup application definitions for apps not in Mackup's built-in registry
- These are Go templates; use `{{ output "sh" "-c" "..." }}` to dynamically list paths (e.g. JetBrains versioned dirs)
- Each file defines `[application]` + `[configuration_files]` sections in Mackup's INI format

## Topgrade Config
- `home/dot_config/topgrade.toml.tmpl` — custom `[commands]` section for tools topgrade doesn't know about
- Current custom commands: `Chezmoi Externals`, `Mackup Backup` (macOS), `OSCAR` (macOS)

## CHANGELOG
- **Never** run `git-cliff` locally — GitHub Actions handles `CHANGELOG.md` automatically

## Mackup + Chezmoi Overlap
- When adding a file to chezmoi, also add the app to `applications_to_ignore` in `dot_mackup.cfg.tmpl`
- Currently ignored: fish, git, lazygit, mackup, mise, neovim, ssh, starship, wget
- Note: mackup app name is `neovim` (not `nvim`) — nvim config is managed via `.chezmoiexternal.toml.tmpl` as a git repo
