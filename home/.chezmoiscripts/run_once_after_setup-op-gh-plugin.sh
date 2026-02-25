#!/usr/bin/env bash
# Set up 1Password GitHub CLI plugin (interactive, runs once)

# Skip if op is not installed
if ! command -v op &>/dev/null; then
    echo "Skipping: 1Password CLI (op) not found"
    exit 0
fi

# Skip if already configured
if [ -f "$HOME/.config/op/plugins.sh" ]; then
    echo "Skipping: 1Password op plugins already configured"
    exit 0
fi

echo "Setting up 1Password GitHub CLI plugin..."
echo "You will be prompted to authenticate with 1Password."
op plugin init gh