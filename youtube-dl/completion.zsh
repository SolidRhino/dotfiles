#youtube-dl completion
completion='$(brew --prefix)/share/zsh/site-functions/_youtube-dl'

if test -f $completion
then
  source $completion
fi
