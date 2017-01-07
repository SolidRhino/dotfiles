if test ! $(which zplug)
then
  if [[ -z $ZPLUG_HOME ]]; then
    export ZPLUG_HOME=~/.zplug
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
  fi
else
  zplug update
fi
