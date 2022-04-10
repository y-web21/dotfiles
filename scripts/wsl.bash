#!/usr/bin/env bash

set -euo pipefail

BLACK='\e[0;30m'
# RED='\033[31m'
# GREEN='\e[32m'
RED='\e[0;31m'
GREEN='\e[0;32m'
ORANGE='\e[0;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
CYAN='\e[0;36m'
LIGHT_GRAY='\e[0;37m'
DARK_GRAY='\e[1;30m'
LIGHT_RED='\e[1;31m'
LIGHT_GREEN='\e[1;32m'
YELLOW='\e[1;33m'
LIGHT_BLUE='\e[1;34m'
LIGHT_PURPLE='\e[1;35m'
LIGHT_CYAN='\e[1;36m'
WHITE='\e[1;37m'
UNDER_LINE='\e[4m'
UNDERLINE='\e[4m'
UNDERLINE='\e[4m'
UNDERLINE='\e[4m'
RESET_ALL_DECO='\e[0m'

REGEX='.*#[^\S]{,8}doc.*'

if [[ $# -eq 0 ]]; then
  echo -e "${YELLOW}$0 <function> <args>${RESET_ALL_DECO}\nSpecify from the following functions"

  while read func; do
    echo -en $GREEN
    echo $func
    echo -en $WHITE
    i=0

    # 関数ドキュメント表示
    while read doc; do
      i=$(expr ${i} + 1)
      # 2行目が'# doc'でなければ終了
      if [[ $i -eq 2 && ! "$doc" =~ $REGEX ]];then echo -e "\tno arguments"; break; fi
      # 1行目は関数名、2行目は'# doc'なので常にスキップ
      if [[ $i -eq 1 || $i -eq 2 ]];then continue; fi
      # 空行で終了
      if [[ ${#doc} -eq 0 ]];then break; fi

      echo -e "\t$doc"
    done < <(grep -A30 ^${func} $0)

  done < <(grep -E '^.*\(\)[ ]{,1}{$' $0 | sed -E 's/(.*)\(\).*$/\1/')

  echo -en $RESET_ALL_DECO
  exit 1
fi

helpo(){
  while read line; do
    echo -e $(eval echo "${line}")
    # printf '\033[31m%s\033[m\n' "$line"
  done <<-"HELP"
  ${RED}${UNDER_LINE}***command prompt***${RESET_ALL_DECO}
	${GREEN}switch WSL1, WSL2${RESET_ALL_DECO}
	wsl --set-default-version \\<1 or 2\\>

	${GREEN}update installed distro to WSL2${RESET_ALL_DECO}
	wsl --set-version \\<distro name\\> 2

	${GREEN}list distro${RESET_ALL_DECO}
	wsl --list --all
	wsl --list --verbose
	wsl -l --online
  wsl -l -v

	${GREEN}rm distro${RESET_ALL_DECO}
	wsl --unregister \\<DistributionName\\>

	${GREEN}shutdown distro${RESET_ALL_DECO}
	wsl -t Ubuntu-20.04
	${GREEN}shutdown all distro${RESET_ALL_DECO}
	wsl --shutdown

	${GREEN}find distro .vhdx\\(entity\\) ${RESET_ALL_DECO}
	sudo find \\$\\(wslpath \\"\\$\\(wslvar LOCALAPPDATA\\)\\"\\) 2\\>\\/dev\\/null \\| grep vhdx\\$

	${GREEN}login not default distribution${RESET_ALL_DECO}
  wsl -d \\<distro-name\\> -u \\ <user-name\\>
	HELP
}

duplicate-distro() {
  # doc
  DistributionName=$1
  DistroTarExportPath=${2}\\${1}.tar
  InstallLocation=$3
  NewDistributionName=$4
  # ex. wsl.bash duplicate-distro Ubuntu-20.04 'C:\\Users\\AAA\\user\\export' 'C:\\Users\\AAA\\user\\wsl' Ubuntu-20.04-experimantal

  cat <<-EOF > dd.bat
	wsl --export $DistributionName $DistroTarExportPath
	wsl --import $NewDistributionName $InstallLocation $DistroTarExportPath
	EOF

  echo "exported dd.bat"
  echo "wsl --distribution ${NewDistributionName}"
}



__func__=$1 && shift
eval $__func__ $@
unset __func__
