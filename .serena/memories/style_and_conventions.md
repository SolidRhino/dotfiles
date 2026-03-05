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

## Package Naming
- `packages.common` uses Homebrew/dnf names
- Known apt differences handled in `packages.apt`:
  - `fd` → `fd-find`
  - `gh` → comes from dedicated repo script (not packages.apt)
- Known pacman differences in `packages.pacman`:
  - `gh` → `github-cli`
  - `tree-sitter-cli` → `tree-sitter`
- `1password-cli` explicitly listed for apt, dnf, pacman; macOS uses cask

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
