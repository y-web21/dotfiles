#!/usr/bin/env bash

# set -eou pipefail

# not suppoted batch proc.

for line in $(find ./ -maxdepth 1 -type f | cut -c 3- | grep -i '^\.' | grep -v gitignore); do
  read -p "execute:  ln -s $(pwd)/${line} ${HOME}/${line}"' ok? (y) ' input
  if [ "$input" == "y" ];then
    echo "${HOME}/${line}"
    if [ -e "${HOME}/${line}" ];then
      read -p "file already exist. remove the file? (y) " input
      test "${input}" != "y" && continue
      rm "${HOME}/${line}"
    fi
    ln -s $(pwd)/${line} ~/${line} && echo ${line} 'lineked.'
  fi
done
