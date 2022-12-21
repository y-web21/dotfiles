# shellcheck disable=SC1091,SC2148
#
# ShellCheck ignore list:
#  - SC1091: Not following: (error message here)
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -e "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

HISTSIZE=300000 # current process
HISTFILESIZE=300000 # .bash_history
HISTTIMEFORMAT='%F %T '
HISTIGNORE='history:pwd:ls:ls *:ll:lla:cd:..:gl:glo'
HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTSIZE HISTCONTROL HISTTIMEFORMAT HISTIGNORE HISTCONTROL
# do not append .bash_history when the end of session (append by PROMPT_COMMAND)
shopt -u histappend
export PROMPT_COMMAND="__bash_history_append;${PROMPT_COMMAND//__bash_history_append;/}"

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi
