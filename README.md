---
title: Home
description: Personal dotfiles for macOS & Linux managed with chezmoi.
hero:
  tagline: Personal dotfiles for macOS & Linux — one command to get started.
  actions:
    - text: Quick Start
      link: /dotfiles/#quick-start
      icon: right-arrow
      variant: primary
    - text: GitHub
      link: https://github.com/SolidRhino/dotfiles
      icon: github
      variant: secondary
---

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports macOS and Linux (Arch, Ubuntu/Debian, Fedora/RHEL). Uses 1Password for secrets and Fish as the default shell.

## Quick Start

Works on macOS and Linux.

### First-time bootstrap

Install chezmoi to `~/.local/bin`, clone the source repo without applying it yet, then add the local pre-source-state hook that bootstraps 1Password CLI + the age key before the first full apply:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init SolidRhino/dotfiles
mkdir -p ~/.config/chezmoi
touch ~/.config/chezmoi/chezmoi.toml
# If you already have a [hooks.read-source-state.pre] section, merge this block into it manually.
grep -Fq '.install-op-and-age.sh' ~/.config/chezmoi/chezmoi.toml || cat >> ~/.config/chezmoi/chezmoi.toml <<'EOF'
[hooks.read-source-state.pre]
command = "/bin/bash"
args = ["-lc", "$HOME/.local/share/chezmoi/.install-op-and-age.sh"]
EOF
chezmoi apply
```

> **macOS with Homebrew already installed:** use `brew install chezmoi` instead of the installer in the first line, then run the same `chezmoi init`, local config, and `chezmoi apply` steps shown above.

**What to expect:**
- On first run, chezmoi prompts for `headless` and `personal` flags (answered once, stored in `~/.config/chezmoi/chezmoi.toml`)
- The local pre-source-state hook tries to ensure `op` exists and hydrates `~/.config/chezmoi/age-key.txt` before the first full apply
- If 1Password CLI is present but not authenticated, unlock/authenticate it and rerun `chezmoi apply`
- Fish is set as the default shell (may prompt for password)
- macOS: Homebrew and all casks/formulae are installed automatically
- The 1Password GitHub CLI plugin setup (`after_25`) is interactive — run it manually if it fails in a non-interactive shell: `op plugin init gh`

### Existing machines

If this repo is already initialized locally, add the same hook block to `~/.config/chezmoi/chezmoi.toml` with the same `touch` + `grep ... || cat >> ...` command shown above, then run:

```sh
touch ~/.config/chezmoi/chezmoi.toml
grep -Fq '.install-op-and-age.sh' ~/.config/chezmoi/chezmoi.toml || cat >> ~/.config/chezmoi/chezmoi.toml <<'EOF'
[hooks.read-source-state.pre]
command = "/bin/bash"
args = ["-lc", "$HOME/.local/share/chezmoi/.install-op-and-age.sh"]
EOF
chezmoi apply
```

### Re-apply after changes

```sh
chezmoi apply          # or: czap
```

---

## What You Get

### Dotfiles & Config

| File | Target | Notes |
|------|--------|-------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` | SSH signing via 1Password, LFS, delta pager, difftastic diff |
| `dot_config/fish/` | `~/.config/fish/` | Modular Fish config (conf.d/ pattern) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Catppuccin Mocha theme |
| `dot_config/mise/config.toml.tmpl` | `~/.config/mise/config.toml` | Language runtime versions (node, python, go, etc.) |
| `dot_config/atuin/config.toml` | `~/.config/atuin/config.toml` | Shell history settings |
| `dot_config/topgrade.toml.tmpl` | `~/.config/topgrade.toml` | Update automation config |
| `dot_mackup.cfg.tmpl` | `~/.mackup.cfg` | Mackup config (macOS) |
| `dot_setapp/bundle.tmpl` | `~/.setapp/bundle` | Setapp app bundle (macOS) |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` | 1Password SSH agent socket (mode 600) |

### Packages Installed Everywhere

**System packages** (via Homebrew / pacman / apt / dnf):

`curl` · `fd` · `fish` · `fzf` · `gh` · `git` · `git-lfs` · `lazygit` · `neovim` · `shellcheck` · `tree-sitter-cli` · `wget`

**Rust (via cargo):**

`atuin` · `bat` · `cargo-binstall` · `cargo-update` · `difftastic` · `eza` · `git-cliff` · `git-delta` · `ripgrep` · `starship` · `topgrade` · `usage-cli` · `xh` · `zoxide`

Cargo CLI tools install with a binary-first path when available (`cargo-binstall`), and fall back to `cargo install --locked` for reproducible source builds.

**mise** is installed via its official installer (`curl https://mise.run | sh`) and manages its own updates.

Version policy for `mise` tools:
- use `latest` for fast-moving developer tooling
- use `lts` for ecosystem runtimes with broad support windows
- use a major pin (for example `ruby = "4"`) when tracking the current stable line without full pin churn

### macOS-only (Homebrew)

**Casks:** `1password` · `1password-cli` · `brave-browser` · `claude` · `codex` · `discord` · `intellij-idea` · `ipfs-desktop` · `iterm2` · `itermai` · `neovide-app` · `ollama-app` · `setapp` · `tailscale-app` · `telegram` · `tor-browser` · `visual-studio-code` · `whatsapp`

**Fonts:** JetBrains Mono Nerd · Fira Code Nerd

**Brews:** `mackup` · `mas` · `pam-reattach`

**App Store (via mas):** Xcode · Pages · Numbers · Swift Playgrounds

**Setapp:** AlDente Pro · CleanMyMac · Elmedia Player · Luminar Neo · Moonlock · Numi · Shortcutie

---

## Reference

→ See [CHEATSHEET.md](CHEATSHEET.md) for all commands, abbreviations, and file naming conventions.

---

## Troubleshooting

**1Password not unlocked during apply**
Secrets baked into templates (SSH config, git config) will fail. Unlock/authenticate 1Password CLI, then rerun `chezmoi apply`.

**Automatic 1Password bootstrap failed on Linux**
Unsupported Linux variants are not auto-detected. Install `1password-cli` manually, then rerun `chezmoi apply`.

**Automatic 1Password bootstrap failed on Arch-based Linux**
If the package database is stale on a fresh machine, refresh the system package state first, then rerun `chezmoi apply`.

**Automatic 1Password bootstrap failed on macOS**
The bootstrap hook expects Homebrew to be installed already. Install Homebrew first, then rerun `chezmoi apply`.

**I already have a `read-source-state.pre` hook section**
Do not append a second `[hooks.read-source-state.pre]` table. Merge the `command` / `args` entry into your existing hook configuration manually.

**Commit signing not showing "Verified" on GitHub**
Add the SSH public key as a **signing key** in GitHub Settings → SSH and GPG keys → New signing key. (Separate from the authentication key.)

**Fish not set as default shell after apply**
Run manually: `chsh -s $(which fish)`. On Linux, fish must be in `/etc/shells` first: `echo $(which fish) | sudo tee -a /etc/shells`.

**`op plugin init gh` failed during setup**
The 1Password GitHub CLI plugin setup script is interactive. Run `op plugin init gh` manually after apply.

**Chezmoi prompts not appearing (non-interactive shell)**
The `headless`/`personal` prompts require a TTY. Bootstrap from a normal terminal, not a script or CI environment.
