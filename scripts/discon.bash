# installation.bash 用へ移行予定の者たち =================================
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# curl -LI https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /dev/null -w '%{http_code}'

enable-git-completion() {
  GIT_COMPLETION_PATH=$(find ~ -name git-completion.bash 2>/dev/null | head -1)
  # echo $GIT_COMPLETION_PATH
  if [ ${#GIT_COMPLETION_PATH} -eq 0 ]; then
    local gitcomp_url='https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash'
    local hcode=$(curl -LIsS ${gitcomp_url} | grep ^HTTP | awk '{print $2}')

    if [[ hcode -ne 200 ]]; then
      echo '!!!! failed to include git-completion !!!!!'
      return
    fi
    GIT_COMPLETION_PATH="${HOME}/git-completion.bash"
    curl -sS ${gitcomp_url} >$GIT_COMPLETION_PATH
  fi
  source ${GIT_COMPLETION_PATH}
}

# イラネーな
# enable-git-completion



install-manpages-ja() {
  read -p 'change locale to JP, ok? (y)' input
  test "$input" != "y" && return 1

  # by JM Project
  sudo apt update
  sudo apt install manpages-ja
  sudo apt install manpages-ja-dev
  sudo apt install language-pack-ja
  sudo update-locale LANG=ja_JP.utf8
  locale
  sleep 4
  exec $SHELL -l
  # export LC_ALL=ja_JP.utf8
  # export LANGUAGE=ja_JP.utf8
}

install-docker-compose-v1() {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  # add completion file
  sudo curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
}

install-docker-compose-v2() {
  sudo apt-get update
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

install-awscliv2() {
  if [ "$(which unzip)" = '' ]; then
    test -f /etc/redhat-release/ && sudo dnf install -y unzip
    test -f /etc/system-release/ && sudo yum install -y unzip
    test -f /etc/debian-release/ && sudo apt install -y unzip
  fi

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm awscliv2.zip && rm -rf aws/
  aws --version
  # aws cli v2 completion
}

test -f '/usr/local/bin/aws_completer' && complete -C '/usr/local/bin/aws_completer' aws

# ============================================================

# read -p "Hit enter: "
setup-awscliv2() {
  csv=${1:-credentials.csv}

  while :; do
    read -p "import csv? ([y/n/[a]bort): " key
    case "$key" in
    [aA]*)
      echo 'abort.'
      break
      ;;
    [yY] | [yY]es)
      # credentials accessKey csv でのIAMユーザー追加
      aws configure set region ap-northeast-1
      aws configure import --csv file://${csv}
      break
      ;;
    [nN]*)
      # 手動セットアップ
      aws configure set region ap-northeast-1
      aws configure
      # リージョン情報セット ~/.aws/config に保存
      break
      ;;
    *) ;;
    esac
  done
  echo 'set following env...'
  echo 'export AWS_PROFILE=<your profile name>'
  echo 'export AWS_DEFAULT_REGION=<region  ex. ap-northeast-1>'
}
