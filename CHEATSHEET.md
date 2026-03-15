---
title: Cheatsheet
description: Commands, abbreviations, and chezmoi naming conventions.
---

# Cheatsheet

## Chezmoi Commands

| Command | Abbreviation | Description |
|---------|-------------|-------------|
| `chezmoi` | `cz` | Chezmoi base command |
| `chezmoi apply` | `czap` | Apply dotfiles |
| `chezmoi apply --refresh-externals --force` | `czre` | Apply with forced external refresh |
| `chezmoi diff` | `czdf` | Preview pending changes |
| `chezmoi edit <file>` | `czed` | Edit a managed file |
| `chezmoi add <file>` | `czad` | Track a new file |
| `chezmoi cd` | `czcd` | cd into this repo |
| `topgrade` | `upd` | Update everything (system + cargo + etc.) |

## Chezmoi Naming Conventions

### File prefixes/suffixes

| Prefix/suffix | Result |
|--------------|--------|
| `dot_` | `.` in target (e.g. `dot_config/` → `~/.config/`) |
| `private_` | File written with mode `600` |
| `empty_` | Creates an empty file |
| `.tmpl` | Go template — supports conditionals and variable substitution |

### Script prefixes

| Prefix | Behaviour |
|--------|-----------|
| `run_once_` | Runs once per machine |
| `run_onchange_` | Runs when rendered script content changes |
| `run_` (no modifier) | Runs on every `chezmoi apply` |
| `before_` / `after_` | Timing relative to file changes |
| Numeric prefix (e.g. `10_`, `20_`) | Enforces execution order within a timing group |

### Script subdirectories

| Directory | Scope |
|-----------|-------|
| `darwin/` | macOS-only |
| `linux/` | Linux-only |
| (top-level) | Cross-platform |

## Script Execution Order

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
| after 19 | `run_once_after_19-install-mise.sh.tmpl` | once | Install mise via `curl https://mise.run \| sh` (skipped on ephemeral) |
| after 20 | `run_onchange_after_20-install-cargo-packages.sh.tmpl` | onchange | Install cargo packages (skipped on ephemeral) |
| after 21 | `run_onchange_after_21-install-mise-tools.sh.tmpl` | onchange | Install mise-managed runtimes (skipped on ephemeral) |
| after 25 | `run_once_after_25-setup-op-gh-plugin.sh` | once | 1Password GitHub CLI plugin |
| after 26 | `darwin/run_once_after_26-install-setapp-cli.sh.tmpl` | once | Install setapp-cli binary |
| after 27 | `darwin/run_onchange_after_27-install-setapp-apps.sh.tmpl` | onchange | Install Setapp apps from bundle |
| after 28 | `darwin/run_after_28-install-oscar.sh.tmpl` | always | Install/update OSCAR via `~/.local/bin/oscar-update` (macOS) |
| after 29 | `darwin/run_once_after_29-setup-touchid-sudo.sh.tmpl` | once | Configure TouchID for sudo via /etc/pam.d/sudo_local (macOS) |
| after 30 | `run_onchange_after_30-set-default-shell.sh.tmpl` | onchange | Set Fish as default shell (skipped on ephemeral) |
| after 35 | `run_once_after_35-login-atuin.sh.tmpl` | once | Log in to Atuin sync |
| after 40 | `run_onchange_after_40-fish-update-completions.sh.tmpl` | onchange | Regenerate Fish man-page completions |
| after 50 | `run_after_50-extract-archive.sh.tmpl` | always | Extract age-decrypted archive to `~/.local/share/` |
| after | `darwin/run_once_after_install-claude-code.sh.tmpl` | once | Install Claude Code (macOS) |
| after | `darwin/run_once_after_mackup-restore.sh.tmpl` | once | Restore GUI app settings via Mackup (macOS) |

## Git Abbreviations

| Abbreviation | Command |
|-------------|---------|
| `g` | `git` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gs` | `git status` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `gl` | `git log --oneline --graph --decorate` |
| `lg` | `lazygit` |

## Docker Abbreviations

| Abbreviation | Command |
|-------------|---------|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcl` | `docker compose logs -f` |
| `dcp` | `docker compose pull` |

## Shell Aliases

| Alias | Expands to |
|-------|-----------|
| `ll` | `eza -lah --icons --git` |
| `ls` | `eza --icons` |
| `la` | `eza -a --icons` |
| `lt` | `eza --tree --icons` |
| `cat` | `bat` |
| `grep` | `rg` |
| `v` / `vi` | `nvim` |
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `mkdir` | `mkdir -p` |
| `cls` | `clear` |
| `reload` | `source ~/.config/fish/config.fish` |
