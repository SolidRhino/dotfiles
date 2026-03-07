# Project Overview

## Purpose
Chezmoi dotfiles repository managing development environment configuration across macOS and Linux.
Uses 1Password for secrets management and Fish shell as the primary shell.

## Tech Stack
- **chezmoi** — dotfiles manager
- **Fish shell** — primary shell
- **1Password** — secrets management (apply-time resolution via `onepasswordRead`)
- **mise** — language runtime version management
- **Homebrew** — macOS package management
- **Starship** — shell prompt
- **Atuin** — shell history
- **Neovim** — editor
- **zoxide** — smart `cd` replacement (cargo; Fish initialized via `--cmd cd` in `conf.d/zoxide.fish`)
- **delta** — git pager with syntax highlighting (cargo crate: `git-delta`; configured in `dot_gitconfig.tmpl`)

## Repository Structure
```
chezmoi/                   # repo root
├── home/                  # chezmoi root (mapped to $HOME)
│   ├── dot_config/        # ~/.config/
│   │   ├── fish/          # Fish shell config
│   │   │   ├── config.fish
│   │   │   ├── conf.d/    # modular Fish config files
│   │   │   └── completions/ # tool completions (e.g. mise.fish.tmpl)
│   │   ├── mise/          # mise config
│   │   ├── atuin/         # atuin config
│   │   └── starship.toml
│   ├── .chezmoiscripts/   # setup scripts
│   │   ├── darwin/        # macOS-only scripts
│   │   ├── linux/         # Linux-only scripts
│   │   └── *.sh[.tmpl]    # cross-platform scripts
│   ├── .chezmoiexternal.toml.tmpl  # external git repos (nvim config; claude skill macOS-only)
│   ├── .chezmoidata/
│   │   └── packages.yaml  # cross-platform package declarations
│   ├── dot_local/
│   │   └── bin/           # ~/.local/bin/ (macOS-only scripts, e.g. oscar-update)
│   ├── private_dot_ssh/   # ~/.ssh/ (mode 600)
│   ├── dot_gitconfig.tmpl
│   ├── dot_mackup.cfg.tmpl
│   └── .chezmoi.toml.tmpl # machine type variables
├── .github/
│   └── workflows/         # CI: lint.yml, dotfiles-changelog.yml
├── docs/
├── CLAUDE.md
├── CHANGELOG.md
├── cliff.toml             # git-cliff config for changelog
├── .editorconfig
└── .yamllint.yaml
```

## Key Conventions
- `dot_` prefix → `.` in target
- `private_` prefix → mode 600
- `empty_` prefix → empty file
- `.tmpl` suffix → Go template
- `home/` is chezmoi root (set in `.chezmoiroot`)
- Secrets baked in at `chezmoi apply` time, never at shell startup
