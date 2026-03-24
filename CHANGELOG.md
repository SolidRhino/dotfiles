---
title: Changelog
description: All notable changes to this dotfiles repository.
---

# Changelog

All notable changes to this dotfiles repository will be documented here.

## 🌿 Latest
### ⚙️ CI
- Expand dotfiles validation coverage

### 📚 Documentation
- Clarify project guidance sources
- Document tool versioning and install policy

### 🔧 Miscellaneous
- Update changelog
- Stabilize local tooling setup
- Update changelog

### 🚀 Features
- Consolidate linux package repo bootstrap
- Speed up cargo package installs

## 23-03-2026
### ⚙️ CI
- Only deploy on documentation file changes
- Use actor-based loop guard in changelog workflow
- Add manual dispatch trigger to deploy workflow
- Add npm dependabot and set schedule to daily
- Gate dependabot auto-merge on required status checks
- Expand lint coverage for shellcheck and TOML validation

### 🐛 Bug Fixes
- Enforce bash strict mode in all scripts
- Surface 1Password errors in age identity script
- Make git gone alias portable across macOS and Linux
- Hardcode age public key to remove 1Password config dependency
- Add error handling and tool guards to setup scripts
- Add EDITOR fallback and use exec fish for reload

### 📚 Documentation
- Update project memories and conventions after code review fixes
- Update memories with Docker/colima conventions

### 📝 Other Changes
- Merge pull request #1 from SolidRhino/dependabot/npm_and_yarn/site/astro-6.0.5

chore(deps): bump astro from 6.0.4 to 6.0.5 in /site
- Merge pull request #2 from SolidRhino/dependabot/npm_and_yarn/site/astro-6.0.6

chore(deps): bump astro from 6.0.5 to 6.0.6 in /site
- Merge pull request #3 from SolidRhino/dependabot/github_actions/withastro/action-6

chore(deps): bump withastro/action from 5 to 6
- Merge pull request #4 from SolidRhino/dependabot/npm_and_yarn/site/astro-6.0.8

chore(deps): bump astro from 6.0.6 to 6.0.8 in /site
- Merge pull request #5 from SolidRhino/dependabot/npm_and_yarn/site/astrojs/starlight-0.38.2

chore(deps): bump @astrojs/starlight from 0.38.1 to 0.38.2 in /site
- Merge pull request #6 from SolidRhino/dependabot/npm_and_yarn/site/h3-1.15.9

chore(deps): bump h3 from 1.15.6 to 1.15.9 in /site

### 🔧 Miscellaneous
- Update changelog
- Update changelog
- Update changelog
- **deps:** Bump astro from 6.0.4 to 6.0.5 in /site
- **deps:** Bump astro from 6.0.5 to 6.0.6 in /site
- Tune atuin sync frequency and add toml editorconfig rule
- Update changelog
- Update changelog
- Update changelog
- **deps:** Bump withastro/action from 5 to 6
- **deps:** Bump astro from 6.0.6 to 6.0.8 in /site
- **deps:** Bump @astrojs/starlight from 0.38.1 to 0.38.2 in /site
- **deps:** Bump h3 from 1.15.6 to 1.15.9 in /site

### 🚀 Features
- Add Docker toolchain (colima, docker, ddev) and ChatGPT to macOS packages
- Add colima setup script with auto-start on macOS
- Add bun, opencode-ai, and oh-my-opencode to mise toolchain

## 16-03-2026
### ⏪ Reverts
- Remove Jekyll setup, switching to Starlight (Astro)
- Remove conflicting custom 404 page (conflicts with Starlight built-in route)

### ⚙️ CI
- Upgrade actions/checkout to v6 (Node.js 24)

### 🐛 Bug Fixes
- Install mise via official curl installer instead of cargo
- Use full path for pam_reattach.so in sudo_local
- Upgrade withastro/action to v5 for Node.js 22 support
- Add Starlight front matter to cliff.toml header so CI preserves it

### 📚 Documentation
- Update README to reflect current state
- Simplify CLAUDE.md to critical rules only
- Add CHEATSHEET.md with commands and naming conventions
- Restructure README for onboarding, move commands to CHEATSHEET
- Add machine type variables to Serena project_overview memory

### 📝 Other Changes
- Add xh, discord, jellyfin-media-player, CleanShot X; fix Numbers mas ID
- Add proxmox host to SSH config

### 🔧 Miscellaneous
- Remove vestigial cargo fallback from mise tools script
- Update serena memory with run_once_after_19-install-mise in ephemeral-gated scripts list
- Add Jekyll build artifacts to .gitignore
- Exclude docs/ and .superpowers/ from git

### 🚀 Features
- Add fish-lsp to mise global tools on non-headless machines
- Enable TouchID for sudo via /etc/pam.d/sudo_local
- Add Jekyll _config.yml for GitHub Pages site
- Add Gemfile for Jekyll + just-the-docs
- Add Jekyll front matter to docs pages
- Add Starlight (Astro) docs site with Catppuccin Mocha/Latte theme
- Add hero section to home page
- Add OpenGraph meta tags and edit-on-GitHub link
- Add custom 404 page

## 09-03-2026
### ⚙️ CI
- Exclude encrypted files from chezmoi verify in CI

### 🎨 Styling
- Align comment format in mas section

### 🐛 Bug Fixes
- Move zoxide to cargo packages instead of common
- Correct lint workflow and add go to mise
- Further lint workflow corrections
- Remove spurious -macOS- from OSCAR DMG filename
- Fix version scraping regex to match full URLs in OSCAR page HTML
- Use ditto instead of cp -R to preserve code signature when installing OSCAR
- Re-sign OSCAR after install to fix broken DMG signature on macOS 26
- Run oscar-update on every chezmoi apply to pick up new versions
- Exclude oscar-update from non-darwin systems

### 📚 Documentation
- Update CLAUDE.md with script table, atuin.fish, and mise path corrections
- Update script table for ephemeral gating and yay AUR helper
- Update Arch package strategy to reflect yay usage
- Add OSCAR script to CLAUDE.md execution order table
- Document run_ (always-run) script type in CLAUDE.md
- Update CLAUDE.md and Serena memories; gate archive extraction on JetBrains
- Update CLAUDE.md and Serena memories to reflect archive behaviour

### 📦 Refactoring
- Remove duplicate git alias from aliases.fish
- Remove duplicate docker aliases from aliases.fish
- Remove duplicate chezmoi aliases from aliases.fish

### 🔧 Miscellaneous
- Add Serena MCP project config and memory files
- Update Serena memories with zoxide, delta, and cargo naming notes
- Add .worktrees to gitignore
- Update Serena memories with ephemeral gating and AUR/yay notes
- Update Serena memories with fish completions patterns
- Update Serena memory with usage-cli requirement for mise completions
- Improve mackup and chezmoi external config
- Add ipfs-desktop to darwin casks
- Silence output from age identity and archive extraction scripts

### 🚀 Features
- Add mas support for Mac App Store app installation
- Add Mac App Store apps to packages.yaml
- Add uv to mise tools
- Add telegram, tor-browser casks and Luminar Neo, Moonlock, Shortcutie setapp apps; sort alphabetically
- Add router and docker SSH host entries
- Add zoxide with cd command override
- Add delta as git pager
- Skip rust install on ephemeral machines
- Skip cargo packages install on ephemeral machines
- Skip mise tools install on ephemeral machines
- Skip set-default-shell on ephemeral machines
- Add packages.aur scaffold for AUR packages
- Add yay AUR helper install script for Arch
- Use yay instead of pacman for Arch package installs
- Add mise fish completion (auto-generated at apply time)
- Run fish_update_completions once on setup
- Auto-update fish completions when packages change
- Add chezmoi fish completions
- Add usage-cli for mise fish completions
- Add python to mise tools
- Add oscar-update script
- Add chezmoi run_once script to bootstrap OSCAR install
- Add OSCAR to topgrade update commands
- Add encrypted archive with age encryption
- Gate archive extraction on JetBrains presence
- Conditionally ignore encrypted archive when no JetBrains installed

## 02-03-2026
### ⚙️ CI
- Auto-merge Dependabot PRs
- Add lint workflow (shellcheck, yamllint, taplo, chezmoi verify)

### 🎨 Styling
- Add comment header to mise.fish
- Reformat cliff.toml commit_parsers with taplo
- Add clarifying comments to brew bundle script

### 🐛 Bug Fixes
- Enforce rust-before-cargo script execution order
- Harden curl commands and pin cargo installs
- Read Claude OAuth token from 1Password at runtime
- Skip Claude token read if 1Password is not unlocked
- Bake Claude OAuth token at apply time via onepasswordRead
- Exclude chezmoi-managed apps from mackup backup
- Ignore nvim and wget in mackup (managed by chezmoi)
- Ignore lazygit in mackup
- Replace taplo fmt check with tomllib and inject chezmoi data for CI
- Correct without argument order in install-packages template
- Add [misc] to topgrade template and exclude mise from Mackup
- Reference config.toml.tmpl in mise tools script include
- Add TLS flags to curl and improve fallback message

### 📚 Documentation
- Update CLAUDE.md to reflect all recent changes
- Add CHANGELOG.md generated by git-cliff
- Add README with bootstrap, commands, and troubleshooting
- Fix bootstrap section to use install script and ~/.local/bin
- Clarify 1Password uses only apply-time onepasswordRead, never runtime op read
- Add enhancements design doc for lint workflow, git aliases, chezmoiignore, packages
- Add implementation plan for enhancements
- Add Atuin integration design doc
- Add Atuin implementation plan
- Add mise integration design
- Add mise implementation plan
- Update CLAUDE.md with mise integration details
- Add brew bundle cleanup design
- Add brew bundle cleanup implementation plan
- Document setapp-cli scripts in CLAUDE.md

### 📦 Refactoring
- Manage cargo packages via packages.yaml
- Adopt twpayne structural improvements + per-tool Linux repos
- Enforce script execution order with numeric prefixes
- Clean up Fish shell configuration

### 🔧 Miscellaneous
- Initial repository setup
- Add git-cliff config and chezmoi external skill
- Silence Initial commit warning in git-cliff
- Automate weekly changelog via GitHub Actions and date tags
- Fix cliff.toml unreleased timestamp error
- Bump GitHub Actions to latest versions
- Add Dependabot for automatic GitHub Actions updates
- Add emoji headers and filter changelog noise from cliff.toml
- Rename Unreleased to 🌿 Latest in changelog
- Gitignore Claude-generated plan docs and local settings

### 🚀 Features
- Add chezmoi dotfiles for Fish shell environment
- Install Rust via rustup and topgrade via cargo
- Install 1Password CLI on Linux
- Add Linux support to SSH config template
- Add cross-platform SSH commit signing via 1Password
- Add quality-of-life git config improvements
- Integrate mackup for iCloud GUI settings backup and restore
- Add nvim config as chezmoi external
- Add chezmoi refresh-externals shortcut to topgrade and fish
- Add git aliases (unstage, amend, undo, gone)
- Add .chezmoiignore to exclude secrets and externally managed paths
- Add shellcheck to common packages
- Add atuin to cargo packages
- Add atuin config
- Add atuin Fish shell integration
- Add atuin 1Password login script
- Add mise to cargo packages
- Add mise global tool config with node lts
- Add mise tool install script
- Add mise Fish shell integration
- Add tailscale cask for macOS
- Add ollama-app and whatsapp casks for macOS
- Add brew bundle cleanup to remove unmanaged packages
- Add smithery CLI via mise on macOS only
- Add Setapp cask to macOS packages
- Add router SSH host entry
- Add setapp app list to packages.yaml
- Add chezmoi-managed setapp bundle template
- Add run_once script to install setapp-cli
- Add run_onchange script to install setapp bundle


