#!/usr/bin/env bash

set -eo pipefail

PACKAGE_MANAGER='scoop'

main() {
  resolve-package-manger
  eval "install-${1} $PACKAGE_MANAGER"
}

install-linuxbrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  #  ~/.profile~/.bash_profile
  cat <<-"EOL" > nazo
	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
	echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
	EOL
}
install-docker() {
  if [ -d /usr/bin/docker ]; then
    # uninstall old version docker.
    dnf -y remove \
      docker \
      docker-client \
      docker-client-latest \
      docker-common \
      docker-latest \
      docker-latest-logrotate \
      docker-logrotate \
      docker-engine
  fi
  # install docker ce edition from the docker official repo.
  dnf -y install dnf-plugins-core
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  dnf -y install docker-ce docker-ce-cli containerd.io

  if [ ${EUID:-${UID}} = 0 ]; then
    install_docker_root
  else
    sudo gpasswd -a $(whoami) docker
  fi
}
install-compose() {
  compose_ver=1.29.2

  if ! [ -d /usr/local/bin/docker-compose ]; then
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  fi
}
install-vscode() {
  :
}
install-xdg-open() {
  eval "$1 install -y xdg-utils"
  if [[ $? -eq 100 ]]; then eval "sudo $1 install -y xdg-utils"; fi
}

resolve-package-manger() {
  PACKAGE_MANAGER=aptitude
  test -f /etc/redhat-release && PACKAGE_MANAGER='dnf'
  test -f /etc/system-release && PACKAGE_MANAGER='yum'
  test -f /etc/debian_version && PACKAGE_MANAGER='apt'
}

list() {

  # PREV_IFS=$IFS
  # IFS="
  # "
  pkg_list=($(grep ^install-.*{ $0 | sed -E 's/^install-(.*)\(\).*$/\1\n/'))
  # for ((i = 0; i < ${#pkg_list[@]}; i++)); do
  #   if [[ ${pkg_list[$i]} = 'compose' ]]; then unset pkg_list[$i]; pkg_list+=('compose      docker-compose'); fi
  # done

  cat <<-HELP
	command
	  \033[31m\c list

	install <package> <package-manger(optional)>
		$(for pkg in ${pkg_list[@]}; do echo -e "  ${pkg}"; done)
	HELP

  # IFS=$PREV_IFS
}

if [ $# -eq 0 ]; then
  list
  exit 0
else
  main $*
fi
