# Style and Conventions

## Editor Config (.editorconfig)
- Charset: UTF-8
- Line endings: LF
- Default indent: tabs, size 2
- YAML/JSON: spaces, size 2
- Insert final newline: yes
- Trim trailing whitespace: yes

## YAML (.yamllint.yaml)
- Max line length: 120 (warning, not error)
- Document start (`---`) disabled
- Truthy values: `true` / `false` only

## Shell Scripts
- All scripts use `set -eufo pipefail` (strict mode)
- Scripts are only shellchecked if they are plain `.sh` (not `.sh.tmpl`) — templates have chezmoi/Go template syntax that shellcheck doesn't understand
- Scripts use numeric prefixes for ordering (e.g., `before_10`, `after_20`)

## Chezmoi Templates (Go templates)
- Machine conditionals: `{{- if eq .chezmoi.os "darwin" }}` for macOS-only
- Use `.personal`, `.headless`, `.ephemeral`, `.hostname`, `.osid` variables
- Secrets: use `onepasswordRead` at template render time, never `op read` at shell runtime

## Ephemeral Gating
- Scripts that should not run on CI/Codespaces/containers are wrapped in `{{ if not .ephemeral -}}` ... `{{ end -}}`
- The shebang and `set -eufo pipefail` go INSIDE the guard (they are part of the rendered script)
- Scripts gated on ephemeral: `run_once_after_10-install-rust.sh.tmpl`, `run_onchange_after_20-install-cargo-packages.sh.tmpl`, `run_onchange_after_21-install-mise-tools.sh.tmpl`, `run_onchange_after_30-set-default-shell.sh.tmpl`, `run_onchange_after_40-fish-update-completions.sh.tmpl`
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
- **File separation**: `aliases.fish` = tool replacements + navigation only (eza, bat, rg, nvim, lg, `..`); `abbreviations.fish` = all workflow shortcuts (git, docker, chezmoi, topgrade)
- Fish abbreviations (inline-expanding) are preferred over aliases for workflow shortcuts

## mise Config
- `home/dot_config/mise/config.toml.tmpl` — Go template for OS-specific tools
- Use `{{- if eq .chezmoi.os "darwin" }}` for macOS-only tools

## Cargo Package Naming
- Cargo crate name ≠ binary name in some cases: `git-delta` installs the `delta` binary
- Always use the crate name in `packages.cargo` in `packages.yaml`

## CHANGELOG
- **Never** run `git-cliff` locally — GitHub Actions handles `CHANGELOG.md` automatically

## Mackup + Chezmoi Overlap
- When adding a file to chezmoi, also add the app to `applications_to_ignore` in `dot_mackup.cfg.tmpl`
- Currently ignored: fish, git, lazygit, mackup, mise, nvim, ssh, starship, wget
