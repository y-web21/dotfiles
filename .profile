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
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# linuxbrew
if type /home/linuxbrew/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif type /home/"$(whoami)"/.linuxbrew/bin/brew >/dev/null 2>&1; then
  eval "$(/home/"$(whoami)"/.linuxbrew/bin/brew shellenv)"
fi

if type fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--reverse --bind=enter:accept,alt-p:preview-up,alt-n:preview-down'
  export FZF_DEFAULT_OPTS+=',shift-up:preview-top,shift-down:preview-bottom'
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

# Install Ruby Gems to ~/gems
if [ -d "$HOME/gems" ]; then
  export GEM_HOME="$HOME/gems"
  export PATH="$HOME/gems/bin:$PATH"
fi

if type apt >/dev/null 2>&1 ;then
  apt moo
fi
