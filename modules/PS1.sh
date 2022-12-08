#!/bin/sh

BCHR_WBG='\e[30;47m'
WCHR_BBG='\e[37;44m'
CLR_RESET='\e[39;49m'
EO_PS1='\e[0m'

if [ "$1" = 'wsl' ]; then
  __git_ps1 >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    PS1="$BCHR_WBG \t $WCHR_BBG \W $BCHR_WBG\$(__git_ps1 '(%s)')$CLR_RESET <$(git config user.name)> $EO_PS1\n\$ "
    return
  fi
  # shellcheck disable=2154
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  return
fi

if [ "$1" = 'debian' ]; then
  PS1='\t ${debian_chroot:+($debian_chroot)}\e[01;32m\u@\h\e[00m:\e[01;34m\w\e[00m'

  __git_ps1 >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    PS1+=' $(__git_ps1 "\e[30;47m(%s)")\e[39;49m <$(git config user.name)>'
  fi
  PS1+='\n\$ '
  return
fi

if [ "$(getent passwd vagrant)" != "" ] && [ -f /etc/bash_completion.d/git-prompt.sh ]; then
  HOST_NAME="\H"
  END="\[\e[m\]"
  GIT_CLR="\[\e[37;45m\]"
  # shellcheck disable=3028
  if [ ${EUID:-${UID}} = 0 ]; then
    BEGIN="\[\e[1;37;41m\]"
    BEGIN_TRIANGLE="\[\e[0;32;41m\]"
    MIDDLE="\[\e[0;30;43m\]"
    MIDDLE_TRIANGLE="\[\e[0;33m\]"
  else
    BEGIN="\[\e[1;37;45m\]"
    BEGIN_TRIANGLE="\[\e[0;32;45m\]"
    MIDDLE="\[\e[0;30;47m\]"
    MIDDLE_TRIANGLE="\[\e[0;37m\]"
  fi

  PS1="${BEGIN}\u@${HOST_NAME}${BEGIN_TRIANGLE} ${MIDDLE} \W ${MIDDLE_TRIANGLE}${GIT_CLR}\$(__git_ps1 '(%s)')${END} \! \\$ "
fi
