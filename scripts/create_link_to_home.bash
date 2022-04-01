#!/usr/bin/env bash

cd $(dirname $0)/..

# Refactor this more eventually if possible
if [[ -z $1 ]];then
    read -p "Create symbolic links to home. <${1}> (y/n)" INPUT
else
    INPUT=$1
fi

if [ "$INPUT" != "y" ];then
    # timeout 5 echo cancel
    read -t 2 -p cancel || echo
    exit 1
fi

while read file; do
    echo $file
    rm ~/$file
    ln -s ~/dotfiles/$file ~/$file
done < <(find . -mindepth 1 \( -path '*/.git/*' -o -path '*/.gat/*' \) -prune -o -type f -print \
        | cut -c 3- | grep ^\\. | grep -v \\.gitignore )


if [[ -z $(grep '. ~/.bashrc_user' ~/.bashrc 2>/dev/null) ]];then
    echo >> ~/.bashrc
    cat <<-EOL >> ~/.bashrc
	# include user bashrc
	test -r ~/.bashrc_user && . ~/.bashrc_user
	EOL
fi

