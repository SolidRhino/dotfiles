#!/bin/bash

# Fallback age identity hydration for machines that do not yet use the
# pre-source-state bootstrap hook.

set -eufo pipefail

AGE_KEY_PATH="${HOME}/.config/chezmoi/age-key.txt"

if [ -s "$AGE_KEY_PATH" ] && grep -Fq 'AGE-SECRET-KEY-' "$AGE_KEY_PATH"; then
    exit 0
fi

# Ensure directory exists
mkdir -p "$(dirname "$AGE_KEY_PATH")"

TMP_KEY_PATH="$(mktemp "$(dirname "$AGE_KEY_PATH")/age-key.txt.XXXXXX")"
trap 'rm -f "$TMP_KEY_PATH"' EXIT

# Write age identity from 1Password only when still missing
if ! command -v op >/dev/null 2>&1; then
    echo "Warning: 1Password CLI (op) not found — skipping age key write" >&2
    echo "Encrypted files will not be available until op is installed and authenticated" >&2
    exit 0
fi

if ! op read "op://Private/chezmoi-age/private" > "$TMP_KEY_PATH"; then
    echo "Error: failed to read age key from 1Password" >&2
    echo "Ensure 1Password CLI is installed, unlocked, and authenticated, then rerun chezmoi apply" >&2
    exit 1
fi

if ! grep -Fq 'AGE-SECRET-KEY-' "$TMP_KEY_PATH"; then
    echo "Error: 1Password item did not contain a valid age secret key" >&2
    exit 1
fi

chmod 600 "$TMP_KEY_PATH"
mv "$TMP_KEY_PATH" "$AGE_KEY_PATH"
trap - EXIT
