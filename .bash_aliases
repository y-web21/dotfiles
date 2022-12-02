#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
#
# Shellcheck ignore list:
#  - SC1090: Can't follow non-constant source. Use a directive to specify location.
#  - SC2034: foo appears unused. Verify it or export it.
#
# You can find more details for each warning at the following page:
#    https://github.com/koalaman/shellcheck/wiki/<SCXXXX>
#    https://www.shellcheck.net/wiki/<SCXXXX>

# system
# alias ='cat /etc/passwd'
# alias ='cat /etc/groups'

# built in or familiar
alias l='ls -CF'
alias la='ls --color=always -AF --time-style=long-iso'
alias ll='ls --color=always -lF'
alias ls='ls --color=always'
alias lla='ls --color=always -AlF --time-style=long-iso'
alias less='less -X'
alias sudo='sudo '
alias ..='\cd ..'
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias .....='\cd ../../../..'
alias relog='exec $SHELL -l'
alias relogin='exec $SHELL -l'
alias dishis='unset HISTFILE'
alias k9='kill -9 $$'
alias filesize='wc -c < '
alias type='type'
alias functoin-list='compgen -A function'
alias ag='alias | grep -E'

# handy short cuts #
alias h='history'
alias j='jobs -l' # fg|bg job_id to continue, kill %job_id to stop

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

# use user .vimrc with sudo vim.
alias sudovim='sudo vim -u ~/.vimrc'

alias dot='/path/to/dotfiles'

alias _awp='awk-print-num'; awk-print-num(){ awk '{print $'${1:-1}'}'; }

alias _hunit='numfmt --to iec --format "%8.4f"'

alias _list_func='compgen -A function'
alias _list_func='declare -f | grep -E "^[^ ].*\(\)" | sed -e s/\ \(\)//'
alias _show_func='typeset -f'
alias _show_func='declare -f'

alias path='echo -e ${PATH//:/\\n}'

alias datetime="date +%Y-%m-%d_%H:%M:%S"
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias sha1='echo -n "${1}" | openssl sha1 | sed -E "s/.*= //"'

if ! is_mac; then
  # open app by extension
  alias open='xdg-open'
fi

if is_debian_based; then
  alias sai='sudo apt install -y'
  alias _apt-outdated='sudo apt update && apt list --upgradable'
  alias _apt-update-single-package='sudo apt install --only-upgrade'
  alias _alldeclare='set'
  alias _alias=__-alias; __-alias(){ alias | grep -E "${1:-.*}" "${@:2}" --color; }
  alias _functions='declare -f'
fi

if is_wsl;then
  alias e.='explorer.exe .'

  # alias sjisgrep='`echo key | nkf -s` *.txt | nkf -w'
  alias _sleep-bear='curl -sS http://pipe-to-sh-poc.herokuapp.com/install.sh | cat'

  alias _cat=__-color_syntax_cat_pip3
  __-color_syntax_cat_pip3(){
    # pygmentize installed by pip3
    pygmentize -O style=monokai -f console256 -g "${@}"
  }
fi

# tar.gz
alias _tar-zip='tar -zcvf' # zipname, directory
alias _tar-unzip='gtar -zxvf'

# remove exif
alias _rmexif=__-remove_exif; __-remove_exif(){ jhead -de "${@}"; }

alias _sjis2utf8='iconv -f cp932 -t UTF8'
alias _utf16le='iconv -fUTF16LE'

alias _timestmp2date='date +"%Y-%m-%d %T" -d' # e.g. @11111111111

# half width space symposium
# find . -size +100M -print0 | sed -e 's/\x0/\n/g' | echo
# find . -size +100M -print0 | xargs --null
# find . -size +100M -print0 | xargs --null -i du -h "{}" | sort -h
# grep -l 10 * --null | xargs --null -n 1 echo

alias mount='mount |column -t'

# Stop after sending count ECHO_REQUEST packets #
alias _ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias _fastping='ping -c 100 -s.2'
alias _ports='netstat -tulanp'

# test loobback address
alias _lb='__curl_local_host__'
__curl_local_host__(){
  curl 127.0.0.1:${1:-8000} ${2}
}
# lsof -i:8080 | awk '{print $2}' | tail +2 | xargs kill
alias _po=__po__; __po__(){ lsof -i:${1}; }

# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# also pass it via sudo so whoever is admin can reload it without calling you #
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias lightyload='sudo /etc/init.d/lighttpd reload'
alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

alias py='python3.10'

# -- applications below -- #
if bundle -v >/dev/null 2>&1; then
  alias _jkwatch='undle exec jekyll serve --force-polling --drafts --livereload --host=0.0.0.0' # --port 4001 --detach
fi

# if wl-copy -v >/dev/null 2>&1;then
if [ -f .nix-profile/bin/wl-copy ];then
  alias clip='wl-copy'
fi

if which code-server >/dev/null 2>&1; then
  if ! which code >/dev/null 2>&1;then
    alias code='code-server'
  fi
fi

if which youtube-dl >/dev/null 2>&1; then
  alias ydl-sub-en='youtube-dl --no-cache-dir --write-auto-sub --sub-lang en'
  alias ydl-sub-ja='youtube-dl --no-cache-dir --write-auto-sub --sub-lang ja'
fi

# -- include dedicated files -- #
# shellcheck source=/dev/null # [sample] Avoid warning SC1090
SRC=$HOME/dotfiles/aliases
while read -d $'\0' file; do
    source "${file}"
done < <(find ${SRC} -mindepth 1 -maxdepth 1 -print0)
unset SRC

# -- for bash completions -- #
# /usr/share/bash-completion/completions/systemctl
# complete -F _systemctl systemctl s
alias s='systemctl '
