#!/usr/bin/env bash
# sshrc

asc(){ echo "$1" | od -tx1 -tc -An; }
sha1() { echo -n "${1}" | openssl sha1 | sed -E "s/.*= //"; }
ucase() { echo "${@^^}"; }
lcase() { echo "${@,,}"; }

grepsjis-recursive() {
  # grep -$1 "${2}" --include="${3}" --include="${4}" | xargs -I% iconv -f cp932 -t UTF8 '%' | grep --color "${2}"
  grep $1 -l $3 . $4 $5 $6 | xargs -I% iconv -f cp932 -t UTF8 '%' | grep $1 $2 --color $3
}

f(){ touch "$1" 2>/dev/null || mkdir -p "${1%/*}" && touch "${1}"; }
mkcd() { mkdir -p "$1"; cd "$1" || return; }
make-bak() { test $# -ne 0 && cp ${1}{,.bak}; }

version(){
  echo '- OS'
  echo cat /etc/os-release | grep PRETTY_NAME | sed -e 's/PRETTY_NAME=//' | sed 's/"//g'
  docker --version 2>/dev/null
  docker-compose --version 2>/dev/null
  nginx -v 2>/dev/null
}

job-watch() {
  while true; do /bin/clear_console; sleep 0.5; jobs; sleep 3; done
}
