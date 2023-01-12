#!/usr/bin/env bash

histpath="$HOME/.bash_history"

_is_timestamp() { [[ "$1" =~ ^\#[0-9]{10,10}$ ]]; }

remove_dupes() {
  # remove dupe commnads and timestamps
  local prev tempfile
  prev=''
  tempfile=$(mktemp)

  while read -r line; do
    if _is_timestamp "$prev" && _is_timestamp "$line"; then
      # skip unnecessary timestamps
      continue
    fi

    printf '%s\n' "$line" >>"$tempfile"
    prev="$line"
  done < <(tac "$histpath" | awk 'ary[$0]++ == 0') # remove dupe commnad

  tac "$tempfile" >"$histpath"
}

# create backup
cp "${histpath}"{,.bak}
remove_dupes
