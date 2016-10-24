if test $(antigen version)
then
  echo "Update antigen bundels and cleanup"
  antigen update
  antigen cleanup --force
fi
