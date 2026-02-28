# Enhancements Design — 2026-02-28

## Scope

Four targeted improvements to the chezmoi dotfiles repository.

---

## 3. GitHub Actions Lint Workflow

**File:** `.github/workflows/lint.yml`

Runs on every push and pull request. Four checks in parallel:

1. **shellcheck** — plain `.sh` files only (3 files):
   - `run_once_after_10-install-rust.sh`
   - `run_once_after_25-setup-op-gh-plugin.sh`
   - `run_onchange_after_30-set-default-shell.sh`
2. **yamllint** — `.github/workflows/*.yml` + `home/.chezmoidata/packages.yaml`
3. **taplo fmt --check** — `cliff.toml` (TOML format validation)
4. **chezmoi verify** — install chezmoi in CI, run against source dir to catch template errors

`.tmpl` shell scripts are not shellchecked — no tool handles Go template + shell hybrids cleanly. `chezmoi verify` covers the template layer instead.

---

## 4. Git Aliases

**File:** `home/dot_gitconfig.tmpl` — extend `[alias]` section

```ini
[alias]
    ci      = commit
    unstage = restore --staged
    amend   = commit --amend --no-edit
    undo    = reset --soft HEAD~1
    gone    = !git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -d
```

- `unstage` — un-stage files without discarding changes
- `amend` — amend last commit without editing the message
- `undo` — soft reset last commit, keeps changes staged
- `gone` — delete local branches whose remote tracking branch is gone

These complement the existing fish abbreviations and do not duplicate them.

---

## 5. `.chezmoiignore`

**File:** `home/.chezmoiignore` (chezmoi source root is `home/`)

Patterns are relative to `$HOME`:

```
.DS_Store
.wget-hsts
.ssh/id_*
.ssh/known_hosts
.aws/
.config/gh/hosts.yml
.kube/
.config/nvim
.local/share/chezmoi
```

Prevents accidental tracking of SSH private keys, cloud credentials, machine-generated files, and the chezmoi source directory itself.

---

## 6. packages.yaml

**File:** `home/.chezmoidata/packages.yaml`

Add `shellcheck` to `packages.common`. It is available under this name on Homebrew, apt, dnf, and pacman. No distro-specific overrides needed.
