#!/bin/sh

# Write age identity from 1Password for chezmoi decryption
# This runs before chezmoi apply to ensure encrypted files can be decrypted

set -e

AGE_KEY_PATH="${HOME}/.config/chezmoi/age-key.txt"

# Ensure directory exists
mkdir -p "$(dirname "$AGE_KEY_PATH")"

# Write age identity from 1Password if it exists
if command -v op >/dev/null 2>&1; then
    if op read "op://Private/chezmoi-age/private" > "$AGE_KEY_PATH" 2>/dev/null; then
        chmod 600 "$AGE_KEY_PATH"
        echo "Age identity written to $AGE_KEY_PATH"
    fi
fi
