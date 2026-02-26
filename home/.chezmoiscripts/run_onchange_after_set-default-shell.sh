#!/bin/bash
set -eufo pipefail

FISH_PATH="$(command -v fish)"

if ! grep -qF "$FISH_PATH" /etc/shells; then
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$FISH_PATH" ]; then
  chsh -s "$FISH_PATH"
fi
