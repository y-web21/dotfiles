# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.

if is_debian_based;then
  apt-remove-purge(){
    sudo apt-get -y remove $1
    sudo apt-get -y remove --auto-remove $1
    sudo apt-get -y purge $1
    sudo apt-get -y purge --auto-remove $1
  }
fi

rand-str() {
  local len=${1:-16}
  local line=${2:-1}
  local tr_arg=${3:-a-zA-Z0-9}
  local prepare=$(($len + 100))
  cat /dev/urandom | tr -dc ${tr_arg} | fold -w ${len} | head -n ${prepare} | uniq | head -n ${line}
}

google() {
  if [ $(echo $1 | grep "^-[cfs]$") ]; then
    local opt=$1
    shift
  fi
  local url="https://google.com/search?q=${*// /+}"
  local c="Google Chrome"
  local f="Firefox"
  local s="Safari"
  case $opt in
  -c) open $url -a $c ;;
  -f) open $url -a $f ;;
  -s) open $url -a $s ;;
  *) open $url ;;
  esac
}

# alias lanana='curl -sS https://www.lanana.org/lsbreg/providers/providers.txt | grep -vE '\''^\s'\'' | grep -v '\''^\s*$'\'' | awk '\''{print $1}'\'''
lanana() {
  # The Linux Assigned Names And Numbers Authority
  # Linux Standard Base (LSB)
  local URL LIST HZLINE
  case "$1" in
  providers)
    # LSB Provider Names - LSB Provider Name Registry
    URL=https://www.lanana.org/lsbreg/providers/providers.txt
    ;;
  packages)
    # LSB Package Names - LSB Package Name Registry
    URL=https://www.lanana.org/lsbreg/packages/packages.txt
    ;;
  init-script)
    # LSB Init Script Names - LSB Init Script Name Registry
    URL=https://www.lanana.org/lsbreg/init/init.txt
    ;;
  cron-script)
    # LSB Cron Script Names - LSB Cron Script Name Registry
    URL=https://www.lanana.org/lsbreg/packages/packages.txt
    ;;
  *)
    echo 'invalid arg error'
    return 1
    ;;
  esac

  LIST=$(curl -sS ${URL}) | grep -vE '^\s' | grep -v '^\s*$' | awk '{print $1}'
  HZLINE=$(curl -sS ${URL} | grep -nE '^-+' | cut -d':' -f1)
  curl -sS ${URL} | grep -vE '^\s' | grep -v '^\s*$' | awk "NR>${HZLINE}{print \$1}"
}

_lanana_comp() {
  local cur complist
  _get_comp_words_by_ref -n : cur
  complist="providers packages init-script cron-script"
  COMPREPLY=($(compgen -W "${complist}" -- "${cur}"))
} && complete -F _lanana_comp lanana

metapack(){
  if apt-get -v >/dev/null 2>&1; then
    echo '=== apt list, apt-get install ==='
    # sudo apt update
    dpkg -l "*${1}*" | grep --color "${1}"
    # apt list "*${1}*" | grep --color "${1}"
  fi

  if yum -v >/dev/null 2>&1; then
    echo -e '\n=== yum search, yum install ==='
    yum search "${1}" | grep --color "${1}"
  fi

  if dnf -v >/dev/null 2>&1; then
    echo -e '\n=== dnf search, dnf install ==='
    dnf search "${1}" | grep --color "${1}"
  fi

  if nix --version >/dev/null 2>&1; then
    echo -e '\n=== nix-env -qa, nix-env --install ==='
    nix-env --query --available"${1}" | grep --color "${1}"
  fi

  if brew -v >/dev/null 2>&1; then
    echo -e '\n=== brew search, brew install ==='
    brew search "${1}" | grep --color "${1}"
  fi

  if scoop -v >/dev/null 2>&1; then
    echo -e '\n=== scoop search, scoop install ==='
    scoop search "${1}" | grep --color "${1}"
  fi
}
