# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports macOS and Linux (Arch, Ubuntu/Debian, Fedora/RHEL). Uses 1Password for secrets and Fish as the default shell.

## Bootstrap

### macOS

```sh
brew install chezmoi
chezmoi init --apply SolidRhino/dotfile
```

### Linux

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply SolidRhino/dotfile
```

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

## What's Managed

### Dotfiles & Config

| File | Target | Notes |
|------|--------|-------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` | SSH signing via 1Password, LFS, difftastic |
| `dot_config/fish/` | `~/.config/fish/` | Modular Fish config (conf.d/ pattern) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Catppuccin Mocha theme |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` | 1Password SSH agent socket (mode 600) |

### Packages Installed Everywhere

`bat` · `difftastic` · `eza` · `fd` · `fish` · `fzf` · `gh` · `git` · `git-lfs` · `lazygit` · `neovim` · `ripgrep` · `starship` · `topgrade` · `tree-sitter` · `wget`

**Rust (via rustup):** `bat` · `cargo-update` · `difftastic` · `eza` · `git-cliff` · `ripgrep` · `starship`

### macOS-only (Homebrew)

Casks: `1password` · `brave-browser` · `claude` · `iterm2` · `neovide` · `visual-studio-code`
Fonts: JetBrains Mono Nerd · Fira Code Nerd

---

## Key Commands

### Chezmoi

| Command | Abbreviation | Description |
|---------|-------------|-------------|
| `chezmoi apply` | `czap` | Apply dotfiles |
| `chezmoi diff` | `czdf` | Preview pending changes |
| `chezmoi edit <file>` | `czed` | Edit a managed file |
| `chezmoi add <file>` | `czad` | Track a new file |
| `chezmoi cd` | `czcd` | cd into this repo |
| `topgrade` | `upd` | Update everything (system + cargo + etc.) |

### Git

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

### Shell

| Alias | Expands to |
|-------|-----------|
| `ll` | `eza -lah --icons --git` |
| `lt` | `eza --tree --icons` |
| `cat` | `bat` |
| `grep` | `rg` |
| `v` / `vi` | `nvim` |
| `reload` | `source ~/.config/fish/config.fish` |

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
