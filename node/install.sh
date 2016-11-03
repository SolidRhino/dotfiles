if test $(which npm)
then
  if test ! $(which yarn)
  then
    npm install --global yarn
  fi

  if test $(which yarn)
  then
    yarn self-update
    yarn global add spoof
    yarn global add react-native-cli
  fi
fi
