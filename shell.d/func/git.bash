#!/usr/bin/env bash

if type ghq >/dev/null 2>&1; then
  ghqcd() {
    local fzf dirs path
    fzf='fzf-tmux --preview='\''tree -p {}'\'''

    # avoid using "+=()" to split paths by 0x0A. it splits by 0x20(sapce).
    if [[ -d "${HOME}/dotfiles" ]]; then
      dirs=("$(ghq list -p; echo "${HOME}/dotfiles")")
    else
      dirs=("$(ghq list -p)")
    fi
    # if [[ -d "${HOME}/dotfiles" ]]; then
    #   mapfile -t dirs < <(ghq list -p; echo "${HOME}/dotfiles")
    # else
    #   mapfile -t dirs < <(ghq list -p)
    # fi

    if [[ $# -eq 0 ]]; then
      path=$(echo "${dirs[*]}" | sort | eval "$fzf")
    else
      path=$(echo "${dirs[*]}" | sort | grep -v "$1" | eval "$fzf")
    fi
    [[ -z "$path" ]] && return 1
    cd "$path" || return 2
  }
fi
