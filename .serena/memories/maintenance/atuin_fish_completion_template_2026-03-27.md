Added Atuin Fish completion template at `home/dot_config/fish/completions/atuin.fish.tmpl`.

Template uses a command-availability guard so rendering only emits completions when Atuin is installed:

- `{{ if lookPath "atuin" }}`
- `{{ output "atuin" "gen-completions" "--shell" "fish" }}`

This follows the existing repo pattern for command-generated fish completions while honoring the requirement to include completions only if Atuin exists on the machine.