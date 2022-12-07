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

if [ -e "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# load homebrew bash-completion file by apt bash-completion.
if type brew >/dev/null 2>&1; then
  if [ -z "$(brew list -1 | grep ^bash-completion$)" ]; then
    echo 'load bash completions in brew... '
    while read comp_file; do
      if ! [[ "${comp_file}" =~ /(gh)$ ]]; then
        # shellcheck disable=SC1090
        . "${comp_file}"
      fi
    done < <(find ${HOMEBREW_PREFIX}/etc/bash_completion.d -type f -or -type l)
  fi
fi

