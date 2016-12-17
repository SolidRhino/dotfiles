#vv completion
completion='$( echo $(which vv)-completions)'

if test -f $completion
then
  source $completion
fi
