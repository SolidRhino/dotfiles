# Git
if command -q git
    abbr -a g    git
    abbr -a ga   git add
    abbr -a gaa  git add --all
    abbr -a gc   git commit
    abbr -a gcm  git commit -m
    abbr -a gp   git push
    abbr -a gpl  git pull
    abbr -a gs   git status
    abbr -a gd   git diff
    abbr -a gco  git checkout
    abbr -a gb   git branch
    abbr -a gl   git log --oneline --graph --decorate
end

# Docker
if command -q docker
    abbr -a d    docker
    abbr -a dc   docker compose
    abbr -a dcu  docker compose up -d
    abbr -a dcd  docker compose down
    abbr -a dcl  docker compose logs -f
    abbr -a dcp  docker compose pull
end

# Chezmoi
if command -q chezmoi
    abbr -a cz   chezmoi
    abbr -a czap chezmoi apply
    abbr -a czed chezmoi edit
    abbr -a czcd chezmoi cd
    abbr -a czdf chezmoi diff
    abbr -a czad chezmoi add
end

# Systeem package managers
if command -q apt
    abbr -a upd "sudo apt update && sudo apt upgrade -y"
end

if command -q brew
    abbr -a upd "brew update && brew upgrade"
end

if command -q dnf
    abbr -a upd "sudo dnf upgrade -y"
end

if command -q pacman
    abbr -a upd "sudo pacman -Syu"
end