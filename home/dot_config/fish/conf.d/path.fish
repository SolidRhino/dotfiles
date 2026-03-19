fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

if command -q nvim
    set -gx EDITOR nvim
else if command -q vim
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end
set -gx VISUAL $EDITOR
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
