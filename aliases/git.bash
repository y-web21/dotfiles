# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

if [ -e "$(which git 2>/dev/null)" ]; then
  # git main
  # alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
  alias gpush='git push origin HEAD'
  alias gap='git add -p'
  alias gsg='git status --short'

  # git sub
  alias git-emptypush='git commit --allow-empty -m '\''empty commit[skip ci]'\'' && git push origin @'
  alias git-emptypush-run-ci='git commit --allow-empty -m '\''empty commit'\'' && git push origin HEAD'
  alias git-whoami='git rev-parse --abbrev-ref HEAD'
  alias git-untracked='git rm --cached'
  alias git-empty-commit='git commit --allow-empty -m'
  alias git-remote-delete-branch='git push --delete origin'
  alias git-remote-marged-branch='git for-each-ref refs/remotes --merged'

  # git log
  alias gln='git log --name-only'
  alias gls='git log --name-status'
  alias gl1='git log -1'
  alias gl2='git log -2'
  alias gl3='git log -3'
  alias gl4='git log -4'
  alias glf='git log --pretty=fuller'
  alias glg='git log --graph'
  alias glga='git log --graph --all'
  alias glo='git log --oneline'
  alias gloa='git log --oneline --all'
  alias glop='git log --pretty=oneline'
  alias grl='git reflog'

  # log advanced
  alias granking-merge='git log --merges --format="%cn" | sort | uniq -c | sort -r | head'
  alias granking-editfile="git log --name-only --pretty='format:' | grep -ve '^$' | sort | uniq -c | sort -r | head"
  alias granking-whos-edit-this-file=__granking-whos-edit-this-file
  __granking-whos-edit-this-file() { git log --format="%cn" $1 | sort | uniq -c | sort -r | head; }
  alias granking-fuck='git log --pretty="format:%cn:%s" | grep fu.k | cut -d":" -f1 | sort | uniq -c | sort -r'
  alias gcount-allcommit='git shortlog -sn'
  # shellcheck disable=2142
  alias granking-commit='for AUTHOR in Foo Bar Baz; do git log --author=$AUTHOR --numstat --pretty="%H"  | awk '\''NF==3 {add+=$1; del+=$2} END {printf("add: %d\tdelete: %d", add, del)}'\''; echo -e "\\t$AUTHOR"; done | sort -nr -k2'
  alias granking-commit-top10='git log --name-only --pretty='\''format:'\'' | grep -ve '\''^$'\'' | sort | uniq -c | sort -r | head'
  alias granking-6month-commit-top10='git log --name-only --pretty="format:" --since="6 months ago" | grep -ve '\''^$'\'' | sort | uniq -c | sort -r | head'
  # shellcheck disable=2142
  alias gl-step-line-all='git log --numstat --pretty='\''%H'\'' | awk '\''NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'\'''
  # shellcheck disable=2142
  alias gl-step-line-file='git log --numstat --pretty='\''%H'\'' | awk '\''NF==3 {add_sum[$3]+=$1; del_sum[$3]+=$2} END {for (key in add_sum) {printf("%d, %d, %s\n", add_sum[key],del_sum[key],key)}}'\'' | sort -k1,1nr -k2,2nr -t,| head'

  # rev-parse
  alias ghash-full='git rev-parse'
  alias ghash-short='git rev-parse --short'

  # alias list
  alias galias='git config -l | grep ^alias | sed s/^alias\./alias\ /'

  # alias with completion
  # prevent gitの補完 lazy-load
  if [[ -n "$BASH_VERSION" ]]; then
    _BASH_COMPLETION_DIRS=(
      "$HOME/.bash_completion.d/"
      /usr/local/share/bash-completion/completions/
    )
    if which brew >/dev/null; then
      _BASH_COMPLETION_DIRS+=("$(brew --prefix)/share/bash-completion/completions")
      _BASH_COMPLETION_DIRS+=("$(brew --prefix)/etc/bash_completion.d")
    fi
    _BASH_COMPLETION_DIRS+=(
      /usr/share/bash-completion/completions
      /etc/bash_completion.d
    )

    for dir in "${_BASH_COMPLETION_DIRS[@]}"; do
      if [ -d "$dir" ] && [ -f "$dir/git" ]; then
        # shellcheck disable=1091
        source "$dir/git"
        break 1
      fi
    done

  elif [[ -n "$ZSH_VERSION" ]]; then
    :
  fi

  # alias with completion
  # GNU Bash Reference Manual - Programmable Completion
  # https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
  # https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases
  # complete
  # -o
  # default: Use Readline’s default filename completion if the compspec generates no matches.
  # nospace: Tell Readline not to append a space (the default) to words completed at the end of the line.
  alias g="git"
  complete -o default -o nospace -F __git_main g
  __git_complete g __git_main
  alias ga="git add"
  complete -o default -o nospace -F _git_add ga
  __git_complete ga _git_add
  alias gb="git branch"
  complete -o default -o nospace -F _git_branch gb
  __git_complete gb _git_branch
  alias gc="git checkout"
  complete -o default -o nospace -F _git_checkout gc
  __git_complete gc _git_checkout
  alias gcm="git commit"
  complete -o default -o nospace -F _git_commit gcm
  __git_complete gcm _git_commit
  alias gd="git diff"
  complete -o default -o nospace -F _git_diff gd
  __git_complete gd _git_diff
  alias gl="git log"
  complete -o default -o nospace -F _git_log gl
  __git_complete gl _git_log
  alias gs="git status"
  complete -o default -o nospace -F _git_status gs
  __git_complete gs _git_status
  alias gsh="git stash"
  complete -o default -o nospace -F _git_stash gsh
  __git_complete gsh _git_stash

  # init
  git-init-genkey() {
    local key_name="${1:-"id_ed25519"}"
    local path="$HOME/.ssh/$key_name"
    [ ! -d "$HOME/.ssh" ] && mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$path"
  }

  # if type __git_ps1 > /dev/null 2>&1; then
  # __git_ps1 プロンプトに各種情報を表示
  # shellcheck disable=2034
  GIT_PS1_SHOWDIRTYSTATE=1 # ファイル変更 unstaged *, staged +
  # shellcheck disable=2034
  GIT_PS1_SHOWUPSTREAM=auto # HEADとupstreamとの差分 =, <, >, <>(branch)
  # shellcheck disable=2034
  GIT_PS1_SHOWUNTRACKEDFILES=1 # 新規ファイル untracked files %
  # shellcheck disable=2034
  GIT_PS1_SHOWSTASHSTATE=1 # スタッシュあり $
  # shellcheck disable=2034
  GIT_PS1_SHOWCOLORHINTS=1 # 表示内容のカラー化
  # upstream = remote tracking branch

  git-get-short-hash() {
    if [[ $# -gt 0 ]]; then
      git log --oneline | head -${1} | tail -1 | awk '{print $1}'
    else
      cat <<-EOF
			1 args required.
			\$1 = line (git log --oneline)
			EOF
    fi
  }

  git-get-hash() {
    if [[ $# -gt 0 ]]; then
      git log --pretty=oneline | head -${1} | tail -1 | awk '{print $1}'
    else
      cat <<-EOF
			1 args required.
			\$1 = line (git log --oneline)
			EOF
    fi
  }

  git-parent-branch() {
    if [[ $# -gt 1 ]]; then
      git show-branch --sha1-name $1 $2 | tail -1
    else
      cat <<-EOF
			2 args required.
			\$1 = branch
			\$2 = branch
			EOF
    fi
  }

  # for remove credential file
  git-permanent-delete() {
    printf "\e[31m%s\n\e[m" "This change is destructive."
    read -p -r "delete <${1}> (y/N)" INPUT
    if [ "$INPUT" = "y" ]; then
      git filter-branch --force --index-filter "git rm --cached --ignore-unmatch ${1}" -- --all
      git push --all --force origin
    fi
  }

fi
