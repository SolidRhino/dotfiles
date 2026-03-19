#!/bin/bash

# Write age identity from 1Password for chezmoi decryption
# This runs before chezmoi apply to ensure encrypted files can be decrypted

set -eufo pipefail

AGE_KEY_PATH="${HOME}/.config/chezmoi/age-key.txt"

# Ensure directory exists
mkdir -p "$(dirname "$AGE_KEY_PATH")"

# Write age identity from 1Password
if ! command -v op >/dev/null 2>&1; then
    echo "Warning: 1Password CLI (op) not found — skipping age key write" >&2
    echo "Encrypted files will not be available until op is installed and authenticated" >&2
    exit 0
fi

if ! op read "op://Private/chezmoi-age/private" > "$AGE_KEY_PATH"; then
    echo "Error: failed to read age key from 1Password" >&2
    echo "Ensure 1Password CLI is authenticated: eval \$(op signin)" >&2
    rm -f "$AGE_KEY_PATH"
    exit 1
fi

chmod 600 "$AGE_KEY_PATH"
