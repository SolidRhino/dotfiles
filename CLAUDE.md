# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository managing development environment configuration across macOS and Linux. It uses 1Password for secrets management and Fish shell as the primary shell.

## Chezmoi Conventions

- **`home/`** is the chezmoi root (set in `.chezmoiroot`); all managed files live here and map to `$HOME`
- `dot_` prefix → `.` in target (e.g., `dot_config/` → `~/.config/`)
- `empty_` prefix → creates an empty file
- `.tmpl` suffix → Go template; supports `{{ if eq .chezmoi.os "darwin" }}` conditionals and `{{ onepasswordRead "..." }}` for secrets
- `.chezmoidata/packages.yaml` declares packages for cross-platform installs

## Script Naming

Scripts in `home/.chezmoiscripts/` follow chezmoi naming conventions:
- `run_once_*` — runs only once (idempotent installs)
- `run_onchange_*` — runs when file content changes
- `.tmpl` suffix — conditionally rendered (e.g., macOS-only scripts)

## Fish Shell Configuration

Modular layout under `home/dot_config/fish/`:
- `config.fish` — entry point, sources `conf.d/`
- `conf.d/aliases.fish` — command aliases with fallbacks (bat/cat, eza/ls, etc.)
- `conf.d/abbreviations.fish` — Git, Docker, chezmoi, and package manager abbreviations
- `conf.d/path.fish` — PATH and env vars; EDITOR is set to `nvim`
- `conf.d/claude.fish.tmpl` — injects Claude Code OAuth token from 1Password (macOS only)
- `conf.d/homebrew.fish.tmpl` — Homebrew env setup (macOS only)

## Key Chezmoi Commands

```fish
chezmoi apply          # Apply dotfiles to home directory
chezmoi diff           # Preview pending changes
chezmoi edit <file>    # Edit a managed file
chezmoi add <file>     # Track a new file
chezmoi cd             # cd into this repo
```

Fish abbreviations provide shortcuts: `czap`, `czed`, `czdiff`/`czdf`, `czad`, `czcd`.

## 1Password Integration

Secrets are retrieved at apply-time via `onepasswordRead` in `.tmpl` files. The `op` CLI must be authenticated. `op-plugins.fish` sources `~/.config/op/plugins.sh` for the GitHub CLI plugin (set up by `run_once_after_setup-op-gh-plugin.sh`).

## Platform Conditionals

Use `{{ if eq .chezmoi.os "darwin" }}...{{ end }}` in templates for macOS-specific content. Linux package scripts detect the distro and select `apt`, `dnf`, or `pacman` accordingly.
