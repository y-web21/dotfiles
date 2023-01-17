#!/usr/bin/env zsh

shwo_zsh_execution_time=0
test $shwo_zsh_execution_time -ne 0 && zmodload zsh/zprof && zprof

# EDITOR=vim でターミナルも bindkey -v 相当にされてしまうため明示的に emacs の設定をする
bindkey -e

# if [[ -o interactive ]]; then :; fi
# login shell は bash なので、zprofile が読み込まれない
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
export HISTFILE HISTSIZE SAVEHIST

# history に 実行時間と時刻を記録する
setopt extended_history
# HISTCONTROL=ignorespace:ignoredups
setopt hist_ignore_dups
setopt hist_ignore_space
# stty stop undef and stty start undef
setopt no_flow_control

setopt hist_ignore_all_dups
## share .zsh_history immediately
# setopt inc_append_history
# setopt share_history

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  # require aws completion (complete -C の有効化)
  autoload bashcompinit && bashcompinit
  # Enable completion -U はユーザーエイリアスによる関数の上書き防止
  autoload -Uz compinit && compinit -u

  # colored completion
  autoload -U colors
  colors
  zstyle ':completion:*' list-colors "${LS_COLORS}"

  # hilight, use cache, ignore case
  zstyle ':completion:*:default' menu select=1
  zstyle ':completion::complete:*' use-cache true
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

  # Use unsetopt to disable
  setopt complete_in_word
  setopt auto_List
  setopt auto_menu
  setopt list_packed
  setopt list_types

  # miss type suggest
  setopt correct
  SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "
fi

# common settings
test -r ~/.shellrc && . ~/.shellrc

# alias -s pdf=xpdf
# alias -g

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters

print_prompt_color() {
  for c in {000..255}; do
    echo -n "\e[38;5;${c}m $c"
    [ $(($c % 16)) -eq 15 ] && echo
  done
  echo
}

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# git
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info; }

_DOCKER_SYMBOL='🐳 '
_AWS_SYMBOL='☁ '

__prompt_1st() {
  inner_prompt_arch() {
    echo -n "%F{036}($(arch))"
  }
  echo -n "%F{224}$(date +"%T %z ")"
  echo -n "$(inner_prompt_arch) "
  echo -n "%F{007}\$(type git >/dev/null 2>&1 && printf '<%s>%s' \"\$(git config user.name)\" \"\$(__git_ps1)\")"
  # echo -n "%{${reset_color}%}[%x@%m] "
}
__prompt_2nd() {
  inner_prompt_docker() {
    type docker >/dev/null 2>&1 && echo -n "%F{044}${_DOCKER_SYMBOL:-container:}$(docker ps | tail +2 | wc -l)"
  }
  inner_prompt_aws() {
    type aws >/dev/null 2>&1 && echo -n "%F{007}${_AWS_SYMBOL:-az:} %F{215}${_AWS_CURRENT_REGION}"
  }
  inner_prompt_status() {
    echo -n "%(?.%B%F{085}.%B%F{160})status:%?"
  }
  inner_prompt_others() {
    echo -n "%F{140}shlvl:${SHLVL} %F{168}jobs:%j"
  }
  echo -n "%F{007}%S %2c %s $(inner_prompt_status) $(inner_prompt_docker) $(inner_prompt_aws) $(inner_prompt_others)"
}

# PS1
RPROMPT='%B%F{green}${vcs_info_msg_0_}'
PROMPT="$(__prompt_1st)
$(__prompt_2nd)
%(?.%B%F{green}.%B%F{red})%(?!> !< )%f%b"

test -r ~/dotfiles/shell.d/modules/keybinds_zsh && . ~/dotfiles/shell.d/modules/keybinds_zsh

complete -C '/usr/local/bin/aws_completer' aws
type zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

if [ $shwo_zsh_execution_time -ne 0 ]; then
  if (which zprof >/dev/null 2>&1); then
    zprof
  fi
fi

# Source
# --------------------
# added by ./Cellar/fzf/0.35.1/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# lib
[ -f ~/dotfiles/shell.d/lib/kwhrtsk/docker-fzf-completion/docker-fzf.zsh ] && source ~/dotfiles/shell.d/lib/kwhrtsk/docker-fzf-completion/docker-fzf.zsh
