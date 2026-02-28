# Atuin Integration Design — 2026-02-28

## Goal

Install and configure Atuin (shell history sync) via chezmoi on macOS and Linux, with automatic login from 1Password credentials.

## Decision: No Daemon

The daemon is skipped. `sync_frequency = 0` already syncs on every command, and `filter_mode = "host"` means cross-machine sync latency is irrelevant. SQLite write conflicts are rare in a typical single-terminal workflow. The daemon can be added later if needed.

---

## Components

### 1. Installation

Add `atuin` to `packages.cargo` in `home/.chezmoidata/packages.yaml`. Cargo is already present on all supported platforms (installed by `run_once_after_10-install-rust.sh`).

### 2. Config

**File:** `home/dot_config/atuin/config.toml` (plain file, no template)

```toml
[sync]
auto_sync = true
sync_frequency = "0"

[history]
filter_mode = "host"

[keys]
dialect = "uk"
```

### 3. Fish Shell Integration

**File:** `home/dot_config/fish/conf.d/atuin.fish`

```fish
if command -q atuin
    atuin init fish | source
end
```

### 4. Login Script

**File:** `home/.chezmoiscripts/run_once_after_35-login-atuin.sh.tmpl`

- Runs on: macOS and personal non-headless Linux only
- Idempotent: skips if `~/.local/share/atuin/session` already exists
- Reads credentials from 1Password at `chezmoi apply` time using `onepasswordRead`:
  - Username: `op://Private/Atuin/CLI/gebruikersnaam`
  - Password: `op://Private/Atuin/CLI/wachtwoord`
  - Key: `op://Private/Atuin/CLI/key`
- Runs: `atuin login -u "$user" -p "$pass" -k "$key"`

---

## 1Password Field References

| Field      | 1Password path                          |
|------------|-----------------------------------------|
| Username   | `op://Private/Atuin/CLI/gebruikersnaam` |
| Password   | `op://Private/Atuin/CLI/wachtwoord`     |
| Key        | `op://Private/Atuin/CLI/key`            |

---

## What Is NOT Included

- No daemon (no systemd unit, no launchd plist)
- No abbreviations (atuin is invoked via Ctrl+R, not typed)
