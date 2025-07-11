#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034,SC2148
#
# ShellCheck ignore list:
#  - SC1090: Can't follow non-constant source. Use a directive to specify location.
#  - SC2034: foo appears unused. Verify it or export it.
#  - SC2148: Tips depend on target shell and yours is unknown. Add a shebang.
#
# You can find more details for each warning at the following page:
#    https://github.com/koalaman/shellcheck/wiki/<SCXXXX>
#    https://www.shellcheck.net/wiki/<SCXXXX>

# system
# alias ='cat /etc/passwd'
# alias ='cat /etc/groups'

# built in or familiar
alias l='ls -CF --time-style=long-iso'
alias la='ls -AF --color=auto --time-style=long-iso'
alias ll='ls -lF --color=auto --time-style=long-iso'
alias ls='ls --color=auto --time-style=long-iso'
alias lla='ls -AlF --color=auto --time-style=long-iso'
# lsd /path/to/dir/*, cwd = lsd $(pwd)/*
alias lsd='ls -dAF--color=auto --time-style=long-iso'
alias lst='eza --time-style=long-iso -laRTL'
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
alias ag='alias | grep -E'
# HACK TBD
alias funcg='func=$(declare -F | awk '\''{print $3}'\'' | fzf --preview '\''source ~/dotfiles/shell.d/func/is.bash && source ~/dotfiles/shell.d/.bash_aliases && declare -f {1}'\'') && [ -n "$func" ] && declare -f "$func"'
alias igrep='grep -in'
alias crontab='crontab -i'
# sudo current shell
alias su-='sudo -H -s'
alias valid_login_shells='cat /etc/shells'

# handy short cuts #
alias h='history'
alias j='jobs -l' # fg|bg job_id to continue, kill %job_id to stop

# color support
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# use user .vimrc with sudo vim.
alias sudovim='sudo vim -u $(if [ -n $XDG_CONFIG_HOME ];then echo "$XDG_CONFIG_HOME"/vim/vimrc ;else echo ~/.vimrc; fi)'
alias vif='vim $(fzf --height 40% --reverse)'

alias dot='/path/to/dotfiles'

alias _awp='awk-print-num'; awk-print-num(){ awk '{print $'${1:-1}'}'; }

alias _hunit='numfmt --to iec --format "%8.4f"'

alias _func-list='compgen -A function'
alias _func-list='declare -f | grep -E "^[^ ].*\(\)" | sed -e s/\ \(\)//'
alias _func-show='typeset -f'
alias _func-show='declare -f'

alias path='echo -e ${PATH//:/\\n}'

# date format
alias datetime="date +%Y-%m-%d_%H:%M:%S"
alias now='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'
alias tree='tree -D --timefmt="%Y-%m-%d %H:%M:%S"'

# clipboard
alias C="sed -z -e '$ s/\n//' | xclip -selection c"

if ! is_mac; then
  alias C="gsed -z -e '$ s/\n//' | pbcopy"
  # open app by extension
  alias open='xdg-open'
fi

if is_debian_based; then
  if is_wayland; then
    # apt install wl-cpoy
    alias C="sed -z -e '$ s/\n//' | wl-copy"
  fi
  alias sai='sudo apt install -y'
  alias _apt-outdated='sudo apt update && apt list --upgradable'
  alias _apt-update-single-package='sudo apt install --only-upgrade'
  alias _alldeclare='set'
  alias _functions='declare -f'
fi

if is_wsl;then
  alias C="sed -z -e '$ s/\n//' | clip.exe"
  alias CP="powershell.exe –noprofile -command Get-clipboard"
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

# test loopback address
# shellcheck disable=2142
alias _lb='f(){ curl 127.0.0.1:${1:-8000} ${2}; }; f'
# lsof -i:8080 | awk '{print $2}' | tail +2 | xargs kill
# shellcheck disable=2142
alias _po='f(){ lsof -i:${1}; }; f'

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

# --------------------
# git prefix gg
# --------------------
alias ggl='g-l'
alias ggb='g-b'
alias ggs='g-s'
alias ggg='gh fgist'
alias ggi='gh fissue'
alias ggp='gh fpr'

# --------------------
# for packages
# --------------------
if type bundle >/dev/null 2>&1; then
  alias _jkwatch='undle exec jekyll serve --force-polling --drafts --livereload --host=0.0.0.0' # --port 4001 --detach
fi

if type brew >/dev/null 2>&1; then
  alias brew-autoremove-deps='brew list | xargs -P$(( $(grep processor /proc/cpuinfo | wc -l) - 1 )) -I{} sh -c '\''brew uses --installed {} | wc -l | xargs printf "%20s is used by %2d formulae.\n" {}'\'''
fi

if type code-server >/dev/null 2>&1; then
  if ! type code >/dev/null 2>&1;then
    alias code='code-server'
  fi
fi

if type rg &>/dev/null; then
  alias rgd='rg --hidden --files --null | xargs -0 dirname | sort -u | uniq'
  alias sudorg='sudo env "PATH=$PATH" rg'
fi

if type pnpm &>/dev/null; then
  alias pn='pnpm'
  complete -o default -F _pnpm_completion pn
fi

# --------------------
# include dedicated files
# --------------------
# shellcheck source=/dev/null # [sample] Avoid warning SC1090
SRC=$HOME/dotfiles/aliases
while read -r -d $'\0' file; do
    source "${file}"
done < <(find "${SRC}" -mindepth 1 -maxdepth 1 -name '*.bash' -print0)
unset SRC

# --------------------
# for bash completions
# --------------------
# /usr/share/bash-completion/completions/systemctl
# complete -F _systemctl systemctl s
alias s='systemctl '
alias rmansiescseq='sed -r "s:\x1B\[[0-9;]*[mK]::g"'
