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

# my settings
test -f ~/dotfiles/shell.d/private_ettings/pre.bash && . ~/dotfiles/shell.d/private_settings/pre.bash

# common settings
test -r ~/.shellrc && . ~/.shellrc

# シェルの切り替えで上書きされる
HISTFILE=~/.bash_history
export HISTFILE

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

history() {
  # wrapper
  __bash_history_append_and_reload
  builtin history "$@"
}

if is_wsl; then
  test -r ~/dotfiles/shell.d/bash.d/.bashrc_wsl && . ~/dotfiles/shell.d/bash.d/.bashrc_wsl
elif is_linux; then
  test -r ~/dotfiles/shell.d/bash.d/.bashrc_linux && . ~/dotfiles/shell.d/bash.d/.bashrc_linux
elif is_mac; then
  :
else
  echo 'nomatch'
fi

# test -r ~/.bash_aliases && . ~/.bash_aliases
test -r ~/.bashrc.local && . ~/.bashrc.local
test -r ~/dotfiles/shell.d/modules/keybinds_bash && . ~/dotfiles/shell.d/modules/keybinds_bash
test -r ~/dotfiles/shell.d/funcs/tools.bash && . ~/dotfiles/shell.d/funcs/tools.bash
test -f ~/dotfiles/shell.d/private_settings/post.bash && . ~/dotfiles/shell.d/private_settings/post.bash

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
