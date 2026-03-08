# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository managing development environment configuration across macOS and Linux. It uses 1Password for secrets management and Fish shell as the primary shell.

## Chezmoi Conventions

- **`home/`** is the chezmoi root (set in `.chezmoiroot`); all managed files live here and map to `$HOME`
- `dot_` prefix → `.` in target (e.g., `dot_config/` → `~/.config/`)
- `private_` prefix → file is written with mode `600`
- `empty_` prefix → creates an empty file
- `.tmpl` suffix → Go template; supports conditionals and variable substitution
- `.chezmoidata/packages.yaml` declares packages for cross-platform installs
- `home/.chezmoi.toml.tmpl` computes machine-type variables on first apply

## Machine Type Variables (from .chezmoi.toml.tmpl)

Available in all templates as `.personal`, `.headless`, `.ephemeral`, `.hostname`, `.osid`:

- `osid` — combined OS+distro string: `"darwin"`, `"linux-ubuntu"`, `"linux-arch"`, etc.
- `personal` — true on personal machines (prompted once on first apply)
- `headless` — true on servers/CI without a display
- `ephemeral` — true in Codespaces, containers, CI environments

## Script Naming & Structure

Scripts in `home/.chezmoiscripts/` follow chezmoi conventions:
- `run_once_*` — runs only once per machine
- `run_onchange_*` — runs when the rendered script content changes
- `run_*` (no modifier) — runs on every `chezmoi apply`
- `before_` / `after_` — timing relative to file changes
- Numeric prefixes enforce execution order within the same timing group
- All scripts use `set -eufo pipefail`

Scripts are organised into subdirectories:
- `darwin/` — macOS-only scripts (still require `{{ if eq .chezmoi.os "darwin" }}` internally)
- `linux/` — Linux-only scripts (use `.osid` for distro-specific logic)
- Top-level — cross-platform scripts (rust, cargo packages, default shell, op plugin)

### Script Execution Order

| Step | Script | Type | Purpose |
|------|--------|------|---------|
| before 00 | `run_before_00-write-age-identity.sh` | always | Write age key from 1Password for encrypted file decryption |
| before 10 | `darwin/run_onchange_before_10-install-packages.sh.tmpl` | onchange | Homebrew + packages (macOS) |
| before 10 | `linux/run_onchange_before_10-install-gh.sh.tmpl` | onchange | GitHub CLI apt repo |
| before 10 | `linux/run_onchange_before_10-install-git-lfs.sh.tmpl` | onchange | git-lfs apt repo |
| before 10 | `linux/run_onchange_before_10-install-op.sh.tmpl` | onchange | 1Password CLI apt/rpm repo |
| before 15 | `linux/run_onchange_before_15-install-aur-helper.sh.tmpl` | onchange | Install yay AUR helper (Arch only) |
| before 20 | `linux/run_onchange_before_20-install-packages.sh.tmpl` | onchange | System packages (Linux) |
| after 10 | `run_once_after_10-install-rust.sh.tmpl` | once | Install Rust via rustup (skipped on ephemeral) |
| after 20 | `run_onchange_after_20-install-cargo-packages.sh.tmpl` | onchange | Install cargo packages (skipped on ephemeral) |
| after 21 | `run_onchange_after_21-install-mise-tools.sh.tmpl` | onchange | Install mise-managed runtimes (skipped on ephemeral) |
| after 25 | `run_once_after_25-setup-op-gh-plugin.sh` | once | 1Password GitHub CLI plugin |
| after 26 | `darwin/run_once_after_26-install-setapp-cli.sh.tmpl` | once | Install setapp-cli binary |
| after 27 | `darwin/run_onchange_after_27-install-setapp-apps.sh.tmpl` | onchange | Install Setapp apps from bundle |
| after 28 | `darwin/run_after_28-install-oscar.sh.tmpl` | always | Install/update OSCAR via `~/.local/bin/oscar-update` (macOS) |
| after 30 | `run_onchange_after_30-set-default-shell.sh.tmpl` | onchange | Set Fish as default shell (skipped on ephemeral) |
| after 35 | `run_once_after_35-login-atuin.sh.tmpl` | once | Log in to Atuin sync |
| after 40 | `run_onchange_after_40-fish-update-completions.sh.tmpl` | onchange | Regenerate Fish man-page completions |
| after 50 | `run_after_50-extract-archive.sh.tmpl` | always | Extract age-decrypted archive to `~/.local/share/` |
| after | `darwin/run_once_after_install-claude-code.sh.tmpl` | once | Install Claude Code (macOS) |
| after | `darwin/run_once_after_mackup-restore.sh.tmpl` | once | Restore GUI app settings via Mackup (macOS) |

## Linux Package Management Strategy

**Arch-based** (Arch, Manjaro, EndeavourOS): `yay` (AUR helper wrapping pacman) — rolling release always has latest versions; AUR packages available via `packages.aur`.

**apt-based** (Ubuntu, Debian, Mint, Pop!_OS): native `apt` with upstream repos added by dedicated per-tool scripts for tools where distro versions lag significantly:
- `linux/run_onchange_before_10-install-gh.sh.tmpl` — GitHub CLI official apt repo
- `linux/run_onchange_before_10-install-git-lfs.sh.tmpl` — Packagecloud apt repo
- `linux/run_onchange_before_10-install-op.sh.tmpl` — 1Password CLI official apt repo

**dnf-based** (Fedora, RHEL, Rocky, AlmaLinux): native `dnf` with upstream repo added for:
- `linux/run_onchange_before_10-install-op.sh.tmpl` — 1Password CLI official RPM repo

**mise** manages language runtime versions (node, python, go, ruby). Installed via `packages.cargo`. Global tool config at `home/dot_config/mise/config.toml.tmpl` (Go template); Fish init at `home/dot_config/fish/conf.d/mise.fish`. Adding a new runtime means adding a line to `config.toml.tmpl` — the `run_onchange_after_21` script reruns automatically.

## Package Naming Differences (packages.yaml)

`packages.common` uses brew/dnf names. Known differences handled in templates:
- `fd` → `fd-find` on apt (added to `packages.apt`)
- `gh` → `github-cli` on pacman (added to `packages.pacman`); apt gets it from the dedicated gh repo script
- `1password-cli` — added to `packages.apt`, `packages.dnf`, and `packages.pacman`; macOS gets it as a cask via `packages.darwin.casks`

## Fish Shell Configuration

Modular layout under `home/dot_config/fish/`:
- `config.fish` — entry point, sources `conf.d/` (alphabetical load order)
- `conf.d/abbreviations.fish` — Git, Docker, chezmoi, and `upd` → topgrade abbreviations
- `conf.d/aliases.fish` — command aliases with fallbacks (bat/cat, eza/ls, rg/grep, nvim/vi)
- `conf.d/atuin.fish` — Atuin shell history initialisation
- `conf.d/claude.fish.tmpl` — sets `CLAUDE_CODE_OAUTH_TOKEN` baked in at `chezmoi apply` time via `onepasswordRead` (macOS only)
- `conf.d/homebrew.fish.tmpl` — Homebrew shellenv (macOS only; handles both Apple Silicon and Intel)
- `conf.d/op-plugins.fish` — sources `~/.config/op/plugins.sh` when present
- `conf.d/path.fish` — PATH (`~/.local/bin`, `~/.cargo/bin`) and env vars; `EDITOR=nvim`
- `conf.d/starship.fish` — Starship prompt initialisation
- `conf.d/zoxide.fish` — zoxide initialisation (`--cmd cd` replaces `cd`)
- `completions/mise.fish.tmpl` — mise Fish completions (generated via `{{ output ... }}`)
- `completions/chezmoi.fish.tmpl` — chezmoi Fish completions

## Key Chezmoi Commands

```fish
chezmoi apply          # Apply dotfiles to home directory
chezmoi diff           # Preview pending changes
chezmoi edit <file>    # Edit a managed file
chezmoi add <file>     # Track a new file
chezmoi cd             # cd into this repo
```

Fish abbreviations: `czap`, `czed`, `czdf`, `czad`, `czcd`.

## 1Password Integration

All secrets use **apply-time** resolution via `onepasswordRead` in `.tmpl` files. The secret is baked into the rendered file during `chezmoi apply` and requires `op` to be authenticated at that point.

**Never use `op read` at shell startup or in Fish config.** Runtime `op read` calls block every new shell until 1Password responds, which makes the shell slow and unreliable when the app is locked or unavailable.

The `op` CLI is installed on all platforms:
- macOS: via `1password-cli` cask
- Linux: via dedicated repo scripts (`install-op.sh.tmpl`) + `1password-cli` package

`op-plugins.fish` sources `~/.config/op/plugins.sh` for the GitHub CLI plugin (set up by `run_once_after_25-setup-op-gh-plugin.sh`).

## Age Encryption

Chezmoi is configured to decrypt files using an age key stored in 1Password:

- `home/dot_local/share/encrypted_x7k9m2p.tar.gz.age` — age-encrypted archive managed by chezmoi
- `run_before_00-write-age-identity.sh` — writes `~/.config/chezmoi/age-key.txt` from `op://Private/chezmoi-age/private` before every apply
- `run_after_50-extract-archive.sh.tmpl` — extracts the decrypted archive to `~/.local/share/x7k9m2p/` if a JetBrains product is installed; skips silently otherwise (tar.gz stays on disk, managed by chezmoi)
- `.chezmoiignore` conditionally excludes `x7k9m2p.tar.gz` using `stat` when no JetBrains directory is found — so chezmoi won't write/track the file on non-JetBrains machines

The age key file is written with mode `600` and requires `op` to be authenticated at apply time.

## Setapp

Setapp app list is managed via `home/dot_setapp/bundle.tmpl`, which renders from `packages.darwin.setapp` in `packages.yaml`. The `run_onchange_after_27` script installs apps from this bundle on macOS.

## Topgrade

`home/dot_config/topgrade.toml.tmpl` configures topgrade with custom commands:
- `Chezmoi Externals` — refreshes external git repos
- `Mackup Backup` — runs `mackup backup --force` (macOS only)
- `OSCAR` — runs `oscar-update` (macOS only)

## Custom Mackup App Configs

`home/dot_mackup/` contains custom Mackup application config files (`.cfg.tmpl`) for apps not in Mackup's built-in registry. Currently:
- `intellijidea-modern.cfg.tmpl` — dynamically discovers installed IntelliJ IDEA versions via `ls ~/Library/Application Support/JetBrains`

## SSH Configuration

`home/private_dot_ssh/private_config.tmpl` manages `~/.ssh/config` with the 1Password SSH agent socket, using an OS-specific path:
- macOS: `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`
- Linux: `~/.1password/agent.sock`

The `private_` prefix ensures chezmoi writes the file with mode `600`.
