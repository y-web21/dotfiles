# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Can't follow non-constant source. Use a directive to specify location.

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

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# added by Nix installer
# shellcheck disable=SC1090
if [ -e /home/"$(whoami)"/.nix-profile/etc/profile.d/nix.sh ]; then . /home/"$(whoami)"/.nix-profile/etc/profile.d/nix.sh; fi

eval "$(gh completion -s bash)"
