#!/usr/bin/env bash

# set -eou pipefail

# readonly is_debug=ture

is_debug() { test '' = ''; }

is_wsl() { [ -n "$(which wslpath 2>/dev/null)" ]; } # type2

if ! is_wsl; then
  echo 'this script is for wsl only'
  exit 1
fi

_funclist() {
  local regex print_all
  print_all=${1:-'false'}
  regex='^[^-_].*\(\)[ ]{,1}{$'
  if [[ ${print_all,,} = 'true' ]]; then regex='^.*\(\)[ ]{,1}{$'; fi

  while read func; do
    echo $func
  done < <(grep -E "$regex" $BASH_SOURCE | sed -E 's/(.*)\(\).*$/\1/')
}

pipe_or_args() {
  if [ -p /dev/stdin ]; then
    echo "*** From pipe ***"
    argument=$(cat /dev/stdin) # alternative: $(cat -)
  else
    echo "*** NOT from pipe ***"
    argument=$1
  fi

  echo "my_func: $argument"
}

# brace expansion sample
_bes_mesure_time() {
  # real	呼び出しから終了までの時間
  # user	プログラムの処理時間(ユーザCPU)
  # sys	OSが処理をした時間
  # network I/Oの待ち時間やdisk I/Oの待ち時間はrealには反映されますが、sysには反映されません
  time seq 1 1000000
  time echo {1..1000000}

  # シェルの組み込み
  # real    0m0.004s
  # user    0m0.004s
  # sys     0m0.000s
  # GNU版のtimeコマンド /usr/bin/time (-p でフォーマットはPOSIX準拠になる Use the following format string, for conformance with POSIX standard 1003.2)
  # 0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 1784maxresident)k
  # 0inputs+0outputs (0major+87minor)pagefaults 0swaps

  # bashでは問題ないが、shなどで表示形式が違う場合は、GNU形式が呼ばれているかもしれない
  # メモリの測定が可能
  # /usr/bin/time -f "%M" sleep 1
}

_time_a_la_carte() {

  # https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html#lbAM

  # 複数のコマンド
  time bash -c 'sleep 1 | sleep 1'
  echo 'sleep 1 | sleep 1 && sleep 1' >test.sh && time bash test.sh && rm test.sh

  # timeの後ろにはbashの複合コマンドも使えるのでこう書ける。
  # 同シェルで実行
  time { seq 1 100 | sed "s#\(.*\)#\1.dat#"; }

  # サブシェルで実行
  time (seq 1 100 | sed "s#\(.*\)#\1.dat#")

  time for i in $(seq 1000); do
    echo $i
  done

  time while read line; do
    echo $line
  done < <(seq 1000)
}

enable_multibutton_mouse() {
  test $# -eq 0 && echo 'Please specify the vmxfile.' && return 1
  vmxfile=$1
  sed -i '/^usb.generic.allowHID/d' $vmxfile
  sed -i '/^mouse.vusb.useBasicMouse/d' $vmxfile
  sed -i '/^mouse.vusb.enable/d' $vmxfile
  cat <<-'EOL' >>$vmxfile
		usb.generic.allowHID = "TRUE"
		mouse.vusb.useBasicMouse ="FALSE"
		mouse.vusb.enable = "TRUE"
	EOL
}

_testcomp_set_by_literal() { COMPREPLY=(one two); }
_testcomp_chk_env() {
  echo
  echo COMP_CWORD: ${COMP_CWORD}
  echo COMP_WORDS: ${COMP_WORDS[@]}
  echo
}

_testcomp_util_func_test() {
  local cur prev cword
  # /usr/share/bash-completion/bash_completion function
  # https://github.com/scop/bash-completion/blob/c16826ee35ecb405fe87007404d0fb846ad61a15/bash_completion#L343-L369
  _get_comp_words_by_ref -n : cur prev cword
  echo
  echo cur: ${cur}   # ${COMP_WORDS[${COMP_CWORD}]}
  echo prev: ${prev} # ${COMP_WORDS[${COMP_CWORD}-1]}
  echo cword: ${cword}
}

_testcomp_compgen() {
  # man 7 bash-builtins
  # ex. command
  # compgen -c -- a
  # Display all 176 possibilities? (y or n)
  # ex. file
  # compgen -f -- .bash
  # ex. directory
  # compgen -d -- a

  local cur prev opts
  _get_comp_words_by_ref -n : cur prev
  opts="one two once twice"
  COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
}
_testcomp_compgen2() {
  local cur prev opts
  _get_comp_words_by_ref -n : cur prev
  opts="one two once twice"
  COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
}

_this_func_comp() {
  local cur prev cword complist
  _get_comp_words_by_ref -n : cur prev cword

  case "$cword" in
  1)
    complist=$(_funclist true | tr '\n ' ' ')
    # complist=$(_funclist | tr '\n ' ' ')
    ;;
  2)
    case "$prev" in
    "pipe_or_args")
      complist="-logfile -logformat -loglevel"
      ;;
    "parse_args")
      complist="-h --help"
      ;;
    *) ;;

    esac
    ;;
  *) ;;

  esac

  if [[ -z $complist ]]; then
    # ディレクトリのスラッシュを補完
    compopt -o filenames
    COMPREPLY=($(compgen -f -- "${cur}")) && complete -F _this_func_comp $BASH_SOURCE
  else
    COMPREPLY=($(compgen -W "${complist}" -- "${cur}"))
  fi
} && complete -F _this_func_comp $BASH_SOURCE

complete -F _this_func_comp $BASH_SOURCE

no_parse_args() {
  parse_args $*

  echo "IGNORECASE "$IGNORECASE
  echo "IGNORECASE "$IGNORECASE
  echo "IGNORECASE "$IGNORECASE
  echo "IGNORECASE "$IGNORECASE
  echo "IGNORECASE "$IGNORECASE

}

parse_args() {
  while (($# > 0)); do
    case $1 in
    # no arg option
    -h | --help)
      echo HELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELPHELP
      return 0
      ;;
    -i | --ignorecase)
      IGNORECASE=1
      ;;
    -v | --verbose)
      VERBOSE=1
      ;;
    # one arg option
    -f | --file | --file=*)
      if [[ "$1" =~ ^--file= ]]; then
        FILE=$(echo $1 | sed -e 's/^--file=//')
      elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "'file' requires an argument." 1>&2
        exit 1
      else
        FILE="$2"
        shift
      fi
      ;;
    # multiple short option
    -*)
      if [[ "$1" =~ 'i' ]]; then IGNORECASE=1; fi
      if [[ "$1" =~ 'v' ]]; then VERBOSE=1; fi
      if [[ "$1" =~ 'f' ]]; then FILE="$2"; shift; fi
      ;;
    *)
      ARGS=("${ARGS[@]}" "$1")
      ;;
    esac
    shift
  done

  if is_debug ; then
  echo "FILE "$FILE
  echo "IGNORECASE "$IGNORECASE
  echo "VERBOSE "$VERBOSE
  echo "{ARGS[@]} "${ARGS[@]}
  fi
}

# set ls completion
# complete -F _testcomp_compgen ls
# reset completion
# complete -r ls # or . ~/.bashrc

if [[ $# -eq 0 ]]; then
  echo please specify one from the list of function below.
  _funclist true
  # exit 1
fi

__func__=$1 && shift
eval $__func__ $@
unset __func__
