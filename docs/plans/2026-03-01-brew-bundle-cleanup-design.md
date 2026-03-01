# Brew Bundle Cleanup Design — 2026-03-01

## Goal

Automatically remove Homebrew packages not listed in `packages.yaml` on every `chezmoi apply`, making the macOS package state fully declarative.

## Decision: Temp Brewfile in Existing Script

The darwin install script already uses `brew bundle --file=/dev/stdin`. The fix is minimal: write the rendered Brewfile to a temp file (so it can be referenced by two commands) and add `brew bundle cleanup --force` after install.

No new files. No execution order changes. Single file change.

---

## Component

**File:** `home/.chezmoiscripts/darwin/run_onchange_before_10-install-packages.sh.tmpl`

Replace the current `brew bundle --file=/dev/stdin <<EOF` heredoc with:

```bash
BREWFILE=$(mktemp)
trap 'rm -f "$BREWFILE"' EXIT

cat > "$BREWFILE" <<'EOF'
<rendered package list>
EOF

brew bundle install --file="$BREWFILE"
brew bundle cleanup --force --file="$BREWFILE"
```

- `mktemp` + `trap` ensures the temp file is always cleaned up
- chezmoi renders the `{{ range }}` template expressions into the heredoc at apply time
- `brew bundle install` installs missing packages (idempotent)
- `brew bundle cleanup --force` removes any Homebrew-managed package not in the Brewfile

## Behaviour

- Runs whenever `packages.yaml` changes (run_onchange trigger)
- Destructive: removes packages installed outside chezmoi — this is intentional
