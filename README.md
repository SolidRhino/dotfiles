---
title: Home
layout: default
nav_order: 1
---

# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports macOS and Linux (Arch, Ubuntu/Debian, Fedora/RHEL). Uses 1Password for secrets and Fish as the default shell.

## Quick Start

Works on macOS and Linux. Installs chezmoi to `~/.local/bin` and applies the dotfiles in one shot:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply SolidRhino/dotfile
```

> **macOS with Homebrew already installed:** `brew install chezmoi && chezmoi init --apply SolidRhino/dotfile`

**What to expect:**
- On first run, chezmoi prompts for `headless` and `personal` flags (answered once, stored in `~/.config/chezmoi/chezmoi.toml`)
- 1Password CLI must be authenticated during apply for secrets to be baked in
- Fish is set as the default shell (may prompt for password)
- macOS: Homebrew and all casks/formulae are installed automatically
- The 1Password GitHub CLI plugin setup (`after_25`) is interactive — run it manually if it fails in a non-interactive shell: `op plugin init gh`

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

`atuin` · `bat` · `cargo-update` · `difftastic` · `eza` · `git-cliff` · `git-delta` · `ripgrep` · `starship` · `topgrade` · `usage-cli` · `xh` · `zoxide`

**mise** is installed via its official installer (`curl https://mise.run | sh`) and manages its own updates.

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
Secrets baked into templates (SSH config, git config) will fail. Run `eval $(op signin)` first, then `chezmoi apply`.

**Commit signing not showing "Verified" on GitHub**
Add the SSH public key as a **signing key** in GitHub Settings → SSH and GPG keys → New signing key. (Separate from the authentication key.)

**Fish not set as default shell after apply**
Run manually: `chsh -s $(which fish)`. On Linux, fish must be in `/etc/shells` first: `echo $(which fish) | sudo tee -a /etc/shells`.

**`op plugin init gh` failed during setup**
The 1Password GitHub CLI plugin setup script is interactive. Run `op plugin init gh` manually after apply.

**Chezmoi prompts not appearing (non-interactive shell)**
The `headless`/`personal` prompts require a TTY. Bootstrap from a normal terminal, not a script or CI environment.
