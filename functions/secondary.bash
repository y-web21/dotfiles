# shellcheck disable=SC2148
#
# ShellCheck ignore list:
#  - SC2148: Can't follow non-constant source. Use a directive to specify location.

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
