if test $(which vagrant)
then

  if test $(which bindfs)
  then
    vagrant plugin install vagrant-bindfs
  fi
  
  vagrant plugin install vagrant-hostmanager
fi
