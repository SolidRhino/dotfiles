Implemented warning cleanup pass across bootstrap scripts/templates:

- Atuin login script (`home/.chezmoiscripts/run_once_after_35-login-atuin.sh.tmpl`) now keeps non-interactive flow but no longer passes password/key via CLI flags. It sets templated vars and pipes password+key over stdin to `atuin login -u ...`.
- mise installer script (`home/.chezmoiscripts/run_once_after_19-install-mise.sh.tmpl`) now uses hardened curl flags: `--proto '=https' --tlsv1.2 -fsSL`.
- CI workflow (`.github/workflows/lint.yml`, chezmoi-verify Install mise step) now mirrors the same hardened mise curl invocation.
- Shebang consistency restored in `home/.chezmoiscripts/run_once_after_25-setup-op-gh-plugin.sh` (`#!/bin/bash`).
- Cargo package detection in `home/.chezmoiscripts/run_onchange_after_20-install-cargo-packages.sh.tmpl` changed from fixed substring match to anchored regex (`^${package} v`) to avoid substring false positives.
- `home/dot_gitconfig.tmpl` deduped credential/GPG signing blocks for darwin + personal non-headless linux into one shared conditional with a small OS-specific `op-ssh-sign` path branch.
- Fish config comment list in `home/dot_config/fish/config.fish` updated to match current conf.d files (`atuin.fish`, `mise.fish`, `zoxide.fish`).
- Optional hygiene: AUR helper (`home/.chezmoiscripts/linux/run_onchange_before_15-install-aur-helper.sh.tmpl`) now runs build in a subshell-scoped `cd`.

Validation run:
- shellcheck on plain updated script succeeded
- rendered shellcheck checks for updated templates succeeded
- `chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null` succeeded
- YAML parsing via Python `yaml.safe_load` succeeded (yamllint not available locally)
