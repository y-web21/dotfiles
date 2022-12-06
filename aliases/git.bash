#!/usr/bin/env bash

if [ -e "$(which git 2>/dev/null)" ]; then
  # git main
  # alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
  alias gpush='git push origin HEAD'

  # git sub
  alias g-emptypush='git commit --allow-empty -m '\''empty commit[skip ci]'\'' && git push origin @'
  alias g-emptypush-run-ci='git commit --allow-empty -m '\''empty commit'\'' && git push origin HEAD'
  alias g-whoami='git rev-parse --abbrev-ref HEAD'

  # git memo
  alias git_untracked='git rm --cached'
  alias git_del_remoteb_ranch='git push --delete origin'
  alias git_empty_commit='git commit --allow-empty -m'
  alias git_memo4='git for-each-ref refs/remotes --merged'

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
  alias granking-whos-edit-this-file='git log --format="%cn" PATH/TO/FILE | sort | uniq -c | sort -r | head'
  alias granking-fuck='git log --pretty="format:%cn:%s" | grep fu.k | cut -d":" -f1 | sort | uniq -c | sort -r'
  alias gcount-allcommit='git shortlog -sn'
  alias granking-commit='for AUTHOR in Foo Bar Baz; do git log --author=$AUTHOR --numstat --pretty="%H"  | awk '\''NF==3 {add+=$1; del+=$2} END {printf("add: %d\tdelete: %d", add, del)}'\''; echo -e "\\t$AUTHOR"; done | sort -nr -k2'

  alias gl_commit_top10='git log --name-only --pretty='format:' | grep -ve '^$' | sort | uniq -c | sort -r | head'
  alias gl_step_line_all='git log --numstat --pretty='\''%H'\'' | awk '\''NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'\'''
  alias gl_step_line_file='git log --numstat --pretty='\''%H'\'' | awk '\''NF==3 {add_sum[$3]+=$1; del_sum[$3]+=$2} END {for (key in add_sum) {printf("%d, %d, %s\n", add_sum[key],del_sum[key],key)}}'\'' | sort -k1,1nr -k2,2nr -t,| head'
  alias gl_6month_commit_top10='git log --name-only --pretty="format:" --since="6 months ago" | grep -ve '\''^$'\'' | sort | uniq -c | sort -r | head'

  # git hash(f298 → f298abb608ed1421635484678237ae1f76c15b88 )
  alias ghash-full='git rev-parse'
  alias ghash-short='git rev-parse --short'

  # git function
  alias gparentbranch='git-parent-branch'
  alias glohash='git-get-hash'
  alias glohashs='git-get-short-hash'

  alias galias='git config -l | grep ^alias | sed s/^alias\./alias\ /'
  git-permanent-delete() {
    read -p "delete <${1}> (y/n)" INPUT
    if [ "$INPUT" = "y" ]; then
      git filter-branch --force --index-filter "git rm --cached --ignore-unmatch ${1}" -- --all
      git push --all --force origin
    fi
  }

  # if change the following, must also change git-completion.bash
  alias g="git"
  alias ga="git add"
  alias gb="git branch"
  alias gc="git checkout"
  alias gcm="git commit"
  alias gd="git diff"
  alias gl="git log"
  alias gs="git status"
  alias gsh="git stash"

  # if type __git_ps1 > /dev/null 2>&1; then
  # __git_ps1 プロンプトに各種情報を表示
  GIT_PS1_SHOWDIRTYSTATE=1     # ファイル変更 unstaged *, staged +
  GIT_PS1_SHOWUPSTREAM=auto    # HEADとupstreamとの差分 =, <, >, <>(branch)
  GIT_PS1_SHOWUNTRACKEDFILES=1 # 新規ファイル untracked files %
  GIT_PS1_SHOWSTASHSTATE=1     # スタッシュあり $
  GIT_PS1_SHOWCOLORHINTS=1     # 表示内容のカラー化
  # upstream = remote tracking branch
fi
