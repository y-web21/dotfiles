#!/usr/bin/env bash

lib() {
  cd "$(dirname "$0")/shell.d/lib" || exit
  mkdir -p ./kwhrtsk/docker-fzf-completion
  curl https://raw.githubusercontent.com/kwhrtsk/docker-fzf-completion/master/docker-fzf.bash --output ./kwhrtsk/docker-fzf-completion/docker-fzf.bash
  curl https://raw.githubusercontent.com/kwhrtsk/docker-fzf-completion/master/docker-fzf.zsh --output ./kwhrtsk/docker-fzf-completion/docker-fzf.zsh
}

tmux_plugin_manger() {
  local plg_dir tpm_dir
  plg_dir="${XDG_CONFIG_HOME}/tmux/plugins"
  test -d "$plg_dir" || mkdir -p "$plg_dir"
  tpm_dir="${plg_dir}/tpm"
  test -d "$tpm_dir" && rm -rf "$tpm_dir"
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

vim_plugin_manger() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

lib
tmux_plugin_manger
vim_plugin_manger
