if test $(which antibody)
then
  echo "Update antibody bundels"
  antibody update
  antibody bundle < "$ZSH/antibody/bundles.txt"
  cat "$ZSH/antibody/bundles.txt" > ~/.bundles.txt
  antibody bundle < "$ZSH/antibody/last_bundles.txt"
  cat "$ZSH/antibody/last_bundles.txt" >> ~/.bundles.txt
fi
