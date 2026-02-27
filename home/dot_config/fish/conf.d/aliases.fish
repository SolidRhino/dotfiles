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

# Git
if command -q git
    alias g="git"
end

# Lazygit
if command -q lazygit
    alias lg="lazygit"
end

# Docker
if command -q docker
    alias d="docker"
    alias dc="docker compose"
end

# Chezmoi
if command -q chezmoi
    alias cz="chezmoi"
    alias czap="chezmoi apply"
    alias czed="chezmoi edit"
    alias czcd="chezmoi cd"
    alias czad="chezmoi add"
end

# Reload fish config
alias reload="source ~/.config/fish/config.fish"