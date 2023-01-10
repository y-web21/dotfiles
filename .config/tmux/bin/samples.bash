#!/usr/bin/env bash

times() {
  tmux show-option -g | grep -E 'time|time'
  # set-titles-string "#S:#I:#W - \"#T\" #{session_alerts}"
}

test() {
  tmux display-message -p '#S'
  tmux display-message -p '#I:#W#F'
  tmux display-message -p '#D#P#T'
}

if [[ "$1" = '--help' || "$1" = '-h' ]]; then
  :
else
  "$1" "${@:2}"
fi

