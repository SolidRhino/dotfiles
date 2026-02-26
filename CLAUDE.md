# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository managing development environment configuration across macOS and Linux. It uses 1Password for secrets management and Fish shell as the primary shell.

## Chezmoi Conventions

- **`home/`** is the chezmoi root (set in `.chezmoiroot`); all managed files live here and map to `$HOME`
- `dot_` prefix → `.` in target (e.g., `dot_config/` → `~/.config/`)
- `empty_` prefix → creates an empty file
- `.tmpl` suffix → Go template; supports conditionals and `{{ onepasswordRead "..." }}` for secrets
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
- `before_` / `after_` — timing relative to file changes
- Numeric prefixes enforce execution order within the same timing group (e.g. `10-install-rust` before `20-install-cargo-packages`)
- All scripts use `set -eufo pipefail`

Scripts are organised into subdirectories:
- `darwin/` — macOS-only scripts (still require `{{ if eq .chezmoi.os "darwin" }}` internally)
- `linux/` — Linux-only scripts (use `.osid` for distro-specific logic)
- Top-level — cross-platform scripts (rust, cargo packages, default shell, op plugin)

## Linux Package Management Strategy

**Arch-based** (Arch, Manjaro, EndeavourOS): native `pacman` — rolling release always has latest versions.

**apt-based** (Ubuntu, Debian, Mint, Pop!_OS): native `apt` with upstream repos added by dedicated per-tool scripts for tools where distro versions lag significantly:
- `linux/run_onchange_before_install-gh.sh.tmpl` — GitHub CLI official apt repo
- `linux/run_onchange_before_install-git-lfs.sh.tmpl` — Packagecloud apt repo

**dnf-based** (Fedora, RHEL, Rocky, AlmaLinux): native `dnf`.

**mise** will be added later for language runtime version management (node, python, go, ruby). Not needed yet.

## Package Naming Differences (packages.yaml)

`packages.common` uses brew/dnf names. Known differences handled in templates:
- `fd` → `fd-find` on apt (added to `packages.apt`)
- `gh` → `github-cli` on pacman (added to `packages.pacman`); apt gets it from the dedicated gh repo script

## Fish Shell Configuration

Modular layout under `home/dot_config/fish/`:
- `config.fish` — entry point, sources `conf.d/`
- `conf.d/aliases.fish` — command aliases with fallbacks (bat/cat, eza/ls, etc.)
- `conf.d/abbreviations.fish` — Git, Docker, chezmoi, and `upd` → topgrade abbreviations
- `conf.d/path.fish` — PATH (~/.local/bin, ~/.cargo/bin) and env vars; EDITOR=nvim
- `conf.d/homebrew.fish.tmpl` — Homebrew shellenv (macOS only; handles both Apple Silicon and Intel)
- `conf.d/starship.fish` — Starship prompt initialisation
- `conf.d/claude.fish.tmpl` — CLAUDE_CODE_OAUTH_TOKEN from 1Password (macOS only)
- `conf.d/op-plugins.fish` — sources `~/.config/op/plugins.sh` when present

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

Secrets are retrieved at apply-time via `onepasswordRead` in `.tmpl` files. The `op` CLI must be authenticated. `op-plugins.fish` sources `~/.config/op/plugins.sh` for the GitHub CLI plugin.
