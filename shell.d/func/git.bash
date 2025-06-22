#!/usr/bin/env bash

if type ghq >/dev/null 2>&1; then
  ghqcd() {
    run_fzf() {
      local fzf_command dirs

      fzf_command=$(
        cat <<-EOL
				fzf-tmux -p 80% --preview='tree -p {}' \
				--layout=reverse \
				--no-sort \
        --query '!gist ' \
				--bind=alt-a:toggle-all \
				--expect=enter,alt-o,ctrl-e \
				--bind='ctrl-l:unix-line-discard' \
				--header-first
			EOL
      )

      # use the array syntax +=() to split the path at 0x0A. this prevents splitting at 0x20.
      if [[ -d "${HOME}/dotfiles" ]]; then
        dirs=("$(
          ghq list -p
          echo "${HOME}/dotfiles"
        )")
      else
        dirs=("$(ghq list -p)")
      fi
      # if [[ -d "${HOME}/dotfiles" ]]; then
      #   mapfile -t dirs < <(ghq list -p; echo "${HOME}/dotfil es")
      # else
      #   mapfile -t dirs < <(ghq list -p)
      # fi

      ret=$(echo "${dirs[*]}" | sort | eval "$fzf_command")
      [[ -z "$ret" ]] && return 1

      key=$(printf '%s' "$ret" | tail +1 | head -1)
      picks=$(echo "$ret" | tail +2 | cut -d ':' -f 2- | cut -f 2-)

      echo $ret

      case "${key}" in
      enter)
        cd "${picks[0]}" || return 2
        ;;
      alt-v | ctrl-e) ;;
      *) ;;
      esac
    }

    run_fzf "$"
  }
fi
