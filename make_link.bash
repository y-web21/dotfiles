#!/usr/bin/env bash

# set -eou pipefail

# support only user interactive process.

EXCEPT='grep -v -e ^\.gitignore -e README -e \.git$ -e ^\.vscode -e \.bak$'

make_link() {
  read -rp "execute:  ln -s $(pwd)/${1} ${HOME}/${1}"' ok? (y/N) ' input
  if [ "$input" == "y" ]; then
    echo "${HOME}/${1}"
    if [ -e "${HOME}/${1}" ]; then
      read -rp "file already exist. remove the file? (y/N) " input
      test "${input}" != "y" && return # continue
      rm "${HOME}/${1}"
    fi
    if [ ! -d "$(dirname ${HOME}/${1})" ]; then mkdir -p "$(dirname ${HOME}/${1})"; fi
    ln -s "$(pwd)/${1}" ~/"${1}" && echo "${1}" 'lineked.'
  fi
}

for TOPLEVELDOTFILE in $(find ./ -maxdepth 1 -type f | cut -c 3- | grep -i '^\.' | $EXCEPT); do
  make_link $TOPLEVELDOTFILE
done

for DOT_FOLDER in $(find ./ -maxdepth 1 -type d | cut -c 3- | grep -i '^\.' | $EXCEPT); do
  for DOT_CONFIG in $(find ${DOT_FOLDER} -maxdepth 3 -type f | $EXCEPT); do
    make_link $DOT_CONFIG
  done
done
