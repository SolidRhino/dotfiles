if test $(which composer)
then
  if test ! $(which valet)
  then
    composer global require laravel/valet
    valet install
  else
    composer global update laravel/valet
    valet install
  fi
fi
