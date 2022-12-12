if peco --version &>/dev/null; then
  _peco_view() {
    grep -r "$1" . -n | peco | cut -d':' -f1 | xargs bat
  }

  _peco_md() {
    grep -r "$1" . -n | peco | cut -d':' -f1 | xargs glow
  }
fi

if fzf --version &>/dev/null; then
  # zsh で グローバルエイリアス化したい
  P() {
    local PICK
    # PICK=$(find -L ${1:-.} -mindepth 1 -maxdepth 4 -type d -prune -o -print | grep -v ^\.$ | fzf)
    PICK=$(find -L ${1:-.} -mindepth 1 -maxdepth 4 | grep -v ^\.$ | fzf)
    echo "$PICK"
    return
    # DBD ディレクトリ遷移しながらパスを選ぶ
    while true; do
      if [ '' = "$PICK" ]; then return; fi
      if [ -f "$PICK" ]; then echo "$PICK" && return ; fi
      # PICK=$(find -L ${1:-.} -mindepth 1 -maxdepth 4 | sed '1a ..' | grep -v ^\.$ | fzf)
      # if [ -d "$PICK" ]; then cd "$PICK" || :; fi
      # C-c までマルチピックするなら return しない
      # if [ -f "$PICK" ]; then echo "$PICK" ; fi
    done
  }
fi
