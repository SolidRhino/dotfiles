# Dotfiles Enhancements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add git aliases, a `.chezmoiignore`, `shellcheck` to packages, and a GitHub Actions lint workflow to the chezmoi dotfiles repo.

**Architecture:** All changes are config files or GitHub Actions YAML. No code logic involved — each task is an isolated file edit or creation followed by a commit. Tasks are independent and can be done in any order.

**Tech Stack:** chezmoi, Fish shell, GitHub Actions, shellcheck, yamllint, taplo, chezmoi verify

---

### Task 1: Add git aliases

**Files:**
- Modify: `home/dot_gitconfig.tmpl`

**Step 1: Open the file and find the `[alias]` section (line 26–27)**

It currently reads:
```ini
[alias]
    ci = commit
```

**Step 2: Replace the alias section with the expanded set**

```ini
[alias]
    ci      = commit
    unstage = restore --staged
    amend   = commit --amend --no-edit
    undo    = reset --soft HEAD~1
    gone    = !git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -d
```

**Step 3: Apply and verify**

```bash
chezmoi apply
git config --get-all alias.unstage   # → restore --staged
git config --get-all alias.gone      # → !git branch -vv ...
```

**Step 4: Commit**

```bash
git add home/dot_gitconfig.tmpl
git commit -m "feat: add git aliases (unstage, amend, undo, gone)"
```

---

### Task 2: Create `.chezmoiignore`

**Files:**
- Create: `home/.chezmoiignore`

**Step 1: Create the file**

```
# macOS metadata
.DS_Store
.wget-hsts

# SSH private keys — never manage via chezmoi
.ssh/id_*
.ssh/known_hosts

# Cloud/tool credentials
.aws/
.config/gh/hosts.yml
.kube/

# Managed externally (chezmoi external)
.config/nvim

# Prevent circular management
.local/share/chezmoi
```

**Step 2: Verify chezmoi still applies cleanly**

```bash
chezmoi verify
chezmoi diff    # should show no unexpected changes
```

**Step 3: Commit**

```bash
git add home/.chezmoiignore
git commit -m "feat: add .chezmoiignore to exclude secrets and externally managed paths"
```

---

### Task 3: Add shellcheck to packages

**Files:**
- Modify: `home/.chezmoidata/packages.yaml`

**Step 1: Add `shellcheck` to `packages.common` (alphabetical order, after `ripgrep` in `packages.cargo` is separate — put after `gh` in common)**

Current `common` list (lines 12–23):
```yaml
  common:
    - curl
    - fd
    - fish
    - fzf
    - gh
    - git
    - git-lfs
    - lazygit
    - neovim
    - tree-sitter-cli
    - wget
```

Updated:
```yaml
  common:
    - curl
    - fd
    - fish
    - fzf
    - gh
    - git
    - git-lfs
    - lazygit
    - neovim
    - shellcheck
    - tree-sitter-cli
    - wget
```

**Step 2: Verify the template renders correctly**

```bash
chezmoi execute-template < home/.chezmoiscripts/linux/run_onchange_before_20-install-packages.sh.tmpl
```
Expected: `shellcheck` appears in the package list for each distro.

**Step 3: Commit**

```bash
git add home/.chezmoidata/packages.yaml
git commit -m "feat: add shellcheck to common packages"
```

---

### Task 4: Create GitHub Actions lint workflow

**Files:**
- Create: `.github/workflows/lint.yml`

**Step 1: Create the workflow file**

```yaml
name: Lint

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  shellcheck:
    name: shellcheck
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Run shellcheck on plain shell scripts
        run: |
          shellcheck \
            home/.chezmoiscripts/run_once_after_10-install-rust.sh \
            home/.chezmoiscripts/run_once_after_25-setup-op-gh-plugin.sh \
            home/.chezmoiscripts/run_onchange_after_30-set-default-shell.sh

  yamllint:
    name: yamllint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Install yamllint
        run: pip install yamllint
      - name: Lint YAML files
        run: |
          yamllint .github/workflows/
          yamllint home/.chezmoidata/packages.yaml

  toml:
    name: taplo
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Install taplo
        run: |
          curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz \
            | gzip -d - > /usr/local/bin/taplo
          chmod +x /usr/local/bin/taplo
      - name: Check TOML formatting
        run: taplo fmt --check cliff.toml

  chezmoi-verify:
    name: chezmoi verify
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Install chezmoi
        run: sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
      - name: Verify chezmoi source
        run: chezmoi verify --source=$GITHUB_WORKSPACE
```

**Step 2: Verify YAML syntax locally (if yamllint available)**

```bash
yamllint .github/workflows/lint.yml
```
Or push and check the Actions tab on GitHub.

**Step 3: Commit and push**

```bash
git add .github/workflows/lint.yml
git commit -m "ci: add lint workflow (shellcheck, yamllint, taplo, chezmoi verify)"
git pull && git push
```

**Step 4: Verify on GitHub**

Open the Actions tab and confirm all 4 jobs pass on the push.

---

### Task 5: Push everything

```bash
git pull && git push
```

All previous task commits (Tasks 1–3) that weren't individually pushed get pushed here.
