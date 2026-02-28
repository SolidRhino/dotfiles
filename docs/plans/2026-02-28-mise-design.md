# Mise Integration Design — 2026-02-28

## Goal

Install mise (runtime version manager) via chezmoi on macOS and Linux, with Node.js LTS as the first global tool. Designed to easily add more runtimes in the future.

## Decision: Install via Cargo

Mise is written in Rust and available on crates.io. Installing via `packages.cargo` is the simplest approach: cross-platform, auto-updated via `cargo-update` + `topgrade`, and consistent with how other Rust tools (bat, eza, ripgrep, etc.) are managed.

---

## Components

### 1. Installation

Add `mise` to `packages.cargo` in `home/.chezmoidata/packages.yaml`. No extra install scripts or platform-specific logic needed.

### 2. Global Tool Config

**File:** `home/dot_config/mise/config.toml` (plain file, no template)

```toml
[tools]
node = "lts"
```

Adding new runtimes in the future means adding a line here (e.g. `python = "latest"`) and the install script will pick it up automatically.

### 3. Tool Install Script

**File:** `home/.chezmoiscripts/run_onchange_after_21-install-mise-tools.sh.tmpl`

- Runs after `run_onchange_after_20` (cargo packages) — mise will be installed first
- `run_onchange`: reruns whenever the rendered script content changes
- Embeds the mise config content as a comment (same pattern as the cargo packages script) so adding a new tool to `config.toml` triggers a rerun
- Idempotent: `mise install` is a no-op if tools are already installed

### 4. Fish Shell Integration

**File:** `home/dot_config/fish/conf.d/mise.fish`

```fish
if command -q mise
    mise activate fish | source
end
```

Standard `command -q` guard, consistent with atuin.fish and starship.fish.

---

## What Is NOT Included

- No per-platform install scripts (cargo handles all platforms)
- No project-level `.mise.toml` files (global only)
- No other runtimes yet (easy to add by editing `config.toml`)
