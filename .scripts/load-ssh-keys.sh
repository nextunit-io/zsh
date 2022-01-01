#!/bin/bash
# Load all ssh keys

for file in $HOME/.ssh/*; do
  basename=$(basename "$file")
  if [ ! -d "$file" ] &&  [[ $basename != *.pub ]] && [[ $basename != *.no ]] && [ "$basename" != "known_hosts" ]; then
    ssh-add $file 2>/dev/null
  fi
done;
