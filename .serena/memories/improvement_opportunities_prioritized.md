# Prioritized Improvement Opportunities

## Quick wins
1. Fix README bootstrap typo
   - File: `README.md:24`
   - Change `SolidRhino/dotfile` to `SolidRhino/dotfiles`

2. Make GitHub credential helper portable
   - File: `home/dot_gitconfig.tmpl`
   - Replace hardcoded `gh` binary paths with PATH-based invocation

3. Update 1Password auth messaging
   - File: `home/.chezmoiscripts/run_before_00-write-age-identity.sh:22`
   - Remove Fish-unfriendly `eval $(op signin)` guidance

4. Replace stale site boilerplate
   - File: `site/README.md`
   - Replace Astro starter text with repo-specific docs or remove it

## Medium effort
5. Expand CI render coverage
   - File: `.github/workflows/lint.yml`
   - Add matrix for key profiles: darwin/personal, linux-ubuntu/headless, linux-arch/personal, linux-fedora/headless

6. Validate rendered shell templates
   - Area: `home/.chezmoiscripts/**/*.sh.tmpl`
   - Render representative scripts in CI, then run shellcheck on rendered output

7. Improve `oscar-update` safety
   - File: `home/dot_local/bin/executable_oscar-update`
   - Install to a temp location first, verify success, then replace existing app

## Larger improvements
8. Refactor package/repo bootstrap logic
   - Files: `home/.chezmoiscripts/linux/run_onchange_before_10-*`, `home/.chezmoiscripts/linux/run_onchange_before_20-install-packages.sh.tmpl`
   - Reduce distro-specific duplication with shared helper structure

9. Add a documented versioning policy
   - File: `home/dot_config/mise/config.toml.tmpl`
   - Document when to use `latest`, `lts`, or major-pinned versions

10. Optimize tool installation strategy
   - File: `home/.chezmoiscripts/run_onchange_after_20-install-cargo-packages.sh.tmpl`
   - Skip already-correct installs or use a faster binary-first path

## Recommended order
- Do now: 1-4
- Next: 5-7
- Later: 8-10
