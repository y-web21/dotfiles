#!/usr/bin/env bash
# sshrc

sha1() {
  echo -n "${1}" | openssl sha1 | sed -E "s/.*= //"
}

f(){
  touch "$1" 2>/dev/null || mkdir -p "${1%/*}" && touch "${1}"
}
