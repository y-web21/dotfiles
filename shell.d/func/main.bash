port_listen() {
  sudo lsof -i -P -n
}

dic() {
  # weblio dictionary
  ~/dotfiles/scripts/dict.js "${1}" | grep -iE "$|${1}" --color

  # -v operator bash => 4.2
  [ -v "$2" ] && return
  if [ -v PLAYER ]; then
    SOUND_URL=$(~/dotfiles/scripts/dict.js "${1}" | grep -E 'https.*mp3' | head -1)
    if [ -n "$SOUND_URL" ]; then
      TEMP_SOUND=$(mktemp) && {
        curl "$SOUND_URL" -o "$TEMP_SOUND" >/dev/null 2>&1
        $PLAYER "$TEMP_SOUND"
        # rm -v $TEMP_SOUND
      }
    fi
  fi
  # trap '[ -v TEMP_SOUND ] && rm -v "$TEMP_SOUND"' EXIT
  trap '[ -v TEMP_SOUND ] && rm "$TEMP_SOUND"' EXIT
}

__ssh-list-config-files() {

  local SSH_DIR=$HOME/.ssh/

  if test -d "$SSH_DIR"; then
    for file in $(find "$SSH_DIR" -type f | grep '/config'); do
      echo "$file"
    done
  fi
}

__ssh-list-known-hosts() {

  local SSH_DIR=$HOME/.ssh/

  if test -d "$SSH_DIR"; then
    for file in $(find "$SSH_DIR" -type f | grep '/config'); do
      grep ^Host "$file" | sed 's/^Host //'
    done
  fi
}

__ssh-list-known-keys() {

  local SSH_DIR=$HOME/.ssh/

  if test -d "$SSH_DIR"; then
    for file in $(find "$SSH_DIR" -type f | grep '/config'); do
      grep IdentityFile "$file" | sed -E 's/^[ \t]{0,}IdentityFile //'
    done
  fi
}

__ssh-list-all-keys() {

  local SSH_DIR=$HOME/.ssh/

  if test -d "$SSH_DIR"; then
    find "$SSH_DIR" | grep -E '(pem|pub)$' | sed 's/\.pub$//'
  fi
}

__ssh-show-known-hosts() {

  local SSH_DIR=$HOME/.ssh/
  local displayFileName=${1:-false}

  if test -d "$SSH_DIR"; then
    for file in $(find "$SSH_DIR" -type f | grep '/config'); do
      if ${displayFileName}; then echo -e "\n$file"; fi
      cat "$file"
    done
  fi
}

__ssh-show-known-hosts-with-filename() {
  ssh-show-known-hosts true
}
