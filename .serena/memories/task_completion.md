# Task Completion Checklist

When finishing any change to this dotfiles repo:

1. **Verify templates render**: `chezmoi --source=home dump --format=json > /dev/null`
2. **Preview changes**: `chezmoi diff`
3. **Lint if modified**:
   - Plain shell scripts: `shellcheck <script>`
   - YAML files: `yamllint <file>`
   - TOML files: `python3 -c "import tomllib; tomllib.load(open('cliff.toml', 'rb'))"`
4. **Mackup overlap**: If a new file was added to chezmoi, add its app to `applications_to_ignore` in `home/dot_mackup.cfg.tmpl`
5. **CLAUDE.md**: Keep project CLAUDE.md updated if conventions change
6. **Commit**: `git add <files> && git commit -m "type: description"`
   - Do NOT include Co-Authored-By Claude lines
   - CHANGELOG is updated automatically by CI (git-cliff) — do not run locally
7. **Push**: `git pull --rebase && git push` — CI may have added CHANGELOG commits between your last pull and push

## Notes
- `docs/plans/` is **gitignored** — design docs stay local only, not tracked in git
- `.serena/` should NOT be committed — it's the Serena MCP project config, untracked by design
