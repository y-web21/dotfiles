#!/usr/bin/env bash

pkgs=(
tree
htop
jq
# yq
)
optional=(
xdg-utils, xdg-open
source-highlight
psmisc,'pstree. '
nano, '素人用エディタ'
ncdu, '使いやすいdu'
)

for opt in "${optional[@]}"; do
    pkg=$(echo ${opt} | awk -F "," '{print $1}')
    msg=$(echo ${opt} | awk -F "," '{print $2}')
    if [ "${msg}" == '' ]; then msg=$pkg; fi
    read -p "use ${msg}? (y or else): " key
    case "$key" in [yY] | [yY]es) pkgs+=("$pkg");; esac
done

PACKAGE_MANAGER=aptitude
test -f /etc/redhat-release && PACKAGE_MANAGER='dnf'
test -f /etc/system-release && PACKAGE_MANAGER='yum'
test -f /etc/debian_version && PACKAGE_MANAGER='apt'

if [ ${EUID:-${UID}} = 0 ]; then
    $PACKAGE_MANAGER update
else
    sudo $PACKAGE_MANAGER update
fi

for pkg in "${pkgs[@]}"; do
    # if [[ "$(which ${pkg})" == '' ]];then
    # fi
    $pkg --version &> /dev/null
    if [ $? -eq 0 ] ; then
        :
    else
        echo trying to install $pkg...
        if [ ${EUID:-${UID}} = 0 ]; then
            $PACKAGE_MANAGER install -y $pkg
        else
            sudo $PACKAGE_MANAGER install -y $pkg
        fi
        if [ $? -ne 0 ] ; then
            faillist+=("${pkg}")
        fi
    fi
done

for pkg in "${faillist[@]}"; do
    read -t 3 -p "${pkg} install failed."
    echo ''
done

unset $faillist
unset $pkgs
unset $optional
