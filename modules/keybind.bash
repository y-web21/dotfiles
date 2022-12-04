
# keybind functions

__history_with_fzf() {
  local RET
  # add current session history to ~/.bash_history
  history -a
  RET=$(HISTTIMEFORMAT='' ; tac ~/.bash_history | grep -v '^#' | uniq | fzf --query "$READLINE_LINE")
  if [ '' = "$RET" ]; then return; fi
  # put text in the bash command line buffer
  READLINE_LINE="$RET"
  READLINE_POINT=${#RET}
}

__history_with_peco() {
  local RET
  # add current session history to ~/.bash_history
  history -a
  RET=$(HISTTIMEFORMAT='' ; tac ~/.bash_history | grep -v '^#' | uniq | peco --layout=bottom-up --query "$READLINE_LINE")
  if [ '' = "$RET" ]; then return; fi
  # put text in the bash command line buffer
  READLINE_LINE="$RET"
  READLINE_POINT=${#RET}
}

__pick_path() {
  local RET
  RET=$(find . | fzf)
  # RET=$(find . -mindepth 1 -maxdepth 5 -perm /u=x,g=x,o=x -type f | fzf)
  if [ '' = "$RET" ]; then return; fi
  # put text in the bash command line buffer
  READLINE_LINE="$READLINE_LINE $RET"
  READLINE_POINT=${#READLINE_LINE}
}

__interactive_cd() {
  local DIR
  while true; do
    DIR=$(find ${1:-.} -mindepth 0 -maxdepth 1 -type d | sed '1a ..' | grep -v ^\.$ | fzf)
    if [ '' = "$DIR" ]; then return; fi
    cd "$DIR"
  done
}

__interacrive_cd_recurse() {
  local DIR
  DIR=$(find . -mindepth 1 -type d | peco --layout=bottom-up)
  if [ '' = "$DIR" ]; then return; fi
  cd "$DIR"
}

__cd_z() {
  local DIR
  DIR=$(z | peco | awk '{print $NF}')
  if [ '' = "$DIR" ]; then return; fi
  cd "$DIR"
}

__relogin(){
  stty echo
  stty sane
  exec $SHELL -l
}

__test_bind(){ echo valid; }

# =============== keybind =================
# = /etc/inputrc ~/.inputrc
# = list of keybind        -> bind -p
# = list of funcions       -> bind --function-names
# = remove bind            -> bind -r "\C-y"
# = reset all              -> `set -o emacs` or `set -o vi`
# = disable tty readline   -> stty stop undef
# = check current settings -> stty -a

# user defined function
bind -x '"\e\C-l": __relogin'
bind -x '"\eh": __history_with_peco'
bind -x '"\e\ed": __interacrive_cd_recurse'
bind -x '"\ed": __interactive_cd'
bind -x '"\e\C-h": __history_with_fzf'
bind -x '"\ej": __cd_z'
bind -x '"\ep": __pick_path'
