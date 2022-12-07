#!/usr/bin/env bash

cs-bin(){
  cat <<-'EOL'
	# x byte output
	xxd -g1 cha
	od -tx1 cha
	od -tc cha
	od -tx1 -tc -An <(echo -n abcd)
	od -tx1 -tc -An <(echo ABCD)
	# file header
	xxd -l 50 bash_function.png
	xxd -l 50 asdf.jpg
	xxd -l 300 sample.wav
	od -tc -N 50 return_code.txt
	EOL
}

cs-rsync(){
  cat <<-'EOL'
	# the fllowing example, copy xml file and directories. (on ubuntu rsync)
	rsync -r --include='*/' --include='*.xml' --exclude='*' src dst

	# シンボリックリンクを実体として、.tmpと.db以外コピー の条件でテストラン
	 rsync -ahvL --include='*/' --exclude='*.db' --exclude='*.tmp' src/ dst --dry-run

	-a -rlptgoDを指定することでなるべくコピー元のファイルと同一条件でコピーする。
	-h human readable unit
	-v verbose
	--progress ファイル単位での状況表示
	-n --dry-run
	-l シンボリックリンクをシンボリックリンクのままコピー
	-L シンボリックリンクを実体としてコピー
	--max-size 転送対象のファイルサイズの上限
	-e sshのポート指定。ex. rsync -e "ssh -p 22222"
	EOL
}
