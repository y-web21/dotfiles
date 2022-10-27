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
alias dishis='unset HISTFILE'
alias k9='kill -9 $$'
alias filesize='wc -c < '
alias s='systemctl '


# use user .vimrc with sudo vim.
alias sudovim='sudo vim -u ~/.vimrc'

alias awp='awk-print-num'; awk-print-num(){ awk '{print $'${1:-1}'}'; }
alias hunit='numfmt --to iec --format "%8.4f"'
alias list_func='compgen -A function'
alias list_func='declare -f | grep -E "^[^ ].*\(\)" | sed -e s/\ \(\)//'
alias show_func='typeset -f'
alias show_func='declare -f'

alias datetime="date +%Y-%m-%d_%H:%M:%S"

if ! is_mac; then
  # open app by extension
  alias open='xdg-open'
fi

if is_wsl; then
  # alias sjisgrep='`echo key | nkf -s` *.txt | nkf -w'
  alias sleep-bear='curl -sS http://pipe-to-sh-poc.herokuapp.com/install.sh | cat'

  # color syntax cat (pip3)
  alias pcat='pygmentize -O style=monokai -f console256 -g'
fi

if is_ubuntu; then
  alias sai='sudo apt install -y'
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

if bundle -v >/dev/null 2>&1; then
  alias jkwatch='undle exec jekyll serve --force-polling --drafts --livereload --host=0.0.0.0' # --port 4001 --detach
fi

alias timestmp2date='date +"%Y-%m-%d %T" -d' # e.g. @11111111111

if is_wsl;then
  alias e.='explorer.exe .'
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

# /usr/share/bash-completion/completions/systemctl
# complete -F _systemctl systemctl s


alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias mount='mount |column -t'

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'


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

# handy short cuts #
alias h='history'
alias j='jobs -l' # fg|bg job_id to continue, kill %job_id to stop

alias py='python3.10'

# shellcheck source=/dev/null # [sample] Avoid warning SC1090
SRC=$HOME/dotfiles/aliases
while read -d $'\0' file; do
    source "${file}"
done < <(find ${SRC} -mindepth 1 -maxdepth 1 -print0)
unset SRC
