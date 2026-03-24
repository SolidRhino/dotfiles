# Suggested Commands

## Chezmoi
```fish
chezmoi apply
chezmoi diff
chezmoi edit <file>
chezmoi add <file>
chezmoi cd

# Fish abbreviations:
czap   # chezmoi apply
czed   # chezmoi edit
czdf   # chezmoi diff
czad   # chezmoi add
czcd   # chezmoi cd
```

## Linting / Validation
```fish
# Plain shell scripts:
shellcheck .install-op-and-age.sh \
  home/.chezmoiscripts/run_before_00-write-age-identity.sh \
  home/.chezmoiscripts/run_once_after_25-setup-op-gh-plugin.sh \
  home/dot_local/bin/executable_oscar-update

# YAML:
yamllint .github/workflows/
yamllint home/.chezmoidata/packages.yaml

# TOML syntax:
python3 -c "import tomllib; tomllib.load(open('cliff.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/starship.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/atuin/config.toml', 'rb')); print('OK')"

# Render sanity check (may be blocked by secret-backed templates locally):
chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null
```

## GitHub CLI
```fish
op plugin run -- gh <command>
```

## Git
```fish
git status
git log --oneline
git diff
```

## Notes
- This repo has no unit-test suite; validation is mostly chezmoi diff/render checks and CI linting.
- For `.sh.tmpl` scripts, CI is the authoritative validation path because it renders representative templates before shellchecking them.
