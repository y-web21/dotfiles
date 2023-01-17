#!/usr/bin/env bash
cd "$(dirname "$0")/shell.d/lib" || exit
mkdir -p ./kwhrtsk/docker-fzf-completion
curl https://raw.githubusercontent.com/kwhrtsk/docker-fzf-completion/master/docker-fzf.bash --output ./kwhrtsk/docker-fzf-completion/docker-fzf.bash
curl https://raw.githubusercontent.com/kwhrtsk/docker-fzf-completion/master/docker-fzf.zsh --output ./kwhrtsk/docker-fzf-completion/docker-fzf.zsh
