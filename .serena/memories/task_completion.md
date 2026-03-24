# Task Completion Checklist

When finishing any change to this dotfiles repo:

1. **Verify renderability when practical**
   - `chezmoi --source=home dump --format=json --exclude=encrypted > /dev/null`
   - If local secret-backed templates block full rendering, use targeted checks and rely on CI for representative template rendering.

2. **Preview changes**
   - `chezmoi diff`

3. **Lint / validate modified files**
   - Plain shell scripts: `shellcheck <script>`
   - Rendered shell templates: rely on CI generated-shellcheck coverage
   - YAML: `yamllint <file>`
   - TOML: `python3 -c "import tomllib; tomllib.load(open('<file>', 'rb'))"`

4. **Mackup check**
   - Before adding a new file to chezmoi, check whether Mackup already manages it.

5. **Mackup overlap**
   - If a new file is added to chezmoi, add its app to `applications_to_ignore` in `home/dot_mackup.cfg.tmpl` if needed.

6. **CLAUDE.md**
   - Keep project CLAUDE.md updated if conventions change.

7. **Commit strategy**
   - Use logical git commits: one commit per logical change
   - Keep scripts, docs, CI, package changes separate when they are meaningfully independent
   - Do not include Co-Authored-By Claude lines
   - Do not run `git-cliff` locally

8. **Push / pull flow**
   - `git push origin main`
   - `git pull origin main`
   - CI may push an updated `CHANGELOG.md`, so pull after pushing

## Notes
- `docs/` is gitignored in this repo; local design/plan docs under `docs/` are not tracked
- `.serena/` should be committed; `.serena/.gitignore` only excludes cache data
