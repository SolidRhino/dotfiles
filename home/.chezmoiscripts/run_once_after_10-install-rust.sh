#!/bin/bash
set -eufo pipefail

if command -v rustup >/dev/null 2>&1; then
		exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
