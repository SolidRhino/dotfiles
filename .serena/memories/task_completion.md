# Task Completion Checklist

When finishing any change to this dotfiles repo:

1. **Verify templates render**: `chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null`
2. **Preview changes**: `chezmoi diff`
3. **Lint if modified**:
   - Plain shell scripts: `shellcheck <script>` (CI covers: `run_before_00-write-age-identity.sh`, `run_once_after_25-setup-op-gh-plugin.sh`, `executable_oscar-update`)
   - YAML files: `yamllint <file>`
   - TOML files: `python3 -c "import tomllib; tomllib.load(open('<file>', 'rb'))"` (CI covers: `cliff.toml`, `starship.toml`, `atuin/config.toml`)
4. **Mackup check**: Before adding a new file to chezmoi, run `mackup backup --dry-run` (or check `~/.mackup/`) to see if mackup already backs up that file — if so, migrate it to chezmoi instead of having both manage it
5. **Mackup overlap**: If a new file was added to chezmoi, add its app to `applications_to_ignore` in `home/dot_mackup.cfg.tmpl`
5. **CLAUDE.md**: Keep project CLAUDE.md updated if conventions change
6. **Commit**: Follow a logical git commit strategy — one commit per logical change, never bundle unrelated changes together. Examples:
   - Script behaviour change → own commit
   - Config/ignore change → own commit
   - Package addition → own commit
   - Docs/memory update → own commit
   - `git add <files> && git commit -m "type: description"`
   - Do NOT include Co-Authored-By Claude lines
   - CHANGELOG is updated automatically by CI (git-cliff) — do not run locally
7. **Push**: `git push origin main`
8. **Pull**: `git pull origin main` — CI commits an updated CHANGELOG back; always pull after every push

## Notes
- `docs/plans/` is **gitignored** — design docs stay local only, not tracked in git
- `.serena/` **should be committed** — contains Serena project config and memory files (its own `.gitignore` excludes `/cache`)
