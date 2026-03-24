# Project Overview

## Purpose
Chezmoi dotfiles repository managing development environment configuration across macOS and Linux.
Uses 1Password for secrets management and Fish shell as the primary shell.

## Tech Stack
- **chezmoi** — dotfiles manager
- **Fish shell** — primary shell
- **1Password** — secrets management (`onepasswordRead` in templates; repo is transitioning from apply-time `op read` hydration to a pre-source-state bootstrap helper plus fallback apply-time hydration)
- **mise** — language runtime version management
- **Homebrew** — macOS package management
- **Starship** — shell prompt
- **Atuin** — shell history
- **Neovim** — editor
- **zoxide** — smart `cd` replacement
- **delta** — git pager with syntax highlighting (`git-delta` crate)

## Repository Structure
```text
chezmoi/
├── home/                  # chezmoi source root mapped to $HOME
│   ├── .chezmoiscripts/   # setup/apply scripts (cross-platform + darwin/linux)
│   ├── .chezmoidata/      # package declarations and template data
│   ├── dot_config/        # ~/.config/
│   ├── dot_local/         # ~/.local/
│   ├── dot_mackup/        # custom Mackup app configs
│   ├── dot_setapp/        # Setapp bundle definition
│   ├── private_dot_ssh/   # ~/.ssh/ (mode 600)
│   ├── dot_gitconfig.tmpl
│   ├── dot_mackup.cfg.tmpl
│   └── .chezmoi.toml.tmpl
├── .github/workflows/     # CI workflows
├── .serena/               # Serena project config and memories
├── .claude/               # local Claude-related config (some parts ignored)
├── docs/                  # currently gitignored local docs/plans
├── site/                  # Astro/Starlight docs site
├── CHEATSHEET.md
├── CHANGELOG.md
├── CLAUDE.md
├── cliff.toml
└── .yamllint.yaml
```

## Key Conventions
- `dot_` prefix → `.` in target path
- `private_` prefix → mode 600
- `empty_` prefix → empty file creation
- `.tmpl` suffix → Go template rendered by chezmoi
- `home/` is the managed chezmoi source root
- Secrets are baked in at render/apply time, never at shell startup

## Machine Type Variables
Available in templates as: `.personal`, `.headless`, `.ephemeral`, `.hostname`, `.osid`

- `osid` — combined OS/distro string: `darwin`, `linux-ubuntu`, `linux-arch`, etc.
- `personal` — true on personal machines
- `headless` — true on servers/CI without a display
- `ephemeral` — true in CI/Codespaces/containers

Defined in `home/.chezmoi.toml.tmpl`.
