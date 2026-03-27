Post-review follow-up for warning cleanup commits:

- Reverted Atuin login script (`home/.chezmoiscripts/run_once_after_35-login-atuin.sh.tmpl`) from stdin-piped credentials back to explicit `-p` and `-k` flags.
- Reason: Atuin password prompt uses TTY (`rpassword`) when `-p` is omitted, so stdin piping is not consumed for password and can block automation.
- This script is a one-time chezmoi automation script, so shell history exposure concern from interactive terminal usage is not applicable.
- Also fixed quote consistency in `.github/workflows/lint.yml`: changed `>> $GITHUB_PATH` to `>> "$GITHUB_PATH"`.
- YAML parse check passed after change.
