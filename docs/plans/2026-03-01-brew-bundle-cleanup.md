# Brew Bundle Cleanup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Automatically remove Homebrew packages not in `packages.yaml` by adding `brew bundle cleanup --force` to the darwin install script.

**Architecture:** Replace the current `brew bundle --file=/dev/stdin` heredoc (which only supports one command) with a temp file approach — write the rendered Brewfile to `mktemp`, run install, then run cleanup against the same file. Single file change.

**Tech Stack:** chezmoi Go templates, bash, Homebrew `brew bundle`

---

### Task 1: Update the darwin install script

**Files:**
- Modify: `home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl`

**Step 1: Read the current file**

```bash
cat home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl
```

Expected: the file uses `brew bundle --file=/dev/stdin <<EOF ... EOF`.

**Step 2: Replace the script body with the temp file approach**

The new content of the file (replacing everything after the Homebrew install block):

```bash
{{ if eq .chezmoi.os "darwin" -}}
#!/bin/bash
set -eufo pipefail

if ! command -v brew >/dev/null 2>&1; then
    # Using Homebrew's prescribed install command verbatim (intentionally omits --proto/--tlsv1.2)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREWFILE=$(mktemp)
trap 'rm -f "$BREWFILE"' EXIT

cat > "$BREWFILE" <<'EOF'
{{ range (concat .packages.common .packages.darwin.brews) -}}
brew "{{ . }}"
{{ end -}}
{{ range .packages.darwin.casks -}}
cask "{{ . }}"
{{ end -}}
EOF

brew bundle install --file="$BREWFILE"
brew bundle cleanup --force --file="$BREWFILE"
{{ end -}}
```

**Step 3: Verify the template renders correctly**

```bash
chezmoi execute-template < home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl 2>/dev/null
```

Expected: a valid bash script with the Brewfile content embedded in the heredoc, followed by `brew bundle install` and `brew bundle cleanup --force`.

**Step 4: Preview what cleanup would remove (dry run — safe, no --force)**

Run this manually to see what would be uninstalled before applying:

```bash
BREWFILE=$(mktemp)
trap 'rm -f "$BREWFILE"' EXIT
chezmoi execute-template < home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl 2>/dev/null \
  | grep -E '^(brew|cask) ' > "$BREWFILE"
brew bundle cleanup --file="$BREWFILE"
```

Expected: lists packages that would be removed. Review the list — if anything unexpected appears, add it to `packages.yaml` before proceeding.

**Step 5: Commit**

```bash
git add home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl
git commit -m "feat: add brew bundle cleanup to remove unmanaged packages"
git pull --rebase && git push
```
