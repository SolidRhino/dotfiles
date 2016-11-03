if test $(which npm)
then
  if test ! $(which yarn)
  then
    npm install --global yarn
  else
    yarn self-update
  fi

  if test $(which yarn)
  then
    yarn global add spoof
    yarn global add react-native-cli
  fi
fi
