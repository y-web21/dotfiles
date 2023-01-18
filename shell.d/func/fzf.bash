#!/usr/bin/env bash

# show man and help
# --------------------
f-man() {
  local cmd query preview binds header opts
  local field1 sel preview2
  # shellcheck disable=2089
  field1="cut -d ' ' -f 1"
  sel="echo {} | $field1"
  preview2='$( $sel ) --help || $( $sel ) -h'
  cmd_full="man -k ${1:-\.}"
  cmd="${cmd_full} | $field1"
  bin_dir="cat <(command ls /bin) <(command ls /usr/bin) <(command ls /usr/local/bin ) <(command ls $HOMEBREW_PREFIX/bin) | sort | uniq"
  # fzf options
  opts="--height 100% --reverse --query=\"${query:-}\" "
  header="--header '$(printf '%-25s\t%-25s\t%-25s\t%-25s\n%-25s\t%-25s' \
    'Enter: Open with pager' 'ctrl-h: Help' 'alt-o: Open with vim' 'ctrl-o: Open with vim' \
    'alt-s,f: reload' 'alt-c: command list')'"
  binds="--bind=\"?:preview:$preview2\" \
      --bind=\"Enter:execute($sel | xargs man -P ${PAGER:-less})\" \
      --bind=\"ctrl-h:execute(($preview2) | ${PAGER:-less})\" \
      --bind=\"alt-o:execute($sel | xargs man | vim -)\" \
      --bind=\"ctrl-o:execute($sel | xargs man | vim -)\" \
      --bind=\"alt-s:reload($cmd)\" \
      --bind=\"alt-f:reload($cmd_full)\" \
      --bind=\"alt-c:reload($bin_dir)\" \
      --bind=change:top"
  preview="--preview \"echo {} | awk '{print \$1}' | xargs man -P ${PAGER:-less}\" --preview-window down:70%"
  opts+="${binds:-} ${header:-} ${preview:-}"

  eval "${cmd}" | eval fzf "${opts:-}"
}

# show apt package files
# --------------------
f-dpkg() {
  local cmd query preview binds header opts
  cmd="dpkg --get-selections | awk '{print \$1}'"
  opts="--height 100% --reverse --query=\"${query:-}\" "
  preview="--preview 'dpkg -L {}' --preview-window down:70%"
  opts+="${binds:-} ${header:-} ${preview:-}"

  eval "${cmd}" | eval fzf "${opts:-}"
}

f-print-funcs_aliases() {
  local fzf_ret
  while fzf_ret=$(
      LC_ALL=C; cat <(declare -F | cut -c 12-) <(compgen -a) | sort -r |
        fzf --height=40 --min-height=20 --expect='esc,ctrl-q,ctrl-c' \
          --bind='ctrl-r:toggle-sort' \
          --header='ctrl-r: toggle-sort'
    );
  do
    mapfile -t fzf_ret <<< "${fzf_ret[@]}"
    case "${fzf_ret[0]}" in
      esc|ctrl-q|ctrl-c)
        break
      ;;
      *)
        bat --paging=always --style=grid,numbers -l bash <(declare -f "${fzf_ret[1]}" || type "${fzf_ret[1]}")
      ;;
    esac
    fzf_ret=()
  done
}

# run npm script (requires jq)
# Reference: https://github.com/junegunn/fzf/wiki/Examples#npm
# --------------------
f-npm() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf) && npm run "$(echo $script)"
}

# Reference: https://github.com/junegunn/fzf/wiki/Examples#Emoji
# --------------------
emoticon() {
  test -z "$emojis" && emojis=$(curl -sSL 'https://git.io/JXXO7')
  selected_emoji=$(echo "$emojis" | fzf --bind='ctrl-d:half-page-down,ctrl-u:half-page-up' --header='ctrl-u,d: page up, down')
  echo "$selected_emoji"
  type clip &>/dev/null && echo "$selected_emoji" | cut -d ':' -f 1 | clip
}

# ftpane - switch pane (@george-b)
# Reference: https://github.com/junegunn/fzf/wiki/Examples#tmux
# --------------------
# ftpane() {
t-pane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
# --------------------
# tm() {
t-m() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# c - browse chrome history
# Source https://github.com/junegunn/fzf/wiki/Examples#google-chrome
# --------------------
# c() {
chis() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if type wslpath >/dev/null 2>&1 ; then
    google_history="/mnt/c/Users/$USER/AppData/Local/Google/Chrome/User Data/Default/History"
    open="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  elif [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs "$open" > /dev/null 2> /dev/null
}
