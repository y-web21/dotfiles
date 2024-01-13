#!/usr/bin/env bash

is_debian_based() { [ -f /etc/debian_version ]; } # /etc/os-release ID_LIKE=debian || ID=debian
is_redhat_based() { [ -f /etc/redhat-release ]; }
is_slackware_based() { [ -f /etc/slackware-version ]; }
is_arch_linux() { [ -f /etc/arch-release ]; }
# window
is_wayland() { [ -v WAYLAND_DISPLAY ]; }
is_xorg() { [ -n "$DISPLAY" ] && [ "$XDG_SESSION_TYPE" == "x11" ]; } # X11, TBDevelopment
# os
is_centos() { [ "$(head </etc/redhat-release -1 | cut -d' ' -f1 2>/dev/null)" = 'CentOS' ]; }
is_linux() { [ "$(printf '%s' "$(uname -s)" | cut -c 1-5)" = 'Linux' ]; }
is_mac() { [ "$(uname)" = 'Darwin' ]; }
is_ubuntu() { grep '^ID=ubuntu' /etc/os-release >/dev/null 2>&1; }
is_debian() { grep '^ID=debian' /etc/os-release >/dev/null 2>&1; }
# shellcheck disable=SC2317
is_wsl() { type wslpath >/dev/null 2>&1; } # type2
is_wsl() { $WSL_DISTRO_NAME 2>&1; } # type3
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
# vm
is_lxc_container() { sudo grep -qa container=lxc /proc/1/environ; }
is_crostini() { is_debian && is_lxc_container; }
