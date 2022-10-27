#!/usr/bin/env bash

if [ -e "$(which git 2>/dev/null)" ]; then
  # git main
  # alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
  alias gpush='git push origin HEAD'

  # git sub
  alias g-emptypush='git commit --allow-empty -m '\''empty commit[skip ci]'\'' && git push origin @'
  alias g-emptypush-run-ci='git commit --allow-empty -m '\''empty commit'\'' && git push origin HEAD'
  alias g-whoami='git rev-parse --abbrev-ref HEAD'

  # git second sub(memo)
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
  alias glg='git log --graph'
  alias glo='git log --oneline'
  alias glop='git log --pretty=oneline'

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

fi
