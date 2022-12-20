#!/usr/bin/env zsh

shwo_zsh_execution_time=0
test $shwo_zsh_execution_time -ne 0 && zmodload zsh/zprof && zprof

# EDITOR=vim でターミナルも bindkey -v 相当にされてしまうため明示的に emacs の設定をする
bindkey -e

test -r ~/.shellrc && . ~/.shellrc

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

# alias -s pdf=xpdf
# alias -g

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters

print_prompt_color(){
  for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
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
precmd () { vcs_info }

# PS1
RPROMPT='%B%F{green}${vcs_info_msg_0_}'
PROMPT='%F{225}$(date +"%T %z ")%{${fg[yellow]}%}%2c%{${reset_color}%} [%n@%md]%F{036}($(arch))$(__git_ps1)
%(?.%B%F{green}.%B%F{red})%(?!> !< )%f%b'

test -r ~/dotfiles/modules/keybinds_zsh && . ~/dotfiles/modules/keybinds_zsh

complete -C '/usr/local/bin/aws_completer' aws
eval "$(zoxide init zsh)"

if [ $shwo_zsh_execution_time -ne 0 ];then
  if (which zprof > /dev/null 2>&1) ;then
    zprof
  fi
fi
