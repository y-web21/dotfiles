# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# linuxbrew default install path is
# /home/<username>/.linuxbrew/bin/brew or /home/linuxbrew/.linuxbrew/bin/brew
if type /home/linuxbrew/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif type /home/"$(whoami)"/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/"$(whoami)"/.linuxbrew/bin/brew shellenv)"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# load homebrew bash-completion file by apt bash-completion.
if type brew >/dev/null 2>&1; then
  if [ -z "$(brew list -1 | grep ^bash-completion$)" ]; then
    echo 'load bash completions in brew... '
    while read comp_file; do
      if ! [[ "${comp_file}" =~ /(gh)$ ]]; then
        # echo 'completion file loaded.       '${comp_file}
        . "${comp_file}"
      fi
    done < <(find ${HOMEBREW_PREFIX}/etc/bash_completion.d -type f -or -type l)
  fi
fi

# added by Nix installer
if [ -e /home/$(whoami)/.nix-profile/etc/profile.d/nix.sh ]; then . /home/$(whoami)/.nix-profile/etc/profile.d/nix.sh; fi

eval "$(gh completion -s bash)"

COMMON_PROFILE=$HOME/.profile_common
