# Suggested Commands

## Chezmoi (primary workflow)
```fish
chezmoi apply          # Apply dotfiles to home directory
chezmoi diff           # Preview pending changes
chezmoi edit <file>    # Edit a managed file
chezmoi add <file>     # Track a new file
chezmoi cd             # cd into the repo

# Fish abbreviations:
czap   # chezmoi apply
czed   # chezmoi edit
czdf   # chezmoi diff
czad   # chezmoi add
czcd   # chezmoi cd
```

## Linting (run locally to mirror CI)
```fish
# Shell scripts (plain .sh only, not .tmpl):
shellcheck home/.chezmoiscripts/run_before_00-write-age-identity.sh \
  home/.chezmoiscripts/run_once_after_25-setup-op-gh-plugin.sh \
  home/dot_local/bin/executable_oscar-update

# YAML:
yamllint .github/workflows/
yamllint home/.chezmoidata/packages.yaml

# TOML syntax:
python3 -c "import tomllib; tomllib.load(open('cliff.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/starship.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/atuin/config.toml', 'rb')); print('OK')"

# Verify chezmoi templates render (CI uses chezmoi dump):
chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null
```

## GitHub CLI (use 1Password plugin)
```fish
op plugin run -- gh <command>
```

## Git
```fish
git status
git log --oneline
git diff
```

## No Testing Commands
This is a dotfiles repo — no unit tests. Validation is done via `chezmoi diff` and CI linting.
