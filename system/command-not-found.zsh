# Add command not found
# brew tap homebrew/command-not-found
if brew command command-not-found-init > /dev/null; then
  eval "$(brew command-not-found-init)";
fi
