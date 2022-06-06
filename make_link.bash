#!/usr/bin/env bash

# set -eou pipefail

# support only user interactive process.

make_link() {
  read -rp "execute:  ln -s $(pwd)/${1} ${HOME}/${1}"' ok? (y/N) ' input
  if [ "$input" == "y" ]; then
    echo "${HOME}/${1}"
    if [ -e "${HOME}/${1}" ]; then
      read -rp "file already exist. remove the file? (y/N) " input
      test "${input}" != "y" && return # continue
      rm "${HOME}/${1}"
    fi
    ln -s "$(pwd)/${1}" ~/"${1}" && echo "${1}" 'lineked.'
  fi
}

for TOPLEVELDOTFILE in $(find ./ -maxdepth 1 -type f | cut -c 3- | grep -i '^\.' | grep -v gitignore); do
  make_link $TOPLEVELDOTFILE
done

for GH_CONFIG in $(find ./.config/gh -maxdepth 1 -type f | cut -c 3- | grep -i '^\.' | grep -v gitignore); do
  make_link $GH_CONFIG
done
