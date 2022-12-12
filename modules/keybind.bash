# keybind functions

__history_with_fzf() {
  local RET
  # add current session history to ~/.bash_history
  history -a
  RET=$(
    HISTTIMEFORMAT=''
    tac ~/.bash_history | grep -v '^#' | uniq | fzf --query "$READLINE_LINE"
  )
  if [ '' = "$RET" ]; then return; fi
  # put text in the bash command line buffer
  READLINE_LINE="$RET"
  READLINE_POINT=${#RET}
}

__history_with_peco() {
  local RET
  # add current session history to ~/.bash_history
  history -a
  RET=$(
    HISTTIMEFORMAT=''
    tac ~/.bash_history | grep -v '^#' | uniq | peco --layout=bottom-up --query "$READLINE_LINE"
  )
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

__pick_docker_container() {
  local RET
  RET=$(docker ps -a | tail +2 | fzf --reverse | awk '{print $1}')
  if [ '' = "$RET" ]; then return; fi
  RET=$(docker ps -a | grep "$RET" | sed -e 's/  \+/\n/g' | fzf --reverse)
  READLINE_LINE="${READLINE_LINE}${RET}"
  READLINE_POINT=${#READLINE_LINE}
}

__interactive_cd() {
  local DIR
  while true; do
    DIR=$(find -L "${1:-.}" -mindepth 0 -maxdepth 1 -type d | sed '1a ..' | grep -v ^\.$ | fzf --preview 'ls {}' --border)
    if [ '' = "$DIR" ]; then return; fi
    cd "$DIR" || return
  done
}

__interacrive_cd_b() {
  local DIR
  DIR=$(find . -mindepth 1 -type d | peco --layout=bottom-up)
  if [ '' = "$DIR" ]; then return; fi
  cd "$DIR" || return
}

__open_with_editor() {
  local prev_dir depth fzf_ret path input

  prev_dir=$(pwd)
  depth=$(seq 6 | fzf --query 1 --reverse --height=60%)

  while true; do

    unset path
    unset fzf_ret
    while read -r ret; do
      fzf_ret+=("$ret")
    done < <(
      find -L . -mindepth 1 -maxdepth "$depth" 2>/dev/null | sed '1i ..' | xargs -n1 bash -c 'echo $0 $( [ -d $0 ] && echo "📦directory🙄" )' |
        fzf \
          --expect=alt-o \
          --expect=ctrl-c \
          --expect=esc \
          --bind="ctrl-e:execute(pwd)" \
          --preview-window=65%,+3/3,~3 \
          --preview 'if [ -d {1} ]; \
              then echo -e '\''\n'\'' && du -hs {1} && exa -al --time-style=long-iso {1} ; \
              else bat -n --color=always --style=header,grid,numbers {} 2>/dev/null; fi' |
        awk '{print $1}'
              # then echo -e '\''\n'\'' && tree {1} -L 2; \
    )

    # var check
    # i=0 && for f in "${fzf_ret[@]}"; do echo $i "$f" ;((i++)); done

    input="${fzf_ret[0]}"
    [ "$input" = 'ctrl-c' ] && break
    [ "$input" = 'esc' ] && break

    path=$(pwd)/$(echo "${fzf_ret[1]}" | sed 's/.\///' )

    if [ "$input" = 'alt-o' ]; then
      file=$(read -p 'filename: ')
      echo $file
      echo newfile WIP
    fi

    [ '' = "${path}" ] && break
    [ -f "${path}" ] && break
    [ -d "${path}" ] && cd "${path}" || exit
  done

  [ -n "$path" ] && "${EDITOR:-vim}" "$path"
  # shellcheck disable=2164
  cd "$prev_dir"
}

__rg() {
  rg -Hn --color=always "$READLINE_LINE" | less -R
}

__rg_edit_uu() {
  __rg_edit "-uu -n -e"
}

__rg_edit() {
  local file editor i rgopt
  rgopt=${1:-"-u -n -e"}
  editor=$EDITOR
  i=0
  # shellcheck disable=1083,2086
  while read -r ret; do
    if [ $i -eq 0 ]; then
      [ "$ret" = 'alt-l' ] && editor=less
      [ "$ret" = 'alt-v' ] && editor=vim
      [ "$ret" = 'alt-b' ] && editor=bat
    else
      file=$ret
    fi
    ((i++))
  done < <(
    rg --color=never $rgopt "$READLINE_LINE" |
      fzf \
        --query "$READLINE_LINE" \
        --delimiter=':' \
        --reverse \
        --expect=alt-l \
        --expect=alt-v \
        --expect=alt-b \
        --border=top \
        --bind alt-p:preview-up,alt-n:preview-down \
        --preview-window=right:65%,+{2}+3/3,~3 \
        --preview 'bat --color=always {1} --highlight-line {2} --wrap character' |
      cut -d ':' -f 1
  )
  # --height=80% \

  [ -n "$file" ] && $editor "$file"
}

__rg_file_uu() {
  __rg_file "-uu -e"
}

__rg_file() {
  local rgopt
  rgopt=${1:-"-u -e"}
  # shellcheck disable=2086
  rg --files | rg --color=always $rgopt "$READLINE_LINE" | bat --style plain
}

__cd_z() {
  local DIR
  DIR=$(z | peco | awk '{print $NF}')
  if [ '' = "$DIR" ]; then return; fi
  cd "$DIR" || return
}

__z() {
  local DIR
  DIR=$(z | fzf --height 40% --reverse | awk '{print $NF}')
  if [ '' = "$DIR" ]; then return; fi
  # カーソルポジションは考慮しない
  READLINE_LINE="$READLINE_LINE $DIR"
  READLINE_POINT=${#READLINE_LINE}
}

__ls_al_readline() {
  if type exa &>/dev/null; then
    exa -la  --time-style=long-iso "${READLINE_LINE:-.}"
  else
    ls -la  --time-style=long-iso "${READLINE_LINE:-.}"
  fi
  echo ''
}

__jump_to_readline() {
  cd "${READLINE_LINE}" || return
  pwd
}

__relogin() {
  stty echo
  stty sane
  exec $SHELL -l
}

__reset_screen() {
  stty echo
  stty sane
  exec $SHELL -l
}

__list_user_binds() { bind -X | column -t | sort -k 2; }

__test_bind() { echo valid; }

# =============== keybind =================
# = /etc/inputrc ~/.inputrc
# = list of keybind           -> bind -p
# = list of keybind(bind -x)  -> bind -X
# = list of funcions          -> bind --function-names
# = remove bind               -> bind -r "\C-y"
# = reset all                 -> `set -o emacs` or `set -o vi`
# = disable tty readline      -> stty stop undef
# = check current settings    -> stty -a

# user defined function
bind -x '"\e\C-l": __relogin'
bind -x '"\eh": __history_with_peco'
bind -x '"\e\C-h": __history_with_fzf'
bind -x '"\ed": __interactive_cd'
bind -x '"\e\ed": __interacrive_cd_b'
bind -x '"\ee": __open_with_editor'
bind -r "\ep"
bind -x '"\ep\ep": __pick_path'
bind -x '"\ep\ed": __pick_docker_container'
bind -x '"\eg\eg": __rg'
bind -x '"\eg\ee": __rg_edit_uu'
bind -x '"\eG\eE": __rg_edit'
bind -x '"\eg\ef": __rg_file_uu'
bind -x '"\eG\eF": __rg_file'
bind -x '"\ejj": __z'
bind -x '"\ej\ej": __cd_z'
bind -x '"\el": __ls_al_readline'
bind -x '"\e;": __jump_to_readline'
bind -x '"\e?": __list_user_binds'
bind -x '"\e\C-rr": __reset_screen'
