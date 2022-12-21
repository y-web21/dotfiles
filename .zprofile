# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

if [ -e "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

if [ -n "$ZSH_VERSION" ]; then
  if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
  fi
fi
