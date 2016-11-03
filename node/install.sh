if test $(which node)
then
  if test ! $(which spoof)
  then
    npm install spoof -g
  fi

  if test ! $(which react-native)
  then
    npm install -g react-native-cli
  fi
fi
