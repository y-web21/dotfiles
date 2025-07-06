# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# XDG Base Directory Specification
# https://wiki.archlinux.jp/index.php/XDG_Base_Directory
# --------------------
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME}/bundle"
export BUNDLE_USER_CACHE="${XDG_CACHE_HOME/}bundle"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"
# export VIMINIT="set nocp | source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'

export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"

# ==== env ====
# date '+%F %R' YYYY-MM-DD HH:mm
export LC_TIME="en_DK.utf8"

# ==== commnad options ====
# export GREP_OPTIONS='--color=auto' # deprecated

# ==== brew ====
export HOMEBREW_NO_AUTO_UPDATE=1

# linuxbrew
if type /home/linuxbrew/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif type /home/"$(whoami)"/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/"$(whoami)"/.linuxbrew/bin/brew shellenv)"
fi

if type fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--reverse --bind=enter:accept,alt-p:preview-up,alt-n:preview-down'
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS",shift-up:preview-top,shift-down:preview-bottom
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS",ctrl-alt-j:jump-accept,alt-j:jump
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS",alt-a:toggle-all
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"',?:toggle-preview'

  # shellcheck disable=2016,2089
  FZF_CTRL_T_OPTS='--preview-window=right:65% --preview '\'' \
    basename {} && \
    [[ $(file --mime {}) =~ directory ]] && ls -aF --color ||
    [[ $(file --mime {}) =~ binary ]] && xxd -l 1024 -g1 {} ||
    ( bat --style=numbers --color=always {} ||
      cat {}) '\'''
  # shellcheck disable=2090
  export FZF_CTRL_T_OPTS
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
  export FZF_COMPLETION_TRIGGER=','
  export FZF_COMPLETION_OPTS='--border --info=inline'

  # --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

  # https://github.com/junegunn/fzf
  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)               fzf --preview 'tree -C {} | head -200'   "$@" ;;
      export|unset)     fzf --preview "eval 'echo \$'{}"         "$@" ;;
      ssh)              fzf --preview 'dig {}'                   "$@" ;;
      docker)           fzf --header 'ctrl-a,d,t: multi-select'  "$@" ;;
      *)                fzf --preview 'bat -n --color=always {}' "$@" ;;
    esac
  }
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# added by Nix installer
# shellcheck disable=SC1090
if [ -e /home/"$(whoami)"/.nix-profile/etc/profile.d/nix.sh ]; then . /home/"$(whoami)"/.nix-profile/etc/profile.d/nix.sh; fi

# Install Ruby Gems to ~/gems
if [ -d "$HOME/gems" ]; then
  export GEM_HOME="$HOME/gems"
  export PATH="$HOME/gems/bin:$PATH"
fi

if type apt >/dev/null 2>&1 ;then
  apt moo
fi

# ログインシェルを複数回起動した場合の重複を削除
PATH=$(echo -n "$PATH" | tr ":" "\n" | sort | uniq | tr "\n" ":")
MANPATH=$(echo -n "$MANPATH" | tr ":" "\n" | sort | uniq | tr "\n" ":")
INFOPATH=$(echo -n "$INFOPATH" | tr ":" "\n" | sort | uniq | tr "\n" ":")
# shellcheck disable=SC1090
[ -f "$HOME/.cargo/env" ] && . "$_"
