# Navigation (always available)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias mkdir="mkdir -p"
alias cls="clear"

# Replace ls with eza if available
if command -q eza
    alias ls="eza --icons"
    alias ll="eza -lah --icons --git"
    alias la="eza -a --icons"
    alias lt="eza --tree --icons"
else
    alias ll="ls -lah"
    alias la="ls -A"
end

# Replace grep with ripgrep if available
if command -q rg
    alias grep="rg"
else
    alias grep="grep --color=auto"
end

# Replace cat with bat if available
if command -q bat
    alias cat="bat"
end

# Neovim
if command -q nvim
    alias v="nvim"
    alias vi="nvim"
end

# Lazygit
if command -q lazygit
    alias lg="lazygit"
end

# Reload fish config
alias reload="exec fish"