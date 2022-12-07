# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

if [ -e "$(which git 2>/dev/null)" ]; then
  # git main
  # alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
  alias gpush='git push origin HEAD'

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
  __granking-whos-edit-this-file(){ git log --format="%cn" $1 | sort | uniq -c | sort -r | head ; }
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

  alias ghash-full='git rev-parse'
  alias ghash-short='git rev-parse --short'

  alias galias='git config -l | grep ^alias | sed s/^alias\./alias\ /'

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
  # shellcheck disable=2034
  GIT_PS1_SHOWDIRTYSTATE=1     # ファイル変更 unstaged *, staged +
  # shellcheck disable=2034
  GIT_PS1_SHOWUPSTREAM=auto    # HEADとupstreamとの差分 =, <, >, <>(branch)
  # shellcheck disable=2034
  GIT_PS1_SHOWUNTRACKEDFILES=1 # 新規ファイル untracked files %
  # shellcheck disable=2034
  GIT_PS1_SHOWSTASHSTATE=1     # スタッシュあり $
  # shellcheck disable=2034
  GIT_PS1_SHOWCOLORHINTS=1     # 表示内容のカラー化
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

  git-config-options-memo() {
    cat <<-EOF
		# ignorecase = <default:true>
		git config --global core.ignoreCase false

		# prevent changes to perimission 644 when push from windows
		filemode = <default:true>

		# コミット(チェックイン)時にlfにする。CO時は何もしない。(for windows)
		git config --global core.autocrlf input
		# core.eol の値に従う (linux default)
		git config --global core.autocrlf false
		git config --global core.eol lf
		# CIに lf へ、CO時に crlf へ変換。(for windows)論外。
		git config --global core.autocrlf true

		# Win向けの改行コードをリポジトリに保持する場合(実質はCICO時の変換をコントロール。リモートは常にlf)
		add .gitattributes > echo '*.html diff=sjis' > .gitattributes
		EOF
  }

  # for remove credential file
  git-permanent-delete() {
    read -p -r "delete <${1}> (y/N)" INPUT
    if [ "$INPUT" = "y" ]; then
      git filter-branch --force --index-filter "git rm --cached --ignore-unmatch ${1}" -- --all
      git push --all --force origin
    fi
  }

fi
