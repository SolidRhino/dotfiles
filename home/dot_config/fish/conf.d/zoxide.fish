# Initialize zoxide — replaces cd with smart directory jumping
if command -q zoxide
    zoxide init fish --cmd cd | source
end
