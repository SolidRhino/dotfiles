if test $(which vagrant)
then
  vagrant plugin install vagrant-bindfs
  vagrant plugin install vagrant-hostmanager
fi
