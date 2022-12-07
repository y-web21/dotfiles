#!/usr/bin/env bash
# cheat sheet

bin() {
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

rsync() {
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

apt() {
  cat <<-'EOL'
		sudo apt list --upgradable
		sudo apt install --only-upgrade
		apt-mark hold
		apt-mark unhold
		APT_HOLD_LIST=$(dpkg --get-selections | grep hold)
	EOL
}

network(){
  cat <<- EOS
		ss -atn
		ss -nultp
		netstat -anp
	EOS
}

date(){
cat <<-'EOL'
# 基本的なフォーマット指定
date --date "2017-03-22 + 90days"  +"%Y-%m-%d %H:%M:%S"
2017-06-20 00:00:00

# 月初の表示
date -d 'now - 2hour' +'%Y%m01'

# touch で timestamp 変更
touch -d $(date -d '-9 month' --iso-8601=second) file.txt

# format
--iso-8601
2022-03-08
--iso-8601=second
2022-03-08T01:33:05+09:00
date -Iseconds
2022-03-08T02:39:01+09:00

# git amend での コミット時間の編集
g cma --date $(date --date 'now - 2hour' -Iseconds)

EOL
}

if [ ${#1} -lt 1 ];then
  declare -F | awk '{print $NF}' | sort
  exit
fi

$1
