#!/usr/bin/env sh
set -eu

TARGET="$HOME/.config/opencode/plugins/shell-strategy/shell_strategy.md"
TARGET_DIR="$(dirname "$TARGET")"
CACHE_FILE="$HOME/.cache/opencode-shell-strategy.last-check"
TMP_FILE="$(mktemp)"
URL="https://raw.githubusercontent.com/JRedeker/opencode-shell-strategy/trunk/shell_strategy.md"
MAX_AGE_SECONDS=86400

cleanup() {
  rm -f "$TMP_FILE"
}

get_mtime() {
  if stat -f %m "$1" >/dev/null 2>&1; then
    stat -f %m "$1"
    return 0
  fi

  if stat -c %Y "$1" >/dev/null 2>&1; then
    stat -c %Y "$1"
    return 0
  fi

  return 1
}

mkdir -p "$TARGET_DIR"
mkdir -p "$(dirname "$CACHE_FILE")"

should_refresh=true

if [ -f "$CACHE_FILE" ]; then
  now="$(date +%s)"
  if last_check="$(get_mtime "$CACHE_FILE")"; then
    age="$((now - last_check))"
    if [ "$age" -lt "$MAX_AGE_SECONDS" ]; then
      should_refresh=false
    fi
  fi
fi

if [ "$should_refresh" = true ]; then
  trap cleanup EXIT INT TERM

  if curl -fsSL --max-time 5 "$URL" -o "$TMP_FILE"; then
    if [ ! -f "$TARGET" ] || ! cmp -s "$TMP_FILE" "$TARGET"; then
      mv "$TMP_FILE" "$TARGET"
    fi
    touch "$CACHE_FILE"
  fi

  trap - EXIT INT TERM
  cleanup
fi

# Verify opencode is available in PATH before exec — exit 127 (command not found)
# with a clear message if it is missing, rather than a cryptic shell error.
if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode-start.sh: error: 'opencode' not found in PATH" >&2
  echo "  Install it from https://opencode.ai or ensure the install directory is on PATH." >&2
  exit 127
fi

exec opencode "$@"
