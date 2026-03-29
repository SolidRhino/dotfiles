# AGENTS.md — Chezmoi Dotfiles Repo

Chezmoi dotfiles repository managing development environment configuration
across macOS and Linux. Manages Fish shell, Neovim, Git, mise, Starship,
Atuin, and related tools. Uses 1Password for secrets.

---

## Read This First

- **Serena memories (`.serena/`) are the primary source of detailed conventions** — read all
  project memories before making significant changes
- This file contains the essential rules that must stay highly visible to every agent
- Use English by default; only switch languages when the user explicitly asks for it
- If this file and a Serena memory ever contradict each other, the Serena memory wins
  for detail; keep this file minimal and authoritative

---

## Repository Layout

```
chezmoi/
├── home/                    # chezmoi source root — maps directly to $HOME
│   ├── .chezmoiscripts/     # setup/apply scripts (ordered by numeric prefix)
│   ├── .chezmoidata/        # package declarations and template data
│   ├── dot_config/          # → ~/.config/
│   ├── dot_local/           # → ~/.local/
│   └── .chezmoi.toml.tmpl  # chezmoi config template
├── .github/workflows/       # CI (lint, shellcheck, chezmoi-verify, changelog)
├── site/                    # Astro/Starlight docs site
├── CHANGELOG.md             # managed by git-cliff via GitHub Actions
├── AGENTS.md                # this file — essential rules for every agent
└── .serena/                 # Serena memories — primary source of conventions
```

**Key path mappings:** `dot_` → `.`, `private_` → mode 600, `empty_` → empty
file, `.tmpl` → Go template rendered at apply time.

---

## Build / Lint / Test Commands

This repo has **no unit-test suite**. Validation is done through linting and
chezmoi render checks.

### Validate everything locally

```fish
# 1. Shellcheck plain (non-templated) scripts
shellcheck \
  .install-op-and-age.sh \
  home/.chezmoiscripts/run_before_00-write-age-identity.sh \
  home/.chezmoiscripts/run_once_after_25-setup-op-gh-plugin.sh \
  home/dot_local/bin/executable_oscar-update

# 2. YAML lint
yamllint .github/workflows/
yamllint home/.chezmoidata/packages.yaml

# 3. TOML syntax
python3 -c "import tomllib; tomllib.load(open('cliff.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/starship.toml', 'rb')); print('OK')"
python3 -c "import tomllib; tomllib.load(open('home/dot_config/atuin/config.toml', 'rb')); print('OK')"

# 4. Chezmoi render sanity check (excludes secret-backed templates)
chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null

# 5. Verify CI bootstrap helper is safe
CI=1 bash .install-op-and-age.sh
```

### Render a single template

```bash
# Render a specific .tmpl file for inspection
chezmoi --source=home execute-template -f home/dot_gitconfig.tmpl
chezmoi --source=home execute-template -f home/.chezmoiscripts/run_onchange_after_20-install-cargo-packages.sh.tmpl
```

### Templated scripts: CI is authoritative

The `.sh.tmpl` scripts are rendered against a matrix of machine configs
(osid, personal, headless, ephemeral) and shellchecked only in CI. Local
renders may fail if 1Password is unavailable. Push to CI to validate them.

### Apply dotfiles

```fish
chezmoi apply          # apply all changes
chezmoi diff           # preview changes before applying
chezmoi edit <file>    # edit a managed file in $EDITOR

# Fish abbreviations (if fish config is applied):
czap   # chezmoi apply
czed   # chezmoi edit
czdf   # chezmoi diff
czad   # chezmoi add
czcd   # chezmoi cd
```

---

## Code Style

### Shell scripts

- **Shebang:** always `#!/bin/bash` — never `#!/bin/sh`
- **Strict mode:** always `set -eufo pipefail` on the first line after the shebang
- Fail loudly on errors; do not silently swallow failures
- Guard optional tool calls with `command -v <tool> || return/exit`
- Use numeric prefixes to control execution order (`before_10`, `after_20`, etc.)

### Chezmoi templates (`.tmpl` files)

- Machine type variables: `.chezmoi.os`, `.osid`, `.personal`, `.headless`,
  `.ephemeral`, `.hostname`
- **Secrets:** use `onepasswordRead` inside templates — never `op read` in
  Fish config files
- `op read` is allowed inside chezmoi scripts (they run at apply time, not
  shell startup)
- Ephemeral gating: wrap scripts that must not run in CI/containers with
  `{{ if not .ephemeral -}} ... {{ end -}}`; keep the shebang and
  `set -eufo pipefail` inside the guard
- Age public key is hardcoded in `.chezmoi.toml.tmpl` — only the private key
  requires 1Password access

### YAML

- Lint config: `.yamllint.yaml`
- Max line length: 120 (warning, not error)
- `document-start` (`---`) is disabled
- Truthy values: `true` / `false` only (not `yes`/`no`)
- 2-space indentation

### TOML

- 2-space indentation
- Validate syntax with `python3 -c "import tomllib; ..."`

### Editor config (`.editorconfig`)

- Charset: UTF-8, line endings: LF
- Default indent: **tabs**, size 2
- YAML / TOML / JSON: **spaces**, size 2
- Final newline: yes, trim trailing whitespace: yes

---

## Naming Conventions

| File prefix/suffix | Meaning |
|---|---|
| `dot_` | Maps to `.` in target (e.g. `dot_gitconfig` → `~/.gitconfig`) |
| `private_` | Installed with mode 600 |
| `empty_` | Creates an empty file |
| `.tmpl` | Go template, rendered by chezmoi at apply time |
| `encrypted_` | Age-encrypted file |
| `run_once_` | Script runs once per machine (hash-tracked) |
| `run_onchange_` | Script runs when its content changes |
| `run_before_` / `run_after_` | Script ordering (before/after file writes) |
| Numeric infix (`before_10`, `after_20`) | Ordering within a phase |

---

## Secrets and 1Password

- **In templates:** `{{ onepasswordRead "op://vault/item/field" }}`
- **In scripts:** `op read "op://vault/item/field"` (allowed at apply time)
- **Never in Fish config:** `op read` blocks shell startup — use `.tmpl` files
- The age private key is written by the bootstrap helper or fallback script;
  the public key is hardcoded

---

## Fish Shell Config Layout

Files under `home/dot_config/fish/`:

- `conf.d/` — modular config loaded alphabetically at shell start
- `aliases.fish` — tool replacements and navigation shortcuts
- `abbreviations.fish` — workflow shortcuts (prefer abbreviations over aliases)
- `reload` uses `exec fish` to replace the current shell process

### Shell completions

Tool completions live in `home/dot_config/fish/completions/`. Most are `.tmpl` files that
invoke the tool's own completion command at apply time (e.g. `chezmoi`, `mise`, `atuin`).

**OpenCode** is the exception: `completions/opencode.fish` is a plain (non-template) file
that calls `opencode --get-yargs-completions` **dynamically at completion time**, so it stays
current with whatever OpenCode version is installed without needing a `chezmoi apply`.
This is a temporary workaround until upstream adds native Fish completion output
([anomalyco/opencode#1515](https://github.com/anomalyco/opencode/issues/1515)).

---

## Package Management

- Package declarations live in `home/.chezmoidata/packages.yaml`
- **macOS:** Homebrew (Darwin scripts in `.chezmoiscripts/darwin/`)
- **Linux:** distro-specific scripts; Arch uses `yay` (never with `sudo`)
- **Cargo:** crate names in `packages.yaml`; prefers `cargo-binstall`, falls
  back to `cargo install --locked`
- **mise:** `home/dot_config/mise/config.toml.tmpl`; use `latest` for dev
  tools, `lts` for runtimes, major pins for stable lines (e.g. `ruby = "4"`)

---

## CHANGELOG

- **Never run `git-cliff` locally.** The `dotfiles-changelog` GitHub Actions
  workflow updates `CHANGELOG.md` automatically on merge to `main`.

---

## Critical Rules (summary)

1. `home/` is the chezmoi source root — all managed files live there
2. All scripts: `#!/bin/bash` + `set -eufo pipefail`
3. No `op read` in Fish config — use `onepasswordRead` in `.tmpl` files
4. Scripts must fail loudly, never silently ignore errors
5. Serena memories (`.serena/`) are the authoritative source of conventions
   — read them before making significant changes
6. When adding a file to chezmoi, check if Mackup would also manage it and
   update Mackup ignore settings accordingly
