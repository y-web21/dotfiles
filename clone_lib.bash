#!/usr/bin/env bash
cd "$(dirname "$0")/lib" || exit
g-sparse-co https://github.com/olivierverdier/zsh-git-prompt 1 zshrc.sh false n .
