#!/bin/bash
set -eu

if command -v topgrade >/dev/null 2>&1; then
    exit 0
fi

if ! command -v cargo >/dev/null 2>&1; then
    # Source cargo env in case rustup just ran in a prior script
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
fi

cargo install topgrade
