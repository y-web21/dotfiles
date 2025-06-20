# shellcheck disable=SC2148,SC1090
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.
#  - SC1090: Can't follow non-constant source. Use a directive to specify location.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# my private settings
test -f ~/dotfiles/private/shell/pre.bash && . $_

# common rc btw shell
test -r ~/.shellrc && . ~/.shellrc

# History
# --------------------
# profile を読み込まないで bash が実行されデフォルトのSIZE(500)が設定され履歴が飛ぶため rc に記述
# (外部から何らかの手段で bash を非ログインシェルで起動した場合)
setup_bash_history() {
  local hist_dir="$XDG_STATE_HOME"/bash
  test -d "$hist_dir" && mkdir -p "$hist_dir"
  HISTFILE="$hist_dir"/history
  HISTSIZE=3000000 # current process
  HISTFILESIZE=3000000 # .bash_history
  HISTTIMEFORMAT='%F %T '
  HISTIGNORE='history:pwd:ls:\:*:ll:lla:cd:..:gl:glo'
  HISTCONTROL=ignorespace:ignoredups:erasedups
  export HISTFILE HISTSIZE HISTCONTROL HISTTIMEFORMAT HISTIGNORE HISTCONTROL
  # do not append .bash_history when the end of session (append by PROMPT_COMMAND)
  shopt -u histappend
  export PROMPT_COMMAND="__bash_history_append;${PROMPT_COMMAND//__bash_history_append;/}"
}
setup_bash_history
unset -f setup_bash_history

__bash_history_append() {
  # history 共有できるように書き出す
  local prev_status=$?
  builtin history -a
  return $prev_status
}

__bash_history_append_and_reload() {
  # コマンド毎に.bash_historyにシェルの履歴を追記ダンプしてから全て読み込み直す
  # 用途別の窓でも即共有するのが難点。実行コストが比較的高め
  local prev_status=$?
  builtin history -a
  builtin history -c
  builtin history -r
  return $prev_status
}

# Wrapper function
# --------------------
history() {
  __bash_history_append_and_reload
  builtin history "$@"
}

# Source: https://stackoverflow.com/questions/46432027/bash-kill-vim-when-vim-warning-output-not-to-a-terminal
vim() {
  [ -t 1 ] || { echo "Not starting vim without stdout to TTY!" >&2; return 1; }
  command vim "$@"
}

# Completion
# --------------------
# load homebrew bash-completion file by apt bash-completion.
load_brew_completion() {
  local brew_completion
  brew_completion="${HOMEBREW_PREFIX}/etc/bash_completion.d"

  type brew >/dev/null 2>&1 || return
  test ! -d "${brew_completion}" && return
  while read -r comp_file; do
    if ! [[ "${comp_file}" =~ /(gh)$ ]]; then
      . "${comp_file}"
    fi
  done < <(find "${brew_completion}" -type f -or -type l)
}
load_brew_completion
unset -f load_brew_completion

type gh >/dev/null 2>&1 && eval "$(gh completion -s bash)"
type zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

# Source
# --------------------
# added by ./Cellar/fzf/0.35.1/install
# enable CTRL-R,T ALT-C (https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings)
if type brew &>/dev/null; then
  [ -f ~/.fzf.bash ] || "$(brew --prefix)/opt/fzf/install"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

test -r ~/dotfiles/shell.d/modules/keybinds_bash && . ~/dotfiles/shell.d/modules/keybinds_bash
test -f ~/dotfiles/private/shell/post.bash && . $_

# lib
test -r ~/dotfiles/shell.d/lib/kwhrtsk/docker-fzf-completion/docker-fzf.bash && . $_

# Custom fuzzy completion for "doge" command
#   e.g. doge **<TAB>
_fzf_complete_doge() {
  _fzf_complete --multi --reverse --prompt="doge> " -- "$@" < <(
    echo very
    echo wow
    echo such
    echo doge
  )
}
