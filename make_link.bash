#!/usr/bin/env bash

# optional arg1 = -f or not
#   if -f then force the creation of symbolic links without confirmation

# set -eou pipefail

cd "$(dirname "$0")" || exit
EXCEPT='grep -v -e \.gitignore$ -e README -e \.git$ -e ^\.vscode -e \.bak$ -e \.shellcheckrc'
FORCE=0
test -n "$1" && test "$1" = '-f' && FORCE=1

make_link() {
  local entity_path symlink_path
  entity_path=${1} # rel
  symlink_path=${HOME}/${entity_path} # abs

  if [ "$FORCE" = 1 ];then
    rm "${symlink_path}" 2>/dev/null
    _mk_dir "$symlink_path"
    _do_link "$entity_path"
    return
  fi

  # interactive mode
  read -rp "execute:  ln -s ./${entity_path} ${symlink_path}"' ok? (y/N) ' input
  [ "$input" != "y" ] && return

  echo "${symlink_path}"
  if [ -e "${symlink_path}" ]; then
    read -rp "file already exist. remove the file? (y/N) " input
    test "${input}" != "y" && return # continue
    rm "${symlink_path}"
  fi
  _mk_dir "$symlink_path"
  _do_link "$entity_path"
}

_mk_dir(){
  if [ ! -d "$(dirname "${1}")" ]; then mkdir -p "$(dirname "${1}")"; fi
}

_do_link() {
  ln -s "$(pwd)/${1}" ~/"${1}" && echo "${1}" 'lineked.'
}

# ./.xxx files
for TOPLEVELDOTFILE in $(find ./ -maxdepth 1 -type f | cut -c 3- | grep -i '^\.' | $EXCEPT | sort); do
  make_link "$TOPLEVELDOTFILE"
done

# ./.xxx directories
for DOT_FOLDER in $(find ./ -maxdepth 1 -type d | cut -c 3- | grep -i '^\.' | $EXCEPT | sort); do
  for DOT_CONFIG in $(find "${DOT_FOLDER}" -maxdepth 3 -type f | $EXCEPT); do
    make_link "$DOT_CONFIG"
  done
done

# ./bin/* files
[ ! -e ~/bin ] && mkdir ~/bin
for MY_SCRIPTS in $(find ./bin -maxdepth 1 -type f | cut -c 3- | $EXCEPT | sort); do
  make_link "$MY_SCRIPTS"
done
for MY_SCRIPTS in $(find ./bin -maxdepth 1 -type f | cut -c 3- | $EXCEPT | sort); do
  sudo chmod u+x "$MY_SCRIPTS"
done
