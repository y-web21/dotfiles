# system
# alias ='cat /etc/passwd'
# alias ='cat /etc/groups'

# built in
alias l='ls -CF'
alias la='ls --color=always -AF --time-style=long-iso'
alias ll='ls --color=always -lF'
alias ls='ls --color=always'
alias lla='ls --color=always -AlF --time-style=long-iso'
alias less='less -X'
alias sudo='sudo '
alias ..='\cd ..'
alias relogin='exec $SHELL -l'

alias awp='awk-print-num'; awk-print-num(){ awk '{print $'$1'}'; }
alias hunit='numfmt --to iec --format "%8.4f"'
alias list_func='compgen -A function'
alias list_func='declare -f | grep -E "^[^ ].*\(\)" | sed -e s/\ \(\)//'
alias show_func='typeset -f'
alias show_func='declare -f'

if ! is_mac; then
  # open app by extension
  alias open='xdg-open'
fi

if is_wsl; then
  alias cd='pushd'
  # alias sjisgrep='`echo key | nkf -s` *.txt | nkf -w'
  alias sleep-bear='curl -sS http://pipe-to-sh-poc.herokuapp.com/install.sh | cat'

  # color syntax cat (pip3)
  alias pcat='pygmentize -O style=monokai -f console256 -g'
fi

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
  git-parmanent-delete() {
    read -p "delete <${1}> (y/n)" INPUT
    if [ "$INPUT" = "y" ]; then
      git filter-branch --force --index-filter "git rm --cached --ignore-unmatch ${1}" -- --all
      git push --all --force origin
    fi
  }

fi

# tar.gz
alias tar-zip='tar -zcvf' # zipname, directory
alias tar-unzip='gtar -zxvf'

# remove exif
alias rmexif='jhead -de'

alias sjis2utf8='iconv -f cp932 -t UTF8'
alias utf16le='iconv -fUTF16LE'

# half width space symposium
# find . -size +100M -print0 | sed -e 's/\x0/\n/g' | echo
# find . -size +100M -print0 | xargs --null
# find . -size +100M -print0 | xargs --null -i du -h "{}" | sort -h
# grep -l 10 * --null | xargs --null -n 1 echo

# color support
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -e "$(which docker-compose 2>/dev/null)" ]; then
  alias dcu='docker-compose up -d'
  alias dcub='docker-compose up -d --build'
  alias dcurb='docker-compose up -d --no-deps --build' # 1イメージをのみリビルド
  alias dcd='docker-compose down'
  alias dcdi='docker-compose down --rmi=all'
  alias dcr='docker-compose down && docker-compose up -d'
  alias dcri='docker-compose down --rmi=all && docker-compose up -d --build'
  alias dcconf='docker-compose config'
fi

if [ -e "$(which docker 2>/dev/null)" ]; then
  alias drmiall='docker rmi $(docker images -q)'
  alias ddestoroy='docker ps -q | xargs docker stop && docker ps -aq | xargs docker rm && docker images -qa | xargs docker rmi'
  alias dmountedvolume='docker inspect $(docker ps -q ${1}) | grep -i source | tr -d '\'' '\'''

  alias container-ip='docker inspect -format='\''{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\'''

  docker-helpo() {
    docker pull nginx
    docker run --rm --name test2 -d -p 80:80 -t nginx:latest
    docker ps -a
    docker rm
    docker images
    docker rmi
    # Dockerfile から image build
    docker build -t nginfox:oldest .
    docker run -d -p 80:80 -t nginfox:oldest
    # -q で id列のみ。awk '{print $1}'的
    $ docker ps -q | xargs docker stop
  }

  # 宙ぶらりんイメージ（dangling image）のみ削除します。宙ぶらりんイメージとは、タグを持たず、他のコンテナからも参照されないイメージです。
  # docker image prune
  # 既存のコンテナ～使われていないイメージすべてを削除するには、 -a フラグを使います。
  # docker image prune -a

  # docker container
  alias dphp='docker exec -it php bash'
  alias dfpmreload='docker exec php ps aux | grep master | sed '\''s/ \+/ /g'\'' | cut -d '\'' '\'' -f 2 | xargs docker exec php kill -USR2' # sshrc用
  alias dfpmreload='docker exec php kill -USR2 $(docker exec php ps aux | grep master | awk '\''{print $2}'\'')'
  alias dmysql='docker exec -it db bash -c '\''mysql -uroot -p'\'''
  alias dnginxreload='docker exec -it nginx bash -c '\''nginx -s reload'\'''
fi

# circleci
alias install-circleci='curl -fLSs https://circle.ci/cli | sudo bash && circleci setup'
if [ -e "$(which circleci 2>/dev/null)" ]; then
  alias ccvalidate='circleci config validate .circleci/config.yml'
  alias cclocaljob='circleci local execute --job build'
  # alias install-dockerOutsideOfDocker='curl -sSL https://get.docker.com/ | sh && usermod -aG docker root'
fi

if which composer >/dev/null 2>&1; then
  # laravel framework
  alias pa='php artisan'
  alias pao='php artisan optimize'
  alias paoc='php artisan optimize:clear'
  alias pdotenv_reload='php artisan cache:clear & php artisan config:cache'
  alias edit_composer-json='composer dump-autoload'
fi

if [ -e "$(which aws 2>/dev/null)" ]; then
  # aws cli v2
  alias aws_account_id='aws sts get-caller-identity --query ''\'Account'\'' --output text'

  # EC2
  alias ec2list='aws ec2 describe-instances --query '\''Reservations[].Instances[].{id:InstanceId, state:State.Name, ipv4:PublicIpAddress, name:Tags[?Key==`Name`].Value|[0]}'\'' --output'
  alias ec2stopall='aws ec2 describe-instances --query '\''Reservations[].Instances[].[InstanceId, State.Name]'\'' --output text | grep running | awk '\''{print $1}'\'' | xargs aws ec2 stop-instances --instance-ids'
  alias ec2start_by_tagname=aws-ec2-start-instances-by-tagname

  aws-ec2-start-instances-by-tagname() {
    aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, State.Name, Tags[?Key==`Name`].Value|[0]]' --output text | awk '$2 == "stopped"' | awk '($3 ~ /'${1}'/){print $1}' | xargs aws ec2 start-instances --instance-ids
  }

  # CloudFormation
  alias cfn_create='aws cloudformation create-stack --template-body file://$(pwd)/cloudformation.yaml --capabilities CAPABILITY_NAMED_IAM --stack-name '
  alias cfn_delete='aws cloudformation delete-stack --stack-name '
  alias cfn_stacklist='aws cloudformation list-stacks --query '\''StackSummaries[].[StackName, StackStatus]'\'' --output'

  # ssh ec2
  alias ec2ssh='ssh -oStrictHostKeyChecking=no -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}'
  alias eeee='echo ${CURRENT_SSH_PEM}'
  alias set-env-CURRENT_SSH_SERVER-ec2='export CURRENT_SSH_SERVER=$(ec2list text | grep running | awk '\''NR==1 {print $2}'\'') && echo set ${CURRENT_SSH_SERVER}'
fi

scp-from() {
  local src=$1
  local dst=${2:-./}
  cmd="scp -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}:${src} ${dst}"
  echo $cmd && $cmd
}
scp-to() {
  local src=$1
  local dst=${2:-\~}
  cmd="scp -i ${CURRENT_SSH_PEM} ${src} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}:${dst}"
  echo $cmd && $cmd
}
ec2sshrc() {
  ssh -oStrictHostKeyChecking=no -t -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER} 'bash --rcfile <(echo "'"$(cat ~/.sshrc)"'")'
}
print-ssh() {
  echo ssh -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}
}

print-current-ssh-var() {
  echo 'CURRENT_SSH_PEM = '${CURRENT_SSH_PEM}
  echo 'CURRENT_SSH_USER = '${CURRENT_SSH_USER}
  echo 'CURRENT_SSH_SERVER = '${CURRENT_SSH_SERVER}
}

test ! -v CURRENT_SSH_PEM && CURRENT_SSH_PEM=
test ! -v CURRENT_SSH_USER && CURRENT_SSH_USER=ec2-user
test ! -v CURRENT_SSH_SERVER && export CURRENT_SSH_SERVER=127.0.0.1
if [ -n "$(which wslpath 2>/dev/null)" ]; then print-current-ssh-var; fi
